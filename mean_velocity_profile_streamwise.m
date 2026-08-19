clear;
close all;
clc;

run('config.m');

figure;
hold on;

for i = 1:Nz

    filename = fullfile(dataDir, ...
        sprintf('u_stream_z%d.csv',i));

    u = readmatrix(filename);

    mean_u_x = mean(u,1);

    plot(x,mean_u_x, ...
        'DisplayName',sprintf('z/h = %.3f',z_by_h(i)), ...
        'LineWidth',1.5);

end

xlabel('Streamwise Position, x');
ylabel('Time-averaged Streamwise Velocity, \langle u \rangle');

title('Mean Streamwise Velocity along x for All z-Levels');

legend show;
grid on;
