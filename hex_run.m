function [loss, gradients, p_margin] = hex_run(G, f, l, back_propagate)
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

if ~back_propagate
  gradients = 0;
  loss = 0;
  return
else
  assert(length(l) == 1);
  assert(l >= 0 && l <= num_v);
  loss = log(p_margin(l));
end

% Part 2: backward pass

end