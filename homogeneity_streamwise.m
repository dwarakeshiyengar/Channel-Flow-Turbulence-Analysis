clear;
close all;
clc;

run('config.m');

max_dev_x = zeros(Nz,1);

figure;

tiledlayout(ceil(Nz/2),2,'TileSpacing','compact');

for i = 1:Nz

    filename = fullfile(dataDir, ...
        sprintf('u_stream_z%d.csv',i));

    u = readmatrix(filename);

    mean_u_x = mean(u,1);

    overall_mean = mean(mean_u_x);

    max_dev_x(i) = max(abs(mean_u_x-overall_mean)) ...
        / abs(overall_mean)*100;

    nexttile;

    plot(x,mean_u_x,'-o', ...
        'LineWidth',1.2,'MarkerSize',4, ...
        'MarkerFaceColor','auto');

    xlabel('x');
    ylabel('\langle u \rangle');

    title(sprintf('z/h = %.3f | Max Dev: %.2f%%', ...
        z_by_h(i),max_dev_x(i)));

    grid on;

end

sgtitle('Streamwise Homogeneity: Time-Averaged u vs x (All z Levels)');
