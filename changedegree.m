function changedegree(hObject, handles)
% Summary of this function goes here
%   Detailed explanation goes here
handles = guidata(hObject);

a = get(handles.changedegree, 'Value'); % new degree
set(handles.degree, 'String', a);

m = size(handles.curvedata,1);

for j = 1 : m
    c = handles.curvedata(j);
    h = c.plotcurve;
    L = get(h,'LineWidth');
    if L == 2.5 % find the selected data
        cpoint = c.controlP;
        num = size(cpoint,1);
        num_of_knot = a + num + 1;
        % pre degree
        k = c.degree;
        t = c.knotV;
        %% compute new knot vector
        % check previous knot vector is modified
        for i = 1 : k 
            if t(i) == t(i+1)
                % the previous knot vector is modified
                m = num_of_knot;
                num_end = a + 1;
                e = m - 2 * num_end;
                temp = [];
                if e == 0
                    T = cat(2, zeros(1, num_end), ones(1,num_end));
                else
                    for o = 1 : e
                        temp = cat(2,temp, o/(e+1));
                    end
                N = cat(2,zeros(1, num_end),temp);
                % new knot vector
                T = cat(2, N, ones(1,num_end));
                end
                break;
            else
                interval = 1/(num_of_knot-1);
                T = 0 : interval: 1;
            end
        end
        %% save new degree
        c = setfield(c, 'degree', a);
        %% save new knot vector 
        c = setfield(c,'knotV', T);
        %% compute new curve
        % get new curve data
        [C] = bspline_curve(a, T, cpoint);
        % save new curve data
        c = setfield(c,'curveP', C);
        
        axes(handles.basis);
         %% plot new knot vector points
        for o = 1 : size(c.plotknotP,1)            
        set(c.plotknotP(o), 'visible','off');
        end
        c.plotknotP = [];
        n = k + 1;
        for pp = 1 : size(T,2)-n
           t1 = [T(pp),0];
           U(pp) = impoint(gca,t1);
           setColor(U(pp),'r');
        end

        for pp = size(T,2) : -1 : size(T,2) -n + 1
            t1 = [T(pp),0];
            S(size(T,2) - pp + 1) = impoint(gca,t1);
            setColor(S(size(T,2) - pp + 1),'r');
        end
        mm = S(end:-1:1);
        U = cat(2,U,mm);
        c = setfield(c,'plotknotP',U');
        
        %% plot new curve
        axes(handles.curve);
        set(c.plotcurve, 'XData', C(1,:), 'YData', C(2,:));
        
        %% plot new basis function
        n = a + 1;
        Y = [];
        X = [];

            for l = 0 : numel(T)-n-1
                [y,x] = bsplineBasis(l,n,T);
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

guidata(hObject, handles);        
end
        
        

