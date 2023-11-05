%Final Project
%Scott Watkins
%05/02/20

close all
clear all

%% Define Network
data = 'sets/set01v2';
[sza,szb] = size(imread([data,'/0/1.tiff']));

imgds = imageDatastore(data,'LabelSource','foldernames','IncludeSubfolders',true);
labels = countEachLabel(imgds);

frac = .9;
[Train,Validation] = splitEachLabel(imgds,frac,'randomize');

layers = [
    imageInputLayer([sza szb 1])
    
    convolution2dLayer(10,48,'Padding','same','Stride',[3 3])
    batchNormalizationLayer
    reluLayer
    
    averagePooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(5,96,'Padding',0)
    batchNormalizationLayer
    reluLayer
    
    averagePooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(4,192,'Padding',0)
    batchNormalizationLayer
    tanhLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,384,'Padding',0)
    batchNormalizationLayer
    tanhLayer
    
    fullyConnectedLayer(100)
    tanhLayer
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm',...
    'Plots','training-progress',...
    'InitialLearnRate', 0.01,...
    'LearnRateDropFactor',.1,...
    'LearnRateDropPeriod',1,...
    'MiniBatchSize',256,...
    'MaxEpochs',10,...
    'ExecutionEnvironment','gpu');

%% train

trainNetwork(imgds,layers,options)
