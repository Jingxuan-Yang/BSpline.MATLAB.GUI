function [new_t] = change_knotV(k,t,cpoint)
%Summary of this function goes here
%   Detailed explanation goes here

num = size(cpoint,1);
num_of_knot = num + k + 1;

%% compute new knot vector
        % check previous knot vector is modified
        for i = 1 : k 
            if t(i) == t(i+1)
                % the previous knot vector is modified
                m = num_of_knot;
                num_end = k + 1;
                e = m - 2 * num_end;
                temp = [];
                if e == 0
                    new_t = cat(2, zeros(1, num_end), ones(1,num_end));
                else
                    for j = 1 : e
                        temp = cat(2,temp, j/(e+1));
                    end
                N = cat(2,zeros(1, num_end),temp);
                % new knot vector
                new_t = cat(2, N, ones(1,num_end));
                end
                break;
            else
                interval = 1/(num_of_knot-1);
                new_t = 0 : interval: 1;
            end
        end

end

