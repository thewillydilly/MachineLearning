%Joshua Williams
%2/7/2020
%ECE 5332-002: Machine Learning
%HW02
%
%Description: 
%   Program generates a set of training and test data,
%   then uses the training data to generate a model (of polynomial degree "M")
%   using the closed form solution (with regularizatoin using "\lambda").
%
%   Then,it determines the training and test error, and plots how that error
%   varies with "M".
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear; clc;

%start with ten datapoints for training, then repeat with N_train = 100
N_train = 10;

while(N_train <= 100) %repeats once (N_train = 10 then N_train = 100)
%constants throughout learning process
N_test = 100;
lambda = 0.001;
seed = 0;
rng(seed);

%% Generate training set
X_train = rand(1,N_train);	%randomly sampled x-values from U(0,1)

epsilon = normrnd(0,0.3,[1 N_train]);				%"noise" to be added N(mu = 0, sigma = 0.3).
t_train(:) = sin(2.*pi.*X_train(:)) + epsilon(:);	%y-values corresponding to X_train samples. (aka sine function with "noise")

%% Generate test set
X_test = rand(1,N_test);	%more randomly sampled x-values (for testing after model is made)

normal_dist_test = normrnd(0,0.3,[1 100]);	%N(0,0.3) again, but for more samples
t_test(:) = sin(2.*pi.*X_test(:)) + normal_dist_test(:);

%% analytical solution to find line of best fit (with training set)

%figure (debug)


for M=0:9 %degree of polynomial

    %map basis function matrix
	for N=1:length(X_train)             %N=rows (10 datapoints)
        for k=1:(M+1)                   %k=columns (M+1 columns)
            phi(N,k) = X_train(N).^(k-1);
        end
	end

    %compute closed-form analytical solution
	W = (phi'*phi + lambda*eye(M+1))\phi'*t_train';
	
    W = flip(W); %evaluating polynomial requires highest order coefficient first
    
    %% plot solution (debug)
    
%     clf
%     
%     %scatter plot of training data
%     subplot(2,1,1);
%     scatter(X_train,t_train);	%(debug)
%     hold on;
%     
%     %line of best fit against training data
%     x=0:0.001:1;
%     y = polyval(W,x);
%     plot(x,y);
%     ylim([-1 1]);
%     title(['Model Plotted Against Training Data (N_{train} = ', num2str(N_train), ', M = ', num2str(M), ')']);
%     
%     %scatter plot of test data
%     subplot(2,1,2);
%     scatter(X_test,t_test);	%(debug)
%     hold on;
%     
%     %line of best fit against test data
%     plot(x,y);
%     ylim([-1 1]);
%     title(['Model Plotted Against Test Data (N_{train} = ', num2str(N_train), ', M = ', num2str(M), ')']);
    
    %% Calculate Error (training + test error)
    
    %sum the square of each error (for this order polynomial) into "J_train"
    J_train = 0;
    for i=1:N_train       
       % = (best fit line evaluated at "X_train") - (actual datapoint located at "X_train")      
       J_train = J_train + (polyval(W,X_train(i))-t_train(i)).^2;        
    end
    E_rms_train(M+1) = sqrt(J_train/N_train);
    
    
    J_test = 0;
    for i=1:N_test
         J_test = J_test + (polyval(W,X_test(i)) - t_test(i)).^2;         
    end
    E_rms_test(M+1) = sqrt(J_test/N_test);
end

%% Plot error vs M
x = 0:1:9;
figure
hold on;
legend
plot(x, E_rms_train, 'DisplayName', 'Training');
plot(x, E_rms_test, 'DisplayName', 'Test');
ylim([0 1]);
title(['Error (N_{train} = ', num2str(N_train), ', \lambda = ', num2str(lambda), ')']);
xlabel('M');
ylabel('E_{rms}');

clearvars -except N_train;
N_train = N_train + 90;
end
