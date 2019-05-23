function plot_knotV(hObject, handles)
%Summary of this function goes here
%   Detailed explanation goes here

% visible off all previous knot vector

num = size(handles.curvedata,1);

if num > 1
    for i = 1 : num -1
        c = handles.curvedata(i);
        k = c.plotknotV;
        set(k, 'visible', 'off');
        knotP = c.plotknotP;
        for o = 1:size(knotP,1)
           set(knotP(o),'visible','off');
        end
    end
end

% get the last load curve data
s = handles.curvedata(num);
cpoint = s.controlP;
cnum = size(cpoint,1);

t = s.knotV;
k = s.degree;
% compute X and Y
    n = k + 1;
    Y = [];
    X = [];
    a = [];
    for j = 0 : cnum-1
        [y,x] = bsplineBasis(j,n,t);
        Y = cat(1, Y, y);
        X = cat(1, X, x);
    end
% plot X and Y basis function
    axes(handles.basis);
    hold on;
    for i = 1 : size(Y,1)   
        q = plot(X(i,:), Y(i,:));
        a = cat(1,a,q);       
    end
    hold off;
 %% draw knot vector point on x axis

for i = 1 : size(t,2)-n
    t1 = [t(i),0];
    % Create draggable point
    h(i) = impoint(gca,t1);
    setColor(h(i),'r');
end

for i = size(t,2) : -1 : size(t,2) -n + 1
    t1 = [t(i),0];
    % Create draggable point
    m(size(t,2) - i + 1) = impoint(gca,t1);
    setColor(m(size(t,2) - i + 1),'r');
end

mm = m(end:-1:1);
h = cat(2,h,mm);

s = setfield(s,'plotknotP',h');
s = setfield(s,'plotknotV',a);

% save updated curve data
handles.curvedata(num) = s;
 
guidata(hObject, handles);
end

