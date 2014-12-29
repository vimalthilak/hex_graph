clear;

%% Example 1
num_var = 5;
E_h = false(num_var);
E_e = false(num_var);

E_h(1, 2) = true;
E_h(2, 3) = true;
E_h(1, 5) = true;
E_h(5, 4) = true;

E_e(3, 4) = true;

E_e = E_e | E_e';
G = hex_setup(E_h, E_e);

%% Example 2

% num_var = 5;
% E_h = false(num_var);
% E_e = false(num_var);
% 
% E_e(1, 2) = true;
% E_e(1, 3) = true;
% E_e(2, 4) = true;
% E_e(3, 4) = true;
% E_e(2, 5) = true;
% E_e(3, 5) = true;
% E_e(4, 5) = true;
% 
% E_e = E_e | E_e';
