function check_consistency(G)
% check_consistency(G)
%   Check if a HEX Graph is legal and consistent (no dead nodes)
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

E_h = G.E_h;
E_e = G.E_e;
num_v = G.num_v;

% check whether the type and size of E_h and E_e are valid
assert(islogical(E_h) && islogical(E_e));
assert(size(E_h, 1) == size(E_h, 2) && size(E_e, 1) == size(E_e, 2));
assert(size(E_h, 1) == size(E_e, 1));

% both E_h and E_e must not have self-loops
assert(~any(diag(E_h, 0)));
assert(~any(diag(E_e, 0)));

% basic checks for hierarchy and exclusion edges:
%   E_h must satisfy that ~(E_h(i, j) && E_h(j, i)))
%   E_e must satisfy that E_e(i, j) == E_e(j, i))
%   E_h and E_e must satisify that E_h(i, j) && E_e(i, j) == 0, since
%   hierarchy and exclusion cannot appear simutaneously
for i = 1:num_v
  for j = 1:num_v
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