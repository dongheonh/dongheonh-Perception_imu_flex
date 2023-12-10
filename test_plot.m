x_lim = [-150 150];
y_lim = [-150 150];
z_lim = [0 300]; 

for i = 1:100
    yaw =   [80, i*10, 80];         % Roll angles for each joint
    pitch = [90, 90, 90];           % Pitch angles for each joint
    roll =  [90, 90 - i*20, 90];    % Yaw angles for each joint
    fprintf('pitch: %2d,%2d,%2d| roll: %2d,%2d,%2d| yaw: %2d,%2d,%2d\n', ...
        pitch(1),pitch(2),pitch(3), roll(1), roll(2), roll(3), yaw(1), yaw(2), yaw(3)) % print roll, yaw, pitch values
    figure(1)
    fig_color1 = [0 0 0];
    fig_color2 = [1 0 1];

    plotRobotArm(pitch, roll, yaw, 80, fig_color1, x_lim, y_lim, z_lim);
    hold on

    yaw =   [80-21, i*10-12, 80-23];        % Roll angles for each joint
    pitch = [90-12, 90-30, 90-23];          % Pitch angles for each joint
    roll =  [90+ 12, 90 - i*20-11, 90];     % Yaw angles for each joint
    plotRobotArm(pitch, roll, yaw, 80, fig_color2, x_lim, y_lim, z_lim);
    hold off
end

