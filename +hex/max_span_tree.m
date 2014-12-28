function G = max_span_tree(G)
% Generate Junction Tree (Max Span Tree) from Junction Graph, using Kruskal
% Algorithm

% Note: undirected edge is only stored once in clq_g_edges.
clq_g_edges = G.clq_g_edges;

% Use Kruskal Algorithm to generate maximal spanning tree.
[weight, E_JT] = kruskal(clq_g_edges);
fprintf('total weight of junction tree: %d\n', weight);

G.E_JT = E_JT;

end

function [w, E_t] = kruskal(PV)
% code modified from
% http://www.mathworks.com/matlabcentral/fileexchange/13457-kruskal-algorithm
% Kruskal algorithm for finding minimum spanning tree
%
% Input:  PV = nx3 martix. 1st and 2nd row's define the edge (2 vertices) and
% the 3rd is the edge's weight
% Output: w = Maximum spanning tree's weight
%         T = Maximum spanning tree's adjacency matrix
%
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
% code modified from
% http://www.mathworks.com/matlabcentral/fileexchange/13457-kruskal-algorithm
% input: korif = set of vertices in the graph
%       akmi = edge we insert in graph
% output: korif = The "new: set of vertices
%        c = 1 if we have circle, else c = 0
%
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
% swap matrix's rows, because we sort column (col) by descending order
% code modified from
% http://www.mathworks.com/matlabcentral/fileexchange/13457-kruskal-algorithm
% input: A =  matrix
%        col = column we want to sort
% output:A = sorted matrix
%
% N.Cheilakos,2006

[~, c] = size(A);
if col < 1 || col > c || fix(col) ~= col
  error(['error input value second argumment takes only integer values between 1 & ' num2str(c)]);
end

[~, IX] = sort(A(:, col), 'descend');
A = A(IX, :);

end