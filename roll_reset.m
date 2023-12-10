function roll = roll_reset(roll)
    for i = 1: 3
        if 90 < abs(roll(i,1)) && abs(roll(i,1)) <= 180
            roll(i,1) = abs(roll(i,1));
            roll(i,1) = roll(i,1) - 180;
        end
    end
    roll = roll + 90 * ones(3,1);
end