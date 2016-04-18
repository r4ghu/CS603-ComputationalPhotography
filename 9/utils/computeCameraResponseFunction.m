function lin_fun = computeCameraResponseFunction(stack,exposure,nSamples)
    max_stack = max(stack(:));
    if max_stack>1,
        stack = stack/max_stack;
    end
    W = computeWeightFunction(0:(1/255):1);
    
    % LDR Stack histogram
    [~, ~, col, n] = size(stack);

    stack_hist = zeros(256, col, n);
    for i=1:n
        for j=1:col
            tmp = round(stack(:,:,j,i) * 255);
            tmp(tmp>255) = 255;
            tmp(tmp<0) = 0;
            tmp = uint8(tmp);
            stack_hist(:,j,i) = imhist(tmp);
        end
    end
    
    stack_samples = GrossbergSamplingAlgo(stack_hist, nSamples);
    
    %recovering the CRF
    lin_fun = zeros(256, col);
    log_exposure = log(exposure);

    max_lin_fun = zeros(col, 1);

    for i=1:col
        g = gsolve(stack_samples(:,:,i), log_exposure, 20, W);
        g = exp(g);

        lin_fun(:,i) = g;
        max_lin_fun(i) = max(g);

        lin_fun(:,i) = lin_fun(:,i) / max_lin_fun(i);
    end
    
end

function weight = computeWeightFunction(img)
    indx1 = find (img <= 0.5);
    indx2 = find (img > 0.5);
    weight = zeros(size(img));
    weight(indx1) = img(indx1);
    weight(indx2) = 1 - img(indx2);
    weight(weight < 0) = 0;
    weight = weight / max(weight(:));
end


function g = gsolve(Z,B,l,w)

% Author: Paul Debevec and Jitendra Malik's code

n = 256;
A = zeros(size(Z, 1) * size(Z, 2) + n + 1, n + size(Z, 1));
b = zeros(size(A, 1), 1);

%the data-fitting term
k = 1;
for i=1:size(Z,1)
    for j=1:size(Z,2)
        wij = w(Z(i,j)+1);
        A(k,Z(i,j)+1) =  wij; 
        A(k,n+i)      = -wij;
        b(k,1)        =  wij * B(j);
        k = k+1;
    end
end

% Fix the curve by setting its middle value to 0
A(k,129) = 1;
k = k + 1;

%the smoothness term
for i=1:n-2
    A(k,i)  =    l*w(i+1);
    A(k,i+1)= -2*l*w(i+1);
    A(k,i+2)=    l*w(i+1);
    k = k+1;
end

%Solve the system using SVD
x = A\b;
g = x(1:n);

end

function stackOut = GrossbergSamplingAlgo(stack, nSamples)
% Author: Paul Debevec and Jitendra Malik's code

[~, col, stackSize] = size(stack);


for i=1:stackSize
    for j=1:col
        h_cdf = cumsum(stack(:,j,i));
        stack(:,j,i) = h_cdf / max(h_cdf(:));
    end
    
    
end

stackOut = zeros(nSamples, stackSize, col);

u = 0:(1.0 / (nSamples - 1)):1;

for i=1:nSamples
    for j=1:col
        for k=1:stackSize
           [~, val] = min(abs(stack(:,j,k) - u(i)));
           stackOut(i,k,j) = val - 1;
        end
    end
end

end