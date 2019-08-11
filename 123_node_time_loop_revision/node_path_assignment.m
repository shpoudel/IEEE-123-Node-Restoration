function Aa= node_path_assignment(mg,loop_node1,path1,path2,node)    
     edges=path1;
     fr=edges(:,1);
     t=edges(:,2);
     G = graph(fr,t);
     T1= dfsearch(G,mg,'edgetonew');
     fr=T1(:,1);
     t=T1(:,2);
    v1=dfsearch(G,mg);
    size(v1);
    %A=zeros(size(v1,1)-1,nNodes);
    s=0;
    for i=1:size(fr)
       from=find(fr==v1(i));      
       for k=1:size(from,1)
            val=any(loop_node1==t(from(k)));
            if val==0 || t(from(k))==node
            s=s+1;
            Aa(s,v1(i))=-1; 
            Aa(s,t(from(k)))=1;
            end
       end
    end
    s=s+1;
    new_val=126;
    for m=1:size(loop_node1,2)
            within_loop1=loop_node1;            
                             
                %Find the two different paths to reach load from node
                p1 = shortestpath(G,loop_node1(m),mg);
                within_loop1 = within_loop1(ismember(within_loop1, p1));
                Aa(s,new_val)=-1;
                if size(within_loop1,2)==1
                    Aa(s,p1(1))=0;
                    Aa(s,loop_node1(m))=0;
                    %We dont have path choice for node just entering into
                    %path. That means although it is part of loop bus has
                    %no alternative path as other nodes
                    Aa(s,new_val)=0;
                end
                within_loop1 = within_loop1(within_loop1~=loop_node1(m));
                for k=1:size(within_loop1,2)                     
                    Aa(s,within_loop1(k))=-1/(size(within_loop1,2));
                    Aa(s,loop_node1(m))=1;
                end                
                new_val=new_val+1;
                %Aineq2(insert,:)=A(i,:);
                s=s+1;              
    end
    Aa;
    new_val=126;    
     edges=path2;
     fr=edges(:,1);
     t=edges(:,2);
     G = graph(fr,t);
     T1= dfsearch(G,mg,'edgetonew');
    for m=1:size(loop_node1,2)
            within_loop1=loop_node1;              
                %Find the two different paths to reach load from node
                p1 = shortestpath(G,loop_node1(m),mg);
                within_loop1 = within_loop1(ismember(within_loop1, p1));
                Aa(s,new_val)=1;
                if size(within_loop1,2)==1
                    Aa(s,p1(1))=0;
                    Aa(s,loop_node1(m))=0;
                    %We dont have path choice for node just entering into
                    %path. That means although it is part of loop bus has
                    %no alternative path as other nodes
                    Aa(s,new_val)=0;
                end
                within_loop1 = within_loop1(within_loop1~=loop_node1(m));
                for k=1:size(within_loop1,2)                     
                    Aa(s,within_loop1(k))=-1/(size(within_loop1,2));
                    Aa(s,loop_node1(m))=1;
                end                
                new_val=new_val+1;
                %Aineq2(insert,:)=A(i,:);
                s=s+1;              
    end
    %Remove rows and coloumns with zero data for striking node..
    Aa( ~any(Aa,2), : ) = [];  %rows
    Aa( :, ~any(Aa,1) ) = [];  %columns
end
