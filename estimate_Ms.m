function Ms=estimate_Ms(handles)
n=0;
Ms=0;
field=handles.field;
M=handles.CD-handles.g*handles.field+handles.c-handles.d*handles.time;
S=get(handles.NSat,'Value');

for i=1:1:size(field,2)
    if(field(i)<S||field(i)>-S)
        Ms=Ms+abs(M(i));
        n=n+1;
    end
end
Ms=Ms/n;
a=sprintf('Ms = %1.2e emu',Ms);
set(handles.MsDisp,'String',a);