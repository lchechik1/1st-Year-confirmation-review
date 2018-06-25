load('Final_variances.mat')

Sample_No = [];
Average_Temp = [];
Average_MAD = [];
Average_IQR = [];
Average_Var = [];
Var_Temp = [];
Var_MAD = [];
Var_IQR = [];
Var_Var = [];

% For each shape
for ii = 1:size(results,2)
    Temp = [];
    Mean_Average_Deviation = [];
    IQ_Range = [];
    Variance = [];
    
%     For each layer
    for jj = 1:size(results,1)
%         Collate the values for each shape (combine all layers)
        Temp = [Temp; results{jj,ii}(1)];
        Mean_Average_Deviation = [Mean_Average_Deviation; results{jj,ii}(2)];
        IQ_Range = [IQ_Range; results{jj,ii}(3)];
        Variance = [Variance; results{jj,ii}(4)];
    end
    
%     Calculate variances etc on each shape
    Sample_No = [Sample_No; ii];
    Average_Temp = [Average_Temp; mean(Temp)];
    Average_MAD = [Average_MAD; mean(Mean_Average_Deviation)];
    Average_IQR = [Average_IQR; mean(IQ_Range)];
    Average_Var = [Average_Var; mean(Variance)];
    
    Var_Temp = [Var_Temp; var(Temp)];
    Var_MAD = [Var_MAD; var(Mean_Average_Deviation)];
    Var_IQR = [Var_IQR; var(IQ_Range)];
    Var_Var = [Var_Var; var(Variance)];
        
end
T=table(Sample_No,Average_Temp,Average_MAD,Average_IQR,Average_Var,Var_Temp,Var_MAD,Var_IQR,Var_Var)