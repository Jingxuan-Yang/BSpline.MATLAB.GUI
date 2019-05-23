function create_new_curve(k,p,hObject, handles)
%Summary of this function goes here
%   Detailed explanation goes here

    num = size(p,1);
if num <= k 
    errordlg('Not enough control points.');
else
    m = num + k + 1;
    num_end = k + 1;
    e = m - 2 * num_end;
    temp = [];
    
    if e == 0
        T = cat(2, zeros(1, num_end), ones(1,num_end));
    else
    for i = 1 : e
        temp = cat(2,temp, i/(e+1));
    end
    
    t = cat(2,zeros(1, num_end),temp);
    T = cat(2, t, ones(1,num_end));
    end

    curve_struct(k, p, T, hObject, handles)
    handles = guidata(hObject);

    plot_curve(hObject, handles);
    handles = guidata(hObject);
    plot_cpoint(hObject, handles);
    handles = guidata(hObject);
    plot_cpolygon(hObject, handles)
    handles = guidata(hObject);
    plot_knotV(hObject, handles)
    handles = guidata(hObject);


end


guidata(hObject, handles);
end

