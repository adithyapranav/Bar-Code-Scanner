clc;

%Reading the image
imgRead=imread('1.png');
imgRead=rgb2gray(imgRead);
img=im2double(imgRead);
figure, imshow(img);

	%Morphology
se=strel('line', 45, 0);
imgMorph=imtophat(~(img), se);
	%IM2 = imtophat(IM,SE) performs morphological top-hat filtering on the grayscale or binary input image IM using the structuring 	element SE, where SE is returned by strel. SE must be a single structuring element object, not an array containing multiple structuring 	element objects.
	%You can use top-hat filtering to correct uneven illumination when the background is dark. This example uses top-hat filtering with a 	disk-shaped structuring element to remove the uneven background illumination from an image.

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
	 % Constant values of 3 and 1 then the others are placed to represernt a pattern it is nothing but basically the weight of the digits in that 			position of ean13(1) till ean13(13) and for obtaining the correct number system value of 1 or also called as country code which here in 			first example is 1.
	% As the barcode has been divided into parts the first two digits are called number system.
checkDigit = ean13 (2:13).*mult; 
	% we multiply all elements induvidually with the constant array mult to obtain a variable called checkdigit
checkDigit = sum(checkDigit);
	 % and we calculate the sum of the array check digit that we have obtained 

sub = ceil(checkDigit / 10) * 10; 
	% we initialize a new variable sub which contain the ceiling round off value of the checkdigit /10 and then multiple it again back by 10 in 	order to find out what exactly is the value of sum   
	%The ceil function or ceiling function (also commonly called ‘least integer function’) for any real number gives the smallest integer 		which is greater than the number itself. 
	% This is important as in the beginning we saw what happens when we run a bar code with 12 digits insted of 13 we then see that it 
	returns 0 in the first digit then the rest digit stays same.
checkDigit = sub - checkDigit;
	 % now we find the final value of the country code or check digit by subtracting the value of the sub obtained by the value of check digit 		that we possess
	% now we know the exact value of the country code which is outside of the barcode
ean13(1) = checkDigit; 
	% here as we know the exact value we store it in its position which is ean13(1) so basically we put the value of the final check digit back 			into ean13(1)'s position which up until now has been 0.

ean13str = mat2str (ean13);
	%chr = mat2str(X) converts the numeric matrix X into a character vector that represents the matrix, with up to 15 digits of precision.You 			can use chr as input to the eval function.

disp ('Barcode reads: ');
disp (ean13str);
	%and then finally after we have our 13 digits barcode discovered we print it in command prompt along with a message that says Barcode 	reads
	%now we come to the part which is the function call that was referred before when arushi was explaining it has a pretty constant working 	with a lot of predefined condition.
	% we start with the function declaration itself.
function [number, code] = EAN13digits( vector7)
	%function [y1,...,yN] = myfun(x1,...,xM) declares a function named myfun that accepts inputs x1,...,xM and returns outputs y1,...,yN. This 	declaration statement must be the first executable line of the function.
	% so over here we have EAN13digits as the function name and it takes input as vector7 and the output it returns is number and code 
	%A vector is a one-dimensional array of numbers. MATLAB allows creating two types of vectors −
		1>Row vectors
		2>Column vectors
	Row Vectors:-
	Row vectors are created by enclosing the set of elements in square brackets, using space or comma to delimit the elements
	%DIFFERENCE BTW ARRAY AND VECOTOR
		 ArrayList is not synchronized.	Vector is synchronized.
	% Synchronised :- Synchronize timetables to common time vector, and resample or aggregate data from input timetables
	% from here it is a constant condition for the array with 7 values the number can range from 0 to 9 as we can only use multiple single 			digits to represent a barcode
	%(3 is the width of a white bar hence represented by three zeroes). Here, 3 is the width of a white bar, 1 is of black and so on.
	% SO THE THREE BASIC CODES HERE L CODE , G CODE AND R CODE which have their own specfic values for the numbers 		these numbers are represented here and if we see we can observe that although each array in comparision have 7 values which by basic 		knowleadge should have 2^7=128 different probabilities but here we have only 0 till 9 so 10 * 3= 30 this occurs as above aarushi 		explained the c1 and c2 check se we remove multiple barcode representations there to be precise 98 of them then for the rest 30 we 		compare the values using a long if else if control statment then reutrn the number value to the ean13 array
   
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


% FINALLY
%How is this going to be useful 
%After the whole number is decoded, it is compared with the database and when a match is found the corresponding information is displayed in another excel sheet. As more number of barcodes is scanned their information is added to the same sheet and a bill is created (by adding the price of each product)