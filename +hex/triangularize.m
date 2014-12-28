function G = triangularize(G)
% Triangularize a HEX graph to get maximal cliques and junction graph

% Convert E_sh to undirected edges and combine with E_se
E_elim = G.E_sh | G.E_sh' | G.E_se;
num_V = size(E_elim, 1);

% Generate a random elimination sequence.
sequence = 1:num_V;
% TODO: Change back
% sequence = randperm(num_V);
fprintf('elimination sequence: \n');
fprintf('%d ', sequence);
fprintf('\n');

% eliminate nodes to get elimination cliques
clq_cell = cell(num_V, 0);
tree_width = 0;
for ii = 1:num_V
  i = sequence(ii);
  
  % Find its neighbours and form a clique.
  neighbours = find(E_elim(:, i));
  num_neighbours = length(neighbours);
  % For a connected graph, a node should always have neighbours (except for
  % the last node) during the elimination process.
  % Only connected HEX graphs are considered in this code.
  assert(num_neighbours >= 1 || ii == num_V);
  clq_cell{i} = sort([i; neighbours]);
  tree_width = max(tree_width, num_neighbours);
  
  % Marry all its neighbours and then eliminate the node
  for n1 = 1:num_neighbours
    for n2 = n1+1:num_neighbours
      E_elim(neighbours(n1), neighbours(n2)) = true;
      E_elim(neighbours(n2), neighbours(n1)) = true;
    end
  end
  E_elim(:, i) = false;
  E_elim(i, :) = false;
end
fprintf('junction tree width after triangularization: %d\n', tree_width);

% Find maximal cliques from all elimination cliques.
keep = true(num_V, 1);
for i = 1:num_V
  for j = i+1:num_V
    if ~keep(i) || ~keep(j)
      continue
    end
    % take intersection
    clq_sec = intersect(clq_cell{i}, clq_cell{j});
    if length(clq_sec) == length(clq_cell{i})
      % clq_cell{i} contains clq_cell{j}
      keep(i) = false;
    elseif length(clq_sec) == length(clq_cell{j})
      % clq_cell{j} contains clq_cell{i}
      keep(j) = false;
    end
  end
end
clq_cell = clq_cell(keep);
num_clq = length(clq_cell);

% record how many times a variable appears in different cliques, and which
% cliques do they appear in, so that they can be marginalized efficiently
appear_times = zeros(num_V, 1);
appear_cell = cell(num_V, 1);
for i = 1:num_clq
  clq_vars = clq_cell{i};
  for j = 1:length(clq_vars)
    var = clq_vars(j);
    appear_times(var) = appear_times(var) + 1;
    appear_cell{var} = cat(1, appear_cell{var}, i);
  end
end
G.appear_times = appear_times;
G.appear_cell = appear_cell;
  
% Create junction graph and compute edge weights in junction graph.
% Note: undirected edge is only stored once in clq_g_edges.
clq_g_edges = zeros(0, 3);
for i = 1:num_clq
  for j = i+1:num_clq
    weight = length(intersect(clq_cell{i}, clq_cell{j}));
    if weight > 0
      clq_g_edges = cat(1, clq_g_edges, [i, j, weight]);
    end
  end
end

% Add results to G.
G.clq_cell = clq_cell;
G.clq_g_edges = clq_g_edges;

end