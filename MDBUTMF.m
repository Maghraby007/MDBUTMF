%% image import
image=imread('Lenna.png'); %reading the image
image=rgb2gray(image);
MDBUTMF_PSNR=[];
MDBUTMF_SSIM=[];
[row,col]=size(image); % detecting size of the image
NewCol = zeros(row,6);%setting a 2 columns of zeros
Newrow = zeros(6,row+6);% setting a 2 rows of zeros
 nd=0.3;
%for nd= 0.1:0.1:1
img_noise=imnoise(image,'salt & pepper',nd); % adding salt and pepper noise
filtered_image=[img_noise NewCol];% adding a column of zeros to image
filtered_image=[filtered_image; Newrow];% adding a row of zeros to image
 %% first cycle filtering
for r=1:row
    for c=1:col  
        window_counter=0;   
        if img_noise(r,c)==255 || img_noise(r,c)==0
          window=filtered_image(r:r+2,c:c+2);
          subwindow=filtered_image(r:r+2,c:c+2);
          for rw=1:3
              for cw=1:3
              if window(rw,cw)==255 || window(rw,cw)==0
               window_counter=window_counter+1;
              end
              end
          end
        end
          if window_counter==9      
        filtered_image(r,c)=mean(window,'all'); 
          else
              y=[];
            for rw=1:3
              for cw=1:3
              if subwindow(rw,cw)~=0 && subwindow(rw,cw)~=255
               y=[y,subwindow(rw,cw)];
              end
              end
            end
            filtered_image(r,c)=median(y);
        end
    end
end

%% Removing the added zero columns and rows and calculating PSNR & SSIM
 filtered_image=[filtered_image(1:row,1:col)];
 MDBUTMF_PSNR = [MDBUTMF_PSNR,psnr(filtered_image,image)];%PSNR
 MDBUTMF_SSIM = [MDBUTMF_SSIM,ssim(filtered_image,image)*100]; %SSIM
% %% poster
% poster=img_noise;
% for r=1:row
%     for c=256:col
%         poster(r,c)=filtered_image(r,c);
%     end 
% end
 %% plot
figure
subplot(2,2,1) ,imshow(image)
subplot(2,2,2) ,imshow(img_noise)
subplot(2,2,3) ,imshow(filtered_image)
subplot(2,2,4) ,imshow(poster)
subplot(2,2,1) ,title ('original image')
subplot(2,2,2) ,title ('noisy image')
subplot(2,2,3) ,title ('noisy image after denoising')
sgtitle('MDBUTMF')
% end
% keep SMFSSIM SMFPSNR ADBMFSSIM ADBMFPSNR DBMFSSIM DBMFPSNR MDBUTMF_PSNR MDBUTMF_SSIM
