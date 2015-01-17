function [loss, gradients, p_margin, p0] = hex_run(G, f, l, back_propagate)
% [loss, gradients, p_margin] = hex_run(G, f, l, back_propagate)
%   Compute marginal probability, (log-marginal-likelihood) HEX Loss and
%   loss gradient w.r.t. f
%
%   G is the structure containing the whole HEX Graph
%   f is raw scores of all variables
%   l is variable index of label (1-indexed), and 0 for none-of-classes
%   (background)
%   back_propagate is boolean variable. Gradients are only evaluated when
%   this variable is set true
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

% l is scalar, 1-indexed for class in HEX Graph, and 0 for background
assert(length(f) == num_v);

% Part 1: forward pass

% step 1: assign potentials to each clique and get potential tables
c_p_cell = hex_run.assign_potential(G, f);

% step 2: sum-product message pass to get message of each cell
c_m_cell = hex_run.pass_message(G, c_p_cell);

% step 3: marginalize within each clique to get (unnormalized) marginal
% probability and partition function of each variable
[Pr_margin, Z, ~] = hex_run.marginalize(G, c_m_cell, c_p_cell);

% normalize the probability
p_margin = Pr_margin / Z;
p0 = 1 / Z;

if ~back_propagate
  gradients = zeros(num_v, 1);
  loss = 0;
  return
else
  assert(length(l) == 1);
  assert(l >= 0 && l <= num_v);
end

% Part 2: backward pass
if l > 0
  % clamp the potential table and re-run message pass
  c_p_cell = hex_run.clamp_potential(c_p_cell, G, l);
  c_m_cell = hex_run.pass_message(G, c_p_cell);
  [Pr_joint_margin, ~, ~] = hex_run.marginalize(G, c_m_cell, c_p_cell);
  
  loss = log(p_margin(l));
  gradients = Pr_joint_margin ./ Pr_margin(l) - Pr_margin / Z;
else
  loss = log(p0);
  gradients = - Pr_margin / Z;
end

end