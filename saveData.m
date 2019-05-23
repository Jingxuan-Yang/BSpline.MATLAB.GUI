function saveData(hObject, handles)
% save data

if isempty(handles.selectdata)
    errordlg('Please select a curve');
else
    s = handles.selectdata(1);
    k = s.degree;
    cpoint = s.controlP;
    num = size(cpoint,1);    
    knotV = s.knotV;
    a = 1;
    % save them to an ASCII file
    save('data.dat','k','num','cpoint','a','knotV','-ascii');

guidata(hObject, handles);
end
