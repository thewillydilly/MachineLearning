%Joshua Williams
%ECE 5332-002
%HW1 - Use Linear Regression (closed form and Gradient Descent) to solve
%for line of best fit

close all; clear; clc;

load carbig.mat

%calculate the mean of the dataset
horsepower_mean = nanmean(Horsepower);

%and replace NaN's with the mean
Horsepower(isnan(Horsepower)) = horsepower_mean;

horsepower_std_deviation = std(Horsepower);
weight_mean = mean(Weight);
weight_std_deviation = std(Weight);

%% Closed form solution
%X = design matrix (2 columns, n rows)
%t = input horsepower values (matrix N x 1)
%W = ( (X')*(X) )^(-1) * (X') * t;
%solution: y = W(1)*x + W(2)

X = [Weight ones(length(Weight),1)]; %design matrix
t = Horsepower; %vector of "y" values corresponding to the values in X

W = ( (X')*(X) )^(-1) * (X') * t; %Solution (2 x 1 matrix) [W_0  W_1]
x = min(Weight):50:max(Weight);
y = W(1)*x + W(2);

%plot the solution
figure('Renderer', 'painters', 'Position', [100 100 1200 600]);
subplot(1, 2, 1);
hold on;

scatter(Weight, Horsepower,'x', 'r');           %original data
cf = plot(x,y,'LineWidth', 1.5, 'color', 'b');  %best fit solution

legend(cf, {'Closed Form'});
title('Matlab''s "carbig" dataset');
xlabel('Weight');
ylabel('Horsepower');

%clear the answer so it can be solved again using gradient descent
clearvars W y t X x

%% Gradient descent solution

%normalize data
Horsepower(:) = Horsepower(:)./horsepower_mean;
Weight(:) = Weight(:)./weight_mean;

X = [Weight ones(length(Weight),1)];
t = Horsepower;

W = [0.05 0.05];		%guess initial W
rho = 0.0001;			%learning rate

%gradient descent algorithm
for index = 1:10000
	gradient = 2*(W)*((X')*X) - 2*(t')*X;
	W = W - rho*gradient;
end

%undo normalization
Weight(:) = Weight(:).*weight_mean;
Horsepower(:) = Horsepower(:).*horsepower_mean;
W(1) = W(1).*(horsepower_mean)./(weight_mean);  %slope (rise/run)
W(2) = W(2).*horsepower_mean;                   %y-intercept (just rise)

%calculate solution
x = min(Weight):50:max(Weight);
y = W(1).*x + W(2);

%plot the solution
subplot(1,2,2);
hold on;

scatter(Weight, Horsepower, 'x', 'r');          %original data
cd = plot(x,y, 'LineWidth', 1.5,'color', 'g');  %line of best fit (via Gradient Descent)

legend(cd, {'Gradient Descent'});
title('Matlab''s "carbig" dataset');
xlabel('Weight');
ylabel('Horsepower');
