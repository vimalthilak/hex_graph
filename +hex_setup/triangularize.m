function G = triangularize(G)
% G = triangularize(G)
%   Triangularize a HEX graph to get maximal cliques and junction graph
%
%   G is the structure containing the whole HEX Graph

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2015, Ronghang Hu (huronghang@hotmail.com)
% 
% This file is part of the HEX Graph code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

% triangularize using sparsified HEX Graph to make cliques small
E_sh = G.E_sh;
E_se = G.E_se;
num_v = G.num_v;

% Convert E_sh to undirected edges and combine with E_se to obtain the
% (undirected) adjacency matrix of all edges for variable elimination
E_elim = E_sh | E_sh' | E_se;

% Generate a variable elimination sequence.
% TODO (Ronghang Hu): change this fixed sequence to heuristic sequence
v_elim_seq = 1:num_v;

% eliminate nodes to get elimination cliques
c_v_cell = cell(num_v, 0);
JT_width = 0;
for vid = 1:num_v
  v = v_elim_seq(vid);
  
  % Find its neighbours and form a clique.
  v_neighbor = find(E_elim(:, v));
  num_v_neighbor = length(v_neighbor);
  
  % For a connected graph, a node should always have neighbors (except for
  % the last node) during the elimination process.
  % Only connected HEX graphs are considered in this code.
  % TODO (Ronghang Hu): generalize this to unconnected hex graph
  assert((num_v_neighbor >= 1) || (vid == num_v));
  
  % sort the viable indices in a clique (to look pretty)
  c_v_cell{v} = sort([v; v_neighbor]);
  
  % the junction tree width is the variable number (minus 1) of the largest
  % clique
  JT_width = max(JT_width, num_v_neighbor);
  
  % connect all its neighbors and then eliminate the node in adjacency
  % matrix
  for n1 = 1:num_v_neighbor
    for n2 = (n1+1):num_v_neighbor
      E_elim(v_neighbor(n1), v_neighbor(n2)) = true;
      E_elim(v_neighbor(n2), v_neighbor(n1)) = true;
    end
  end
  E_elim(:, v) = false;
  E_elim(v, :) = false;
end
fprintf('hex_setup.triangularize: junction tree width: %d\n', JT_width);

% Find maximal cliques from all elimination cliques.
num_c = length(c_v_cell);
keep = true(num_c, 1);
for c1 = 1:num_c
  for c2 = (c1+1):num_c
    if ~keep(c1) || ~keep(c2)
      continue
    end
    % take intersection of two cliques
    c_v_sec = intersect(c_v_cell{c1}, c_v_cell{c2});
    
    % if one clique contains another, then remove the small one
    if length(c_v_sec) == length(c_v_cell{c1})
      keep(c1) = false;
    elseif length(c_v_sec) == length(c_v_cell{c2})
      keep(c2) = false;
    end
  end
end
c_v_cell = c_v_cell(keep);
num_c = length(c_v_cell);
G.c_v_cell = c_v_cell;
G.num_c = num_c;
fprintf('hex_setup.triangularize: clique number: %d\n', G.num_c);

% Record which cliques a variable appears in, so that it can be marginalized
% efficiently.
v_c_cell = cell(num_v, 1);
for c = 1:num_c
  v_this = c_v_cell{c};
  for vid = 1:length(v_this)
    v = v_this(vid);
    v_c_cell{v} = cat(1, v_c_cell{v}, c);
  end
end
G.v_c_cell = v_c_cell;

% record how many times a variable appears
var_appear_times = zeros(num_v, 1);
for v = 1:num_v
  var_appear_times(v) = length(v_c_cell{v});
end
G.var_appear_times = var_appear_times;

end