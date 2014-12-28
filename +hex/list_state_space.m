function G = list_state_space(G)
% list the state space for each clique

% TODO (Ronghang Hu): replace the brute-force approach with more efficient
% algorithm
clq_cell = G.clq_cell;
E_dh = G.E_dh;
E_de = G.E_de;

num_clq = length(clq_cell);
state_cell = cell(num_clq, 1);
for i = 1:num_clq
  clq_vars = clq_cell{i};
  num_vars = length(clq_vars);
  states_mat = false(0, num_vars);
  div_vec = 2 .^ (num_vars-1:-1:0);
  for state_id = 0:(2^num_vars - 1)
    state = mod(floor(state_id ./ div_vec), 2) > 0;
    is_legal = true;
    % check with brute-force whether this state is legal
    for n1 = 1:num_vars
      if ~is_legal
        break
      end
      for n2 = 1:num_vars
        if ~is_legal
          break
        end
        var1 = clq_vars(n1);
        var2 = clq_vars(n2);
        y1 = state(n1);
        y2 = state(n2);
        if (E_de(var1, var2) && y1 && y2) || (E_dh(var1, var2) && ~y1 && y2)
          is_legal = false;
        end
      end
    end
    % if this state is legal, then add it into the state space of this
    % clique
    if is_legal
      states_mat = cat(1, states_mat, state);
    end
  end
  state_cell{i} = states_mat;
end
G.state_cell = state_cell;

end