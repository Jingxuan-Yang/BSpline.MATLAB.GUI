function change_to_floating(hObject, handles)
%Summary of this function goes here
%   Detailed explanation goes here

handles = guidata(hObject);
m = size(handles.curvedata,1);

for i = 1 : m
    c = handles.curvedata(i);
    h = c.plotcurve;
    L = get(h,'LineWidth');
    if L == 2.5
        t = c.knotV;
        num = size(t,2);
        interval = 1/(num-1);
        new = 0 : interval: 1;
        % save new knot vector to c
        c = setfield(c,'knotV', new);
        % get new curve
        k = c.degree;
        cpoint = c.controlP;
        [C] = bspline_curve(k, new, cpoint);
        % save new curve data
        c = setfield(c,'curveP', C);

        % plot new curve
        axes(handles.curve);
        set(c.plotcurve, 'XData', C(1,:), 'YData', C(2,:));
        
        axes(handles.basis);
        %% plot new knot vector points
        for o = 1 : size(c.plotknotP,1)            
        set(c.plotknotP(o), 'visible','off');
        end
        c.plotknotP = [];
        n = k + 1;
        for pp = 1 : size(new,2)-n
           t1 = [new(pp),0];
           U(pp) = impoint(gca,t1);
           setColor(U(pp),'r');
        end

        for pp = size(new,2) : -1 : size(new,2) -n + 1
            t1 = [new(pp),0];
            S(size(new,2) - pp + 1) = impoint(gca,t1);
            setColor(S(size(new,2) - pp + 1),'r');
        end
        mm = S(end:-1:1);
        U = cat(2,U,mm);
        c = setfield(c,'plotknotP',U');

       
        % plot new basis function
        n = k + 1;
        Y = [];
        X = [];

            for j = 0 : numel(new)-n-1
                [y,x] = bsplineBasis(j,n,new);
                Y = cat(1, Y, y);
                X = cat(1, X, x);
            end
            
        b = c.plotknotV;
        for j = 1 : size(b,1)
            b1 = b(j);
            set(b1,'XData', X(j,:), 'YData', Y(j,:));
        end
        handles.curvedata(i) = c;
        handles.selectdata = c;
        break;
    end
end


guidata(hObject, handles);
end

