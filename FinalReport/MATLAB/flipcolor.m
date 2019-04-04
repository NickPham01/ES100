%% Flip the black and white, leave the other colors
clear; clc;
filename = '../FinalImages/SystemBlock_inv.png'
im = imread(filename);

black   = uint8([0 0 0]);
white   = uint8([255 255 255]);
gray    = uint8([128 128 128]);
green   = uint8([0 255 0]);
red     = uint8([255 0 0]);

%{
for i = 1:size(im, 1)
    for j = 1:size(im, 2)
        if all([im(i,j,1) im(i,j,2) im(i,j,3)] ~= green) && all([im(i,j,1) im(i,j,2) im(i,j,3)] ~= red)
            if all([im(i,j,1) im(i,j,2) im(i,j,3)] < gray)
               im(i,j,1) = white(1);
               im(i,j,2) = white(2);
               im(i,j,3) = white(3);
            else
               im(i,j,1) = black(1);
               im(i,j,2) = black(2);
               im(i,j,3) = black(3);
            end
        end
    end
    i
end
%}

lowlim = 100
hilim = 150


for i = 1:size(im, 1)
    for j = 1:size(im, 2)
        if im(i,j,1) > hilim && im(i,j,2) > hilim && im(i,j,3) > hilim
            im(i,j,1) = 255;
            im(i,j,2) = 255;
            im(i,j,3) = 255;
        elseif im(i,j,1) < lowlim && im(i,j,2) < lowlim && im(i,j,3) < lowlim
            im(i,j,1) = 0;
            im(i,j,2) = 0;
            im(i,j,3) = 0;
        elseif im(i,j,1) < lowlim && im(i,j,2) > hilim && im(i,j,3) > hilim
            im(i,j,1) = 255;
            im(i,j,2) = 0;
            im(i,j,3) = 0;
        elseif im(i,j,1) > hilim && im(i,j,2) < lowlim && im(i,j,3) > hilim
            im(i,j,1) = 0;
            im(i,j,2) = 255;
            im(i,j,3) = 0;
        else
            im(i,j,1) = 255;
            im(i,j,2) = 255;
            im(i,j,3) = 255;
        end
    end
    i
end


imshow(im)