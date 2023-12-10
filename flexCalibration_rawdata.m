% Author: Dong Heon Han
% FREE lab
% 12/09/2023

clear, clc

s = serialport("/dev/tty.usbmodem14401",9600);

% check the data readings for the flex sensors
data = readline(s);
parsedData = sscanf(data, "%f, %f, %f, %f, %f, %f, " + ...
        "%f, %f, %f, %f, %f, %f");

orient_iter_ea = parsedData';
pitch_fx = orient_iter_ea(length(orient_iter_ea) - 2: ...
        length(orient_iter_ea))';

% display on the command window
fprintf('Pitch: ')
disp(pitch_fx)
fprintf('\n')

% save important data
number_IMUs = 3;
rmse_pitch = zeros(10,number_IMUs);
pitch = zeros(10,number_IMUs);


% ask which sensor are you calibrating
response_sensorN = input('nth sensor calibration 1/2/3:', 's');

% calibration # of iteration
iter_mean = 100;
pitch_fx_data = zeros(iter_mean,1);

% record the sensor #
if response_sensorN     == '1'
    sensorNum = 1;
elseif response_sensorN == '2'
    sensorNum = 2;
elseif response_sensorN == '3'
    sensorNum = 3;
end

% record the degree input
response_degree = input('at "x" degree (0 deg to 90 deg): ', 's');
if response_degree     == '0'
    degNum = 1;
elseif response_degree == '10'
    degNum = 2;
elseif response_degree == '20'
    degNum = 3;
elseif response_degree == '30'
    degNum = 4;
elseif response_degree == '40'
    degNum = 5;
elseif response_degree == '50'
    degNum = 6;
elseif response_degree == '60'
    degNum = 7;
elseif response_degree == '70'
    degNum = 8;
elseif response_degree == '80'
    degNum = 9;
elseif response_degree == '90'
    degNum = 10;
end

% press s(start) when you are ready
response_start = input('press start button "s" when you are reaady: ', 's');
if response_start == 's'
    sum_pitch_fx = 0;
    for i = 1: iter_mean
        data = readline(s);
        parsedData = sscanf(data, "%f, %f, %f, %f, %f, %f, " + ...
            "%f, %f, %f, %f, %f, %f");
        pitch_fx_data(iter_mean,1) = orient_iter_ea(length(orient_iter_ea) ...
            - 3 + sensorNum)';
        sum_pitch_fx = sum_pitch_fx + pitch_fx_data(iter_mean,1);   
    end
 
        pitchMean = sum_pitch_fx/iter_mean;
        var = pitch_fx - pitchMean * ones(iter_mean,1);
        sum_rmse = 0;

        for i = 1: iter_mean
            sum_rmse = sum_rmse + var(iter_mean)^2;
        end

        % save data
        pitch(degNum,sensorNum) = pitchMean;
        rmse_pitch(degNum,sensorNum) = sqrt(sum_rmse/iter_mean);
end 

save flexCalibration.mat pitch rmse_pitch
