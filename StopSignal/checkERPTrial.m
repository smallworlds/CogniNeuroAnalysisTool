function Output = checkERPTrial(InputData, TypeNum)
    Output = [];    
    [NumRows, Numcolms] = size(InputData);
    AccumulatedData = zeros(NumRows, 1);
    for i = 1:Numcolms-1
        AccumulatedData = AccumulatedData + InputData(:, i+1);
        if sum(AccumulatedData >= 2)
            error('The ERP Trial Data cannot be romoved two times');
        end
        for j = 1:TypeNum
            NoTrials = AccumulatedData(InputData(:, 1) == j,1);
            NumTrials = length(NoTrials);            
            Output = [Output NumTrials-sum(NoTrials)]; 
        end
    end
end