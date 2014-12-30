function G = hex_setup(E_h, E_e)
% G = hex_setup(E_h, E_e)
%   Set up a HEX Graph using adjacency matrix
%
%   E_h is the adjacency logical matrix of hierarchy edges
%   E_e is the adjacency logical matrix of exclusion edges

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2015, Ronghang Hu (huronghang@hotmail.com)
% 
% This file is part of the HEX Graph code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

% G is the structure containing the whole HEX Graph
G.E_h = E_h;
G.E_e = E_e;
G.num_v = size(G.E_h, 1);

% Check if the HEX graph is consistent
hex_setup.check_consistency(G);

% Set up a HEX Graph for forward pass and backward pass
% step 1: sparsify and densify a graph
G = hex_setup.sparsify_and_densify(G);

% step 2: build junction tree and record 
G = hex_setup.triangularize(G);
G = hex_setup.max_span_tree(G);

% step 3: list state space and record sum-product operations
G = hex_setup.list_state_space(G);
G = hex_setup.record_sumprod(G);

end