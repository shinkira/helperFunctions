function plotRasterTick(x,y,dy,color)

if size(x,1)~=1 && size(x,2)~=1
    error('x must be a vector')
end
if size(y,1)~=1 && size(y,2)~=1
    error('y must be a vector')
end

if size(x,1)>1
    x = x';
end
if size(y,1)>1
    y = y';
end
if numel(y)==1
    y = y*ones(1,length(x));
end

X = [x;x];
Y = [y-dy;y+dy];

plot(X,Y,'color',color)