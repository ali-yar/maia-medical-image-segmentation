function testDiffusion ()
num_iter = 100;
delta_t = 0.25; % controls speed of diffusion
kappa = 5; % the diffusion constant or flow constant / controls sensitivity to edges.
option = 1; % Diffusion equation 1 favours high contrast edges over low contrast ones.


im1 = rgb2gray(imread('brainweb59.tif'));
% im1 = (dicomread('slice_3D.dcm'));

% blurring
H = fspecial('disk',3);
blurred = imfilter(im1,H,'replicate');

ad = anisodiff(im1,num_iter,kappa,delta_t,option);
figure, subplot 131, imshow(im1), subplot 132, imshow(ad,[]), subplot 133, imshow(blurred,[])



