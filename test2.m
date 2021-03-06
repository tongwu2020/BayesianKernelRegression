% read in image
img = double(imread('lena.jpg'));

sigma = 100;        % standard deviation
randn('state', 0); % initialization
y = round0_255(img + randn(size(img)) * sigma);

%% 
% for debugging, only run this section. No need to read in the image. The
% values in the first kernel(without padding) has been hard coded
% below as a sample.

% this is typically what an input sample x looks like. 
% the observed intensity t = 21.4030805731549
% so, basically, we are trying to do regression within this kernel
sample = [117.743518847178,115.866290578128,255;...
    0,21.4030805731549,125.154110383554;...
    174.533230647483,125.547036726468,163.252143048791]; 

% vectorize this sample:
input = reshape(sample, [9, 1]);

% normalize the input ??
input = input ./ sum(input);

% declare the initial value of Weights vector. w0, w1, ... w9
w = 0.01;
W = repelem(w,10)';

% declare the initial values of sigma, which are the variance values from
% sig1^2 to sig9^2
sig = 1;
Variance_prior = repelem(sig,9)';

% declare the initial value of sigma0^2, which is 
variance0_prior = 1;

% initialize the unknown variable sigma, which is the unknown noise added
% to this image 
variance_unknown = 0.1;

% declare the step size eta
eta = 0.001;

% declare the brandwidth of the Gaussian kernel
r = 1;

%-------------------------
% start run the regression:
[W_MAP, variance0_MAP, Variance_MAP, variance_unknown] = ...
    getMAP(input, W, variance_unknown, Variance_prior, variance0_prior, r, eta);

disp("W_MAP: ");
disp( W_MAP);

disp("Sigma_MAP: ");
disp(real(sqrt(Variance_MAP)));

disp("s0_MAP: ");
disp(real(sqrt(variance0_MAP)));

disp("sigma_unknown: ");
disp(real(sqrt(variance_unknown)));

%--------------------------
% reconstruct (predict) the image intensity

% transfer the input by the kernel function
phiVec = zeros(1, 9);

input(5)
for index = 1 : 9
    phiVec(1, index) = getKVal(input(5), input(index), r);
end

% compute the mean weights:
meanW = sum(W_MAP) / size(W_MAP, 1);

% predict
y = sum(meanW .* phiVec);



