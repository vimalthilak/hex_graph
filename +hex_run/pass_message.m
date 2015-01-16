function c_m_cell = pass_message(G, c_p_cell)
% c_m_cell = pass_message(G, c_p_cell)
%   Perform sum-product message pass (up and down) on Junction Tree
%
%   G is the structure containing the whole HEX Graph
%   c_p_cell contains potential tables of all cliques
%   c_m_cell contains message tables of all cliques

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2015, Ronghang Hu (huronghang@hotmail.com)
%
% This file is part of the HEX Graph code and is available
% under the terms of the Simplified BSD License provided in
% LICENSE. Please retain this notice and LICENSE if you use
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

num_c = G.num_c;
c_children_cell = G.c_children_cell;
c_parent_vec = G.c_parent_vec;
sumprod_cell = G.sumprod_cell;
up_pass_seq = G.up_pass_seq;

% all incoming messages (from its neighbors) of each clique
c_m_cell = cell(num_c, 1);

% first pass (up pass): pass message from leaves to root
for cid = 1:num_c
  c = up_pass_seq(cid);
  
  % order of neighbors: child_1, child_2, ..., parent
  neighbor_state_cell = sumprod_cell{c};
  num_neighbor_this = size(neighbor_state_cell, 1);
  num_state_this = length(c_p_cell{c});
  
  % message vector of this clique
  m_vec_this = zeros(num_neighbor_this, num_state_this);
  
  % collect message from children cliques
  c_children = c_children_cell{c};
  
  % loop over each neighbor and each state (of this clique)
  for cid_neighbor = 1:length(c_children)
    c_child = c_children(cid_neighbor);
    % the neighbor's number of (its own) neighbor
    % collect message from this child
    for sid_this = 1:num_state_this
      msg_total = 0;
      sid_vec_neighbor = neighbor_state_cell{cid_neighbor, sid_this};
      for i = 1:length(sid_vec_neighbor)
        sid_neighbor = sid_vec_neighbor(i);
        p_neighbor = c_p_cell{c_child}(sid_neighbor);
        
        % product the message from all (its own) children, but not its parent
        msg_prod_neighbor = prod(c_m_cell{c_child}(1:end-1, sid_neighbor), 1);
        msg_total = msg_total + p_neighbor * msg_prod_neighbor;
      end
      m_vec_this(cid_neighbor, sid_this) = msg_total;
    end
  end
  % set up message cell after passing messages
  c_m_cell{c} = m_vec_this;
end

% second pass (down pass): pass message from root to leaves
% revert the up-pass sequence and skip the root
for cid = (num_c - 1):-1:1
  c = up_pass_seq(cid);
  
  % order of neighbors: child_1, child_2, ..., parent
  neighbor_state_cell = sumprod_cell{c};
  num_state_this = length(c_p_cell{c});
  
  m_vec_this = c_m_cell{c};
  
  % collect message from parent clique
  c_parent = c_parent_vec(c);
  for sid_this = 1:num_state_this
    msg_total = 0;
    sid_vec_neighbor = neighbor_state_cell{end, sid_this};
    for i = 1:length(sid_vec_neighbor)
      sid_neighbor = sid_vec_neighbor(i);
      p_neighbor = c_p_cell{c_parent}(sid_neighbor);
      
      % TODO (Ronghang Hu): avoid multiplying together messages by
      % multiplying them one time and divide them (like in HUGIN algorithm)
      c_children_neighbor = c_children_cell{c_parent};
      prod_idx = c_children_neighbor ~= c;
      if c_parent_vec(c_parent) > 0
        prod_idx = [prod_idx; true]; %#ok<AGROW>
      end
      msg_prod_neighbor = prod(c_m_cell{c_parent}(prod_idx, sid_neighbor), 1);
      
      msg_total = msg_total + p_neighbor * msg_prod_neighbor;
    end
    m_vec_this(end, sid_this) = msg_total;
  end
  % set up message cell after passing messages
  c_m_cell{c} = m_vec_this;
end