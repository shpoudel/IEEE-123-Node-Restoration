     function [Aineq, bineq]=line_unavailability(Aineq,bineq,node1,node2,f,nNodes)

     br1=zeros(1,size(f,1)); br2=zeros(1,size(f,1)); br3=zeros(1,size(f,1));
     br4=zeros(1,size(f,1)); br5=zeros(1,size(f,1));
     br1(1,node1)=1; br1(1,node2)=1; br2(1,node1+nNodes+12)=1; br2(1,node2+nNodes+12)=1;
     br3(1,node1+nNodes*2+12*2)=1; br3(1,node2+nNodes*2+12*2)=1; br4(1,node1+nNodes*3+12*3)=1;
     br4(1,node2+nNodes*3+12*3)=1; br5(1,node1+nNodes*4+12*4)=1; br5(1,node2+nNodes*4+12*4)=1;
     size(Aineq);
     Aineq=[Aineq;br1]; Aineq=[Aineq;br2]; Aineq=[Aineq;br3];
     Aineq=[Aineq;br4]; Aineq=[Aineq;br5];
     size(Aineq);
     size(bineq);
     bineq=[bineq;1;1;1;1;1];
     end