% Author: Dong Heon Han
% FREE lab
% 12/09/2023

clear, clc
load flexCalibration.mat

v_flex1 = pitch(:,1);
v_flex2 = pitch(:,2);
v_flex3 = pitch(:,3);

deg = 0:10:90;

% common variables
quadraticFit = fittype('poly2');
deg_interp = 1:90;
numb_sensors = 3;
plot_param = zeros(3,numb_sensors);

%% first sensor
figure(1)

[quadratic_fit_plot, rmse_poly] = fit(deg',v_flex1,quadraticFit);
predBounds = predint(quadratic_fit_plot, deg, 0.95);

p = polyfit(deg,v_flex1,2);

plot(deg_interp,quadratic_fit_plot.p1.*deg_interp.^2 + ...
    quadratic_fit_plot.p2*deg_interp + quadratic_fit_plot.p3, 'k' ,'LineWidth', 2.5)

% save data 
plot_param(1,1) = quadratic_fit_plot.p1;
plot_param(2,1) = quadratic_fit_plot.p2;
plot_param(3,1) = quadratic_fit_plot.p3;

hold on 
plot(deg,v_flex1, 'b*','LineWidth',2)
plot(deg, predBounds, 'r--','LineWidth',2); % prediction bounds

title('Angle vs Voltage Calibration', 'FontSize',15)
xlabel('Angle \theta (Deg)', 'FontSize',13)
ylabel('Voltage (V)', 'FontSize',13)
legend({'V = 1.719 \times 10^{-5} \theta^{2} + 0.0001099 \theta + 0.1659', ...
    'Experimental Data', 'Prediction Intervals (RMSE = 0.0075 at 95% confidence)'}, ...
    'FontSize',12, 'Location','northwest')

%% second sensor
figure(2)

[quadratic_fit_plot, rmse_poly] = fit(deg',v_flex2,quadraticFit);
predBounds = predint(quadratic_fit_plot, deg, 0.95);

p = polyfit(deg,v_flex2,2);

plot(deg_interp,quadratic_fit_plot.p1.*deg_interp.^2 + ...
    quadratic_fit_plot.p2*deg_interp + quadratic_fit_plot.p3, 'k' ,'LineWidth', 2.5)

% save data 
plot_param(1,2) = quadratic_fit_plot.p1;
plot_param(2,2) = quadratic_fit_plot.p2;
plot_param(3,2) = quadratic_fit_plot.p3;

hold on 
plot(deg,v_flex2, 'b*','LineWidth',2)
plot(deg, predBounds, 'r--','LineWidth',2); % prediction bounds

title('Angle vs Voltage Calibration', 'FontSize',15)
xlabel('Angle \theta (Deg)', 'FontSize',13)
ylabel('Voltage (V)', 'FontSize',13)
legend({'V = 1.719 \times 10^{-5} \theta^{2} + 0.0001099 \theta + 0.1659', ...
    'Experimental Data', 'Prediction Intervals (RMSE = 0.0075 at 95% confidence)'}, ...
    'FontSize',12, 'Location','northwest')
%% third sensor
figure(3)

[quadratic_fit_plot, rmse_poly] = fit(deg',v_flex3,quadraticFit);
predBounds = predint(quadratic_fit_plot, deg, 0.95);

p = polyfit(deg,v_flex3,2);

plot(deg_interp,quadratic_fit_plot.p1.*deg_interp.^2 + ...
    quadratic_fit_plot.p2*deg_interp + quadratic_fit_plot.p3, 'k' ,'LineWidth', 2.5)

% save data 
plot_param(1,3) = quadratic_fit_plot.p1;
plot_param(2,3) = quadratic_fit_plot.p2;
plot_param(3,3) = quadratic_fit_plot.p3;

hold on 
plot(deg,v_flex3, 'b*','LineWidth',2)
plot(deg, predBounds, 'r--','LineWidth',2); % prediction bounds

title('Angle vs Voltage Calibration', 'FontSize',15)
xlabel('Angle \theta (Deg)', 'FontSize',13)
ylabel('Voltage (V)', 'FontSize',13)
legend({'V = 1.719 \times 10^{-5} \theta^{2} + 0.0001099 \theta + 0.1659', ...
    'Experimental Data', 'Prediction Intervals (RMSE = 0.0075 at 95% confidence)'}, ...
    'FontSize',12, 'Location','northwest')

save plot_parameters.mat plot_param