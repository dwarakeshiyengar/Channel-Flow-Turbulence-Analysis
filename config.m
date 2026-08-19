dataDir = 'data';

x = readmatrix(fullfile(dataDir, 'x.csv'));
y = readmatrix(fullfile(dataDir, 'y.csv'));
z = readmatrix(fullfile(dataDir, 'z.csv'));

x = x(:);
y = y(:);
z = z(:);

Nx = length(x);
Ny = length(y);
Nz = length(z);

dx = mean(diff(x));
dy = mean(diff(y));

H = max(z) - min(z);
h = H/2;

z_by_h = (z - min(z))/h;

windowSize = 500;

% Representative wall-normal planes (near-wall, mid-height, outer edge)
% used by any script that only analyzes a subset of z-levels.
z_indices = unique([1, round(Nz/2), Nz]);
