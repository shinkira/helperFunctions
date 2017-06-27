function D = diag3D(W)
    [~,~,z_size] = size(W);
    for i = 1:z_size
        D(i,:) = diag(squeeze(W(:,:,i)));
    end
end