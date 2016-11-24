function [varargout] = VSM(varargin)
% VSM MATLAB code for VSM.fig
%      VSM, by itself, creates a new VSM or raises the existing
%      singleton*.
%
%      H = VSM returns the handle to a new VSM or the handle to
%      the existing singleton*.
%
%      VSM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VSM.M with the given input arguments.
%
%      VSM('Property','Value',...) creates a new VSM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VSM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VSM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VSM

% Last Modified by GUIDE v2.5 24-Nov-2016 09:43:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VSM_OpeningFcn, ...
                   'gui_OutputFcn',  @VSM_OutputFcn, ...
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


% --- Executes just before VSM is made visible.
function VSM_OpeningFcn(hObject, eventdata, handles, varargin)

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VSM (see VARARGIN)
[filename filepath deleteme]=uigetfile;
fid=fopen([filepath filename],'r');                        %open file
l=fgetl(fid);                                   %get line

while ~strcmp('New Section: Section 0: ',l)     %loop skips ahead to line that marks start of data
   l=fgetl(fid);
end
l=fgetl(fid);   %get first data line
i=1;
L=sscanf(l,'%f');
t0=L(1);
while ~strcmp('@@END Data.',l)     %until line that marks end of data
    L=sscanf(l,'%f');
    handles.time(i)=L(1)-t0;
   	handles.Mpar(i)=L(13);
    handles.Mperp(i)=L(14);
    handles.field(i)=L(5);      %'Applied Field For Plot' [need to find out what the difference is between this and 'Raw Applied field'/'Raw Applied Field', etc]
    i=i+1;
    l=fgetl(fid);       %get next line of data
end

fclose(fid);
plot(handles.field,handles.Mpar,handles.field,handles.Mperp);
legend('M Parallel with Sample','M Perpendicular with sample','Location','southeast');
xlabel('Applied Field (Oe)');
ylabel('Magnetisation (emu)');
set(handles.LineSlider,'Max',3e-7);
set(handles.LineSlider,'Min',-3e-7);
set(handles.Msonoff,'Value',1);
set(handles.scatteronoff,'Value',0);
handles.c=0;
handles.d=0;
handles.g=0;
handles.pm=1;
set(handles.NSat,'Min',min(handles.field));
set(handles.NSat,'Max',0);
set(handles.NSat,'Value',0.5*min(handles.field));

    
% Choose default command line output for VSM
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VSM wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VSM_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

varargout{1}=handles.field;
varargout{2}=handles.CD-handles.g*handles.field+handles.c-handles.d*handles.time;
varargout{3}=handles.Ms;
varargout{4}=handles.d;
varargout{5}=handles.g;
varargout{6}=handles.c;
varargout{7}=handles.CD;
varargout{8}=handles.time;
delete(handles.figure1);

% --- Executes on button press in SelectFileButton.
function SelectFileButton_Callback(hObject, eventdata, handles)
% hObject    handle to SelectFileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename filepath deleteme]=uigetfile;
fid=fopen([filepath filename],'r');                        %open file
l=fgetl(fid);                                   %get line

while ~strcmp('New Section: Section 0: ',l)     %loop skips ahead to line that marks start of data
   l=fgetl(fid);
end
l=fgetl(fid);   %get first data line
i=1;
while ~strcmp('@@END Data.',l)     %until line that marks end of data
    L=sscanf(l,'%f');
   	handles.Mpar(i)=L(13);
    handles.Mperp(i)=L(14);
    handles.field(i)=L(5);      %'Applied Field For Plot' [need to find out what the difference is between this and 'Raw Applied field'/'Raw Applied Field', etc]
    i=i+1;
    l=fgetl(fid);       %get next line of data
end

