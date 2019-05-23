function [y,x] = bsplineBasis(j,n,t,x)
% The function is used to generate bspline basis function
% Input: 
% j: the degree of the curve
% t: knot vector
% 
% Output:
% y: bspline basis function
%
    if nargin < 4
        x = linspace(t(1), t(end), 500);
    end
    
    y = bspline_basis_recursion(j,n,t,x);

    function y = bspline_basis_recursion(j,n,t,x)
        y = zeros(size(x));
        if n > 1
            [b,~] = bsplineBasis(j, n-1, t, x);
            dn = x - t(j+1);
            dd = t(j+n) - t(j+1);
            
            if dd ~= 0
                y = y + b.*(dn./dd);
            end
            
            b = bsplineBasis(j+1, n-1, t,x);
            dn = t(j+n+1) -x;
            dd = t(j+n+1) -t(j+1+1);
            
            if dd ~= 0
                y = y + b.*(dn./dd);
            end
            
        elseif t(j+2) < t(end)
            y(t(j+1) <= x & x < t(j+2)) = 1;
        else
            y(t(j+1) <= x) = 1;
        end                   
    end

end
