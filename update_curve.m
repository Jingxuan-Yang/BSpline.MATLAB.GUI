function update_curve(p, hObject, handles,i)
%Summary of this function goes here
%   Detailed explanation goes here
% The function is used to update curve when drag a control point

handles = guidata(hObject);
% find which curve is moving
m = size(handles.curvedata,1);
n = [];
for j = 1 : m
    d = handles.curvedata(j);
    point = d.plotcontrolP;
    num = size(point,1);
    n = cat(1,n,num);       
end

for j = 2 : size(n,1)
    n(j) = n(j) + n(j-1);
end

for j = 1 : size(n,1)
    if i <= n(j)
        d = handles.curvedata(j);  % the curve data which is moving
        break;
    end
end

    %% find new position
    H = d.plotcontrolP;
    new = [];
    for q = 1 : size(H,1)
        h = H(q);
        p = getPosition(h);
        new = cat(1, new, p);
    end

    %% update new positon of selected data
    d = setfield(d, 'controlP', new);
    k = d.degree;
    t = d.knotV;

    %% new curve data
    [C] = bspline_curve(k, t, new);
    d = setfield(d,'curveP', C);

    axes(handles.curve);
    set(d.plotcurve, 'XData', C(1,:), 'YData', C(2,:));
    set(d.plotcpolygon, 'XData', new(:,1), 'YData', new(:,2));

    update_handles(hObject, handles)

    handles.curvedata(j) = d;

guidata(hObject, handles);

end

