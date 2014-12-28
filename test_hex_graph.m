clear;

%% Example
num_var = 5;
E_h = false(num_var);
E_e = false(num_var);

E_h(1, 2) = true;
E_h(2, 3) = true;
E_h(1, 5) = true;
E_h(5, 4) = true;

E_e(3, 4) = true;

% E_e(1, 2) = true;
% E_e(1, 3) = true;
% E_e(2, 4) = true;
% E_e(3, 4) = true;
% E_e(2, 5) = true;
% E_e(3, 5) = true;
% E_e(4, 5) = true;

E_e = E_e | E_e';
G.E_h = E_h;
G.E_e = E_e;

f = rand(num_var, 1);

%% HEX Graph
check_graph_consistency(G);
G = sparsify_and_densify(G);
G = triangularize(G);
G = max_span_tree(G);
G = list_state_space(G);
potential_cell = assign_potential(f, G);
