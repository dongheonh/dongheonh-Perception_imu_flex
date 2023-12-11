clear, clc
load flexCalibration.mat

v_flex1 = pitch(:,1);
v_flex2 = pitch(:,2);
v_flex3 = pitch(:,3);
deg = 0:10:90;

quadraticFit = fittype('poly2');

volt_1 = v_flex1(1):v_flex1(end);
volt_2 = v_flex2(1):v_flex2(end);
volt_3 = v_flex3(1):v_flex3(end);
numb_sensors = 3;

plot_param = zeros(3,numb_sensors);

%% sensor 1 
[quadratic_fit_plot, rmse_poly] = fit(v_flex1, deg',quadraticFit);
figure(1)
plot(v_flex1, deg, 'b*','LineWidth',2)
hold on 
plot(volt_1,quadratic_fit_plot.p1.*volt_1.^2 + ...
    quadratic_fit_plot.p2*volt_1 + quadratic_fit_plot.p3, 'k' ,'LineWidth', 2.5)
title('Voltage vs Angle Calibration', 'FontSize',15)
ylabel('Angle \theta (Deg)', 'FontSize',13)
xlabel('Voltage (V)', 'FontSize',13)
predBounds = predint(quadratic_fit_plot, v_flex1, 0.95);
plot(v_flex1, predBounds, 'r--','LineWidth',2); % prediction bounds

plot_param(1,1) = quadratic_fit_plot.p1;
plot_param(2,1) = quadratic_fit_plot.p2;
plot_param(3,1) = quadratic_fit_plot.p3;

%% sensor 2
[quadratic_fit_plot, rmse_poly] = fit(v_flex2, deg',quadraticFit);
figure(2)
plot(v_flex2, deg, 'b*','LineWidth',2)
hold on 
plot(volt_2,quadratic_fit_plot.p1.*volt_2.^2 + ...
    quadratic_fit_plot.p2*volt_2 + quadratic_fit_plot.p3, 'k' ,'LineWidth', 2.5)
title('Voltage vs Angle Calibration', 'FontSize',15)
ylabel('Angle \theta (Deg)', 'FontSize',13)
xlabel('Voltage (V)', 'FontSize',13)
predBounds = predint(quadratic_fit_plot, v_flex2, 0.95);
plot(v_flex2, predBounds, 'r--','LineWidth',2); % prediction bounds

% save data 
plot_param(1,2) = quadratic_fit_plot.p1;
plot_param(2,2) = quadratic_fit_plot.p2;
plot_param(3,2) = quadratic_fit_plot.p3;

%% sensor 3
[quadratic_fit_plot, rmse_poly] = fit(v_flex3, deg',quadraticFit);
figure(3)
plot(v_flex3, deg, 'b*','LineWidth',2)
hold on 
plot(volt_3,quadratic_fit_plot.p1.*volt_3.^2 + ...
    quadratic_fit_plot.p2*volt_3 + quadratic_fit_plot.p3, 'k' ,'LineWidth', 2.5)
title('Voltage vs Angle Calibration', 'FontSize',15)
ylabel('Angle \theta (Deg)', 'FontSize',13)
xlabel('Voltage (V)', 'FontSize',13)
predBounds = predint(quadratic_fit_plot, v_flex3, 0.95);
plot(v_flex3, predBounds, 'r--','LineWidth',2); % prediction bounds

plot_param(1,3) = quadratic_fit_plot.p1;
plot_param(2,3) = quadratic_fit_plot.p2;
plot_param(3,3) = quadratic_fit_plot.p3;

save plot_parameters.mat plot_param

