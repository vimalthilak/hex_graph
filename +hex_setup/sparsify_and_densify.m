function G = sparsify_and_densify(G)
% G = sparsify_and_densify(G)
%   Sparsify and densify a HEX Graph to obtain equivalent maximal-sparse
%   and maximal-dense HEX Graph
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

% TODO (Ronghang Hu): implement the sparsify and densify procedures
G.E_sh = G.E_h;
G.E_se = G.E_e;
G.E_dh = G.E_h;
G.E_de = G.E_e;

end