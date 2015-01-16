function G = list_state_space(G)
% G = list_state_space(G)
%   List the state space for each clique
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

% list state space using densified HEX Graph to state space inference
% efficient
E_dh = G.E_dh;
E_de = G.E_de;
c_v_cell = G.c_v_cell;
num_c = G.num_c;

% List state space of all cliques.
% For each clique cell, state space matrix is a logical matrix. Each row 
% is a state vector. The order of variables in each row is the same as in
% c_v_cell.
c_s_cell = cell(num_c, 1);
% the variable-state table of each clique, to compute marginal probability
% of a variable within a clique
margin_cell = cell(num_c, 1);

% TODO (Ronghang Hu): replace the brute-force approach with more efficient
% algorithm. List state space using densified graph
for c = 1:num_c
  c_v = c_v_cell{c};
  num_v_in_clq = length(c_v);
  s_mat = false(0, num_v_in_clq);
  
  % enumerate all (2^num_c_v) possible states within a clique
  divide_vec = 2 .^ (num_v_in_clq-1:-1:0);
  for sid = 0:(2^num_v_in_clq - 1)
    s = mod(floor(sid ./ divide_vec), 2) > 0;
    % check (with brute-force) whether this state is legal
    is_legal = true;
    for n1 = 1:num_v_in_clq
      if ~is_legal
        break
      end
      for n2 = 1:num_v_in_clq
        if ~is_legal
          break
        end
        v1 = c_v(n1);
        v2 = c_v(n2);
        y1 = s(n1);
        y2 = s(n2);
        if (E_de(v1, v2) && y1 && y2) || (E_dh(v1, v2) && ~y1 && y2)
          is_legal = false;
        end
      end
    end
    % if this state is legal, then add it into the state space of this
    % clique
    if is_legal
      s_mat = cat(1, s_mat, s);
    end
  end
  
  % list the variable-state table for each clique
  % record the states associated with a variable
  v_s_cell = cell(num_v_in_clq, 1);
  for vid_in_clq = 1:num_v_in_clq
    v_s_cell{vid_in_clq} = find(s_mat(:, vid_in_clq));
  end
  
  % store them
  c_s_cell{c} = s_mat;
  margin_cell{c} = v_s_cell;
end
G.c_s_cell = c_s_cell;
G.margin_cell = margin_cell;

end