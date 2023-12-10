function yaw = yaw_reset(yaw)
    for i = 1: 3
        if 180 < yaw(i,1) && yaw(i,1) <= 360
            yaw(i,1) = yaw(i,1) - 360;
        end
    end
    yaw = yaw + 90 * ones(3,1);
end