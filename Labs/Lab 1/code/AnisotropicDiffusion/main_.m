%clean
 clc; clear all; close all;

% initialization of parameters
% option 1 and 2 performs anisotropic diffusion
% option 3 performs isotropic diffusion


num_iter =100;
delta_t = 0.25;
kappa = 10;
option = 1;
% the selected kappa should be based on the range of gradient values
% option 1 is selected because the brain images are well contrasted


% path to the NIfTI files and braindata
pathNIFTI = '../Nifti';
pathDATA =  '../braindata';

addpath(genpath(pathNIFTI));
addpath(genpath(pathDATA));


%loads the image
Im1 = load_nii('t1_icbm_normal_1mm_pn5_rf20_bc.nii');
t1 = Im1.img; 

H1 = 'Slice No';
H2 = 'MSE';
        
%   saving the output of the ssd in txt file
FileDir = fopen('.\results\evaluation_opt1_pn5_rf20_after_biascorr.txt','w');
fprintf(FileDir, [ H1 '     ' H2 '\n---------------------------\n']);

% x = t1(:,:,100);
% %   blurring
% H = fspecial('disk',3);
% blurred = imfilter(x,H,'replicate');
% 
% 
% figure ;
% subplot 121;
% imshow(double(x'),[]);
% title("Original image");
% subplot 122;
% imshow(blurred',[]);
% title("Blurred image");
% 
% figure;
 
 
% option = 2;
% num_iter = [50 100];
% delta_t = 0.25;
% kappa = [10 20 50 100];

plotId = 1;

% for iter = 1:numel(num_iter)
%     for k = 1: numel(kappa) 
        for i = 1:size(t1,3)
        %   skips empty images
            tmp = t1(:,:,i);
            if (sum(tmp(:)) ~= 0)
                x = double(t1(:,:,i));

            %   anisotropic diffusion/isotropic diffusion
                ad = anisodiff(x,num_iter,kappa,delta_t,option);

            %   save 2D slices from the 3D volume in a folder
                s = mat2gray(x');
                outputFileName = fullfile('.\results\original', ['Slice_' num2str(i) '.png']);
                imwrite(s, outputFileName);

            %   save noise suppressed images in a folder  
                 ss = mat2gray(ad');
                outputFileName2 = fullfile('.\results\anisotropic', ['ad_corrected_' num2str(i) '.png']);
                imwrite(ss, outputFileName2);

            %   quantitative evaluation
                e(i) = immse(ss,s);
                
                fprintf(FileDir,'%d  \t  %f\n',i, e(i));

%                 subplot(2, 4, plotId); plotId = plotId + 1;
%                 imshow(ad',[]); title(sprintf("i=%d, k=%d, e=%f", num_iter(iter), kappa(k), e(i)));
            end
        end
%     end
% end

fclose(FileDir);