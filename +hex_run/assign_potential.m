function c_p_cell = assign_potential(G, f)
% c_p_cell = assign_potential(f, G)
%   Assign potentials to each clique and return potential table
%
%   G is the structure containing the whole HEX Graph
%   f is raw scores of all variables
%   c_p_cell contains potential tables of all cliques

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2015, Ronghang Hu (huronghang@hotmail.com)
%
% This file is part of the HEX Graph code and is available
% under the terms of the Simplified BSD License provided in
% LICENSE. Please retain this notice and LICENSE if you use
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

c_v_cell = G.c_v_cell;
num_c = G.num_c;
var_appear_times = G.var_appear_times;
c_s_cell = G.c_s_cell;

% create potential table for each clique inside the tree
c_p_cell = cell(num_c, 1);
for i = 1:num_c
  v_this = c_v_cell{i};
  num_v_this = length(v_this);
  s_mat_this = c_s_cell{i};
  num_s_this = size(s_mat_this, 1);
  p_vec = zeros(num_s_this, 1);
  for sid = 1:num_s_this
    energy = 0;
    for vid = 1:num_v_this
      if s_mat_this(sid, vid)
        energy = energy - f(v_this(vid)) / var_appear_times(v_this(vid));
      end
    end
    p_vec(sid) = exp(-energy);
  end
  c_p_cell{i} = p_vec;
end

end