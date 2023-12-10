% Author: Dong Heon Han
% FREE lab
% 12/09/2023

clear, clc
tic;                        % record time

fig_color1 = [0 0 0]; fig_color2 = [1 0 1];
x_lim = [-150 150]; y_lim = [-150 150]; z_lim = [0 300]; 

% check the serial port name in the terminal, type: ls /dev/tty.*
s = fileread('test_usb_data.txt');
readings = sscanf(s, "%f, %f, %f, %f, %f, %f," + ...
    " %f, %f, %f, %f, %f, %f")';

alldata = zeros(319,12);
armLength = 80;             % each of arms length in mm 
number_IMUs = 3;            % numbers of IMUs
roll  = zeros(number_IMUs,1);
pitch = zeros(number_IMUs,1);
yaw   = zeros(number_IMUs,1);
pitch_flex = zeros(1,3);

for j = 1: 319
    orient_iter_ea = readings(1+12*(j-1):12*j);
    for i = 1: 3
        yaw(i)  = orient_iter_ea(3*(i-1) + 1);
        pitch(i) = orient_iter_ea(3*(i-1) + 2);
        roll(i)   = orient_iter_ea(3*(i-1) + 3);
    end
    pitch_flex = orient_iter_ea(length(orient_iter_ea) - 2: ...
        length(orient_iter_ea))';
    yaw = yaw_reset(yaw);
    roll = roll_reset(roll);
    
    fprintf('pitch: %2d,%2d,%2d| roll: %2d,%2d,%2d| yaw: %2d,%2d,%2d\n', ...
        pitch(1),pitch(2),pitch(3), roll(1), roll(2), roll(3), yaw(1), yaw(2), yaw(3)) % print roll, yaw, pitch values
    figure(1)
    plotRobotArm(pitch, roll, yaw, armLength, fig_color1, x_lim, y_lim, z_lim) % PLOT robot_IMU_data
    hold on 
    plotRobotArm(pitch_flex, 90 * ones(3,1), 90 * ones(3,1), armLength, fig_color2, x_lim, y_lim, z_lim) % PLOT robot_IMU_data

end