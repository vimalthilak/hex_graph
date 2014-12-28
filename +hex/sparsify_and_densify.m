function G = sparsify_and_densify(G)
% sparsify and densify the graph

% Check if the HEX graph is consistent
check_graph_consistency(G);

% TODO (Ronghang Hu): implement the sparsify and densify procedures
G.E_sh = G.E_h;
G.E_se = G.E_e;
G.E_dh = G.E_h;
G.E_de = G.E_e;

end

