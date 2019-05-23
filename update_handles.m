function update_handles(hObject, handles)
% clear data in handles
handles.plotcurve = [];
handles.plotcontrolP = [];
handles.plotknotP = [];

m = size(handles.curvedata,1);
for i = 1 : m
    c = handles.curvedata(i);
    plotcurve = c.plotcurve;
    plotcontrolP = c.plotcontrolP;
    plotknotP = c.plotknotP;
    handles.plotcurve = cat(1,handles.plotcurve,plotcurve);
    handles.plotcontrolP = cat(1,handles.plotcontrolP,plotcontrolP);
    handles.plotknotP = cat(1,handles.plotknotP,plotknotP);
end

guidata(hObject, handles);
end

