clear;
close all;
clc;

run('config.m');

mean_u = zeros(Nz,1);

for i = 1:Nz

    filename = fullfile(dataDir, ...
        sprintf('u_stream_z%d.csv',i));

    u = readmatrix(filename);

    mean_u(i) = mean(u(:));

end

figure;

plot(z_by_h,mean_u,'o-', ...
    'LineWidth',1.5);

xlabel('z/h');
ylabel('\langle u \rangle');

title('Mean Velocity Profile vs Wall-normal Position');

grid on;
