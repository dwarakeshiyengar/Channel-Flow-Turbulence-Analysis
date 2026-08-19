clear;
close all;
clc;

run('config.m');

z_index = round(Nz/2);   % change this to inspect a different plane

filename = fullfile(dataDir, ...
    sprintf('u_stream_z%d.csv',z_index));

u = readmatrix(filename);

Nx_data = size(u,2);

rms_x = zeros(Nx_data,1);

for j = 1:Nx_data

    u_col = u(:,j);

    u_mean = mean(u_col);

    u_fluct = u_col - u_mean;

    rms_x(j) = sqrt(mean(u_fluct.^2));

end

figure;

plot(x,rms_x,'-o', ...
    'LineWidth',1.5,'MarkerSize',5);

xlabel('x');
ylabel('RMS of u''');

title(sprintf('RMS of Streamwise Fluctuation u'' vs x, z/h = %.3f', ...
    z_by_h(z_index)));

grid on;
