function potential_cell = assign_potential(f, G)
% assign potentials to each clique

clq_cell = G.clq_cell;
num_clq = length(clq_cell);
appear_times = G.appear_times;
num_V = length(appear_times);
state_cell = G.state_cell;

assert(length(f) == num_V);

% create potential table for each clique inside the tree
potential_cell = cell(num_clq, 1);
for i = 1:num_clq
  clq_vars = clq_cell{i};
  num_vars = length(clq_vars);
  state_mat = state_cell{i};
  num_state = size(state_mat, 1);
  potential_vec = zeros(num_state, 1);
  for n_state = 1:num_state
    p = 1;
    for n_var = 1:num_vars
      if state_mat(n_state, n_var)
        p = p * exp(f(clq_vars(n_var)) / appear_times(clq_vars(n_var)));
      end
    end
    potential_vec(n_state) = p;
  end
  potential_cell{i} = potential_vec;
end

end