function [P_final,index1,index2]=final_power(node,loop_node1,G,mg,power)
    T1= dfsearch(G,mg,'edgetonew');
    fr=T1(:,1);
    t=T1(:,2);     
    v1=dfsearch(G,mg);
    size(v1);
    P_final=zeros(1,495);
    insert=1;    
    val=337;  
    index1=[];
    index2=[];
        for k=size(v1):-1:1   
            a=v1(k);
            if size(find(loop_node1==a),2)==0
             P=power(a,2);
             P_final(insert,a+299)=1;
             P_final(insert,a)=-1*P;
             add=find(fr==v1(k));
             for m=1:size(add,1)  
                  P_final(insert,t(add(m))+299)=-1;                  
             end
             insert=insert+1; 
            end
            %IF striking node then sum of two nodes of different hands of
            %the path
            if a==node
                P_final(insert,a+299)=1;
                P_final(insert,299+23)=-1;
                P_final(insert,299+24)=-1;
                insert=insert+1;
            end
                
            if size(find(loop_node1==a),2)~=0&&a~=node                
                P_final(insert,a+299)=1;
                P_final(insert,45+a)=-1;
                P_final(insert,val)=+1;
                index1=[index1 val];
                val=val+1;
                P_final(insert,val)=-1;
                 index2=[index2 val];
                insert=insert+1;
                val=val+1;
            end           
        end
end
       
           
            
            
