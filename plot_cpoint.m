function plot_cpoint(hObject,handles)
%Summary of this function goes here
%   Detailed explanation goes here

hold all;
n = size(handles.curvedata,1);
s = handles.curvedata(n);

cpoint = s.controlP;
cc = s.color;
m = size(cpoint,2);

    if m == 2
        axes(handles.curve);
        axis([-10 10 -10 10]);
        pp = [];
        for j = 1 : size(cpoint,1)
            p = cpoint(j,:);
            % h = impoint(hparent,position) creates a draggable point
            % with coordinates defined by position.
            h(j) = impoint(gca,p);
            setColor(h(j),cc);
        end
        s = setfield(s,'plotcontrolP',h');
        % save updated curve data
        handles.curvedata(n) = s;

        set(handles.numofcp,'String', size(cpoint,1));
    else
        % if dimension is 3, just plot
        scatter3(cpoint(:,1),cpoint(:,2),cpoint(:,3));
        plot3(cpoint(:,1),cpoint(:,2),cpoint(:,3));
    end

guidata(hObject, handles);
end
