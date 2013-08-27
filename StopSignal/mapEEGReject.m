function OutputSet = mapEEGReject(EEG, Dataset, VarNames)
    Amount = length(Dataset);
    RejMatrix = zeros(Amount, 1);
    for i = 1:length(EEG.event)
        RejMatrix(EEG.event(i).trial) = EEG.reject.rejmanual(i);
    end    
    OutputSet = [Dataset dataset(RejMatrix, 'VarNames', {VarNames})];
end