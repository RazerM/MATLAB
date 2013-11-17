function [normd] = normd(matrix, dim)
    % NORMD Calculate norm of a matrix along the dimension specified by
    % dim.
    %
    %     NORMD(matrix,1) returns a vector where every element is the norm
    %     of the column at that position in matrix.
    %
    %     Examples
    %         NORMD([3  5  8  7 20 12  9 28;
    %                  4 12 15 24 21 35 40 45],1)
    %
    %         ans = 5 13 17 25 29 37 41 53
    %
    %     See also norm.
    %
    % Frazer McLean <frazergmclean@gmail.com>
    normd = sqrt(sum(matrix.^2, dim));
end



