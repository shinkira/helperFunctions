function D = diag3D(W)
    if isempty(W)
        D = double.empty(0,size(W,1));
    end
    [~,~,z_size] = size(W);
    for i = 1:z_size
        D(i,:) = diag(squeeze(W(:,:,i)));
    end
end