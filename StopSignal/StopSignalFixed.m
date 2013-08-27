function Output = StopSignalFixed(InputArray)
    % This Function is for Calculating the result from the data acquired in
    % stop-signal task with fixed method
    SSD1 = InputArray(1,1);
    SSD2 = InputArray(1,2);
    SSD3 = InputArray(1,3);
    CorrectOrNot = InputArray(:,4);
    SSDTime = InputArray(:,5);
    ReactionTime =  InputArray(:,6);
    GoOrStop = InputArray(:,7);
    
    RTGoAcc1 = ReactionTime(GoOrStop == 1 & CorrectOrNot == 1);
    StdGoRT1 = std(RTGoAcc1);
    MeanGoRT1 = mean(RTGoAcc1);
    UpperLineRT = MeanGoRT1 + 2*StdGoRT1;
    LowerLineRT = MeanGoRT1 - 2*StdGoRT1;
    
    RTGoAcc2 = RTGoAcc1(RTGoAcc1 <= UpperLineRT & RTGoAcc1 >= LowerLineRT);
    StdGoRT2 = std(RTGoAcc2);
    MeanGoRT2 = mean(RTGoAcc2);
    
    UncanceledRateSSD1 = 1-mean(CorrectOrNot(SSDTime == SSD1 & (((ReactionTime <= UpperLineRT & ReactionTime >= LowerLineRT)| ReactionTime == 0)))); 
    UncanceledRateSSD2 = 1-mean(CorrectOrNot(SSDTime == SSD2 & (((ReactionTime <= UpperLineRT & ReactionTime >= LowerLineRT)| ReactionTime == 0))));
    UncanceledRateSSD3 = 1-mean(CorrectOrNot(SSDTime == SSD3 & (((ReactionTime <= UpperLineRT & ReactionTime >= LowerLineRT)| ReactionTime == 0))));
    
    if UncanceledRateSSD1 == 0
        UncanceledRTSSD1 = 0;
    else
        UncanceledRTSSD1 = mean(ReactionTime(SSDTime == SSD1 & ReactionTime <= UpperLineRT & ReactionTime >= LowerLineRT));
    end
    if UncanceledRateSSD2 == 0
        UncanceledRTSSD2 = 0;
    else
        UncanceledRTSSD2 = mean(ReactionTime(SSDTime == SSD2 & ReactionTime <= UpperLineRT & ReactionTime >= LowerLineRT));
    end
    if UncanceledRateSSD3 == 0
        UncanceledRTSSD3 = 0;
    else
        UncanceledRTSSD3 = mean(ReactionTime(SSDTime == SSD3 & ReactionTime <= UpperLineRT & ReactionTime >= LowerLineRT));
    end
    
    EstimatedRTSSD1 = norminv(UncanceledRateSSD1, MeanGoRT2, StdGoRT2);
    EstimatedRTSSD2 = norminv(UncanceledRateSSD2, MeanGoRT2, StdGoRT2);
    EstimatedRTSSD3 = norminv(UncanceledRateSSD3, MeanGoRT2, StdGoRT2);
    
    SSRTSSD1 = EstimatedRTSSD1 - SSD1;
    SSRTSSD2 = EstimatedRTSSD2 - SSD2;
    SSRTSSD3 = EstimatedRTSSD3 - SSD3;
    
    if UncanceledRateSSD1 == 0 || UncanceledRateSSD2 == 0 || UncanceledRateSSD3 == 0
        MeanUncanceledRate = sum([UncanceledRateSSD1 UncanceledRateSSD2 UncanceledRateSSD3])/2;
    else
        MeanUncanceledRate = mean([UncanceledRateSSD1 UncanceledRateSSD2 UncanceledRateSSD3]);        
    end
    SSRT = [SSRTSSD1 SSRTSSD2 SSRTSSD3];
    SSRT = mean(SSRT(SSRT < 1000 & SSRT > 0));
    
    SortedRTGoAcc2 = sort(RTGoAcc2);
    IndexLastGoFast = round(length(RTGoAcc2)*MeanUncanceledRate);
    LastGoFastRT = SortedRTGoAcc2(IndexLastGoFast); 
    
    Output = [MeanGoRT2, StdGoRT2, UncanceledRateSSD1, UncanceledRateSSD2, UncanceledRateSSD3, SSRT, LastGoFastRT,...
        UncanceledRTSSD1, UncanceledRTSSD2, UncanceledRTSSD3, EstimatedRTSSD1, EstimatedRTSSD2, EstimatedRTSSD3,...
        SSRTSSD1, SSRTSSD2, SSRTSSD3, LowerLineRT, UpperLineRT];
    
end