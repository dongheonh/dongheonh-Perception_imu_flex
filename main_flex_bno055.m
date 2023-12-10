% Author: Dong Heon Han
% FREE lab
% 12/09/2023

clear, clc
close all 
tic;                        % record time

% check the serial port name in the terminal, type: ls /dev/tty.*
s = serialport("/dev/tty.usbmodem14401",9600);

orient = [];                % ith column is ith angular orientation 
maxIteration = 2*10^2;      % approximately 20 seconds of data collecting
iteration = 0;              % initialize the iteration

armLength = 80;             % each of arms length in mm 
number_IMUs = 3;            % numbers of IMUs
number_Flex = 3;

% Roll pitch and yaw vectors from IMUs
roll  = zeros(number_IMUs,1);
pitch = zeros(number_IMUs,1);
yaw   = zeros(number_IMUs,1);

% Pitch from Flex Sensor
pitch_fx = zeros(number_Flex,1);

% Data Plot Settings
fig_color1 = [0 0 0]; fig_color2 = [1 0 1];
x_lim = [-150 150]; y_lim = [-150 150]; z_lim = [0 300]; 

%% Read the first datum to Update the offsets (Calibration)
% Ask user if the robot is straightened up
% Assume that the robot starts from the posture if vertical straight line

response = input(['Is the robot straighten up? ' ...
    'Do you want to conduct calibration? y/n: '], 's');

% Check the response
while ~ismember(response, ['y', 'n'])
    disp('Invalid input. Please enter y or n.');
    response = input('Is the robot straighten up? y/n: ', 's');
end

% Terminate the program if the input is 'y' or 'n'
if response == 'y'
    disp('Calibration (wait for 20 seconds)...\n');
    
    % IMUs
    rollsum  = zeros(number_IMUs,1);
    pitchsum = zeros(number_IMUs,1);
    yawsum   = zeros(number_IMUs,1);
    
    % Flex Sensor
    pitch_fxsum = zeros(number_Flex,1);

    % # iteration to average data 
    average_iter = 100;
    
    for j = 1:average_iter
        data = readline(s);
        readings = sscanf(data, "%f, %f, %f, %f, %f, %f, " + ...
            "%f, %f, %f, %f, %f, %f");
        orient_iter_ea = readings';

        for i = 1: number_IMUs
            yaw(i)   = orient_iter_ea(3*(i-1) + 1);
            pitch(i) = orient_iter_ea(3*(i-1) + 2);
            roll(i)  = orient_iter_ea(3*(i-1) + 3);
        end
        
        % reset IMU's yaw and roll 
        yaw = yaw_reset(yaw);
        roll = roll_reset(roll);
        
        % IMUs
        yawsum   = yawsum + yaw;
        pitchsum = pitchsum + pitch;
        rollsum  = rollsum + roll;

        % Flex Sensor
        pitch_fx = flexSensor_volt_angle(orient_iter_ea(length ...
            (orient_iter_ea) - 2: length(orient_iter_ea)));
        pitch_fxsum = pitch_fxsum + pitch_fx;
    end
    
    % IMUs
    m_yaw   = yawsum/average_iter;
    m_pitch = pitchsum/average_iter;
    m_roll  = rollsum/average_iter;

    % Flex Sensor
    m_pitch_fx = pitch_fxsum/average_iter;

    % IMUs offset
    offset_roll  = 90*ones(number_IMUs,1) - m_roll;
    offset_pitch = 90*ones(number_IMUs,1) - m_pitch;
    offset_yaw   = 90*ones(number_IMUs,1) - m_yaw;
    
    % Flex offset
    offset_pitch_fx = 90*ones(number_Flex,1) - m_pitch_fx;

else
    disp('Terminating program.');

    % IMUs
    offset_roll  = zeros(3,1);
    offset_pitch = zeros(3,1);
    offset_yaw   = zeros(3,1);
    
    % Flex Sensor
    offset_pitch_fx = zeros(3,1);
end

%% Data Collection

whileFlag = 1;

while whileFlag

    iteration = iteration + 1;

    % Read data from serial port
    data = readline(s);
    parsedData = sscanf(data, "%f, %f, %f, %f, %f, %f, " + ...
        "%f, %f, %f, %f, %f, %f");

    orient_iter_ea = parsedData';


    % *** IMU sensors' output and offsets are applied
    % data from the IMUs
    for i = 1: 3
        yaw(i)  = orient_iter_ea(3*(i-1) + 1);
        pitch(i) = orient_iter_ea(3*(i-1) + 2);
        roll(i)   = orient_iter_ea(3*(i-1) + 3);
    end
    
    % reset yaw and roll 
    yaw  = yaw_reset(yaw);
    roll = roll_reset(roll);

    % apply offsets
    yaw   = offset_yaw + yaw;
    roll  = offset_roll + roll;
    pitch = offset_pitch + pitch;

    % *** Flex sensor's output and offsets are applied
    % data from the flex sensor
    pitch_fx = orient_iter_ea(length(orient_iter_ea) - 2: ...
        length(orient_iter_ea))';

    % apply offsets
    pitch_fx = offset_pitch_fx + pitch_fx;
    
    % print IMU and flex sensor orientation in command window
    fprintf(['***IMUs : pitch: %2d,%2d,%2d| roll: %2d,%2d,%2d| ' ...
        'yaw: %2d,%2d,%2d\n'], pitch(1),pitch(2),pitch(3), roll(1), ...
        roll(2), roll(3), yaw(1), yaw(2), yaw(3))

    fprintf('***Flex Sensor: pitch: %d,%d,%d\n\n', pitch_fx(1), ...
        pitch_fx(2), pitch_fx(3))
    
    % @ figure 1
    figure(1)
    plotRobotArm(pitch, roll, yaw, armLength, fig_color1, ...
        x_lim, y_lim, z_lim)
    hold on 

    % @ figure 2
    plotRobotArm(pitch_flex, [90; 90; 90], [90; 90; 90], armLength, ...
        fig_color1, x_lim, y_lim, z_lim)

    % (optional) save orientation data - expand the matrix size
    orient = [orient; orient_iter_ea];

    % if iteration reach maxIteratioan terminate
    if iteration == maxIteration
        fprintf('done with collecting orientation')
        whileFlag = 0;
    end

end

toc;    % record time