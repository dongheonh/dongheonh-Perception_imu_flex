function  roll = flexSensor_volt_angle(volts)
    load plot_parameters.mat plot_param

    % clibration data from each sensors
    roll = [(plot_param(1,1)*volts(1)*10^-5)* volts(1)^2 + plot_param(2,1)*volts(1) + plot_param(3,1),...
            (plot_param(1,2)*volts(2)*10^-5)* volts(2)^2 + plot_param(2,2)*volts(2) + plot_param(3,2),...
            (plot_param(1,3)*volts(3)*10^-5)* volts(3)^2 + plot_param(2,3)*volts(3) + plot_param(3,3)];
end