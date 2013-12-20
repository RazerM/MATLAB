function [outp] = iif(condition, t, f)
    if condition
        outp = t;
    else
        outp = f;
    end
end

