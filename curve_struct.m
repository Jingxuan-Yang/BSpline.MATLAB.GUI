function curve_struct(k, cpoint, t, hObject, handles)
% The function is used to create a new structure of a curve
% and save the new structure in the data handles
% The struct has the format:
%                           degree : k
%                           controlP: cpoint
%                           knotV: t
%                           curveP: C
%                           color: cc
%                           plotcurve: []
%                           plotcontrolP: []
%                           plotcpolygon: []

% the curve points
[C] = bspline_curve(k, t, cpoint);

% the color
cc = rand(3,1)';

% create field and value
field1 = 'degree'; value1 = k;
field2 = 'controlP'; value2 = cpoint;
field3 = 'knotV'; value3 = t;
field4 = 'curveP'; value4 = C;
field5 = 'color'; value5 = cc;
field6 = 'plotcurve'; value6 = [];
field7 = 'plotcontrolP'; value7 =  [];
field8 = 'plotcpolygon'; value8 =  [];
field9 = 'plotknotV'; value9 = [];
field10 = 'plotknotP'; value10 = [];
s = struct(field1,value1,field2,value2,field3,value3,field4,value4, ...
           field5,value5,field6,value6,field7, value7,field8,value8, ...
           field9,value9,field10,value10);

%cat, Concatenate arrays along 1 dimension
handles.curvedata = cat(1, handles.curvedata, s);

guidata(hObject, handles);

end

