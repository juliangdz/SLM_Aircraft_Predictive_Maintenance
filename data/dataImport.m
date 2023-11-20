function [trainingData, testData]=dataImport(dirName, isPlot, EID)
% Input:
%       dirName - directory containing data files
%       isPlot - flag for plotting the data example: plot if isPlot = 1,
%       for isPlot = 0 plotting is suppressed
%       EID - selected engine ID for plotting results
% Outputs:
%       trainingData - structure containing sensor measurements with
%       respect to operation cycles for each engine and classification
%       labels
%       testData - structure containing a single sensor measurement at
%       the randomly selected operation cycle for each type of the engine


cd(dirName)
if nargin<3
    EID =1;
end

%% Training Dataset

Train = csvread('train_selected.csv', 1,0); % Importing Training Dataset

ID = Train(:,1); % Engine ID Number
Cycle = Train(:,2); % Time sequences

% Sensor Measurements
S1 = Train(:,3);
S2 = Train(:,4);
S3 = Train(:,5);
S4 = Train(:,6);

ttf = Train(:,7);  % Remaining cycles before failure (Time-to-failure)
Label_bnc = Train(:,8); % Binary Classification Label


trainingData=struct('Cycles',[],'S1',[],'S2',[],'S3',[],'S4',[],'TTF',[],'ClassificationLabel',[]);
for k=1:max(ID) % going thorough all engine IDs
    EIDinds=find(ID==k);
    trainingData(k).Cycles=Cycle(EIDinds);
    trainingData(k).S1=S1(EIDinds);
    trainingData(k).S2=S2(EIDinds);
    trainingData(k).S3=S3(EIDinds);
    trainingData(k).S4=S4(EIDinds);
    trainingData(k).TTF=ttf(EIDinds);
    trainingData(k).ClassificationLabel=Label_bnc(EIDinds);
end

% remove unneeded variables
clear Train ID Cycle S1 S2 S3 S4 ttf Label_bnc EIDinds k

%% Testing Dataset

Test = csvread('test_selected.csv', 1,0); % Full Testing Dataset

ID = Test(:,1); % Engine ID Number
Cycle = Test(:,2); % Time sequences


% Sensor Measurements
S1 = Test(:,3);
S2 = Test(:,4);
S3 = Test(:,5);
S4 = Test(:,6);


testData=struct('Cycles',[],'S1',[],'S2',[],'S3',[],'S4',[]);
for k=1:max(ID) % going thorough all engine IDs
    EIDinds=find(ID==k);
    testData(k).Cycles=Cycle(EIDinds);
    testData(k).S1=S1(EIDinds);
    testData(k).S2=S2(EIDinds);
    testData(k).S3=S3(EIDinds);
    testData(k).S4=S4(EIDinds);
end

% remove unneeded variables
clear Train ID Cycle S1 S2 S3 S4 ttf Label_bnc EIDinds k

if isPlot
    
    %% Data visualization
    % This example can be used for visualizing data and also as a template for
    % extracting necessary variables from the data structure
    
%     EID = 10; % engine ID to visualize
    
    % plotting training and test data for each sensor with indication of
    % cycles were engine is considered as faulty
    figure('name',['Sensor data for engine ' num2str(EID)]),
    xArg = trainingData(EID).Cycles;
    bncInds = logical(trainingData(EID).ClassificationLabel);
    
    % sensor 1
    subplot(4,1,1),
    plot(xArg(~bncInds), trainingData(EID).S1(~bncInds),...
        xArg(bncInds), trainingData(EID).S1(bncInds), 'r',...
        testData(EID).Cycles, testData(EID).S1, 'm+')
    legend('S1 good data','S1 faulty engine','Test','Location','best')
    ylabel('Units')
    
    % sensor 2
    subplot(4,1,2),
    plot(xArg(~bncInds), trainingData(EID).S2(~bncInds),...
        xArg(bncInds), trainingData(EID).S2(bncInds), 'r',...
        testData(EID).Cycles, testData(EID).S2, 'm+')
    legend('S2 good data','S2 faulty engine','Test','Location','best')
    ylabel('Units')
    
    % sensor 3
    subplot(4,1,3),
    plot(xArg(~bncInds), trainingData(EID).S3(~bncInds),...
        xArg(bncInds), trainingData(EID).S3(bncInds), 'r',...
        testData(EID).Cycles, testData(EID).S3, 'm+')
    legend('S3 good data','S3 faulty engine','Test','Location','best')
    ylabel('Units')
    
    % sensor 4
    subplot(4,1,4),
    plot(xArg(~bncInds), trainingData(EID).S4(~bncInds),...
        xArg(bncInds), trainingData(EID).S4(bncInds), 'r',...
        testData(EID).Cycles, testData(EID).S4, 'm+')
    legend('S4 good data','S4 faulty engine','Test','Location','best')
    ylabel('Units')
    xlabel('Time in engine cycles')
    
end

