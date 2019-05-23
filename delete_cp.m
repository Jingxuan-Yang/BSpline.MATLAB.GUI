function delete_cp(p,hObject,handles)
% delete control point
% Author: JingXuan Yang

% check if there is multiple control points

handles = guidata(hObject);
s = handles.selectdata;

cpoint = s.controlP;
plotcp = s.plotcontrolP;
pp = getPosition(p);
delete(p);
[n,~] = size(plotcp);
plotcpp = zeros(n,2);
for i = 1:n
    
    pcp = getPosition(plotcp(i));
    plotcpp(i,:) = pcp;
    
end

% delete new control point and plot point
% S = setfield(S,field,value) assigns a value to the specified field of 
% the 1-by-1 structure S
% C = cat(dim, A1, A2, A3, A4, ...) concatenates all the input arrays
% (A1, A2, A3, A4, and so on) along array dimension dim.

for i = 1:n
    dp(i,:) = plotcpp(i,:) - pp;
    ndp(i) = norm(dp(i,:));
    if ndp(i) < 0.2
        delete(plotcp(i));
        plotcp(i,:) = [];
        cpoint(i,:) = [];
    end
end

s = setfield(s, 'controlP', cpoint);
s = setfield(s, 'plotcontrolP', plotcp);

new_cpoint = cpoint;

% compute new knot vector
k = s.degree;
t = s.knotV;
new_t = change_knotV(k,t,new_cpoint);

% save new knot vector
s = setfield(s, 'knotV', new_t);

% compute new curve
[C] = bspline_curve(k, new_t, new_cpoint);
% save new knot vector
s = setfield(s, 'curveP',C);
% update plot curve
axes(handles.curve);
set(s.plotcurve, 'XData', C(1,:), 'YData', C(2,:));

% update control polygon
set(s.plotcpolygon, 'XData', new_cpoint(:,1), 'YData', new_cpoint(:,2));

axes(handles.basis);
        %% plot new knot vector points
        for o = 1 : size(s.plotknotP,1)            
            set(s.plotknotP(o), 'visible','off');
        end
        s.plotknotP = [];
        n = k + 1;
        for pp = 1 : size(new_t,2)-n
           t1 = [new_t(pp),0];
           U(pp) = impoint(gca,t1);
           setColor(U(pp),'r');
        end

        for pp = size(new_t,2) : -1 : size(new_t,2) -n + 1
            t1 = [new_t(pp),0];
            S(size(new_t,2) - pp + 1) = impoint(gca,t1);
            setColor(S(size(new_t,2) - pp + 1),'r');
        end
        mm = S(end:-1:1);
        U = cat(2,U,mm);
        s = setfield(s,'plotknotP',U');
        

% plot new basis function
n = k + 1;
Y = [];
X = [];

    for l = 0 : numel(new_t)-n-1
        [y,x] = bsplineBasis(l,n,new_t);
        Y = cat(1, Y, y);
        X = cat(1, X, x);
    end

a = [];
for o = 1 : size(s.plotknotV,1)            
    set(s.plotknotV(o), 'visible','off');
end
s.plotknotV = [];
hold all
for o = 1 : size(Y,1)   
    q = plot(X(o,:), Y(o,:));
    a = cat(1,a,q);       
end
s = setfield(s, 'plotknotV',a);
set(handles.numofcp, 'String',size(new_cpoint,1));

handles.selectdata = s;

m = size(handles.curvedata,1);

for i = 1 : m
    c = handles.curvedata(i);
    h = c.plotcurve;
    L = get(h,'LineWidth');
    if L == 2.5
        handles.curvedata(i) = s;
        break;
    end
end


guidata(hObject, handles);
end

