function G = record_sumprod(G)
% G = record_sum_prod(G)
%   Record the sum-product sequence of a junction tree
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

c_v_cell = G.c_v_cell;
c_s_cell = G.c_s_cell;
c_parent_vec = G.c_parent_vec;
c_children_cell = G.c_children_cell;
num_c = G.num_c;

% record how states in a clique is connected in states in neighbor cliques
sumprod_cell = cell(num_c, 1);
for c = 1:num_c
  v_this = c_v_cell{c};
  % order of neighbors: child_1, child_2, ..., parent
  c_neighbors = c_children_cell{c};
  if c_parent_vec(c) > 0
    c_neighbors = cat(1, c_neighbors, c_parent_vec(c));
  end
  % states and state number of this clique
  s_mat_this = c_s_cell{c};
  num_s_this = size(s_mat_this, 1);
  % visit all its neighbors
  neighbor_s_cell = cell(length(c_neighbors), num_s_this);
  for n = 1:length(c_neighbors)
    c_neighbor = c_neighbors(n);
    v_neighbor = c_v_cell{c_neighbor};
    % find intersection variables between current clique and neighbor
    % clique
    [~, vid_this, vid_neighbor] = intersect(v_this, v_neighbor);
    % states and state number of neighbor clique
    s_mat_neighbor = c_s_cell{c_neighbor};
    num_s_neighbor = size(s_mat_neighbor, 1);
    % for each s in this clique's s table, match it with associated
    % states in the neighbor's s table
    for sid_this = 1:num_s_this
      % state of intersection variables in this clique
      intersec_s_this = s_mat_this(sid_this, vid_this);
      % state id list of matching neighbor states
      sid_match = [];
      for sid_neighbor = 1:num_s_neighbor
        % state of intersection variables in neighbor clique
        intersec_s_neighbor = s_mat_neighbor(sid_neighbor, vid_neighbor);
        if all(intersec_s_this == intersec_s_neighbor)
          sid_match = cat(1, sid_match, sid_neighbor);
        end
      end
      neighbor_s_cell{n, sid_this} = sid_match;
    end
  end
  sumprod_cell{c} = neighbor_s_cell;
end
G.sumprod_cell = sumprod_cell;

end