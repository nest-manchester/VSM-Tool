function g=estimate_g(handles)
field=handles.field;
M=handles.CD-handles.d*handles.time;
sat=get(handles.NSat,'Value');

n=0;
sxy=0;
sx=0;
sy=0;
sx2=0;

for i=1:1:size(field,2)
    if(field(i)<sat)
        n=n+1;
        sxy=sxy+field(i)*M(i);
        sx=sx+field(i);
        sy=sy+M(i);
        sx2=sx2+field(i)*field(i);
    end
end
gn=(n*sxy-sx*sy)/(n*sx2-sx*sx);

n=0;
sxy=0;
sx=0;
sy=0;
sx2=0;

for i=1:1:size(field,2)
    if(field(i)>-sat)
        n=n+1;
        sxy=sxy+field(i)*M(i);
        sx=sx+field(i);
        sy=sy+M(i);
        sx2=sx2+field(i)*field(i);
    end
end
gp=(n*sxy-sx*sy)/(n*sx2-sx*sx);
g=(gn+gp)/2;        