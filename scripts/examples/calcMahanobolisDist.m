function d = calcMahanobolisDist(vertex1,vertex2)
	Y=vertex1;
	ny=size(Y,1);
	X=vertex2;
	[Cx]=cov(X);
	mx=mean(X);
	mx=mx(:)';
	Yc=Y-mx(ones(ny,1),:);
	d=real(sum(Yc/Cx.*conj(Yc),2));
end
