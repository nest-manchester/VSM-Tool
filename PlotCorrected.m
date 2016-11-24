function []=PlotCorrected(handles)

if(handles.pm>1)
    pdata=handles.CD-handles.g*handles.field+handles.c-handles.d*handles.time;
    if(get(handles.scatteronoff,'Value')==0)
        a=plot(handles.field,pdata,'-','color','b');
    elseif(get(handles.scatteronoff,'Value')==1)
        a=scatter(handles.field,pdata,'MarkerEdgeColor','b');
    end
    hold on;
    line([get(handles.NSat,'Value') get(handles.NSat,'Value')],[-100 100])
    if(get(handles.Msonoff,'Value')==1)
        line([min(handles.field) max(handles.field)], [-handles.Ms -handles.Ms],'color','red')
        line([min(handles.field) max(handles.field)], [handles.Ms handles.Ms],'color','red')
    end
    axis ([min(handles.field) max(handles.field) 1.2*min(pdata) 1.2*max(pdata)]);
    uistack(a,'top');
    grid on;
    hold off;
end