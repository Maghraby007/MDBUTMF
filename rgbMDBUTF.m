% tic
image=imread('lenna.png'); %reading the image
nd=0.8;% value of the noise density
img_noise=imnoise(image,'salt & pepper',nd); % adding salt and pepper noise
[r,g,b] = imsplit(img_noise);
[i,j]=size(r); % detecting size of the image
NewCol = zeros(i,2);%setting a 2 columns of zeros
Newrow = zeros(2,i+2);% setting a 2 rows of zeros
%% red plane
red_plane=[r NewCol];% adding a column of zeros to image
red_plane=[red_plane; Newrow];% adding a row of zeros to image
%% green plane
green_plane=[g NewCol];% adding a column of zeros to image
green_plane=[green_plane; Newrow];% adding a row of zeros to image
%% blue plane
blue_plane=[b NewCol];% adding a column of zeros to image
blue_plane=[blue_plane; Newrow];% adding a row of zeros to image
 %% first cycle filtering
for col=1:i
    for row=1:j
        %% red plane filter
         if red_plane(col,row)==255 || red_plane(col,row)==0
            window_counter=0;
            x=[red_plane(col:col+2,row:row+2)];
          for cw=1:3
              for rw=1:3
              if x(cw,rw)==255 || x(cw,rw)==0
               window_counter=window_counter+1;
              end
              end
          end
        end
          if window_counter==9      
        red_plane(col,row)=mean(x,'all');  
          else
              y=[];
            for cw=1:3
              for rw=1:3
              if x(cw,rw)~=255 && x(cw,rw)~=0
               y=[y,x(cw,rw)];
              end
              end
            end
          end
            red_plane(col,row)=median(y);
%% green plane filter
         if green_plane(col,row)==255 || green_plane(col,row)==0
            window_counter=0;
            x=[green_plane(col:col+2,row:row+2)];
          for cw=1:3
              for rw=1:3
              if x(cw,rw)==255 || x(cw,rw)==0
               window_counter=window_counter+1;
              end
              end
          end
        end
          if window_counter==9      
        green_plane(col,row)=mean(x,'all');  
          else
              y=[];
            for cw=1:3
              for rw=1:3
              if x(cw,rw)~=255 && x(cw,rw)~=0
               y=[y,x(cw,rw)];
              end
              end
            end
          end
            green_plane(col,row)=median(y);
       %% blue plane filter
         if blue_plane(col,row)==255 || blue_plane(col,row)==0
            window_counter=0;
            x=[blue_plane(col:col+2,row:row+2)];
          for cw=1:3
              for rw=1:3
              if x(cw,rw)==255 || x(cw,rw)==0
               window_counter=window_counter+1;
              end
              end
          end
        end
          if window_counter==9      
        blue_plane(col,row)=mean(x,'all');  
          else
              y=[];
            for cw=1:3
              for rw=1:3
              if x(cw,rw)~=255 && x(cw,rw)~=0
               y=[y,x(cw,rw)];
              end
              end
            end
            
            blue_plane(col,row)=median(y);
          end
    end
end
%% Removing the added zero columns and rows
 red_plane=[red_plane(1:i,1:j)];
green_plane=[green_plane(1:i,1:j)];
blue_plane=[blue_plane(1:i,1:j)];
rgbimage = cat(3, red_plane,green_plane,blue_plane);
%% PSNR
 RGBMDBUTMF_PSNR = psnr(rgbimage,image);
 %% SSIM
 RGBMDBUTMF_SSIM = ssim(rgbimage,image)*100;
 %% poster 
 %% poster
poster=img_noise;
for r=1:row
    for c=256:col
        poster(r,c)=rgbimage(r,c);
    end 
end
%% plot
subplot(2,2,1) ,imshow(image)
subplot(2,2,2) ,imshow(img_noise)
subplot(2,2,3) ,imshow(rgbimage)
subplot(2,2,4) ,imshow(poster)
%subplot(2,2,4) ,imshow(RGB)
subplot(2,2,1) ,title ('original image')
subplot(2,2,2) ,title ('noisy image at')
% subplot(2,2,3) ,title ('noisy image after denoising')
%subplot(2,2,4) ,title ('second time filtering')
sgtitle('MDBUTMF')
% figure
% montage({red_plane, green_plane, blue_plane})
timeElapsed = toc