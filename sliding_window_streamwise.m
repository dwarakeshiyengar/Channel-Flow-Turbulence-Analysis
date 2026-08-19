clear;
close all;
clc;

run('config.m');

max_devs_percent = zeros(Nz,1);

figure;

tiledlayout(ceil(Nz/2),2);

for i = 1:Nz

    filename = fullfile(dataDir, ...
        sprintf('u_stream_z%d.csv',i));

    u = readmatrix(filename);

    Nt = size(u,1);
    num_windows = Nt - windowSize + 1;

    full_mean = mean(u(:));

    sliding_means = zeros(num_windows,1);

    for k = 1:num_windows

        window_data = u(k:k+windowSize-1,:);

        sliding_means(k) = mean(window_data(:));

    end

    max_devs_percent(i) = max(abs(sliding_means-full_mean)) ...
        / abs(full_mean)*100;

    nexttile;

    plot(sliding_means,'LineWidth',1.2);
    hold on;

    yline(full_mean,'--r','Full Mean', ...
        'LabelVerticalAlignment','bottom');

    xlabel('Window Start Index');
    ylabel('Sliding Mean');

    title(sprintf('z/h = %.3f',z_by_h(i)));

    grid on;

end

sgtitle('Sliding Window Mean vs Time (All z Levels, Streamwise)');

disp('Max deviation from full mean at each z-position (% of mean):');
for i = 1:Nz
    fprintf('z/h = %.3f: Max Deviation = %.4f%%\n', ...
        z_by_h(i), max_devs_percent(i));
end
