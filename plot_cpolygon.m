function plot_cpolygon(hObject, handles)
% plot control polygon

hold all;
n = size(handles.curvedata,1);
s = handles.curvedata(n);

cpoint = s.controlP;
cc = s.color;

axes(handles.curve);
axis([-10 10 -10 10]);

c = plot(cpoint(:,1), cpoint(:,2), 'Color', cc, 'Linewidth', 2);
set(c, 'XData',cpoint(:,1), 'YData',cpoint(:,2));
uistack(c,'down',500);

s = setfield(s,'plotcpolygon',c);
handles.curvedata(n) = s;


guidata(hObject, handles);
end
