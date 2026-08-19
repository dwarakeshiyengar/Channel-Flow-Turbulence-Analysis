clear;
close all;
clc;

run('config.m');

mean_u = zeros(Nz,1);
rms_u = zeros(Nz,1);
skew_u = zeros(Nz,1);
flat_u = zeros(Nz,1);

for i = 1:Nz

    filename = fullfile(dataDir, ...
        sprintf('u_stream_z%d.csv',i));

    u = readmatrix(filename);

    u_flat = u(:);

    mean_u(i) = mean(u_flat);

    u_fluct = u_flat - mean_u(i);

    rms_u(i) = sqrt(mean(u_fluct.^2));

    skew_u(i) = skewness(u_flat);
    flat_u(i) = kurtosis(u_flat);

end

figure;
tiledlayout(2,2);

nexttile;
plot(z_by_h,mean_u,'-o','LineWidth',1.5,'MarkerSize',5);
xlabel('z/h'); ylabel('\langle u \rangle');
title('Mean Streamwise Velocity vs z/h');
grid on;

nexttile;
plot(z_by_h,rms_u,'-o','LineWidth',1.5,'MarkerSize',5);
xlabel('z/h'); ylabel('RMS of u''');
title('Root Mean Square of Fluctuating Velocity u'' vs z/h');
grid on;

nexttile;
plot(z_by_h,skew_u,'-o','LineWidth',1.5,'MarkerSize',5);
xlabel('z/h'); ylabel('Skewness(u)');
title('Skewness of u vs z/h');
grid on;

nexttile;
plot(z_by_h,flat_u,'-o','LineWidth',1.5,'MarkerSize',5);
xlabel('z/h'); ylabel('Flatness(u)');
title('Flatness (Kurtosis) of u vs z/h');
grid on;

sgtitle('Turbulence Statistics vs Wall-normal Position');
