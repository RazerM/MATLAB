function rad = deg2rad(deg)
    % DEG2RAD Convert radians to degrees.
    %
    %     DEG2RAD(rad) converts a scalar, vector or matrix of radians into
    %     degrees.
    %
    %     Examples (results shown to 2 decimal places)
    %         DEG2RAD(180)               % 3.14
    %         DEG2RAD([90 180 270 360])  % [1.57 3.14 4.71 6.28]
    %
    %     See also rad2deg.
    %
    % Frazer McLean <frazergmclean@gmail.com>
    rad = deg*pi/180;
end
