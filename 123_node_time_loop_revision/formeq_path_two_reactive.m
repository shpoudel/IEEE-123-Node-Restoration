function [Q2eq,Q22eq,ind_p1,ind_node]=formeq_path_two_reactive(mg,power,insert,G,loop_node1)
    T1= dfsearch(G,mg,'edgetonew');
    fr=T1(:,1);
    t=T1(:,2);     
    v1=dfsearch(G,mg);
    [fr t];
    size(v1);
    path=126;
    ind_p1=[];
    ind_node=[];
    
for k=size(v1):-1:1        
         a=v1(k);
         %Form the Pineq matrix for nodes other than that involved in loop
         %formation because the node within loop will have different one...
         if size(find(loop_node1==a),2)==0
             P1(a)=power(a,3);
             Q2eq(insert,a)=1;
             Q22eq(insert,a)=-1*P1(a);
             add=find(fr==v1(k));
             for m=1:size(add,1)  
                  Q2eq(insert,t(add(m)))=-1;                  
             end
             insert=insert+1;  
         end
          if size(find(loop_node1==a),2)~=0
              a=v1(k);
             P1(a)=power(a,3);
             Q2eq(insert,a)=1;
             Q22eq(insert,a)=-1*P1(a);
             add=find(fr==v1(k));
             for m=1:size(add,1)
                 t(add(m));
                  %Q2eq(insert,t(add(m)))=-1;
                  % If node within the loop then introduce the separation
                  % variable zp1.
                  if size(find(loop_node1==t(add(m))),2)~=0
                       ind_node=[ind_node t(add(m))];
                       ind_p1=[ind_p1 path];
                      Q2eq(insert,path)=-1;
                      path=path+1;
                  end
             end
             insert=insert+1;  
          end
end 
end