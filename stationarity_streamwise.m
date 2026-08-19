clear;
close all;
clc;

run('config.m');

figure;

tiledlayout(ceil(Nz/2),2);

for i = 1:Nz

    filename = fullfile(dataDir, ...
        sprintf('u_stream_z%d.csv',i));

    u = readmatrix(filename);

    mean_u_time = mean(u,2);

    nexttile;

    plot(mean_u_time,'LineWidth',1);

    xlabel('Time step');
    ylabel('\langle u \rangle_x');

    title(sprintf('z/h = %.3f',z_by_h(i)));

    grid on;

end

sgtitle('Stationarity Check: Streamwise Data (mean over x)');
