%% Warps im1 to im2 using forward warp
function warp_forward()
    clc;clear;
    
    % number of points to click
    points = 3;
    
    % loads image 1
    im1_original = imread('triangleA.jpg');
    % loads image 2 
    im2_original = imread('triangleB.jpg');
    
    % rescales image 1 to 256x256
    im1(:,:,1) = imresize(im1_original(:,:,1), [256 256]); 
    im1(:,:,2) = imresize(im1_original(:,:,2), [256 256]); 
    im1(:,:,3) = imresize(im1_original(:,:,3), [256 256]); 
    
    % rescales image 2 to 256x256
    im2(:,:,1) = imresize(im2_original(:,:,1), [256 256]); 
    im2(:,:,2) = imresize(im2_original(:,:,2), [256 256]); 
    im2(:,:,3) = imresize(im2_original(:,:,3), [256 256]);
    
    figure;
    imagesc(im1);
    axis equal;
    hold on;
    [x1,y1] = ginput(points);
    
    % Appends points (1,1), (1,256), (256,1), and (256,256) to the clicked
    % points. This is needed for a Delauny triangulation that affects the
    % entire image
    x1 = vertcat(x1, 1, 1, 256, 256);
    y1 = vertcat(y1, 1, 256, 1, 256);
    fprintf('x1: %.5f , y1: %.5f\n',x1(1), y1(1));
    fprintf('x1: %.5f , y1: %.5f\n',x1(2), y1(2));
    fprintf('x1: %.5f , y1: %.5f\n',x1(3), y1(3));
    hold off;
    
    figure;
    imagesc(im2);
    axis equal;
    hold on;
    [x2,y2] = ginput(points);
    x2 = vertcat(x2, 1, 1, 256, 256);
    y2 = vertcat(y2, 1, 256, 1, 256);
    fprintf('x2: %.5f , y2: %.5f\n',x2(1), y2(1));
    fprintf('x2: %.5f , y2: %.5f\n',x2(2), y2(2));
    fprintf('x2: %.5f , y2: %.5f\n',x2(3), y2(3));
    hold off;
    
    close all

    % Computes triangulation at mid point using Delauny 
    x_mean = (x1 + x2) / 2;
    y_mean = (y1 + y2) / 2;
    triangles = delaunay(x_mean, y_mean);
    % triangles store the conectivity of the mesh in a [3 x F] matrix,
    % where F is the number of faces. Each row of triangles defines one
    % face, using the IDs of the vertices that contains
    
    % Show triangulation
    figure;
    imagesc(im1);
    axis equal;
    hold on;
    triplot(triangles, x1, y1);
    title('Source');
    hold off;
    
    figure;
    imagesc(im2);
    axis equal;
    hold on;
    triplot(triangles, x2, y2);
    title('Target');
    hold off;
    
    num_triangles = size(triangles, 1);
    warp_src_to_target = zeros(256, 256, 3, 'uint8');
    affine_transf_src = zeros(3, 3, num_triangles);
    
    % Find affine transformation of each triangle and store it 
    % in affine_transf_src 
    for tri=1:num_triangles
        currentT = triangles(tri, :);
        A = [x1(currentT)  y1(currentT)  ones(3,1)]';
        X = [x2(currentT)  y2(currentT)  ones(3,1)]';
        T = X/A;
        affine_transf_src(:, :, tri) = T; 
    end
    
    % warps all pixels in im1 using the affine transformation of the
    % triangle they belong to
    for y = 1:size(im1,1)
        for x = 1:size(im1,2)

            % computes triangles ID that contains pixel (i, j)
            tn = tsearchn([x1 y1], triangles, [x, y]);
            if isnan(tn)
                continue;
            end
            
            % step 1:
            % compute the warped position (i',j') of the pixel (i,j)
            warpedPos = affine_transf_src(:, :, tn) * [x; y; 1];
            newX = round(warpedPos(1));
            newY = round(warpedPos(2));

            % step 2:
            % populate pixel (i',j') of warp_src_to_target with 
            % pixel (i,j) of the source image
            warp_src_to_target(newY, newX, :) = im1(y, x, :);
        end
    end
    
    figure;
    imagesc(warp_src_to_target);
    title('Source warped to target');
    axis equal;
end
