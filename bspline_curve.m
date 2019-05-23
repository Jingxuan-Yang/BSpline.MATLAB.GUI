function [C] = bspline_curve(k, t, CPoint)
%Summary of this function goes here
%   Detailed explanation goes here
% The function is used to evaluate Bspline

% reference from De Boor Algorithm 
%

n = k + 1;
CPoint = CPoint';

U = [];
for m  = n : size(t,2)-k - 1
    u1 = linspace(t(m), t(m+1), 5*size(CPoint,2));
    U = cat(2,U,u1);    
end

t = t(:).';     % knot sequence
U = U(:);

num = size(CPoint,1); % dimension of points

S = sum(bsxfun(@eq, U, t), 2);
I = bspline_interval(U,t);

% use Pk to save 
P = zeros(num,k+1,k+1);
a = zeros(k+1,k+1);

C = zeros(size(CPoint,1),numel(U));

for j = 1 : numel(U)
    u = U(j);
    s = S(j);
    ix = I(j);
    P(:) = 0;
    a(:) = 0;

    % identify d+1 relevant control points
    P(:, (ix-k):(ix-s), 1) = CPoint(:, (ix-k):(ix-s));
    h = k - s;

    if h > 0
        % de Boor algorithm
        for r = 1 : h
            q = ix-1;
            for i = (q-k+r) : (q-s)
                a(i+1,r+1) = (u-t(i+1)) / (t(i+k-r+1+1)-t(i+1));
                P(:,i+1,r+1) = (1-a(i+1,r+1)) * P(:,i,r) + a(i+1,r+1) * P(:,i+1,r);
            end
        end
        C(:,j) = P(:,ix-s,k-s+1);
    elseif ix == numel(t)
        C(:,j) = CPoint(:,end);
    else
        C(:,j) = CPoint(:,ix-k);
    end
end

function ix = bspline_interval(u,t)
% The function is used to find interval of each u
% return the higest index of interval

p = bsxfun(@ge, u, t) & bsxfun(@lt, u, [t(2:end) 2*t(end)]);  % indicator of knot interval in which u is
[row,col] = find(p);
[~,ind] = sort(row);
ix = col(ind);

end

end

