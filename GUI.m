function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 04-Apr-2019 12:40:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1}); 
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

%% Create handle data
handles.curvedata = [];

handles.selectdata = [];

handles.plotcurve = [];
handles.plotcontrolP = [];
handles.plotknotP = [];


%% set handle data
set(handles.displaycurve, 'value',1);
set(handles.displaycontrolP, 'value',1);
set(handles.displaycpolygon, 'value',1);

%% set GUI to the center of the screen
% gcf, gui current figure
% gca, gui current axes
movegui(gcf,'center');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% push button to load 2D data file
% --- Executes on button press in load2Ddata.
function load2Ddata_Callback(hObject, eventdata, handles)
% hObject    handle to load2Ddata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% [file,path,indx] = uigetfile returns the index of the filter selected
% in the dialog box when the user clicks Open
[FileName,PathName] = uigetfile('*.dat','Select the Data file');
[k, cpoint, t] = load2DData(PathName, FileName);

% update data handles
% guidata, stores the variables
curve_struct(k, cpoint, t, hObject, handles)
handles = guidata(hObject);

plot_curve(hObject, handles);
handles = guidata(hObject);

plot_cpoint(hObject, handles);
handles = guidata(hObject);

plot_cpolygon(hObject, handles)
handles = guidata(hObject);

plot_knotV(hObject, handles);
handles = guidata(hObject);

% update plotcurve,plotcontrolP and plotknotP;
update_handles(hObject, handles);
handles  = guidata(hObject);

set(handles.plotcurve, 'ButtonDownFcn',{@LineSelected,handles.plotcurve,hObject,handles});

for i = 1 : size(handles.plotcontrolP,1)
    m = handles.plotcontrolP(i);
    % id = addNewPositionCallback(h,fcn) adds the function handle fcn
    % to the list of new-position callback functions of the ROI object h.
    addNewPositionCallback(m, @(p) update_curve(p,hObject,handles,i));
    handles = guidata(hObject);
end
    
knotP = handles.plotknotP;
for o = 1:size(knotP,1)
  addNewPositionCallback(knotP(o), @(p) move_knot(p,hObject,handles));
end


guidata(hObject, handles);
    
% --- Executes on button press in displaycurve.
function displaycurve_Callback(hObject, eventdata, handles)
% hObject    handle to displaycurve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of displaycurve
if get(handles.displaycurve, 'Value')
    if isempty(handles.selectdata)
        errordlg('Please select a curve');
    else
       s = handles.selectdata(1);
       c = s.plotcurve;
       set(c,'visible','on');
    end
end

if ~get(handles.displaycurve, 'Value')
    if isempty(handles.selectdata)
        errordlg('Please select a curve');
    else
       s = handles.selectdata(1);
       c = s.plotcurve;
       set(c,'visible','off');
    end
end
guidata(hObject, handles);

% --- Executes on button press in displaycontrolP.
function displaycontrolP_Callback(hObject, eventdata, handles)
% hObject    handle to displaycontrolP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of displaycontrolP
if get(handles.displaycontrolP, 'Value')
    if isempty(handles.selectdata)
        errordlg('Please select a curve');
    else
    s = handles.selectdata(1);
    c = s.plotcontrolP;
        for i = 1 : size(c,1)
           cc = c(i);
           set(cc,'visible','on');
        end
    end
end

if ~get(handles.displaycontrolP, 'Value')
    if isempty(handles.selectdata)
        errordlg('Please select a curve');
    else
       s = handles.selectdata(1);
       c = s.plotcontrolP;
       for i = 1 : size(c,1)
           cc = c(i);
           set(cc,'visible','off');
       end
    end
end
guidata(hObject, handles);

% --- Executes on button press in displaycpolygon.
function displaycpolygon_Callback(hObject, eventdata, handles)
% hObject    handle to displaycpolygon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of displaycpolygon
if get(handles.displaycpolygon, 'Value')
    if isempty(handles.selectdata)
        errordlg('Please select a curve');
    else
       s = handles.selectdata(1);
       c = s.plotcpolygon;
       set(c,'visible','on');
    end
end

if ~get(handles.displaycpolygon, 'Value')
    if isempty(handles.selectdata)
        errordlg('Please select a curve');
    else
       s = handles.selectdata(1);
       c = s.plotcpolygon;
       set(c,'visible','off');
    end
end
guidata(hObject, handles);


% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.clear, 'Value')
    axes(handles.curve);
    % cla reset, deletes graphics objects from the current axes 
    % regardless of their handle visibility. 
    % It also resets axes properties to their default values, 
    % except for the Position and Units properties.
    cla reset;   
    axes(handles.basis);
    cla reset; 
    
    % restart
    close(gcbf) 
    GUI;
end
    
% --- Executes on button press in Modified.
function Modified_Callback(hObject, eventdata, handles)
% hObject    handle to Modified (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.Modified, 'Value')
    %check if the selected curve's knot vector is modified
    if isempty(handles.selectdata)
        errordlg('Please select a curve');
    else
        s = handles.selectdata(1);
        t = s.knotV;
        k = s.degree;
        for i = 1 : k 
            if t(i) ~= t(i+1) || t(k+1) - t(k) ~= t(k+2) - t(k+1)
            change_to_modifiedopen(hObject, handles);
            handles = guidata(hObject);
            break;
            end
        end
    end
end
update_handles(hObject, handles);
handles = guidata(hObject);
for i = 1 : size(handles.plotcontrolP,1)
    m = handles.plotcontrolP(i);
    addNewPositionCallback(m, @(p) update_curve(p,hObject,handles,i));
    handles = guidata(hObject);
end
    
knotP = handles.plotknotP;
for o = 1:size(knotP,1)
  addNewPositionCallback(knotP(o), @(p) move_knot(p,hObject,handles));
  handles = guidata(hObject);
end
handles = guidata(hObject);
guidata(hObject, handles);


% --- Executes on button press in floating.
function floating_Callback(hObject, eventdata, handles)
% hObject    handle to floating (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.floating, 'Value')
    %check if the selected curve's knot vector is modified
    if isempty(handles.selectdata)
        errordlg('Please select a curve');
    else
    s = handles.selectdata(1);
    t = s.knotV;
    k = s.degree;
    for i = 1 : k 
        if t(i) == t(i+1)
        change_to_floating(hObject, handles);
        handles = guidata(hObject);
        break;
        end
    end
    end
end
update_handles(hObject, handles);
handles = guidata(hObject);
for i = 1 : size(handles.plotcontrolP,1)
    m = handles.plotcontrolP(i);
    addNewPositionCallback(m, @(p) update_curve(p,hObject,handles,i));
    handles = guidata(hObject);
end
    
knotP = handles.plotknotP;
for o = 1:size(knotP,1)
  addNewPositionCallback(knotP(o), @(p) move_knot(p,hObject,handles));
  handles = guidata(hObject);
end

handles = guidata(hObject);

guidata(hObject, handles);


% --- Executes on selection change in changedegree.
function changedegree_Callback(hObject, eventdata, handles)
% hObject    handle to changedegree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns changedegree contents as cell array
%        contents{get(hObject,'Value')} returns selected item from changedegree

if isempty(handles.selectdata)
    errordlg('Please select a curve');
else
    changedegree(hObject, handles);
    handles = guidata(hObject);
end

update_handles(hObject, handles);
handles = guidata(hObject);
for i = 1 : size(handles.plotcontrolP,1)
    m = handles.plotcontrolP(i);
    addNewPositionCallback(m, @(p) update_curve(p,hObject,handles,i));
    handles = guidata(hObject);
end
    
knotP = handles.plotknotP;
for o = 1:size(knotP,1)
  addNewPositionCallback(knotP(o), @(p) move_knot(p,hObject,handles));
  handles = guidata(hObject);
end

handles = guidata(hObject);

guidata(hObject, handles);
    

% --- Executes during object creation, after setting all properties.
function changedegree_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changedegree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in insertcontrolP.
function insertcontrolP_Callback(hObject, eventdata, handles)
% hObject    handle to insertcontrolP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.insertcontrolP, 'Value')
    if isempty(handles.selectdata)
            errordlg('Please select a curve');
    else
        add_cp_beginning(hObject,handles);
        change_to_modifiedopen(hObject, handles);
        handles = guidata(hObject);
    end       
end

update_handles(hObject, handles);
handles = guidata(hObject);

for i = 1 : size(handles.plotcontrolP,1)
    m = handles.plotcontrolP(i);
    addNewPositionCallback(m, @(p) update_curve(p,hObject,handles,i));
    handles = guidata(hObject);
end

knotP = handles.plotknotP;
for o = 1:size(knotP,1)
  addNewPositionCallback(knotP(o), @(p) move_knot(p,hObject,handles));
  handles = guidata(hObject);
end

%delete impoint p
@(p)delete;

