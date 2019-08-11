function [node,path1,path2]=striking_node(loop_node1, mg,G1,edges)
    v1=dfsearch(G1,mg);
    fr=edges(:,1);
    t=edges(:,2);  
    decide_path=[];
    for k=1:size(v1)
        log=ismember(v1(k),loop_node1);
        if log==1
            node=v1(k);
            decide_path1=find(fr==v1(k));
            for m=1:size(decide_path1)
                if  size(find(loop_node1==t(decide_path1(m))),2)==0
                    decide_path1(m)=0;
                end
            end            
            decide_path2=find(t==v1(k));
            for m=1:size(decide_path2)
                if  size(find(loop_node1==fr(decide_path2(m))),2)==0
                    decide_path2(m)=0;
                end
            end
            [decide_path]=[decide_path1 ;decide_path2];
            %Remove branch node of striking node which is not involved in
            %loop formation.
              decide_path = decide_path(decide_path~=0);
              path1=edges;
              path1(decide_path(1),:)=[];
              path2=edges;
              path2(decide_path(2),:)=[];      
            break            
        end       
    end
        