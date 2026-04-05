img = imread('image.bmp');
img = imresize(img, [300 400]);

fid = fopen('image.hex', 'w');

for y = 1:300
    for x = 1:400
        r = img(y,x,1);
        g = img(y,x,2);
        b = img(y,x,3);

        r4 = round(double(r) * 15 / 255);
        g4 = round(double(g) * 15 / 255);
        b4 = round(double(b) * 15 / 255);

        pixel = bitshift(r4,8) + bitshift(g4,4) + b4;
        fprintf(fid, '%03x\n', pixel);
    end
end

fclose(fid);