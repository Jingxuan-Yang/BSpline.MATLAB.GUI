function [K, Cpoint,T] = load2DData(pathname, filename)
% The function is used to load 2D data file
% Input: name of data File
% Output: a data cell contains all data 

% f = fullfile(filepart1,...,filepartN) builds a full file specification
% from the specified folder and file names.
filepath = fullfile(pathname, filename);
 
fid = fopen(filepath);

if fid == -1
    % error(msg,A1,...,An) displays an error message that contains
    % formatting conversion characters
    error('Author:Function:OpenFile', 'Cannot open file: %s', f_name);
end

% C = textscan(fileID,formatSpec) reads data 
% from an open text file into a cell array, C.
D = textscan(fid, '%s', 'delimiter','\n','CommentStyle', '#');

% A = cellfun(func,C) applies the function func to the contents
% of each cell of cell array C, one cell at a time
D = cellfun(@str2num, D{:}, 'UniformOutput', false);

D(cellfun(@isempty, D)) = [];

% the degree of the curve
K = D{1};

% The number of control points
num = D{2};

% The position of control points
% A = cell2mat(C) converts a cell array into an ordinary array
Cpoint = cell2mat(D(3: 3 + num -1));

%% if the knot vector exist
if D{3+num} == 1
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
        % C = cat(dim, A, B) concatenates the arrays A and B
        % along array the dimension specified by dim
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

