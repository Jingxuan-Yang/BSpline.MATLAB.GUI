function add_cp_middle(p,a1,a2,hObject,handles)
% Summary of this function goes here
%   Detailed explanation goes here

% check if there is multiple control points

handles = guidata(hObject);
s = handles.selectdata;

cpoint = s.controlP;
plotcp = s.plotcontrolP;
curve = s.plotcurve;
cc = get(curve, 'color');
p = getPosition(p);
setColor(plotcp(a1), cc);
setColor(plotcp(a2), cc);
% compute new control point and plot new control point
    if a1 < a2
        temp = cat(1,cpoint(1:a1,:),p);
        new_cpoint = cat(1, temp, cpoint(a2:end,:));
        % plot new control points
        p = impoint(gca,p);
        setColor(p, cc);
        temp = cat(1,plotcp(1:a1,:),p);
        plotcp = cat(1, temp, plotcp(a2:end,:));
    else
        temp = cat(1,cpoint(1:a2,:),p);
        new_cpoint = cat(1, temp, cpoint(a1:end,:));
        % plot new control points
        p = impoint(gca,p);
        setColor(p, cc);
        temp = cat(1,plotcp(1:a2,:),p);
        plotcp = cat(1, temp, plotcp(a1:end,:));
    end

% save new control point and plot point
s = setfield(s, 'controlP', new_cpoint);
s = setfield(s, 'plotcontrolP', plotcp);

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

