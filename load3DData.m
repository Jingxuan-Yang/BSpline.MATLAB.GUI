function [K, Cpoint,T] = load3DData(pathname, filename)
%Summary of this function goes here
%   Detailed explanation goes here

filepath = fullfile(pathname, filename);
 
fid = fopen(filepath);
fid1 = fopen(filepath);

if fid == -1
  error('Author:Function:OpenFile', 'Cannot open file: %s', f_name);
end

D = textscan(fid, '%s', 'delimiter', '\n','CommentStyle', '#');
D1 = textscan(fid1, '%s', 'delimiter', ',','CommentStyle', '#');

D = cellfun(@str2num, D{:}, 'UniformOutput', false);
D1 = cellfun(@str2num, D1{:}, 'UniformOutput', false);

K = D1{2};

D(cellfun(@isempty, D)) = [];

% The number of control points
num = D{1};

% The position of control points
Cpoint = cell2mat(D(2: 2 + num -1));
Cpoint = Cpoint(:,1:3);

%% if the knot vector exist
if D{2+num} == 1
    % The knot vector
    T = D{size(D,1)};
else
    % if the knot vector does not exist, default knot vector by open 
    % the number of knot vector
    m = num + K + 1;
    num_end = K + 1;
    e = m - 2 * num_end;
    temp = [];
    
    if e == 0
        T = cat(2, zeros(1, num_end), ones(1,num_end));
    else
    for i = 1 : e
        temp = cat(2,temp, i/(e+1));
    end
    
    t = cat(2,zeros(1, num_end),temp);
    T = cat(2, t, ones(1,num_end));
    end
    
end


end