fclose(fid);
plot(handles.field,handles.Mpar,handles.field,handles.Mperp);
legend('M Parallel with Sample','M Perpendicular with sample','Location','southeast');
xlabel('Applied Field (Oe)');
ylabel('Magnetisation (emu)');
grid
handles.m=1;
handles.c=2;
handles.d=1e-7;
% Choose default command line output for VSM
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on selection change in Display.
function Display_Callback(hObject, eventdata, handles)
% hObject    handle to Display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Determine the selected data set.
str = get(hObject, 'String');
handles.pm = get(hObject,'Value');
if(handles.pm==1)
   	plot(handles.field,handles.Mpar,handles.field,handles.Mperp);
    handles.CDL='M Parallel with Sample','M Perpendicular with sample';
    grid
    legend(handles.CDL,'Location','southeast');
    xlabel('Applied Field (Oe)');
    ylabel('Magnetisation (emu)');
else
    if(handles.pm==2)
        handles.CD=handles.Mpar;
        handles.CDL='M parallel with Sample (corrected)';
    elseif(handles.pm==3)
      	handles.CD=handles.Mperp;
        handles.CDL='M perpendicular with Sample (corrected)';
    end
    
   	handles.g=estimate_g(handles);
    set(handles.LineSlider,'Value',handles.g)
    set(handles.LineValue,'String',num2str(handles.g,'%1.2e'));
    set(handles.LineSlider,'Max',handles.g+abs(0.25*handles.g));
    set(handles.LCmax,'String',num2str(handles.g+abs(0.25*handles.g),'%1.2e'));
  	set(handles.LineSlider,'Min',handles.g-abs(0.25*handles.g));
    set(handles.LCmin,'String',num2str(handles.g-abs(0.25*handles.g),'%1.2e'));
    
    handles.d=estimate_d(handles.field,handles.time,handles.CD-handles.g*handles.field,get(handles.NSat,'Value'));
    set(handles.DriftSlider,'Value',handles.d)
    set(handles.DriftValue,'String',num2str(handles.d,'%1.2e'));
    set(handles.DriftSlider,'Max',handles.d+abs(0.25*handles.d));
    set(handles.dmax,'String',num2str(handles.d+abs(0.25*handles.d),'%1.2e'));
  	set(handles.DriftSlider,'Min',handles.d-abs(0.25*handles.d));
    set(handles.dmin,'String',num2str(handles.d-abs(0.25*handles.d),'%1.2e'));
    
    handles.c=estimate_c(handles.field,handles.CD-handles.g*handles.field-handles.d*handles.time,get(handles.NSat,'Value'));
   	set(handles.OffsetSlider,'Value',handles.c)
    set(handles.OffsetValue,'String',num2str(handles.c,'%1.2e'));
    set(handles.OffsetSlider,'Max',handles.c+abs(0.25*handles.c));
    set(handles.omax,'String',num2str(handles.c+abs(0.25*handles.c),'%1.2e'));
  	set(handles.OffsetSlider,'Min',handles.c-abs(0.25*handles.c));
    set(handles.omin,'String',num2str(handles.c-abs(0.25*handles.c),'%1.2e'));
    
	handles.Ms=estimate_Ms(handles);
    PlotCorrected(handles);

end

% Save the handles structure.
guidata(hObject,handles)

% Hints: contents = cellstr(get(hObject,'String')) returns Display contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Display


% --- Executes during object creation, after setting all properties.
function Display_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LineValue_Callback(hObject, eventdata, handles)
% hObject    handle to LineValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.pm>1)    %don't mess with corrections if displaying both
    handles.g=str2double(get(hObject,'String'));
    if(handles.g>get(handles.LineSlider,'Max'))
        set(handles.LineSlider,'Max',handles.g);
        set(handles.LCmax,'String',num2str(handles.g,'%1.2e'));
    end
    if(handles.g<get(handles.LineSlider,'Min'))
        set(handles.LineSlider,'Min',handles.g);
        set(handles.LCmin,'String',num2str(handles.g,'%1.2e'));
    end

  	handles.Ms=estimate_Ms(handles);
  	PlotCorrected(handles);
