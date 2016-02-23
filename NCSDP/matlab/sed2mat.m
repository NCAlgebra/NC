function P = sed2mat(At, b, c, K, file);
% SED2MAT Saves a SeDuMi problem stored in compact form in 'file.mm'
%
% P = sed2mat(At, b, c, K, file);
%
% On exit P is the compact storage for the problem.
%
% Alternatively, the syntax
% 
% sed2mat(infile, outfile);
%
% reads (At, b, c, K) from infile.mat. Or
%
% sed2mat(file);
%
% which reads from 'file.mat' and saves to 'file.mm'
%
% Author: Mauricio de Oliveira
%   Date: August 2009

% Check input arguments
if (nargin < 1 || (nargin > 2 & nargin ~= 5))
  error('Wrong number of arguments.');
end

disp(['SED2MAT']);

if (nargin == 1)
  % Read data from file
  infile = [At '.mat'];
  % Write on file
  outfile = [At '.mm'];
elseif (nargin == 2)
  % Read data from file
  infile = [At '.mat'];
  % Write on file
  outfile = [b '.mm'];
else
  % Write on file
  outfile = [file '.mm'];
end

if (nargin ~= 5)
  disp(['> Reading file ''' infile '''']);
  data = load(infile, 'At', 'b', 'c', 'K');
  At = data.At;
  b = data.b;
  c = data.c;
  K = data.K;
end

% Assemble compact problem
disp('> Assembling data');

% dimensions
n = length(b);
m = length(c);

disp(['> Problem dimensions: (n, m) = (' num2str(n) ', ' num2str(m) ')']);
disp(['> Variables:']);

% info
info = [];
if isfield(K, 'f')
  info(1) = K.f;
  disp(['  Free = ' num2str(K.f) ]);
else
  info(1) = 0;
end
if isfield(K, 'l')
  info(2) = K.l;
  disp(['  Positive = ' num2str(K.l) ]);
else
  info(2) = 0;
end
if isfield(K, 'q')
  info = [info length(K.q) K.q(:)'];
  disp(['  Lorentz = ' num2str(length(K.q)) ]);
else
  info = [info 0];
end
if isfield(K, 'r')
  info = [info length(K.r) K.r(:)'];
  disp(['  Rotated Lorentz = ' num2str(length(K.r)) ]);
else
  info = [info 0];
end
if isfield(K, 's')
  info = [info length(K.s) K.s(:)'];
  disp(['  SD = ' num2str(length(K.s)) ]);
else
  info = [info 0];
end
r = length(info);

% Assemble sparse storage
P = sparse(m+2, max([n r]));

P = [sparse([n b']); At c];
P(m+2, 1:r) = info;

% Make sure it is sparse
P = sparse(P);

% And save in MM format
disp(['> Wrinting file ''' outfile '''']);
mmwrite(outfile, P);
