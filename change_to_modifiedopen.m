function change_to_modifiedopen(hObject, handles)
% The function is used to change knot vector to modified open uniform 
handles = guidata(hObject);
Q = size(handles.curvedata,1);
for i = 1 : Q
    c = handles.curvedata(i);
    h = c.plotcurve;
    L = get(h,'LineWidth');
    if L == 2.5
        cpoint = c.controlP;
        k = c.degree;
        num = size(cpoint,1);
        % get new knot vector
        m = num + k + 1;
        num_end = k + 1;
        
        e = m - 2 * num_end;
        temp = [];
        if e == 0
            new = cat(2, zeros(1, num_end), ones(1,num_end));
        else
            for j = 1 : e
                temp = cat(2,temp, j/(e+1));
            end
    
            T = cat(2,zeros(1, num_end),temp);
            new = cat(2, T, ones(1,num_end));
        end
        
        % save new knot vector
        c = setfield(c,'knotV', new);
        % get new curve data
        [C] = bspline_curve(k, new, cpoint);
        % save new curve data
        c = setfield(c,'curveP', C);
        
        axes(handles.basis)
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
        

        %% plot new curve
        axes(handles.curve);
        set(c.plotcurve, 'XData', C(1,:), 'YData', C(2,:));
        
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

