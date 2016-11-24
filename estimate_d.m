function d=estimate_d(field,time,M,sat)
n1=0;
n2=0;
M1=0;
M2=0;
for i=1:1:size(time,2)
    if(field(i)<sat)
        if(i<size(time,2)/2)
            n1=n1+1;
            M1=M1+M(i);
        end
        if(i>size(time,2)/2)
            n2=n2+1;
            M2=M2+M(i);
        end     
    end
end

M1=M1/n1;
M2=M2/n2;

d=(M2-M1)/time(end);