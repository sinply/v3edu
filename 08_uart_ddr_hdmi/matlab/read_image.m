clear all;
RGB = imread('p1.jpg');
[ROW,COL,N] = size(RGB);
fid = fopen('grayimage1.txt','w+');
for i = 1:ROW
    for j = 1:COL
    RG=bitand(RGB(i,j,1),248) + bitshift(RGB(i,j,2),-5);%R[7:3]G[7:5]
    GB=bitshift( bitand(RGB(i,j,2),28),3) + bitshift(RGB(i,j,3),-3);%G[4:2]B[7:3]
    fprintf(fid,'%02x %02x ',RG,GB);
    end	
end
fclose(fid);
