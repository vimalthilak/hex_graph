function c_p_cell = clamp_potential(c_p_cell, G, l)
% c_p_cell = clamp_potential(c_p_cell, G, l)
%   Clamp the potentials to calculate joint probability
%
%   c_p_cell contains potential tables of all cliques
%   G is the structure containing the whole HEX Graph
%   l is variable index of label (1-indexed), and 0 for none-of-classes
%   (background)

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2015, Ronghang Hu (huronghang@hotmail.com)
% 
% This file is part of the HEX Graph code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

% nothing needs to be done if l == 0
if l == 0
  return
end

v_c_cell = G.v_c_cell;
c_v_cell = G.c_v_cell;
margin_cell = G.margin_cell;

% set potentials of all states in which y_l = 0 to be zero
v = l;
c_vec_containing_l = v_c_cell{v};
for cid = 1:length(c_vec_containing_l);
  c = c_vec_containing_l(cid);
  var_state_cell = margin_cell{c};
  
  % all the states that y_l = 1
  vid_idx = (c_v_cell{c} == v);
  sid_vec = var_state_cell{vid_idx};
  
  % all the states that y_l = 0
  num_state = length(c_p_cell{c});
  idx = true(num_state, 1);
  idx(sid_vec) = false;
  
  % set the potentials of y_l = 0 states to be zero
  c_p_cell{c}(idx) = 0;
end

end