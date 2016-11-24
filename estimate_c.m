function c=estimate_c(x,y,sat)
nl=0;
nh=0;
high=0;
low=0;

for i=1:1:size(x,2)
    if(x(i)<sat)
        low=low+y(i);
        nl=nl+1;
    end
   	if(x(i)>-sat)
        high=high+y(i);
        nh=nh+1;
    end
end
c=-((low/nl)+(high/nh))/2;