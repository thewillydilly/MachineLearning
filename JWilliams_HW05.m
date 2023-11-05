%Joshua Williams
%April 26, 2020
%HW5: Feed Forward Neural Network
%
%NOTE: 
%   The following code completes part (a) (minus decision boundary plot).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear; clc;

%% input parameters
rng('default');

train_input = [-1, -1; 1, 1; -1, 1; 1, -1];
train_t = [0; 0; 1; 1];

rho = 0.1;
epochs = 3000;

% network architecture
num_inputs = 2;
num_hidden_units = 2;
num_hidden_layers = 1;
num_outputs = 1;    %need to implement later with two output classes

%% ml stuff
% initialize neural network object
network = neuralnetwork(num_inputs, num_hidden_units, num_outputs);

% train
figure
hold on;
set(gca,'yscale','log');
xlim([0 epochs]);
xlabel('Epochs');
ylabel('Error');

divisor = 2; %for plotting
for i = 1:epochs
    
    network = nn_train(network, train_input, train_t, rho);
    
    % plot loss function at specific epochs
    if( mod(i,floor(divisor)) == 0 )
        tot_error = sum(0.5.*(network.output(:)-train_t(:)).^2);
        plot(i, tot_error, '.r' );

        divisor = divisor.*1.005; %plot points less frequently as time goes on
        pause(0);
    end
    
end

%% output results

network = feedforward(train_input, network);

fprintf('\nNetwork solution to xor problem: \n');
fprintf('epochs: %d\n', epochs);
fprintf(' input\t network output\n');
for i=1:4
    fprintf(' %d\t %d\t\t%f\n', train_input(i,1), train_input(i,2), network.output(i));
end








%% functions

%train the nn using gradient descent
function network = nn_train(network, input, t, rho)
    
    % calculate output value(s) from each unit
    network = feedforward(input, network);
    
    
    % backprop (calculate gradients and adjust every W)
    
    % hidden-to-output layer (L) %
    lowercase_delta_output = network.output-t;
    gradient_out = network.h_out'*lowercase_delta_output;
    
    %update equations
    network.W{2} = network.W{2} - rho.*gradient_out;
    network.bias{2} = network.bias{2} - rho.*lowercase_delta_output;
    
    
    % input-to-hidden layer (L-1) %
    d_sigmoid = network.output.*(1-network.output); %h'(x) = h(x)(1-h(x))
    
    lowercase_delta_hidden = d_sigmoid.*lowercase_delta_output*sum(network.W{2});
    gradient_hidden = network.input'*lowercase_delta_hidden;
    
    %update equations
    network.W{1} = network.W{1} - rho.*gradient_hidden;
    network.bias{1} = network.bias{1} - rho.*lowercase_delta_hidden;
end


%use pre-initialized neural network architecture, generates network output(s)
function network = feedforward(inputs, network)
    
    %column vector (length = num inputs)
    network.input = inputs;

    %column vector (length = num hidden units)
    network.h_out = sigmoid((network.input*network.W{1}) + network.bias{1});   %{1} is input-to-hidden layer
    
    %column vector (length = num outputs)
    network.output = sigmoid((network.h_out*network.W{2}) + network.bias{2});  %{2} is hidden-to-output layer

end

%initialize neural network object
function network_obj = neuralnetwork(num_inputs, num_hidden_units, num_outputs)
    
    % neural network architecture %
    % (currently only creates architecture described in hw05) %
    
    % input
    network_obj.input = [];
    
    % input-to-hidden layer
    network_obj.W{1} = rand(num_inputs, num_hidden_units); %W{1} is weights between input and hidden layer
    network_obj.bias{1} = rand(1,num_hidden_units);
    
    % hidden-to-output layer
    network_obj.W{2} = rand(num_hidden_units, num_outputs); %W{2} is weights between hidden layer and output
    network_obj.bias{2} = rand(1, num_outputs);
    
    network_obj.h_out = [];         %output of hidden layer
    %network_obj.h_out_error = [];   %error associated with output of hidden layer
    
    % output
    network_obj.output = [];        %output of nn
    %network_obj.error_out = [];     %error associated with output of nn
    
end

%activation function
function out = sigmoid(x)
    out = 1./(1+exp(-x));
end