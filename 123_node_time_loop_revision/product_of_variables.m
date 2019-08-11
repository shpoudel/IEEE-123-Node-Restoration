
function[Aineq, bineq]=product_of_variables(Aineq,bineq, vec1,vec2,from ,to,s,step)
% For zp1>=0;
    zp1=zeros(1,s);
    p=1;
    for i=from:step:to
        zp1(p,i)=-1;
        p=p+1;
    end
    Aineq=[Aineq;zp1];
    bineq=[bineq; zeros(12,1)];
    % For zp1<=M*yp1;
    zp1=zeros(1,s);
    p=1;
    %vec=[40 41 42 43 44 45 46 39];
    for i=from:step:to
        zp1(p,i)=1;
        zp1(p,vec1(p))=-1000;
        p=p+1;
    end
    Aineq=[Aineq;zp1];
    bineq=[bineq; zeros(12,1)];
    % For zp1<=Power;
    zp1=zeros(1,s);
    p=1;
    %vec=[70 73 74 78 79 80 81 69];
    for i=from:step:to
        zp1(p,i)=1;        
        zp1(p,vec2(p))=-1;
        p=p+1;
    end
    zp1;
    Aineq=[Aineq;zp1];
    bineq=[bineq; zeros(12,1)];
    
    zp1=zeros(1,s);
    p=1;
%     vec1=[70 73 74 78 79 80 81 69];
%     vec2=[40 41 42 43 44 45 46 39];
    for i=from:step:to
        zp1(p,i)=-1;        
        zp1(p,vec2(p))=1;
        zp1(p,vec1(p))=1000;
        p=p+1;
    end
    Aineq=[Aineq;zp1];
    bineq=[bineq; 1000*ones(12,1)];   
end