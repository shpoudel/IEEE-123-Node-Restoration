function loop_node=node_forming_loops(fr,t,mg,nNodes)    
    str_fr=[];
    str_to=[];
    store_fr=fr;
    store_to=t;
    fro=fr;
    to=t;
    for i=1:nNodes
        fr(i)=[];
        t(i)=[];        
        G = graph(fr,t);
        T= bfsearch(G,mg,'edgetonew'); 
        fr=fro;
        t=to;
        if size(T,1)==nNodes-1
            str_fr=[str_fr fr(i)];
            str_to=[str_to t(i)];
        end        
    end 
    loop_node=unique([str_fr str_to]);
end