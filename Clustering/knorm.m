function K = knorm(K)
% knorm - normalize a kernel matrix
%
% Synopsis:
%    K = knorm(K);
%
% Arguments:
%    K:         kernel matrix (n x n)
%
% Returns:
%    K:         normalized kernel matrix
%
% Description:
%    kn(x,y) = k(x,y) / sqrt(k(x,x) k(y,y))
%
% $Id: knorm.m,v 1.1 2005/05/30 12:07:21 neuro_cvs Exp $
%
% Copyright (C) 2005 Fraunhofer FIRST
% Author: Konrad Rieck (rieck@first.fhg.de)
%  Modified by Marius Kloft

if size(K,3)>1
    for i=1:size(K,3)
        diag_value = diag(K(:,:,i));
        diag_value(diag_value == 0) = 1;
        diag_value = sqrt(diag_value * diag_value');
        K(:,:,i) = K(:,:,i) ./ diag_value;
    end
else
    K = K ./ sqrt(diag(K) * diag(K)');
end