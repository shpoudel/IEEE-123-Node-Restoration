function [Q_final,index1,index2]=final_power_reactive(node,loop_node1,G,mg,power)
    T1= dfsearch(G,mg,'edgetonew');
    fr=T1(:,1);
    t=T1(:,2);     
    v1=dfsearch(G,mg);
    size(v1);
    Q_final=zeros(1,495);
    insert=1;    
    val=390;  
    index1=[];
    index2=[];
        for k=size(v1):-1:1   
            a=v1(k);
            if size(find(loop_node1==a),2)==0
             P=power(a,3);
             Q_final(insert,a+352)=1;
             Q_final(insert,a)=-1*P;
             add=find(fr==v1(k));
             for m=1:size(add,1)  
                  Q_final(insert,t(add(m))+352)=-1;                  
             end
             insert=insert+1; 
            end
            %IF striking node then sum of two nodes of different hands of
            %the path
            if a==node
                Q_final(insert,a+352)=1;
                Q_final(insert,352+23)=-1;
                Q_final(insert,352+24)=-1;
                insert=insert+1;
            end
                
            if size(find(loop_node1==a),2)~=0&&a~=node                
                Q_final(insert,a+352)=1;
                Q_final(insert,90+a)=-1;
                Q_final(insert,val)=+1;
                index1=[index1 val];
                val=val+1;
                Q_final(insert,val)=-1;
                 index2=[index2 val];
                insert=insert+1;
                val=val+1;
            end           
        end
end
       
           
            
            
