clear;
close all;
clc;

run('config.m');

max_dev_y = zeros(length(z_indices),1);

figure;

tiledlayout(1,length(z_indices),'TileSpacing','compact');

for n = 1:length(z_indices)

    i = z_indices(n);

    filename = fullfile(dataDir, ...
        sprintf('u_span_z%d.csv',i));

    if ~isfile(filename)
        continue;
    end

    u = readmatrix(filename);

    mean_u_y = mean(u,1);

    overall_mean = mean(mean_u_y);

    max_dev_y(n) = max(abs(mean_u_y-overall_mean)) ...
        / abs(overall_mean)*100;

    nexttile;

    plot(y,mean_u_y,'-o', ...
        'LineWidth',1.3,'MarkerSize',4, ...
        'MarkerFaceColor','auto');

    xlabel('y');
    ylabel('\langle u \rangle');

    title(sprintf('z/h = %.3f | Max Dev: %.2f%%', ...
        z_by_h(i),max_dev_y(n)));

    grid on;

end

sgtitle('Spanwise Homogeneity: Time-Averaged u vs y');