end
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of LineValue as text
%        str2double(get(hObject,'String')) returns contents of LineValue as a double


% --- Executes during object creation, after setting all properties.
function LineValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LineValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DriftValue_Callback(hObject, eventdata, handles)
% hObject    handle to DriftValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.pm>1)    %don't mess with corrections if displaying both
    handles.d=str2double(get(hObject,'String'));
    if(handles.d>get(handles.DriftSlider,'Max'))
        set(handles.DriftSlider,'Max',handles.d);
        set(handles.dmax,'String',num2str(handles.d,'%1.2e'));
    end
    if(handles.d<get(handles.DriftSlider,'Min'))
        set(handles.DriftSlider,'Min',handles.d);
        set(handles.dmin,'String',num2str(handles.d,'%1.2e'));
    end
    
   	handles.Ms=estimate_Ms(handles);
   	PlotCorrected(handles);
end
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of DriftValue as text
%        str2double(get(hObject,'String')) returns contents of DriftValue as a double


% --- Executes during object creation, after setting all properties.
function DriftValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DriftValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OffsetValue_Callback(hObject, eventdata, handles)
% hObject    handle to OffsetValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.pm>1)    %don't mess with corrections if displaying both
    handles.c=str2double(get(hObject,'String'));
    if(handles.c>get(handles.OffsetSlider,'Max'))
        set(handles.OffsetSlider,'Max',handles.c);
        set(handles.omax,'String',num2str(handles.c,'%1.2e'));
    end
    if(handles.c<get(handles.OffsetSlider,'Min'))
        set(handles.OffsetSlider,'Min',handles.c);
        set(handles.omin,'String',num2str(handles.c,'%1.2e'));
    end
    
   	handles.Ms=estimate_Ms(handles);
   	PlotCorrected(handles);
end
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of OffsetValue as text
%        str2double(get(hObject,'String')) returns contents of OffsetValue as a double


% --- Executes during object creation, after setting all properties.
function OffsetValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OffsetValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on slider movement.
function LineSlider_Callback(hObject, eventdata, handles)
% hObject    handle to LineSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.g=get(hObject,'Value');
set(handles.LineValue,'String',num2str(handles.g,'%1.2e'));
handles.Ms=estimate_Ms(handles);
PlotCorrected(handles);
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function LineSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LineSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function OffsetSlider_Callback(hObject, eventdata, handles)
% hObject    handle to OffsetSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.c=get(hObject,'Value');
set(handles.OffsetValue,'String',num2str(handles.c,'%1.2e'));
handles.Ms=estimate_Ms(handles);
PlotCorrected(handles);
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function OffsetSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OffsetSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function DriftSlider_Callback(hObject, eventdata, handles)
% hObject    handle to DriftSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.d=get(hObject,'Value');
set(handles.DriftValue,'String',num2str(handles.d,'%1.2e'));
handles.Ms=estimate_Ms(handles);
PlotCorrected(handles);
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function DriftSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DriftSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function LCmax_Callback(hObject, eventdata, handles)

% hObject    handle to LCmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.pm>1)
    A=str2double(get(hObject,'String'));

    if(A<str2double(get(handles.LCmin,'String')))
        set(handles.LineSlider,'Min',A-abs(A));
       	set(handles.LCmin,'String',num2str(A-abs(A),'%1.2e'));
        set(handles.LineSlider,'Value',A);
        set(handles.LineSlider,'Max',A);
    	set(handles.LineValue,'String',num2str(A,'%1.2e'));
        handles.g=A;
        handles.Ms=estimate_Ms(handles);
    	PlotCorrected(handles);

    elseif (A<get(handles.LineSlider,'Value'))
       set(handles.LineSlider,'Value',A);
       set(handles.LineSlider,'Max',A);
       set(handles.LineValue,'String',num2str(A,'%1.2e'));
        handles.g=A;
     	handles.Ms=estimate_Ms(handles);
    	PlotCorrected(handles);
    else
       set(handles.LineSlider,'Max',A);    
    end
