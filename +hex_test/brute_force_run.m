function [loss, gradients, p_margin, p0] = brute_force_run(G, f, l)
% p_margin = brute_force_forward(G, f)
%   Forward with brute-force as a check
%
%   G is the structure containing the whole HEX Graph
%   f is raw scores of all variables
%   p_margin is normalized marginal probability of each variable
%   loss is log marginal likelihood of label
%   gradients is derivatives of loss w.r.t f (raw scores)
%   p_margin is normalized marginal probability of each variable
%   p0 is the marginal probability of being background

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2015, Ronghang Hu (huronghang@hotmail.com)
%
% This file is part of the HEX Graph code and is available
% under the terms of the Simplified BSD License provided in
% LICENSE. Please retain this notice and LICENSE if you use
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

num_v = G.num_v;
E_dh = G.E_dh;
E_de = G.E_de;

if num_v > 10
  warning('brute force run can be very slow when variable number is large');
end

exp_f = exp(f);

% unnormalized marginal probability
Pr_margin = zeros(num_v, 1);

% partition function
Z = 0;

% raw gradient, partial Pr_margin(l) / partial f_j for j = 1:num_v
gradients_Pr = zeros(num_v, 1);
% raw gradient, partial Z / partial f_j for j = 1:num_v
gradients_Z = zeros(num_v, 1);

% list state space (with brute force) and marginalize (also with brute force)
% by traverse through state space

% enumerate all (2^num_v) possible states in HEX Graph
divide_vec = 2 .^ (num_v-1:-1:0);
for sid = 0:(2^num_v - 1)
  s = mod(floor(sid ./ divide_vec), 2) > 0;
  % check (with brute-force) whether this state is legal
  is_legal = true;
  for v1 = 1:num_v
    if ~is_legal
      break
    end
    for v2 = 1:num_v
      if ~is_legal
        break
      end
      y1 = s(v1);
      y2 = s(v2);
      if (E_de(v1, v2) && y1 && y2) || (E_dh(v1, v2) && ~y1 && y2)
        is_legal = false;
      end
    end
  end
  if is_legal
    % accumulate belief
    Pr = prod(exp_f(s));
    Pr_margin(s) = Pr_margin(s) + Pr;
    Z = Z + Pr;
    
    % accumulate gradients
    g = Pr * s';
    if l > 0 && s(l)
      gradients_Pr = gradients_Pr + g;
    end
    gradients_Z = gradients_Z + g;
  end
end

p_margin = Pr_margin / Z;
p0 = 1 / Z;

if l > 0
  loss = log(p_margin(l));
else
  loss = log(p0);
end

if l > 0
  gradients = gradients_Pr / Pr_margin(l) - gradients_Z / Z;
else
  gradients = - gradients_Z / Z;
end

end