handles = guidata(hObject);   
guidata(hObject, handles);


% --- Executes on button press in insertend.
function insertend_Callback(hObject, eventdata, handles)
% hObject    handle to insertend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.insertend, 'Value')
    if isempty(handles.selectdata)
            errordlg('Please select a curve');
    else
        add_cp_end(hObject,handles); 
        change_to_modifiedopen(hObject, handles);
        handles = guidata(hObject);
    end       
end

update_handles(hObject, handles);
handles = guidata(hObject);
for i = 1 : size(handles.plotcontrolP,1)
    m = handles.plotcontrolP(i);
    addNewPositionCallback(m, @(p) update_curve(p,hObject,handles,i));
    handles = guidata(hObject);
end
    
knotP = handles.plotknotP;
for o = 1:size(knotP,1)
  addNewPositionCallback(knotP(o), @(p) move_knot(p,hObject,handles));
  handles = guidata(hObject);
end

%delete impoint p
@(p)delete;

handles = guidata(hObject);
guidata(hObject, handles);


% --- Executes on button press in insertmiddle.
function insertmiddle_Callback(hObject, eventdata, handles)
% hObject    handle to insertmiddle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.insertmiddle, 'Value')
    
    if isempty(handles.selectdata)
        errordlg('Please select a curve');
    else
        h = msgbox({'Please first select two points that you want to'; ...
            'insert the new point between, then click at the ';...
            'position to insert the desired point'}, 'Note','modal');
        
        % change font size
        ah = get(h, 'CurrentAxes');
        ch = get(ah, 'Children');
        set(ch, 'FontSize', 14);
        
        % change message position
        set(h,'Position',[400 300 300 100]);
        
        s = handles.selectdata(1);
        cpoint = s.controlP;
        % Y = diff(X) calculates differences between adjacent elements
        % of X along the first array dimension whose size does not equal 1
        a = find(diff(cpoint)==0, 1);
        if isempty(a)
        plotcp = s.plotcontrolP;

        axes(handles.curve);
        p1 = impoint(gca);
        %compute Euclidean distances:
        pp1 = getPosition(p1);
        distances1 = sqrt(sum(bsxfun(@minus, cpoint, pp1).^2,2));
        pp1 = cpoint(distances1==min(distances1),:);
        a1 = distances1==min(distances1);
        a1 = find(a1 == 1);
        setColor(plotcp(a1), 'r');
        set(p1,'visible', 'off');
        %compute Euclidean distances:
        p2 = impoint(gca);
        pp2 = getPosition(p2);
        distances2 = sqrt(sum(bsxfun(@minus, cpoint, pp2).^2,2));
        %find the smallest distance and use that as an index into B:
        pp2 = cpoint(distances2==min(distances2),:);
        a2 = distances2==min(distances2); 
        a2 = find(a2 == 1);
        set(p2,'visible', 'off');                
        setColor(plotcp(a2), 'r');
        
        % insert p
        axes(handles.curve);
        p = impoint(gca);
        add_cp_middle(p,a1,a2, hObject,handles);
        change_to_modifiedopen(hObject, handles);
        handles = guidata(hObject);
        else
            errordlg({'There are miltiple control points,';...
                'please seperate them first and press insert again.'});
        end
    end

end

update_handles(hObject, handles);
handles = guidata(hObject);
for i = 1 : size(handles.plotcontrolP,1)
    m = handles.plotcontrolP(i);
    addNewPositionCallback(m, @(p) update_curve(p,hObject,handles,i));
    handles = guidata(hObject);
end
    
knotP = handles.plotknotP;
for o = 1:size(knotP,1)
  addNewPositionCallback(knotP(o), @(p) move_knot(p,hObject,handles));
  handles = guidata(hObject);
end

% delete p
delete(p);

handles = guidata(hObject);
guidata(hObject, handles);


% --- Executes on button press in load3d.
function load3d_Callback(hObject, eventdata, handles)
% hObject    handle to load3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.txt','Select the Data file');
[k, cpoint, t] = load3DData(PathName, FileName);
% update data handles
curve_struct(k, cpoint, t, hObject, handles)
handles = guidata(hObject);

plot_curve(hObject, handles);
handles = guidata(hObject);
plot_cpoint(hObject,handles)
handles = guidata(hObject);

plot_knotV(hObject, handles);
handles = guidata(hObject);
guidata(hObject, handles);