end

guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of LCmax as text
%        str2double(get(hObject,'String')) returns contents of LCmax as a double


% --- Executes during object creation, after setting all properties.
function LCmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LCmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LCmin_Callback(hObject, eventdata, handles)
% hObject    handle to LCmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.pm>1)
    A=str2double(get(hObject,'String'));

    if(A>str2double(get(handles.LCmax,'String')))
        set(handles.LineSlider,'Max',A+abs(A));
       	set(handles.LCmax,'String',num2str(A+abs(A),'%1.2e'));
        set(handles.LineSlider,'Value',A);
        set(handles.LineSlider,'Min',A);
    	set(handles.LineValue,'String',num2str(A,'%1.2e'));
        handles.g=A;
     	handles.Ms=estimate_Ms(handles);
    	PlotCorrected(handles);
	elseif (A>get(handles.LineSlider,'Value'))
        set(handles.LineSlider,'Value',A);
        set(handles.LineSlider,'Min',A);
        set(handles.LineValue,'String',num2str(A,'%1.2e'));
        handles.g=A;
    	handles.Ms=estimate_Ms(handles);
    	PlotCorrected(handles);
    else
       set(handles.LineSlider,'Min',A);    
    end
end

guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of LCmin as text
%        str2double(get(hObject,'String')) returns contents of LCmin as a double


% --- Executes during object creation, after setting all properties.
function LCmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LCmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function LineCorrection_CreateFcn(hObject, eventdata, handles)
%having this here seems to make the stupid error go away
%I have no idea where it's calling this function from or why, but it seems
%to insist that it must exist. 


% --- Executes on slider movement.
function NSat_Callback(hObject, eventdata, handles)
% hObject    handle to NSat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Display_Callback(handles.Display,eventdata,handles);
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function NSat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NSat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function omin_Callback(hObject, eventdata, handles)
% hObject    handle to omin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.pm>1)
    A=str2double(get(hObject,'String'));

    if(A>str2double(get(handles.omax,'String')))
        set(handles.OffsetSlider,'Max',A+abs(A));
       	set(handles.omax,'String',num2str(A+abs(A),'%1.2e'));
        set(handles.OffsetSlider,'Value',A);
        set(handles.OffsetSlider,'Min',A);
    	set(handles.OffsetValue,'String',num2str(A,'%1.2e'));
        handles.o=A;
     	handles.Ms=estimate_Ms(handles);
    	PlotCorrected(handles);
	elseif (A>get(handles.OffsetSlider,'Value'))
        set(handles.OffsetSlider,'Value',A);
        set(handles.OffsetSlider,'Min',A);
        set(handles.OffsetValue,'String',num2str(A,'%1.2e'));
        handles.o=A;
    	handles.Ms=estimate_Ms(handles);
    	PlotCorrected(handles);
    else
       set(handles.OffsetSlider,'Min',A);    
    end
end

guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of omin as text
%        str2double(get(hObject,'String')) returns contents of omin as a double


% --- Executes during object creation, after setting all properties.
function omin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to omin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function omax_Callback(hObject, eventdata, handles)
% hObject    handle to omax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.pm>1)
    A=str2double(get(hObject,'String'));

    if(A<str2double(get(handles.omin,'String')))
        set(handles.OffsetSlider,'Min',A-abs(A));
       	set(handles.omin,'String',num2str(A-abs(A),'%1.2e'));
        set(handles.OffsetSlider,'Value',A);
        set(handles.OffsetSlider,'Max',A);
    	set(handles.OffsetValue,'String',num2str(A,'%1.2e'));
        handles.c=A;
        handles.Ms=estimate_Ms(handles);
    	PlotCorrected(handles);

    elseif (A<get(handles.OffsetSlider,'Value'))
       set(handles.OffsetSlider,'Value',A);
       set(handles.OffsetSlider,'Max',A);
       set(handles.OffsetValue,'String',num2str(A,'%1.2e'));
        handles.c=A;
     	handles.Ms=estimate_Ms(handles);
    	PlotCorrected(handles);
    else
       set(handles.OffsetSlider,'Max',A);    
    end
