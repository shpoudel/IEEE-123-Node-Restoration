function [Aineq, bineq, mg_insP1, mg_insQ1, mg_insv1,mg_insP2, mg_insQ2, mg_insv2]=microgrid5(Aineq, bineq,mg5,power,loop_node1,yp1,f,path1,path2,nNodes,node)
    %****Real Power Euality Constraints***********
    %For path#1
     edges=path1;
     fr=edges(:,1);
     t=edges(:,2);
     G = graph(fr,t);
     T1= dfsearch(G,mg5,'edgetonew');
     fr=T1(:,1);
     t=T1(:,2);     
     v1=dfsearch(G,mg5);
     size(v1);
    %Calculate cummulative active power of "active" nodes based on DG at mg.
    %Later these values are used to calculate the voltage at the nodes with
    insert=1;      
    [P1eq,P11eq,indp1,indnode]=formeq(mg5,power,insert,G,loop_node1);
    [Q1eq,Q11eq,indq1,indnode]=formeq_reactive(mg5,power,insert,G,loop_node1);
    for i=1:size(loop_node1,2)-1
        sorts(i)=find(indnode(i)==yp1);
    end
    % Indnode finds the order in which the nodes within the loops are
    % visited. For example in this case 23-35-34-33-32-28-27-24
    %Location of yp1 for the nodes within the loop which comes first in 
    %power calculation logic. In our loop, 23 comes first and goes around
    %35-34-33...24
    vec1P=indp1(sorts);
    vec1Q=indq1(sorts);
    %Vec2 is the vector which contains the power calculated value for the
    %nodes within the loop according to path#1 order. For example for node
    %23 the power calculated will be stored in 37+8+23th entry of the
    %matrix for P and 37+8+37+8+23th entry for Q....
    vec2P=indnode+nNodes*29+(size(loop_node1,2)-1)*21;
    vec2Q=indnode+nNodes*30+(size(loop_node1,2)-1)*22;
    %Place where z variables are kept...the first z variable is for 23rd
    %node and last is for 24 node....So the variables start from 37+8+37
    from=nNodes*30+(size(loop_node1,2)-1)*21+1;
    to=nNodes*30+(size(loop_node1,2)-1)*22;
    s=size(f,1);
    step=1;
   [Aineq, bineq]=product_of_variables(Aineq,bineq, vec1P,vec2P,from ,to,s,step);
    %Product of variables for Q
    from=nNodes*31+(size(loop_node1,2)-1)*22+1;
    to=nNodes*31+(size(loop_node1,2)-1)*23;
    step=1;
   [Aineq, bineq]=product_of_variables(Aineq,bineq, vec1Q,vec2Q,from ,to,s,step);
    %Voltage values according to path 1 needs to be calculated as follows,
    Volt1=zeros(125,125);
    Vp1=zeros(125,125);
    Vq1=zeros(125,125);
    n=size((v1),1)-1;
    Volt1(1,mg5)=1;
    for i=2:size(v1)        
        Volt1(i,fr(n))=1;
        Volt1(i,t(n))=-1;
        Vp1(i,t(n))=-0.001/100;
        Vq1(i,t(n))=-0.001/100;
        n=n-1;
    end  
    %Inserting zeros (z1), z2 for path #2 and z3 for final power calculation
    %for the node assignment variable to make the matrix
    %equal to size of f
    z1=zeros(nNodes,(size(loop_node1,2)-1));
    z2=zeros(nNodes,nNodes+size(loop_node1,2)-1);
    z=zeros(nNodes,nNodes);
    zi=zeros(nNodes,560);
    mg_insP1=[P11eq zi z2 z2 z z2 z2 z             z2 z2 z z2 z2 z         z2 z2 z z2 z2 z           z2 z2 z z2 z2 z          P1eq z2 z z2 z2 z];
    mg_insQ1=[Q11eq zi z2 z2 z z2 z2 z            z2 z2 z z2 z2 z         z2 z2 z z2 z2 z            z2 z2 z z2 z2 z           z2 Q1eq z z2 z2 z];
    mg_insv1=[z zi z z1 z z1 z z2 z2 z           z z1 z z1 z z2 z2 z     z z1 z z1 z z2 z2 z       z z1 z z1 z z2 z2 z      Vp1 z1 Vq1 z1 Volt1 z2 z2 z];   
     %% 
     %% 
    %****Power Equality Constraints***********
    %For path#2
     edges=path2;
     fr=edges(:,1);
     t=edges(:,2);
     G = graph(fr,t);
     T1= dfsearch(G,mg5,'edgetonew');
     fr=T1(:,1);
     t=T1(:,2);     
     v1=dfsearch(G,mg5);
     size(v1);
    %Calculate cummulative active power of "active" nodes based on DG at mg.
    %Later these values are used to calculate the voltage at the nodes with
    insert=1;
    [P2eq,P22eq,ind_p1,ind_node]=formeq_path_two(mg5,power,insert,G,loop_node1);
    [Q2eq,Q22eq,ind_q1,ind_node]=formeq_path_two_reactive(mg5,power,insert,G,loop_node1);
    for i=1:size(loop_node1,2)-1
        sorts(i)=find(ind_node(i)==yp1);
    end
    vec1P=ind_p1(sorts);
    vec1Q=ind_q1(sorts);
    %The real power starts from vec2 values....
    vec2P=ind_node+nNodes*32+(size(loop_node1,2)-1)*23;
    from=nNodes*33+23*(size(loop_node1,2)-1)+1;
    to=nNodes*33+(size(loop_node1,2)-1)*24;
    step=1;
    [Aineq, bineq]=product_of_variables(Aineq,bineq, vec1P,vec2P,from ,to,s,step); 
    %For Reactive power basedd on path #2
    vec2Q=ind_node+nNodes*33+(size(loop_node1,2)-1)*24;
    from=nNodes*34+(size(loop_node1,2)-1)*24+1;
    to=nNodes*34+(size(loop_node1,2)-1)*25;
    step=1;
    [Aineq, bineq]=product_of_variables(Aineq,bineq, vec1Q,vec2Q,from ,to,s,step); 
    %Voltage values according to path 1 needs to be calculated as follows,
    Volt2=zeros(125,125);
    Vp2=zeros(125,125);
    Vq2=zeros(125,125);
    n=size((v1),1)-1;
    Volt2(1,mg5)=1;
    for i=2:size(v1)        
        Volt2(i,fr(n))=1;
        Volt2(i,t(n))=-1;
        Vp2(i,t(n))=-0.001/100;
        Vq2(i,t(n))=-0.001/100;
        n=n-1;
    end  
    z1=zeros(nNodes,(size(loop_node1,2)-1));
    z2=zeros(nNodes,nNodes+size(loop_node1,2)-1);
    z=zeros(nNodes,nNodes);    
    zi=zeros(nNodes,560);
    mg_insP2=[P22eq zi z2 z2 z z2 z2 z           z2 z2 z z2 z2 z         z2 z2 z z2 z2 z           z2 z2 z z2 z2 z         z2 z2 z P2eq z2 z];
    mg_insQ2=[Q22eq zi z2 z2 z z2 z2 z           z2 z2 z z2 z2 z         z2 z2 z z2 z2 z           z2 z2 z z2 z2 z         z2 z2 z z2 Q2eq z];
    mg_insv2=[z zi z z1 z z1 z z2 z2 z          z z1 z z1 z z2 z2 z    z z1 z z1 z z2 z2 z       z z1 z z1 z z2 z2 z     z2 z2 z Vp2 z1 Vq2 z1 Volt2]; 
   end