function dd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in create.
function create_Callback(hObject, eventdata, handles)
% hObject    handle to create (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% creat
if get(handles.create, 'Value')   
%     k = str2num(cell2mat(get(handles.dd, 'string')));
        k = str2num((get(handles.dd, 'string')));
    if k ~= 0
        axes(handles.curve);
        ah = get(handles.curve);
        % mouse response by ginput
        n = 0;
        but = 1;
        while but == 1 && n < 10            
            axis([-10 10 -10 10]); % fix display range
            
            [xi,yi,but] = ginput(1); % input data by mouse
            n = n+1;
            if isempty(xi) == 1 % exit when right click
                break;
            end
            x(n) = xi;
            y(n) = yi; %assign click points to x,y
            po(n) = plot(x,y,'--bo'); % show all clicked points
            axis([-10 10 -10 10]);
            hold on;                                            
        end
        % delete the circles and lines that represents each point
        delete(po);
        
        p = [x',y'];
        create_new_curve(k,p,hObject, handles);
        handles = guidata(hObject);
    else
        errordlg('Please enter a degree first.');
    end
end

update_handles(hObject, handles);
handles = guidata(hObject);

set(handles.plotcurve, 'ButtonDownFcn',{@LineSelected,handles.plotcurve,hObject,handles});
handles = guidata(hObject);

for i = 1 : size(handles.plotcontrolP,1)
    m = handles.plotcontrolP(i);
    addNewPositionCallback(m, @(p) update_curve(p,hObject,handles,i));
    handles = guidata(hObject);
end
    
knotP = handles.plotknotP;
for o = 1:size(knotP,1)
  addNewPositionCallback(knotP(o), @(p) move_knot(p,hObject,handles));
  handles = guidata(hObject);
end

handles = guidata(hObject);

guidata(hObject, handles);


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.save, 'Value')
    saveData(hObject,handles);
end

guidata(hObject, handles);


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc,clear,close all;


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% tasks to be accomplished
% dynamically show the marker

% --- Executes on button press in DeleteContP.
function DeleteContP_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteContP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.DeleteContP, 'Value')
    
    if isempty(handles.selectdata)
        errordlg('Please select a curve');
    else
        
        s = handles.selectdata(1);
        cpoint = s.controlP;
        % Y = diff(X) calculates differences between adjacent elements
        % of X along the first array dimension whose size does not equal 1
        a = find(diff(cpoint)==0, 1);
        if isempty(a)
            plotcp = s.plotcontrolP;

            axes(handles.curve);

            % delete p
            axes(handles.curve);
            p = impoint(gca);
            delete_cp(p,hObject,handles);
            change_to_modifiedopen(hObject, handles);
            handles = guidata(hObject);
        else
            errordlg({'There are miltiple control points,';...
                'please seperate them first and press insert again.'});
        end
    end

end

update_handles(hObject, handles);
handles = guidata(hObject);
for i = 1 : size(handles.plotcontrolP,1)
    m = handles.plotcontrolP(i);
    addNewPositionCallback(m, @(p) update_curve(p,hObject,handles,i));
    handles = guidata(hObject);
end
    
knotP = handles.plotknotP;
for o = 1:size(knotP,1)
  addNewPositionCallback(knotP(o), @(p) move_knot(p,hObject,handles));
  handles = guidata(hObject);
end

handles = guidata(hObject);

guidata(hObject, handles);


% --- Executes on button press in drag.
function drag_Callback(hObject, eventdata, handles)
% hObject    handle to drag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.drag, 'Value')
    %check if the selected curve's knot vector is modified
    if isempty(handles.selectdata)
        errordlg('Please select a curve');
    else
        s = handles.selectdata(1);
        t = s.knotV;
        k = s.degree;
        for i = 1 : k 
            if t(i) ~= t(i+1) || t(k+1) - t(k) ~= t(k+2) - t(k+1)
            change_to_modifiedopen(hObject, handles);
            handles = guidata(hObject);
            break;
            end
        end
    end
end
update_handles(hObject, handles);
handles = guidata(hObject);
for i = 1 : size(handles.plotcontrolP,1)
    m = handles.plotcontrolP(i);
    addNewPositionCallback(m, @(p) update_curve(p,hObject,handles,i));
    handles = guidata(hObject);
end
    
knotP = handles.plotknotP;
for o = 1:size(knotP,1)
  addNewPositionCallback(knotP(o), @(p) move_knot(p,hObject,handles));
  handles = guidata(hObject);
end
handles = guidata(hObject);
guidata(hObject, handles);
