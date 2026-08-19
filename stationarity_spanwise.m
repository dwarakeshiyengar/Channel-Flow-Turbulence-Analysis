clear;
close all;
clc;

run('config.m');

figure;
hold on;

for n = 1:length(z_indices)

    i = z_indices(n);

    filename = fullfile(dataDir, ...
        sprintf('u_span_z%d.csv',i));

    if ~isfile(filename)
        continue;
    end

    u = readmatrix(filename);

    mean_u_time = mean(u,2);

    plot(mean_u_time, ...
        'DisplayName',sprintf('z/h = %.3f',z_by_h(i)), ...
        'LineWidth',1.2);

end

xlabel('Time step');
ylabel('Mean Streamwise Velocity');

title('Stationarity Check for Spanwise Data');

legend show;
grid on;
