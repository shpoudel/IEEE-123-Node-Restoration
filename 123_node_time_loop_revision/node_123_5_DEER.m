function cplexmilp
%%  
tic
    try
    clear all;
    clc;  
    f = ones(125, 1); 
    nNodes=125;
    load 'branch.txt';    
    load 'powerdata.txt'
    power=powerdata;
    edges=branch;
    size(edges);
    fr=edges(:,1);
    t=edges(:,2);    
    G= graph(fr,t);
    T = minspantree(G);
    plot(G);
    mg1=4; mg2=26; mg3=44; mg4=86; mg5=60;
    CL=[9 17 87 79 101 66 27 30 37 94 46]';
    for m=1:125
        if m~=CL
                power(m,2)=0;
                power(m,3)=0;      
        end
    end  
    power(9,2)=52.4290;
    power(17,2)=19.5881;
    power(87,2)=26.7542;
    power(79,2)=14.5636;
    power(101,2)=33.7123;
    power(66,2)=20.3529;
    power(27,2)=44.6561;
    power(30,2)=40.7885;
    power(37,2)=12.1409;
    power(94,2)=20.0843;
    power(46,2)=28.5569;
    s=0;
    for k=1:11
        s=s+power(CL(k),2);
    end
    %% 
    %%     
    %Finding the set of nodes that are involved in forming a loop. In this/
    %we have choosen a loop which contains 13 nodes within it. Finding the
    %node forming loops is independent of MG location so, we can have only
    %one variable for it
    loop_node=node_forming_loops(fr,t,mg1,nNodes); 
    %Now we have to find the path #1 and path #2 based which node is being
    %striked as moving from DERs to that loop. 
    [node1,path11,path12]=striking_node(loop_node, mg1,G,edges);
    [node2,path21,path22]=striking_node(loop_node, mg2,G,edges);
    [node3,path31,path32]=striking_node(loop_node, mg3,G,edges);
    [node4,path41,path42]=striking_node(loop_node, mg4,G,edges);
    [node5,path51,path52]=striking_node(loop_node, mg5,G,edges);
    %%
    %%
    %Finding the index for path assignment variable (yp1,1-yp1) for nodes
    %within the loop other than striking node because the striking node has
    %no alternative path.
    yp1 = loop_node(loop_node~=node1);
    yp2 = loop_node(loop_node~=node2);
    yp3 = loop_node(loop_node~=node3);
    yp4 = loop_node(loop_node~=node4);
    yp5 = loop_node(loop_node~=node5);
    %inserting new variables for path assignment
    f_loop=zeros(size(yp1,2),1);  
    %Inserting new variables for power calculations
    %f is 125 node assignment and remaining goes as below:
    % *****Node Path Node Path Node Path Node Path Node Path
    %******125  12   125  12   125  12   125  12   125  12
    av1=0.95; av2=0.95; av3=0.92; av4=.90; av5=.95;
