function test_hex_graph

% Test example 0
num_var = 3;
E_h = false(num_var);
E_h(1, 2) = true;
E_h(2, 3) = true;

E_e = false(num_var);
f = ones(num_var, 1);

% % Test example 1
% num_var = 5;
% 
% % adjacency matrix of hierarchy edges
% E_h = false(num_var);
% E_h(1, 2) = true;
% E_h(2, 3) = true;
% E_h(1, 5) = true;
% E_h(5, 4) = true;
% 
% % adjacency matrix of exclusion edges
% E_e = false(num_var);
% E_e(3, 4) = true;
% E_e = E_e | E_e';
% 
% % raw category scores of this instance
% % f = randn(5, 1);
% f = zeros(5, 1);

% label of this instance
l = randperm(num_var + 1, 1) - 1;

fprintf('Test Example 1\n');
fprintf('  raw scores: ');
fprintf('%f ', f);
fprintf('\n');
fprintf('  label: %d\n', l);

G = hex_setup(E_h, E_e);
back_propagate = true;
[loss, gradients, p_margin, p0] = hex_run(G, f, l, back_propagate);

fprintf('Junction Tree results\n');
fprintf('  marginal probability: ');
fprintf('%f ', [p_margin; p0]);
fprintf('\n');
fprintf('  loss: %f\n', loss)
fprintf('  gradients: ');
fprintf('%f ', gradients');
fprintf('\n');

[loss_bf, gradients_bf, p_margin_bf, p0_bf] = hex_test.brute_force_run(G, f, l);
fprintf('Brute Force results\n');
fprintf('  marginal probability: ');
fprintf('%f ', [p_margin_bf; p0_bf]);
fprintf('\n');
fprintf('  loss: %f\n', loss_bf)
fprintf('  gradients: ');
fprintf('%f ', gradients_bf');
fprintf('\n');

% Test example 2

% num_var = 5;
% E_h = false(num_var);
%
% E_e = false(num_var);
% E_e(1, 2) = true;
% E_e(1, 3) = true;
% E_e(2, 4) = true;
% E_e(3, 4) = true;
% E_e(2, 5) = true;
% E_e(3, 5) = true;
% E_e(4, 5) = true;
% E_e = E_e | E_e';

end