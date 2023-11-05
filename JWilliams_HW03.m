%Joshua Williams
%2/29/2020
%ECE 5332
%HW03: Regularization with Linear Regression and Gaussian basis functions

close all; clear; clc;

%% generate dataset
N = 25;

%training
rng(0)
X = rand(N,1);  %uniform distribution U(0,1)
design_matrix = design_rbf_matrix(X,X,N);

%test
x_test = 1/1000:1/1000:1;
epsilon_test = normrnd(0,0.3,[1 1000]);
t_test(:) = sin(2.*pi.*x_test(:)) + epsilon_test(:);

%regularization parameter
lambda = logspace(-1,1,20);

%arrays to have final plots
final_bias = zeros(1,length(lambda));
final_variance = zeros(1,length(lambda));
final_error = zeros(1,length(lambda));

%repeat for 20 different values of lambda
for k=1:length(lambda)
    %console progress output
    fprintf( [num2str(100.*k./length(lambda)),'%%\n']);
    fprintf(['ln(lambda) = ', num2str(log(lambda(k))),'\n\n']);
    
    %% fit model to training data (100 times)
    f_total = zeros(100,25);   %storing all model outputs (25 samples per output, 100 times)
    w_total = 0;               %for sampling 1000 samples from f_avg for test error
    
    for L=1:100     
        
        %Generate training dataset
        rng('shuffle');
        epsilon = normrnd(0,0.3,[1 N]);
        t(:) = sin(2.*pi.*X(:)) + epsilon(:);
        
        % compute analytical solution
        w = (design_matrix'*design_matrix + lambda(k)*eye(N+1))\design_matrix'*t';
        y = design_matrix*w;
        
        %store solution in matrix of all 100 solutions (25 samples each)
        f_total(L,:) = y';
        
        %sum w's to calculate w_avg. (for finding test error with 1000 samples later)
        w_total = w_total + w;
        
        clearvars t
    end
    
    %% calculate plot info
    
    %bias   (uses f_avg with 25 samples)
    bias = 0;
    f_avg = mean(f_total);  %average f(x) (25 samples)
    for i=1:N
        bias = bias + (f_avg(i) - sin(2*pi.*X(i))).^2;
    end
    bias = bias/N;

    
    %variance   (uses all 100 models [25 samples each])
    variance = 0;
    for i=1:N   %which X-value
        total_variance = 0;
        for j=1:100 %sum differences at same X-value over every model
            total_variance = total_variance + (f_total(j,i) - f_avg(i)).^2;
        end
        variance = variance + total_variance./100;  %average squared differences, sum for all 25 samples
    end
    variance = variance./N; %average for 25 samples

    
    %test error (sample f_avg (using w_avg) 1000 times [test data unused in training])
    w_avg = w_total/100;  
    y = design_rbf_matrix(x_test,X,N)*w_avg;    %x_test is 1000 samples
    
    J_test = 0;
    for i=1:1000
        J_test = J_test + (y(i)-t_test(i)).^2;
    end
    error = J_test/1000;
    
    %store all parameters in final array and repeat with increased \lambda
    final_bias(k) = bias;
    final_variance(k) = variance;
    final_error(k) = error;

    clearvars f_total f_avg 
end

%% create plot
clf
ylim([0 0.15]);
xlim([-3 2]);
xlabel('ln(\lambda)');
legend('Location','northwest');
hold on;

semilogx(log(lambda),final_bias, 'DisplayName','(bias)^2','LineWidth',3);
semilogx(log(lambda),final_variance, 'DisplayName','variance','LineWidth',3);
semilogx(log(lambda),final_bias + final_variance, 'DisplayName', '(bias)^2 + variance','LineWidth',3);
semilogx(log(lambda),final_error, 'DisplayName', 'test error','LineWidth',3);







%% functions

%Gaussian dist.
function phi_out = phi(x,mu)
    s = 0.1;
    phi_out = exp(-(x-mu).^2 / (2.*(s.^2)) );
end

%create matrix of Gaussian rbf's.
%N = num datapoints in Xi = num columns in output matrix
%length(X) = num rows in output matrix
function [design_matrix_out] = design_rbf_matrix(X,Xi,N)

    design_matrix_out = ones(length(X),1);
    for i=1:N
        design_matrix_out(:,i+1) = phi(X,Xi(i));
    end

end