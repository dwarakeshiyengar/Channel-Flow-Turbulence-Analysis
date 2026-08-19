clear;
close all;
clc;

run('config.m');

max_devs_percent = zeros(length(z_indices),1);

figure;

for n = 1:length(z_indices)

    i = z_indices(n);

    filename = fullfile(dataDir, ...
        sprintf('u_span_z%d.csv',i));

    if ~isfile(filename)
        continue;
    end

    u = readmatrix(filename);

    Nt = size(u,1);
    num_windows = Nt - windowSize + 1;

    full_mean = mean(u(:));

    sliding_means = zeros(num_windows,1);

    for k = 1:num_windows

        window_data = u(k:k+windowSize-1,:);

        sliding_means(k) = mean(window_data(:));

    end

    max_devs_percent(n) = max(abs(sliding_means-full_mean)) ...
        / abs(full_mean)*100;

    subplot(length(z_indices),1,n);

    plot(sliding_means,'LineWidth',1.2);
    hold on;

    yline(full_mean,'--r','Full Mean', ...
        'LabelVerticalAlignment','bottom');

    xlabel('Window Start Index');
    ylabel('Sliding Mean');

    title(sprintf('Sliding Mean: u_{span} at z/h = %.3f', ...
        z_by_h(i)));

    grid on;

end

sgtitle('Stationarity Check via Sliding Window (Spanwise Data)');

disp('Max deviation from full mean (% of mean) for spanwise data:');
for n = 1:length(z_indices)
    fprintf('z/h = %.3f: Max Deviation = %.4f%%\n', ...
        z_by_h(z_indices(n)), max_devs_percent(n));
end