%      % Now we have P1 and P2 for all nodes and the nodes within loop have
%      % two different values. So, we will convert that value into 1 using
%      % P_final=P1(1-y1)+y1*P2.==> P_final-P1+P1y1-y1*P2.
%      edges=path1;
%      fr=edges(:,1);
%      t=edges(:,2);
%      G = graph(fr,t);
%     [P_final,index1,index2]=final_power(node,loop_node1,G,mg1,power);   
%     vec1=[nNodes+1:nNodes+(size(loop_node1,2)-1)];
%     %The real power for first path starts from 46 to 82...
%     vec2=yp1+45;
%     from=index1(1);
%     to=index1(size(loop_node1,2)-1);    
%     step=2;
%     [Aineq, bineq]=product_of_variables(Aineq,bineq, vec1,vec2,from ,to,s,step); 
%     vec1=[nNodes+1:nNodes+(size(loop_node1,2)-1)];
%     %The power for second path starts from 172....
%     vec2=yp1+172;
%     from=index2(1);
%     to=index2(size(loop_node1,2)-1);   
%     step=2;
%     [Aineq, bineq]=product_of_variables(Aineq,bineq, vec1,vec2,from ,to,s,step);  
%     %Qfinal value from Q1 and Q2
%     [Q_final,index1,index2]=final_power_reactive(node,loop_node1,G,mg1,power);   
%     vec1=[nNodes+1:nNodes+(size(loop_node1,2)-1)];
%     %The power for second path starts from 91...
%     vec2=yp1+90;
%     from=index1(1);
%     to=index1(size(loop_node1,2)-1);
%     step=2;
%     [Aineq, bineq]=product_of_variables(Aineq,bineq, vec1,vec2,from ,to,s,step); 
%     vec1=[nNodes+1:nNodes+(size(loop_node1,2)-1)];
%     %The power for second path starts from 218...
%     vec2=yp1+217;
%     from=index2(1);
%     to=index2(size(loop_node1,2)-1);   
%     step=2;
%     [Aineq, bineq]=product_of_variables(Aineq,bineq, vec1,vec2,from ,to,s,step);