end

guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of omax as text
%        str2double(get(hObject,'String')) returns contents of omax as a double


% --- Executes during object creation, after setting all properties.
function omax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to omax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dmin_Callback(hObject, eventdata, handles)
% hObject    handle to dmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.pm>1)
    A=str2double(get(hObject,'String'));

    if(A>str2double(get(handles.dmax,'String')))
        set(handles.DriftSlider,'Max',A+abs(A));
       	set(handles.dmax,'String',num2str(A+abs(A),'%1.2e'));
        set(handles.DriftSlider,'Value',A);
        set(handles.DriftSlider,'Min',A);
    	set(handles.DriftValue,'String',num2str(A,'%1.2e'));
        handles.d=A;
        handles.Ms=estimate_Ms(handles);
    	PlotCorrected(handles);

    elseif (A>get(handles.DriftSlider,'Value'))
       set(handles.DriftSlider,'Value',A);
       set(handles.DriftSlider,'Min',A);
       set(handles.DriftValue,'String',num2str(A,'%1.2e'));
        handles.d=A;
     	handles.Ms=estimate_Ms(handles);
    	PlotCorrected(handles);
    else
       set(handles.DriftSlider,'Min',A);    
    end
end

guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of dmin as text
%        str2double(get(hObject,'String')) returns contents of dmin as a double


% --- Executes during object creation, after setting all properties.
function dmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dmax_Callback(hObject, eventdata, handles)
% hObject    handle to dmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.pm>1)
    A=str2double(get(hObject,'String'));

    if(A<str2double(get(handles.dmin,'String')))
        set(handles.DriftSlider,'Min',A-abs(A));
       	set(handles.dmin,'String',num2str(A-abs(A),'%1.2e'));
        set(handles.DriftSlider,'Value',A);
        set(handles.DriftSlider,'Max',A);
    	set(handles.DriftValue,'String',num2str(A,'%1.2e'));
        handles.d=A;
     	handles.Ms=estimate_Ms(handles);
    	PlotCorrected(handles);
	elseif (A>get(handles.DriftSlider,'Value'))
        set(handles.DriftSlider,'Value',A);
        set(handles.DriftSlider,'Max',A);
        set(handles.DriftValue,'String',num2str(A,'%1.2e'));
        handles.d=A;
    	handles.Ms=estimate_Ms(handles);
    	PlotCorrected(handles);
    else
       set(handles.LineSlider,'Max',A);    
    end
end

guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of dmax as text
%        str2double(get(hObject,'String')) returns contents of dmax as a double


% --- Executes during object creation, after setting all properties.
function dmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MsDisp_Callback(hObject, eventdata, handles)
% hObject    handle to MsDisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MsDisp as text
%        str2double(get(hObject,'String')) returns contents of MsDisp as a double


% --- Executes during object creation, after setting all properties.
function MsDisp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MsDisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Msonoff.
function Msonoff_Callback(hObject, eventdata, handles)
% hObject    handle to Msonoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlotCorrected(handles)
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of Msonoff


% --- Executes on button press in scatteronoff.
function scatteronoff_Callback(hObject, eventdata, handles)
% hObject    handle to scatteronoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlotCorrected(handles)
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of scatteronoff


% --- Executes on button press in SnC.
function SnC_Callback(hObject, eventdata, handles)
% hObject    handle to SnC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%delete(handles)
guidata(hObject, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(get(hObject, 'waitstatus'), 'waiting')
% The GUI is still in UIWAIT, us UIRESUME
uiresume(hObject);
else
% The GUI is no longer waiting, just close it
delete(hObject);
end

