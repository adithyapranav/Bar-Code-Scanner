clc;

%Reading the image
imgRead=imread('ean-13.png');
imgRead=rgb2gray(imgRead);
img=im2double(imgRead);
figure, imshow(img);

%Morphology
se=strel('line', 45, 0);
imgMorph=imtophat(~(img), se);

%Rescale the Image
[x,y]=size(imgMorph);
midx=round(x/2);

i=1; yinit=i+1;
while(imgMorph(midx, i)==0)
     i=i+1;
     yinit=i;
end

i=y; yend = i-1;
while(imgMorph(midx, i)==0)
      i=i-1;
      yend=i;
end

imgRescaled=imgMorph(midx:midx, yinit:yend);

imgRescaled=imresize(imgRescaled, [1 10*95]);

imgBits=zeros(95);
for i=1:95
    imgBits(1,i)=imgRescaled(1, 10*(i-1)+5);
end

imgRescaled=imgBits(1,:);

%  BarCode Decodification

%check c1
digit=1;
C1=imgRescaled(digit:digit+2);
digit=digit + 3;
if(C1~=[1 0 1])
     disp('Error on C1');
end

ean13 = [0 0 0 0 0 0 0 0 0 0 0 0 0];

ean13 (2) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (3) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (4) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (5) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (6) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (7) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;

%check c2
C2 = imgRescaled (digit:digit+4);
digit = digit + 5;
if(C2 ~= [0 1 0 1 0])
    disp('Error on C2');   
end

ean13 (8) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (9) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (10) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (11) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (12) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;
ean13 (13) = EAN13digits(imgRescaled(digit: digit+6));
digit = digit + 7;

% Check Digit   
mult = [3 1 3 1 3 1 3 1 3 1 3 1];

disp("eanvalue");
disp(ean13);

checkDigit = ean13 (2:13).*mult;
disp("cde");
disp(checkDigit);

checkDigit = sum(checkDigit);

sub = ceil(checkDigit / 10) * 10;
checkDigit = sub - checkDigit;

ean13(1) = checkDigit;

ean13str = mat2str (ean13);

disp ('Barcode reads: ');
disp (ean13str);


function [number, code] = EAN13digits( vector7)
   
    if isequal(vector7, [0 0 0 1 1 0 1])
        number = 0; code = 1; return;
    elseif isequal(vector7, [0 1 0 0 1 1 1])
        number = 0; code = 2; return;
    elseif isequal(vector7, [1 1 1 0 0 1 0])
        number = 0; code = 3; return;
    
    elseif isequal(vector7, [0 0 1 1 0 0 1])
        number = 1; code = 1; return;
    elseif isequal(vector7, [0 1 1 0 0 1 1])
        number = 1; code = 2; return;
    elseif isequal(vector7, [1 1 0 0 1 1 0])
        number = 1; code = 3; return;        
    
    elseif isequal(vector7, [0 0 1 0 0 1 1])
        number = 2; code = 1; return;
    elseif isequal(vector7, [0 0 1 1 0 1 1])
        number = 2; code = 2; return;
    elseif isequal(vector7, [1 1 0 1 1 0 0])
        number = 2; code = 3; return;
    
    elseif isequal(vector7, [0 1 1 1 1 0 1])
        number= 3;  code = 1; return;
    elseif isequal(vector7, [0 1 0 0 0 0 1])
        number = 3; code = 2; return;
    elseif isequal(vector7, [1 0 0 0 0 1 0])
        number = 3; code = 3; return;
    
    elseif isequal(vector7, [0 1 0 0 0 1 1])
        number = 4;  code = 1; return;
    elseif isequal(vector7, [0 0 1 1 1 0 1])
        number = 4; code = 2; return;
    elseif isequal(vector7, [1 0 1 1 1 0 0])
        number = 4; code = 3; return;    
    
    elseif isequal(vector7, [0 1 1 0 0 0 1])
        number = 5;  code = 1; return;
    elseif isequal(vector7, [0 1 1 1 0 0 1])
        number = 5; code = 2; return;
    elseif isequal(vector7, [1 0 0 1 1 1 0])
        number = 5; code = 3; return;    
    
    elseif isequal(vector7, [0 1 0 1 1 1 1])
        number = 6;  code = 1; return;
    elseif isequal(vector7, [0 0 0 0 1 0 1])
        number = 6; code = 2; return;
    elseif isequal(vector7, [1 0 1 0 0 0 0])
        number = 6; code = 3; return;   
    
    elseif isequal(vector7, [0 1 1 1 0 1 1])
        number = 7;  code = 1; return;
    elseif isequal(vector7, [0 0 1 0 0 0 1])
        number = 7; code = 2; return;
    elseif isequal(vector7, [1 0 0 0 1 0 0])
        number = 7; code = 3; return;    
    
    elseif isequal(vector7, [0 1 1 0 1 1 1])
        number = 8;  code = 1; return;
    elseif isequal(vector7, [0 0 0 1 0 0 1])
        number = 8; code = 2; return;
    elseif isequal(vector7, [1 0 0 1 0 0 0])
        number = 8; code = 3; return;   
    
    elseif isequal(vector7, [0 0 0 1 0 1 1])
        number = 9;  code = 1; return;
    elseif isequal(vector7, [0 0 1 0 1 1 1])
        number = 9; code = 2; return;
    elseif isequal(vector7, [1 1 1 0 1 0 0])
        number = 9; code = 3; return;
    
    else number = -2;  code = 0; return;    
    
    end
    
end
