function check_graph_consistency(G)
% E_h and E_e are adjacency matrix of hierarchy edge and exclusion edge

E_h = G.E_h;
E_e = G.E_e;

% check if the size is valid
assert(islogical(E_h) && islogical(E_e));
assert(size(E_h, 1) == size(E_h, 2) && size(E_e, 1) == size(E_e, 2));
assert(size(E_h, 1) == size(E_e, 1));

num_V = size(E_h, 1);

% both E_h and E_e must not have self-loops
assert(~any(diag(E_h, 0)));
assert(~any(diag(E_e, 0)));

% E_h must satisfy that ~(E_h(i, j) && E_h(j, i)))
% E_e must satisfy that E_e(i, j) == E_e(j, i))
% E_h and E_e must satisify that E_h(i, j) && E_e(i, j) == 0, since
% hierarchy and exclusion cannot appear simutaneously
for i = 1:num_V
  for j = 1:num_V
    assert(~(E_h(i, j) && E_h(j, i)));
    assert(E_e(i, j) == E_e(j, i));
    assert(~(E_h(i, j) && E_e(i, j)));
  end
end

% TODO (Ronghang Hu): Check for consistency:
% 1. no directed (hierarchy) loop
% 2. for each node, no exclusion edge between its ancestors or between
% itself and its ancestors
% 3. the graph must be connected

end