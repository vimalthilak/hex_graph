function c_m_cell = pass_message(G, c_p_cell)
% use sum-product algorithm to compute marginal probability of labels
% perform two message pass on Junction Tree using depth-first search

num_V = size(G.E_u, 1);

% check whether the label is valid
assert(islogical(label_y));
assert(length(label_idx) == length(label_y));
% check for label index range and duplicated label index
assert(all(label_idx >= 1) && all(label_idx <= num_V));
assert(length(intersect(label_idx, label_idx)) == length(label_idx));
% Here we only allow marginalize over one variable
% TODO (Ronghang Hu): allow computing marginal probability over multiple
% labels
assert(length(label_idx) == 1 && length(label_y) == 1);

% Junction Tree
clq_cell = G.clq_cell;
num_clq = length(clq_cell);
E_JT = G.E_JT;
assert(num_clq == size(E_JT, 1));
assert(num_clq == size(E_JT, 2));

% randomly select a node as root
root_JT = randperm(num_clq, 1);

%% state space and potential table construction for each clique
% each state is a logical matrix, with each column representing
% initialize msg_cell, each of which is a vector of length == state_num

msg_cell = cell(num_clq, 1);
for i = 1:num_clq
  xsaefl;
end

%% first pass: from leaves to root
% and also identify the parent of each clique, and get partition function
msg_sent = false(num_clq, 1);
parent_vec = zeros(num_clq, 1); % the parent of root is 0
sep_cell = cell(num_clq, 1); % the separator between a node and its parents

% depth-first search
clq_this = root_JT;
while true
  neighbours = find(E_JT(:, clq_this));
  % visit all the children who has not sent message yet.
  % if no children or all children have sent their message, then send
  % message and to back to parents. If no parent (root), then stop.
  go_down = false;
  for clq_down = 1:length(neighbours)
    if clq_down ~= parent_vec(clq_this) && ~msg_sent(clq_down)
      go_down = true;
      break
    end
  end
  if go_down
    % set up the parent node and separator of this child
    parent_vec(clq_down) = clq_this;
    sep_cell{clq_down} = intersect(clq_cell{clq_down}, clq_cell{clq_this});
    clq_this = clq_down;
  elseif parent_vec(clq_this) > 0 % send msg and go up
    %% College MSG and send up
    clq_this = parent_vec(clq_this);
  else
    %% root has been reached College MSG and calculate the partition function
    break
  end
end

%% second pass: from root to leaves

end

function msg_cell = send_msg(msg_cell, clq_cell, ids, idr)
% send message from clq ids to clq idr


end