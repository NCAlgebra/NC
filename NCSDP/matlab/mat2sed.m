function [At, b, c, K] = mat2sed(infile);
% MAT2SED Reads a SeDuMi problem stored in compact form in 'infile.mm'
%
% [At, b, c, K] = mat2sed(infile);
%
% Author: Mauricio de Oliveira
%   Date: August 2009

% Load big problem
P = mmread([infile '.mm']);

n = P(1,1);

b = P(1, 2:n+1)';
At = P(2:end-1, 1:n);
c = P(2:end-1, n+1);

Kline = full(P(end, :));
K.f = Kline(1);
K.l = Kline(2);

i = 3;
m = Kline(i);
K.q = Kline(i+1:i+m);
i = i + m + 1;

m = Kline(i);
K.r = Kline(i+1:i+m);
i = i + m + 1;

m = Kline(i);
K.s = Kline(i+1:i+m);
i = i + m + 1;
