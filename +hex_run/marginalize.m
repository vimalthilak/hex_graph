function [Pr_margin, Z, c_belief_cell] = marginalize(G, c_m_cell, c_p_cell)
% [Pr_margin, Z] = marginalize(G, c_m_cell, c_p_cell)
%   Marginalize within cliques to get unnormalized marginal probability and 
%   partition function
%
%   G is the structure containing the whole HEX Graph
%   c_p_cell contains potential tables of all cliques
%   c_m_cell contains message tables of all cliques
%   Pr_margin is unnormalized probability of each category
%   Z is partition function
%   c_belief_cell contains belief vector of each clique

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2015, Ronghang Hu (huronghang@hotmail.com)
%
% This file is part of the HEX Graph code and is available
% under the terms of the Simplified BSD License provided in
% LICENSE. Please retain this notice and LICENSE if you use
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

num_v = G.num_v;
num_c = G.num_c;
v_c_cell = G.v_c_cell;
c_v_cell = G.c_v_cell;
margin_cell = G.margin_cell;

% calculate cluster belief and partition function
c_belief_cell = cell(num_c, 1);
for c = 1:num_c
  p_vec = c_p_cell{c};
  m_vec = c_m_cell{c};
  belief = p_vec .* prod(m_vec, 1)';
  c_belief_cell{c} = belief;
end

% calculate partition function (from the first clique)
Z = sum(c_belief_cell{1});

% calculate marginal probability of each variable via marginalizing in (the
% first) clique containing this variable
Pr_margin = zeros(num_v, 1);
for v = 1:num_v;
  c = v_c_cell{v}(1);
  var_state_cell = margin_cell{c};
  belief = c_belief_cell{c};
  Pr_margin(v) = sum(belief(var_state_cell{c_v_cell{c} == v}));
end

end