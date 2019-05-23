function move_knot(p,hObject, handles)
%Summary of this function goes here
%   Detailed explanation goes here

% 
handles = guidata(hObject);

if isempty(handles.selectdata)
        errordlg('Please select a curve');
else

m = size(handles.curvedata,1);

for j = 1 : m
    c = handles.curvedata(j);
    h = c.plotcurve;
    L = get(h,'LineWidth');
    if L == 2.5 % find the selected data
        knotP = c.plotknotP;
        new = [];
        for i = 1 : size(knotP,1)
            temp = getPosition(knotP(i));
            new = cat(1,new,temp);
        end
        t= new(:,1)';
        
        for i = 1 : size(knotP,1)
        if i == 1 
           fcn = makeConstrainToRectFcn('impoint',[t(i),t(i)],...
           [0,0]);
            setPositionConstraintFcn(knotP(i),fcn);
        elseif i == size(t,2)
           fcn = makeConstrainToRectFcn('impoint',[t(i),t(i)],...
           [0,0]);
            setPositionConstraintFcn(knotP(i),fcn);            
            else
            fcn = makeConstrainToRectFcn('impoint',[t(i-1),t(i+1)],...
           [0,0]);
            setPositionConstraintFcn(knotP(i),fcn);
        end
        end
        
        %% save the new knot vector position
        c = setfield(c, 'knotV', new(:,1)');
        
        %% obtain new curve
        k = c.degree;
        cpoint = c.controlP;
        [C] = bspline_curve(k, new(:,1)', cpoint);
        %% save new curve
        c = setfield(c,'curveP', C);
        axes(handles.curve);
        set(c.plotcurve, 'XData', C(1,:), 'YData', C(2,:));
        
        %% plot new basis function
        n = k + 1;
        Y = [];
        X = [];
           for l = 0 : numel(new(:,1)')-n-1
                [y,x] = bsplineBasis(l,n,new(:,1)');
                Y = cat(1, Y, y);
                X = cat(1, X, x);
           end
        b = c.plotknotV;
        for l = 1 : size(b,1)
            b1 = b(l);
            set(b1,'XData', X(l,:), 'YData', Y(l,:));
        end
        
        handles.curvedata(j) = c;
         handles.selectdata = c;
        break;
    end
end


end
        

guidata(hObject, handles);
end

