function deg = rad2deg(rad)
    % RAD2DEG Convert radians to degrees.
    %
    %     RAD2DEG(rad) converts a scalar, vector or matrix of radians into
    %     degrees.
    %
    %     Examples
    %         RAD2DEG(pi)                     % 180
    %         RAD2DEG([pi/2 pi 6*pi/4 2*pi])  % [90 180 270 360]
    %
    %     See also deg2rad.
    %
    % Frazer McLean <frazergmclean@gmail.com>
    deg = rad*180/pi;
end
