function G = max_span_tree(G)
% G = max_span_tree(G)
%   Generate Junction Tree (Max Span Tree) from Junction Graph, using
%   Kruskal Algorithm
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
num_c = G.num_c;

% Create junction graph and compute edge weights in junction graph. Edges
% are stored in num_edge*3 matrix c_JG_edges. Each row [i, j, w] are
% indices and weight of a edges in junction graph.
% Undirected edge is only stored once in c_JG_edges.
c_JG_edges = zeros(0, 3);
for c1 = 1:num_c
  for c2 = (c1+1):num_c
    % the weight of each edge is the variable number after intersection
    weight = length(intersect(c_v_cell{c1}, c_v_cell{c2}));
    if weight > 0
      c_JG_edges = cat(1, c_JG_edges, [c1, c2, weight]);
    end
  end
end

% Use Kruskal Algorithm to generate maximal spanning tree.
[E_JT, JT_weight] = kruskal(c_JG_edges);
fprintf('hex_setup.max_span_tree: junction tree weight: %d\n', JT_weight);

% Convert adjacency matrix by performing a depth-first search. Record each
% clique's parent and children, and clique sequence of up (first) message
% pass. The sequence of down (second) message pass is simply the revert.
% c_parent_vec records each clique's parent clique index (0 for root)
c_parent_vec = zeros(num_c, 1);
% c_children_cell records eqch clique's children clique indices (empty
% for leaf)
c_children_cell = cell(num_c, 1);
% the clique indices in up passage pass sequence.
up_pass_seq = [];

% depth-first search
% Select an arbitrary clique as root.
JT_root_c = 1;
c_visited = false(num_c, 1);
c_this = JT_root_c;
while true
  c_neighbors = find(E_JT(:, c_this));
  % Visit all current clique's children who has not been visited yet.
  % If no children (leaf) or all children have been visited, then visit
  % current clique and back to parent. 
  % message and to back to parents. If no parent (root), then stop.
  visit_child = false;
  c_parent = c_parent_vec(c_this);
  for n = 1:length(c_neighbors)
    c_child = c_neighbors(n);
    if (c_child ~= c_parent) && (~c_visited(c_child))
      visit_child = true;
      break
    end
  end
  if visit_child
    % set up the parent node and separator of this child
    c_parent_vec(c_child) = c_this;
    % go down to its child clique
    c_this = c_child;
  else
    % visit current clique
    c_visited(c_this) = true;
    % set up current clique's children
    c_adjacency = E_JT(:, c_this);
    if c_parent > 0
      c_adjacency(c_parent) = false;
    end
    c_children_cell{c_this} = find(c_adjacency);
    % add current clique to up-pass sequence
    up_pass_seq = cat(1, up_pass_seq, c_this);
    
    % go up to its parent clique if it is not root, otherwise stop.
    if c_parent_vec(c_this) > 0
      c_this = c_parent_vec(c_this);
    else
      break
    end
  end
end
assert(length(up_pass_seq) == num_c);
G.c_parent_vec = c_parent_vec;
G.c_children_cell = c_children_cell;
G.up_pass_seq = up_pass_seq;

end

function [E_t, w] = kruskal(PV)
% [E_t, w] = kruskal(PV)
%   Kruskal algorithm for finding maximum spanning tree
%
%   PV is nx3 martix. 1st and 2nd row's define the edge (2 vertices) and the
%   3rd is the edge's weight.
%   E_t is adjacency matrix of maximum spanning tree
%   w is maximum spanning tree's weight

% code modified from
% http://www.mathworks.com/matlabcentral/fileexchange/13457-kruskal-algorithm
% N.Cheilakos,2006

num_edge = size(PV,1);
num_node = max(max(PV(:, 1), max(PV(:, 2))));
% sort PV by descending weights order.
PV = fysalida(PV,3);
korif = zeros(1, num_node);
E_t = false(num_node);
insert_vec = true(num_edge, 1);
for i = 1:num_edge
  % control if we insert edge[i,j] in the graphic. Then the graphic has
  % circle
  akmi = PV(i, [1 2]);
  [korif, c] = iscycle(korif, akmi);
  % insert the edge iff it does not introduce a circle
  insert_vec(i) = (c == 0);
  % Create maximum spanning tree's adjacency matrix
  if insert_vec(i)
    E_t(PV(i, 1), PV(i, 2)) = true;
    E_t(PV(i, 2), PV(i, 1)) = true;
  end
end
% Calculate maximum spanning tree's weight
w = sum(PV(insert_vec, 3));

end

function [korif, c] = iscycle(korif, akmi)
% [korif, c] = iscycle(korif, akmi)
%   Test whether there will be a circle if a new edge is added
%
%   korif is set of vertices in the graph
%   akmi is edge we insert in graph
%   c = 1 if we have circle, else c = 0

% code modified from
% http://www.mathworks.com/matlabcentral/fileexchange/13457-kruskal-algorithm
% N.Cheilakos,2006

g=max(korif)+1;
c=0;
n=length(korif);
if korif(akmi(1))==0 && korif(akmi(2))==0
  korif(akmi(1))=g;
  korif(akmi(2))=g;
elseif korif(akmi(1))==0
  korif(akmi(1))=korif(akmi(2));
elseif korif(akmi(2))==0
  korif(akmi(2))=korif(akmi(1));
elseif korif(akmi(1))==korif(akmi(2))
  c=1;
  return
else
  m=max(korif(akmi(1)),korif(akmi(2)));
  for i=1:n
    if korif(i)==m
      korif(i)=min(korif(akmi(1)),korif(akmi(2)));
    end
  end
end

end

function A = fysalida(A, col)
% A = fysalida(A, col)
%   swap matrix's rows, because we sort column (col) by descending order
%
%   A is matrix
%   col is column we want to sort

% code modified from
% http://www.mathworks.com/matlabcentral/fileexchange/13457-kruskal-algorithm
% N.Cheilakos,2006

[~, c] = size(A);
if col < 1 || col > c || fix(col) ~= col
  error(['error input value second argumment takes only integer values ' ...
    'between 1 & ' num2str(c)]);
end

[~, IX] = sort(A(:, col), 'descend');
A = A(IX, :);

end