%   av1=0.95; av2=0.95; av3=0.95; av4=.95; av5=.95;

   
    alpha=1;beta=0;
    %f1 = (alpha*(ones(125*1, 1)/25))
    f1 = (ones(125*1, 1))*(1-av1);
    f2 = (ones(125*1, 1))*(1-av2);
    f3 = (ones(125*1, 1))*(1-av3);
    f4 = (ones(125*1, 1))*(1-av4);
    f5 = (ones(125*1, 1))*(1-av5);
   
    f=[f1;f_loop;f2;f_loop;f3;f_loop;f4;f_loop;f5;f_loop];
    
    %Now start including the power (real and reactive and voltage
    %variables) P1, y1, Q1, y1, V1 and   P2, y1, Q2, y1, V2 and for all
    %DERs
    f1=zeros(125,1);
    %***************************%DER#1*****************************
    %Inclusion of path#1,            %Inclusion of path#2
    f=[f;f1;f_loop;f1;f_loop;f1];    f=[f;f1;f_loop;f1;f_loop;f1];
    
    %***************************%DER#2*****************************
    %Inclusion of path#1,            %Inclusion of path#2
    f=[f;f1;f_loop;f1;f_loop;f1];    f=[f;f1;f_loop;f1;f_loop;f1];
    
    %***************************%DER#3*****************************
    %Inclusion of path#1,            %Inclusion of path#2
    f=[f;f1;f_loop;f1;f_loop;f1];    f=[f;f1;f_loop;f1;f_loop;f1];
    
    %***************************%DER#4*****************************
    %Inclusion of path#1,            %Inclusion of path#2
    f=[f;f1;f_loop;f1;f_loop;f1];    f=[f;f1;f_loop;f1;f_loop;f1];
    
    %***************************%DER#5*****************************
    %Inclusion of path#1,            %Inclusion of path#2
    f=[f;f1;f_loop;f1;f_loop;f1];    f=[f;f1;f_loop;f1;f_loop;f1];
    f=[f;zeros(5,1)];
    f=[f;-100*ones(11,1)];
    % Adding the status variable for CL not always being served.
    %f=[f;-1*ones(size(CL,2),1)];
    %% 
    %%             
    %****INEQUALITY MATRICES***********
    %V_k-Vj<=yp1...for path #1 
    %V_k-V_j<=1-yp1...for path #2
    [Aineq1]=node_path_assignment(mg1,loop_node,path11,path12,node1);
    bineq1=[zeros(nNodes-1,1);ones(size(loop_node,2)-1,1)];
    [Aineq2]=node_path_assignment(mg2,loop_node,path21,path22,node2);
    bineq2=[zeros(nNodes-1,1);ones(size(loop_node,2)-1,1)];
    [Aineq3]=node_path_assignment(mg3,loop_node,path31,path32,node3);
    bineq_add=[zeros(nNodes-1,1);ones(size(loop_node,2)-1,1)];
    [Aineq4]=node_path_assignment(mg4,loop_node,path41,path42,node4);
    bineq4=[zeros(nNodes-1,1);ones(size(loop_node,2)-1,1)];
    [Aineq5]=node_path_assignment(mg5,loop_node,path51,path52,node5);
    bineq5=[zeros(nNodes-1,1);ones(size(loop_node,2)-1,1)];
    z=zeros(size(Aineq1));
    [Aineq1]=[Aineq1 z z z z];
    [Aineq2]=[z Aineq2 z z z];
    [Aineq3]=[z z Aineq3 z z];
    [Aineq4]=[z z z Aineq4 z];
    [Aineq5]=[z z z z Aineq5];  
    %%
    %%
    %Combining all the inequality matrices..
    [Aineq]=[Aineq1;Aineq2;Aineq3;Aineq4;Aineq5];
    bineq=[bineq1;bineq2;bineq_add;bineq4;bineq5];    
    %Inequality constraints for a node belonging to only one MG
    A6=zeros(125,685);
    bineq_add=ones(125,1);
    for i=1:125
         %if i~=mg1&&i~=mg2&&i~=mg3&&i~=mg4&&i~=mg5&&i~=17&&i~=9&&i~=30&&i~=66&&i~=101&&i~=83&&i~=79&&i~=27&&i~=37&&i~=55&&i~=46
          A6(i,i)=1;
          A6(i,i+137)=1;
          A6(i,i+137*2)=1;
          A6(i,i+137*3)=1;
          A6(i,i+137*4)=1;
        %end
    end
    [Aineq]=[Aineq;A6];
    bineq=[bineq ;bineq_add];
    z=zeros(size(Aineq,1),size(f,1)-size(Aineq,2));
    Aineq=[Aineq z];
    %Calculating power and Aineq bineq will be updated as required for the
    %product of variables
    [Aineq, bineq, mg_insP11, mg_insQ11, mg_insv11,mg_insP12, mg_insQ12, mg_insv12]=microgrid1(Aineq, bineq,mg1,power,loop_node,yp1,f,path11,path12,nNodes,node1);
    [Aineq, bineq, mg_insP21, mg_insQ21, mg_insv21,mg_insP22, mg_insQ22, mg_insv22]=microgrid2(Aineq, bineq,mg2,power,loop_node,yp2,f,path21,path22,nNodes,node2);
    [Aineq, bineq, mg_insP31, mg_insQ31, mg_insv31,mg_insP32, mg_insQ32, mg_insv32]=microgrid3(Aineq, bineq,mg3,power,loop_node,yp3,f,path31,path32,nNodes,node3);
    [Aineq, bineq, mg_insP41, mg_insQ41, mg_insv41,mg_insP42, mg_insQ42, mg_insv42]=microgrid4(Aineq, bineq,mg4,power,loop_node,yp4,f,path41,path42,nNodes,node4);
    [Aineq, bineq, mg_insP51, mg_insQ51, mg_insv51,mg_insP52, mg_insQ52, mg_insv52]=microgrid5(Aineq, bineq,mg5,power,loop_node,yp5,f,path51,path52,nNodes,node5);
    %[Aineq, bineq, mg_insP1, mg_insQ1, mg_insv1, mg_insP2, mg_insQ2, mg_insv2, P_final, Q_final,]=microgrid1(Aineq, bineq,mg1,power,loop_node,yp1,f,path11,path12,nNodes,node1);
    %%
    %%
    Aeq=zeros(16,size(f,1));
    %CL=[9 17 87 79 101 66 27 30 37 94]';
    k=4681;
    for i=1:size(CL)
        Aeq(i,CL(i))=1;
        Aeq(i,CL(i)+137)=1;
        Aeq(i,CL(i)+137*2)=1;
        Aeq(i,CL(i)+137*3)=1;
        Aeq(i,CL(i)+137*4)=1;
        Aeq(i,k)=-1;
        k=k+1;
    end
    % We are maximizing the supply to critical load. This means their
    % status defined by last 11 variables (11 CLs) should be maximized    
    % Node where DG is installed is always one.
    Aeq(12,mg1)=1; 
    Aeq(13,mg2+137)=1;
    Aeq(14,mg3+137*2)=1;
    Aeq(15,mg4+137*3)=1;
    Aeq(16,mg5+137*4)=1;    
    beq=[zeros(11,1);ones(5,1)]; 
    z=zeros(125,16);
    
    Aeq=[Aeq;mg_insP11 z;mg_insQ11 z;mg_insv11 z;mg_insP12 z;mg_insQ12 z;mg_insv12 z];
    badd=[zeros(nNodes*2,1); 1; zeros(124,1);zeros(nNodes*2,1); 1; zeros(124,1)];
    beq=[beq;badd];
    
    Aeq=[Aeq;mg_insP21 z;mg_insQ21 z;mg_insv21 z;mg_insP22 z;mg_insQ22 z;mg_insv22 z];
    badd=[zeros(nNodes*2,1); 1; zeros(124,1);zeros(nNodes*2,1); 1; zeros(124,1)];
    beq=[beq;badd];
    
    Aeq=[Aeq;mg_insP31 z;mg_insQ31 z;mg_insv31 z;mg_insP32 z;mg_insQ32 z;mg_insv32 z];
    badd=[zeros(nNodes*2,1); 1; zeros(124,1);zeros(nNodes*2,1); 1; zeros(124,1)];
    beq=[beq;badd];
    
    Aeq=[Aeq;mg_insP41 z;mg_insQ41 z;mg_insv41 z;mg_insP42 z;mg_insQ42 z;mg_insv42 z];
    badd=[zeros(nNodes*2,1); 1; zeros(124,1);zeros(nNodes*2,1); 1; zeros(124,1)];
    beq=[beq;badd];
    
    Aeq=[Aeq;mg_insP51 z;mg_insQ51 z;mg_insv51 z;mg_insP52 z;mg_insQ52 z;mg_insv52 z];
    badd=[zeros(nNodes*2,1); 1; zeros(124,1);zeros(nNodes*2,1); 1; zeros(124,1)];
    beq=[beq;badd];
    
    %Adding of branch constraints means a branch may be fail during a
    %disaster and can't serve load during the optimization process through
    %it. For example we consider line 18-13 is loss during an event. This
    %means 18 and 13 cannot belong to same MG. 
     node1=18;node2=13;
     [Aineq, bineq]=line_unavailability(Aineq,bineq,node1,node2,f,nNodes);
         % Line 25-26 not available so DER 26 will never supply CL 30.
     node1=54;node2=57;
     [Aineq, bineq]=line_unavailability(Aineq,bineq,node1,node2,f,nNodes);
     

     node1=26;node2=27;
     [Aineq, bineq]=line_unavailability(Aineq,bineq,node1,node2,f,nNodes);
