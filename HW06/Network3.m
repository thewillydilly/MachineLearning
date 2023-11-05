%Final Project
%Scott Watkins
%05/02/20
close all
clear all

parpool(2)

%Define Network
data = 'sets/set02v3';
[sza,szb] = size(imread([data,'/0/1.tiff']));
imgds = imageDatastore(data,'LabelSource','foldernames','IncludeSubfolders',true);
labels = countEachLabel(imgds);
frac = .9;
[Train,Validation] = splitEachLabel(imgds,frac,'randomize');
layers = [
    imageInputLayer([sza szb 1])
    
    convolution2dLayer(10,64,'Padding','same','Stride',[3 3])
    batchNormalizationLayer
    reluLayer
    
    averagePooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(5,128,'Padding',0)
    batchNormalizationLayer
    reluLayer
    
    averagePooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(4,256,'Padding',0)
    batchNormalizationLayer
    tanhLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,512,'Padding',0)
    batchNormalizationLayer
    tanhLayer
    
    fullyConnectedLayer(400)
    tanhLayer
    fullyConnectedLayer(300)
    tanhLayer
    fullyConnectedLayer(100)
    tanhLayer
    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm',...
    'ExecutionEnvironment','parallel',...
    'WorkerLoad',2,...
    'Plots','training-progress',...
    'LearnRateSchedule','piecewise',...
    'InitialLearnRate', 0.01,...
    'LearnRateDropFactor',.8,...
    'LearnRateDropPeriod',1,...
    'MiniBatchSize',256,...
    'MaxEpochs',5);

    
trainNetwork(imgds,layers,options)

delete(gcp('nocreate'))
