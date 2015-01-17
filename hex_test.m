function hex_test

% Test example 1
fprintf('############ Test Example 1 ############\n');
num_var = 3;
E_h = false(num_var);
E_h(1, 2) = true;
E_h(2, 3) = true;
E_e = false(num_var);

f = randn(num_var, 1);
l = randperm(num_var + 1, 1) - 1;
run_test_example(E_h, E_e, f, l);

% Test example 2
fprintf('############ Test Example 2 ############\n');
num_var = 5;
E_h = false(num_var);
E_h(1, 2) = true;
E_h(2, 3) = true;
E_h(1, 5) = true;
E_h(5, 4) = true;
E_e = false(num_var);
E_e(3, 4) = true;
E_e = E_e | E_e';

f = randn(num_var, 1);
l = randperm(num_var + 1, 1) - 1;
run_test_example(E_h, E_e, f, l);

% Test example 3
fprintf('############ Test Example 3 ############\n');
num_var = 5;
E_h = false(num_var);
E_e = false(num_var);
E_e(1, 2) = true;
E_e(1, 3) = true;
E_e(2, 4) = true;
E_e(3, 4) = true;
E_e(2, 5) = true;
E_e(3, 5) = true;
E_e(4, 5) = true;
E_e = E_e | E_e';

f = randn(num_var, 1);
l = randperm(num_var + 1, 1) - 1;
run_test_example(E_h, E_e, f, l);

end

function test_passed = run_test_example(E_h, E_e, f, l)

fprintf('  raw scores: ');
fprintf('%.3f ', f);
fprintf('\n');
fprintf('  label: %d\n', l);

G = hex_setup(E_h, E_e);
back_propagate = true;
[loss, gradients, p_margin, p0] = hex_run(G, f, l, back_propagate);

fprintf('Junction Tree results\n');
fprintf('  marginal probability: ');
fprintf('%.3f ', [p_margin; p0]);
fprintf('\n');
fprintf('  loss: %.3f\n', loss)
fprintf('  gradients: ');
fprintf('%.3f ', gradients');
fprintf('\n');

[loss_bf, gradients_bf, p_margin_bf, p0_bf] = hex_test.brute_force_run(G, f, l);
fprintf('Brute Force results\n');
fprintf('  marginal probability: ');
fprintf('%.3f ', [p_margin_bf; p0_bf]);
fprintf('\n');
fprintf('  loss: %.3f\n', loss_bf)
fprintf('  gradients: ');
fprintf('%.3f ', gradients_bf');
fprintf('\n');

eps = 1e-4;
p_margin_diff = abs([p_margin; p0] - [p_margin_bf; p0_bf]);
loss_diff = abs(loss - loss_bf);
gradients_diff = gradients_bf - gradients;

fprintf('probability difference: ');
fprintf('%.3f ', p_margin_diff);
fprintf('\n');
fprintf('loss difference: %.3f\n', loss_diff);
fprintf('gradient difference: ');
fprintf('%.3f ', gradients_diff);
fprintf('\n');

test_passed = all(p_margin_diff <= eps) ...
  && all(loss_diff <= eps) ...
  && all(gradients_diff <= eps);

if test_passed
  fprintf('TEST PASSED\n');
else
  warning('TEST FAILED');
end

end