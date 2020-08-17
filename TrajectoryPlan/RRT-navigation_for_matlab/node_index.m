function n_index = node_index(T_LIST,xval,yval)
    %This function returns the index of the location of a node in the T_LIST
    i=1;
    while ( T_LIST(i,1) ~= xval || T_LIST(i,2) ~= yval )
        i=i+1;
    end
    n_index=i;
end