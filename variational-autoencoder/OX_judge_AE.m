% OX (Circle or Cross) Judgement Program (Auto Encoder) 
% LSI Design Contest 2025
%
% OX_judge_AE
%
% Requrired : OX_judge_AE.m, Neuralnetwork_AE.m, Neuralnetwork_forward_AE.m
%
% see also OX_judge_AE, Neuralnetwork_AE, Neuralnetwork_forward_AE.

clear;
close all;

rng(2025);          % Set random seed.

MARU = [1 1 1;
        1 0 1;
        1 1 1];     % 〇 Circle (Maru in Japanese)
BATU = [1 0 1;
        0 1 0;
        1 0 1];     % × Cross (Batu in Japanese)

% Teacher data of 〇
TrainData(:,1) = reshape(MARU',9,1);
LabelData(:,1) = TrainData(:,1);   % Correct answer when input is 〇

% Teacher data of ×
TrainData(:,2) = reshape(BATU',9,1);
LabelData(:,2) = TrainData(:,2);   % Correct answer when input is ×

% Create test data
% Maru and Maru + 1bit error
TestData(:,1) = reshape([1 1 1;1 0 1;1 1 1]', 9,1);
TestData(:,2) = reshape([0 1 1;1 0 1;1 1 1]', 9,1);
TestData(:,3) = reshape([1 0 1;1 0 1;1 1 1]', 9,1);
TestData(:,4) = reshape([1 1 0;1 0 1;1 1 1]', 9,1);
TestData(:,5) = reshape([1 1 1;0 0 1;1 1 1]', 9,1);
TestData(:,6) = reshape([1 1 1;1 1 1;1 1 1]', 9,1);
TestData(:,7) = reshape([1 1 1;1 0 0;1 1 1]', 9,1);
% Batsu and Batsu + 1bit error
TestData(:,8) = reshape([1 0 1;0 1 0;1 0 1]', 9,1);
TestData(:,9) = reshape([0 0 1;0 1 0;1 0 1]', 9,1);
TestData(:,10) = reshape([1 1 1;0 1 0;1 0 1]', 9,1);
TestData(:,11) = reshape([1 0 0;0 1 0;1 0 1]', 9,1);
TestData(:,12) = reshape([1 0 1;1 1 0;1 0 1]', 9,1);
TestData(:,13) = reshape([1 0 1;0 0 0;1 0 1]', 9,1);
TestData(:,14) = reshape([1 0 1;0 1 1;1 0 1]', 9,1);

% Parameter setting
Layer1 = 9;                     % Number of input layer units
Layer2 = 2;                     % Number of hidden layer units
Layer3 = Layer1;                % Number of output layer units

L2func = 'ReLUfnc';             % Algorithm of hidden layer ('Sigmoid' or Default: 'ReLUfnc')
L3func = 'Sigmoid_BCE';         % Algorithm of output layer and error ('Sigmoid_MSE' or Default : 'Sigmoid_BCE' (Binary Cross Entropy))
         
%% 中間層と出力層の重みとバイアスの初期値
% Initialization values of weights (Hidden layer and Output layer)
% Initialization values of bias (Hidden layer and Output layer)

w2 = rand(Layer2,Layer1);       % Hidden layer's weight matrix for supervisor data
w3 = rand(Layer3,Layer2);       % Hidden layer's weight matrix for supervisor data

b2 = (-0.5)*ones(Layer2,1);
b3 = (-0.5)*ones(Layer3,1);

% 学習率
% Learning rate
eta = 0.001;	%学習率が高すぎると更新した係数が大きくなりすぎてコストが減らなくなる	
				%If the learning rate is too high, the updated coefficient becomes too large and the cost may not decrease

epoch = 10000;

%% Pre-learning Test
X = TestData;

[z2,a2,z3,a3] = Neuralnetwork_forward_AE(X,w2,w3,b2,b3,L2func,L3func);

fprintf('Initial Weight\n');
fprintf('w2\n');    disp(w2);
fprintf('b2\n');    disp(b2);
fprintf('w3\n');    disp(w3);
fprintf('b3\n');    disp(b3);

fprintf('Initial Weight Test\n');
fprintf('Test data X\n');   disp(X);
fprintf('a2\n');    disp(a2);
fprintf('a3\n');    disp(a3);

% 学習前のテスト入力における中間層の分布のグラフ表示
% Test before learning and graph the distribution of hidden layer.
figure(1);
hold on;
for i=1:7
    plot(a2(1,i), a2(2,i),'or');
end
for i=8:14
    plot(a2(1,i), a2(2,i),'xk');
end
hold off;
xlabel('y_1 = a^2_1'); ylabel('y_2 = a^2_2');
title('Latent Variable (Initial weights and bias)');
box('on');

%% AE Learning
X = TrainData;
t = LabelData;

[w2,w3,b2,b3,w2_t,w3_t,b2_t,b3_t,E] = Neuralnetwork_AE(X,t,w2,w3,b2,b3,eta,epoch,L2func,L3func);

%% Post-learning Test
X = TestData;

[z2,a2,z3,a3] = Neuralnetwork_forward_AE(X,w2,w3,b2,b3,L2func,L3func);

fprintf('Final Weight\n');
fprintf('w2\n');    disp(w2);
fprintf('b2\n');    disp(b2);
fprintf('w3\n');    disp(w3);
fprintf('b3\n');    disp(b3);

fprintf('Final Weight Test\n');
fprintf('Test data X\n');   disp(X);
fprintf('a2\n');    disp(a2);
fprintf('a3\n');    disp(a3);

% 学習後のテスト入力における中間層の分布のグラフ表示
% Test input after the study and display a graph of the distribution of hidden layer.
figure(2);
hold on;
for i=1:7
    plot(a2(1,i), a2(2,i),'or');
end
for i=8:14
    plot(a2(1,i), a2(2,i),'xk');
end
hold off;
xlabel('y_1 = a^2_1'); ylabel('y_2 = a^2_2');
title('Latent Variable (Final weights and bias)');
xlim([0 ceil(max(a2(1,:))/10)*10]);
ylim([0 ceil(max(a2(2,:))/10)*10]);
box('on');

figure(1);
xlim([0 ceil(max(a2(1,:))/10)*10]);
ylim([0 ceil(max(a2(2,:))/10)*10]);

% 学習過程のグラフ表示（各エポックごとのの誤差関数の値）
% Graphically display the learning process (Error function values for each epoch)

figure(3);
plot(E);
xlabel('Epoch'); ylabel('Error');
