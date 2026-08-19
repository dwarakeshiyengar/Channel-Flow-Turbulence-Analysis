clear;
close all;
clc;

run('config.m');

figure;

tiledlayout(1,length(z_indices));

for n = 1:length(z_indices)

    i = z_indices(n);

    filename = fullfile(dataDir, ...
        sprintf('u_stream_z%d.csv',i));

    u = readmatrix(filename);

    Nt = size(u,1);
    Nx_data = size(u,2);

    R = zeros(1,2*Nx_data-1);

    for t = 1:Nt

        u_fluct = u(t,:) - mean(u(t,:));

        R = R + xcorr(u_fluct,'biased');

    end

    R = R/Nt;

    R = R(Nx_data:end);

    R = R/R(1);

    r = (0:length(R)-1)*dx;

    nexttile;

    plot(r,R,'-o', ...
        'LineWidth',1.3);

    xlabel('r_x');
    ylabel('R_{uu}(r_x)');

    title(sprintf('z/h = %.3f',z_by_h(i)));

    grid on;

end

sgtitle('Streamwise Two-Point Correlation');