%       node1=76;node2=86;
%      [Aineq, bineq]=line_unavailability(Aineq,bineq,node1,node2,f,nNodes);
      node1=67;node2=97;
     [Aineq, bineq]=line_unavailability(Aineq,bineq,node1,node2,f,nNodes);
%          node1=54;node2=53;
%      [Aineq, bineq]=line_unavailability(Aineq,bineq,node1,node2,f,nNodes);
         node1=91;node2=93;
     [Aineq, bineq]=line_unavailability(Aineq,bineq,node1,node2,f,nNodes);
     
     
%      Finding the total power for each DER based on node-DER assignment
%      variable.
     Aeq1=[power(:,2)' zeros(1,4550) -1 0 0 0 0 zeros(1,11)];
     Aeq2=[zeros(1,137) power(:,2)' zeros(1,4413) 0 -1 0 0 0 zeros(1,11)];
     Aeq3=[zeros(1,137) zeros(1,137) power(:,2)' zeros(1,4276) 0 0 -1 0 0 zeros(1,11)];
     Aeq4=[zeros(1,137) zeros(1,137) zeros(1,137) power(:,2)' zeros(1,4139) 0 0 0 -1 0 zeros(1,11)];
     Aeq5=[zeros(1,137) zeros(1,137) zeros(1,137) zeros(1,137) power(:,2)' zeros(1,4002) 0 0 0 0 -1 zeros(1,11)];
     Aeq=[Aeq;Aeq1;Aeq2;Aeq3;Aeq4;Aeq5];
     beq=[beq;0;0;0;0;0];
     Ek=[780.65 539.78 919.12 550.23 895.29];
    s2=0;
    for k=1:5
        s2=s2+Ek(k);
    end
    Ap1=zeros(1,size(f,1));Ap2=zeros(1,size(f,1)); Ap3=zeros(1,size(f,1));
    Ap4=zeros(1,size(f,1));Ap5=zeros(1,size(f,1));
    Ap1(1,4676)=-1/Ek(1);
    Ap2(1,4677)=-1/Ek(2);
    Ap3(1,4678)=-1/Ek(3);
    Ap4(1,4679)=-1/Ek(4);
    Ap5(1,4680)=-1/Ek(5);
%   Aineq=[Aineq; Ap1; Ap2; Ap3; Ap4; Ap5];    
%   bineq=[bineq; -1/15; -1/15; -1/15; -1/15; -1/15]; 
    %bineq=[bineq; -1/45; -1/45; -1/45; -1/45; -1/45]; 
     
    %%
    %%
    %Creating lower and upper bound for different variables
    lb=zeros(685,1);
    ub=ones(685,1);
    lb=[lb; -.5*ones(size(f,1)-685,1)];
    ub=[ub; 1000*ones(size(f,1)-685,1)];
  
    %% 
    %%         
    options = cplexoptimset;
    options.Display = 'on';
    
    for i=1:685
        ctype(i)='I';
    end
    for i=686:size(f,1)
        ctype(i)='C';
    end
           
    [x,fval] = cplexmilp(f,Aineq,bineq,Aeq,beq,[],[],[],lb,ub,ctype);
    fprintf ('Number of nodes active in MG = %f\n', fval);
    disp ('Index =');
    disp (x');
    active=find(x);
    size(active);
    
    mg1=[];
    mg2=[];
    mg3=[];
    mg4=[];
    mg5=[];
    for i=1:size(active)
        if active(i)<=125
            mg1=[mg1 active(i)];
        end
        if active(i)>137 && active(i)<=262
            active(i)=active(i)-137;
           mg2=[mg2 active(i)];
        end
         if active(i)>274&&active(i)<=399
             active(i)=active(i)-274;
            mg3=[mg3 active(i)];
         end
        if active(i)>411 && active(i)<=536
            active(i)=active(i)-411;
           mg4=[mg4 active(i)];
        end
         if active(i)>548&&active(i)<=673
             active(i)=active(i)-548;
            mg5=[mg5 active(i)];
        end
    end
    mg1
    mg2
    mg3
    mg4
    mg5
    s2/s
     
    %%
    catch m
    disp(m.message);   
    end  
    toc
end