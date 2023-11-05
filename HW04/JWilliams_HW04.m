%Joshua Williams
%Machine Learning HW04
%Test code with mnist handwriting data
%Base code uses lawrenceglewis' image input code
close all; clear; clc;

%% read in data

% read in training set of mnist data (28x28 x 60,000)
[imgs, labels] = mnist_parse('train-images.idx3-ubyte', 'train-labels.idx1-ubyte');
%displayMNISTimage(imgs,labels,1);

[num_rows,num_cols,N] = size(imgs);

% unroll each greyscale image so X is 784 x 60,000 (transposed)
X = reshape(double(imgs), [num_rows.*num_cols N])';
t = labels;
t(t==0) = 10; % make class zero class 10 so indexing doesn't get weird

% normalize data
maxval = max(X(:));
X = X/maxval;

% add column of ones to X (call this the design matrix "phi")
phi = [ones(N,1),X];

% extract information from data for training
[N, num_features] = size(phi);
num_classes = max(t);

%% ML stuff
rho = 0.0001;

%cap_t = one_hot_encode(t,10);

for k = 1:10  % train each class
    fprintf('Training class: %d\n', k);
    
    % if it's the value we're training for, put a 1 there, otherwise put a zero
    t_temp = zeros(N,1);
    t_temp(t==k) = 1;

    % fill W vector with random W's [ W1 W2 W3 ... W_num_features]
    W = 0.05*ones(1,num_features);

    % use gradient descent to find actual W's
    old_cost = 1;
    cost = 0;
    iter = 0;
    %abs(old_cost - cost) > 1e-15)
    while (iter < 400)
        %old_cost = cost;
        iter = iter + 1;
        fprintf('\tIteration: %d\n', iter);        
        
        %find gradient
        gradient = sum( (sigmoid(W*phi')' - t_temp).*phi);
        
        %update W using found gradient
        W = W - rho*gradient;
        
    end

    % compute answer using sigmoid function (put in column corresponding to class (k))
    y(:,k) = sigmoid(W*phi');

end

%display results (and calculate error)
num_success = 0;
num_error = 0;
for i=1:N
    
    %at each sample (row), find which class (column) is the highest (Nxk)   
    [~,col] = max(y(i,:));
    %certainty = maxVal.*100;
    guess = mod(col,10);
    
    if guess == labels(i)
        num_success = num_success + 1;
    else
        num_error = num_error + 1;
    end
    
    %display image, and corresponding guess
    %displayMNISTimage(imgs,labels,i,certainty,guess);
    %pause; 
    
end

fprintf('Identified %d images\n',num_success);
fprintf('Missed %d images\n',num_error);
fprintf('Success rate: %% %f\n', (num_success./N).*100);

    
%% functions
% read in mnist data
function [images, labels] = mnist_parse(path_to_digits, path_to_labels)

% Open digits files
fid_digits = fopen(path_to_digits, 'r');

% Open labels files
fid_labels = fopen(path_to_labels, 'r');

% Read in magic number for digits
A = fread(fid_digits, 1, 'uint32');
magicNumber1 = swapbytes(uint32(A)); % Should be 2051
fprintf('Magic Number - Images: %d\n', magicNumber1);

% Read in magic number for labels
A = fread(fid_labels, 1, 'uint32');
magicNumber2 = swapbytes(uint32(A)); % Should be 2049
fprintf('Magic Number - Labels: %d\n', magicNumber2);

% Read in total number of images
A = fread(fid_digits, 1, 'uint32');
totalImages = swapbytes(uint32(A));

A = fread(fid_labels, 1, 'uint32');

% Ensure that this number matches with the labels file
if totalImages ~= swapbytes(uint32(A))
    error('Total number of images read from images and labels files are not the same');
end

fprintf('Total number of images: %d\n', totalImages);

% Read in number of rows
A = fread(fid_digits, 1, 'uint32');
numRows = swapbytes(uint32(A));

% Read in number of columns
A = fread(fid_digits, 1, 'uint32');
numCols = swapbytes(uint32(A));

fprintf('Dimensions of each digit: %d x %d\n', numRows, numCols);

% For each image, store into an individual slice
images = zeros(numRows, numCols, totalImages, 'uint8');
for k = 1 : totalImages
    % Read in numRows*numCols pixels at a time
    A = fread(fid_digits, numRows*numCols, 'uint8');

    % Reshape so that it becomes a matrix
    % We are actually reading this in column major format
    % so we need to transpose this at the end
    images(:,:,k) = reshape(uint8(A), numCols, numRows).';
end

% Read in the labels
labels = fread(fid_labels, totalImages, 'uint8');

% Close the files
fclose(fid_digits);
fclose(fid_labels);

end

% for debug
function displayMNISTimage(imgs,labels,k,certainty,guess)
    imshow(imgs(:,:,k),'InitialMagnification','fit');
    title({
        [num2str(certainty) '% confident it''s a ' num2str(guess)]
        ['Actually: ' num2str(labels(k))]
        });
end

% logistic sigmoid function
function out = sigmoid(x)
     out = 1./(1+exp(-x));
end

function cap_t = one_hot_encode(t, N, num_classes)
    % this function assumes the classes are labeled 1,2,3...N (i.e. class zero is labeled as "10")    
    
    cap_t = zeros(N,num_classes);
    
    for i = 1:N
        cap_t(i,t(i)) = 1;
        
    end
    
end
