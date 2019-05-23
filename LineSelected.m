function LineSelected(ObjectH, EventData, H, hObject, handles)

l = get(ObjectH,'LineWidth');
handles = guidata(hObject);
if l == 1.5 || l == 1.0
    set(ObjectH, 'LineWidth', 2.5);
    set(H(H ~= ObjectH), 'LineWidth', 1.0);

    if ~isempty(handles.selectdata)
        handles.selectdata = [];
    end

    m = size(handles.curvedata,1);

    if ~isempty(handles.curvedata)
        for i = 1 : m
            d = handles.curvedata(i);
            h = d.plotcurve;
            p = d.plotcpolygon;
            L = get(h,'LineWidth');
            if L == 2.5
                % show selectdata knot vector
                axes(handles.basis);
                c = d.plotknotV;
                set(c, 'visible', 'on');
                
                knotP = d.plotknotP;           
                for o = 1:size(knotP,1)
                    set(knotP(o),'visible','on');
                end
                
                k = d.degree;
                cpoint = d.controlP;
                num = size(cpoint,1);
                % The max possible degree is num - 1
                a = 1:(num - 1);
                set(handles.changedegree, 'String', a);
                set(handles.degree, 'String', k);
                set(handles.numofcp, 'String', num);
                
                % save selectdata
                handles.selectdata = cat(1, handles.selectdata, d);
            else
                axes(handles.basis);
                c = d.plotknotV;
                set(c, 'visible', 'off');
                
                knotP = d.plotknotP;           
                for o = 1:size(knotP,1)
                    set(knotP(o),'visible','off');
                end
            end
        end
    end
else
    set(H,'LineWidth', 1.5);
    if ~isempty(handles.selectdata)
        handles.selectdata = [];
    end
end

guidata(hObject,handles);
end


