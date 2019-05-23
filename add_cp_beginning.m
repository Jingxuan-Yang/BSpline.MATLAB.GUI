function add_cp_beginning(hObject, handles)
% add control point at the beginning of the curve

handles = guidata(hObject);
axes(handles.curve);
p = impoint(gca);
m = size(handles.curvedata,1);
% pos = getPosition(h) returns the current position of the ROI object, h.
point = getPosition(p);
for i = 1 : m
    c = handles.curvedata(i);
    h = c.plotcurve;
    L = get(h,'LineWidth');
    if L == 2.5
        cpoint = c.controlP;
        new_cpoint = cat(1,point,cpoint);
        % save new cpoint
        c = setfield(c,'controlP', new_cpoint);
        
        % plot new control point
        plotcp = c.plotcontrolP;
        setColor(p, getColor(plotcp(1,1)));
        plotcp = cat(1,p,plotcp);
        c = setfield(c, 'plotcontrolP', plotcp);
        
        % get new curve
        k = c.degree;
        t = c.knotV;
        new_t = change_knotV(k,t,new_cpoint);
        [C] = bspline_curve(k, new_t, new_cpoint);
        % save new knot vector
        c = setfield(c, 'knotV', new_t);
        
        axes(handles.basis);
        
        %% plot new knot vector points
        for o = 1 : size(c.plotknotP,1)            
        set(c.plotknotP(o), 'visible','off');
        end
        c.plotknotP = [];
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
        c = setfield(c,'plotknotP',U');
                
       %% plot new basis function
        n = k + 1;
        Y = [];
        X = [];

            for l = 0 : numel(new_t)-n-1
                [y,x] = bsplineBasis(l,n,new_t);
                Y = cat(1, Y, y);
                X = cat(1, X, x);
            end
            
        a = [];
        for o = 1 : size(c.plotknotV,1)            
        set(c.plotknotV(o), 'visible','off');
        end
%         c.plotknotV = [];
        axes(handles.basis);
        hold on;
        for o = 1 : size(Y,1)   
            q = plot(X(o,:), Y(o,:));
            a = cat(1,a,q);       
        end
        hold off;
        c = setfield(c, 'plotknotV',a);
      
        % save new curve
        c = setfield(c, 'curveP', C);
        % update new curve
        axes(handles.curve);
        set(c.plotcurve, 'XData', C(1,:), 'YData', C(2,:));
        
        % update new control polygon
        set(c.plotcpolygon, 'XData', new_cpoint(:,1), 'YData', new_cpoint(:,2));
        set(handles.numofcp, 'String',size(new_cpoint,1));
        handles.curvedata(i) = c;
        handles.selectdata = c;
        break;                      
    end
end


guidata(hObject, handles);
end

