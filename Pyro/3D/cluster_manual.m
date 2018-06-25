startpos = [-16350.2503938028, -18479.3304230140; -15579.1554361694, -13529.5984390180; -18656.8545137927, -18482.4209575072; -13982.5640720647, -16090.5825406591; -18654.9892602187, -14768.2210556438; -12657.9839950127, -18265.2538947732; -13300.0000000000, -17200.0000000000; -17108.6663712332, -20954.2679117076; -19420.2661566847, -17241.4282987201; -14809.9550129027, -14769.8630120553; -20335.4137114236, -18479.0894659954; -17890.6117910693, -15998.4124414543; -15956.8302733440, -16012.6096178212; -15198.7479172009, -17237.3218678012; -16732.9434596802, -14768.1364216240; -14429.2761963527, -18475.0931166872; -17493.2296646727, -13535.1581623331; -17126.3468230717, -17042.9797298099; -17884.3439845558, -19706.5458452565; -19416.2583989783, -13531.4843071554];

MyFolderInfo = dir('*.pcd'); 
MyFolderInfo = MyFolderInfo(~cellfun('isempty', {MyFolderInfo.date}));
MyFolderI=struct2table(MyFolderInfo)
A = MyFolderI{1:height(MyFolderI),{'name'}};
B=A.';
formatSpec = '%6f%7f%4f%f%[^\n\r]';

 for i=1:length(A)
    i
    fileID=fopen(A{i}, 'r');
    %% Read columns of data according to the format.
    % This call is based on the structure of the file used to generate this
    % code. If an error occurs for a different file, try regenerating the code
    % from the Import Tool.
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
    %% Close the text file.
    fclose(fileID);

    %% Create output variable
    test = table(dataArray{1:end-1}, 'VariableNames', {'VarName1','VarName2','VarName3','VarName4'});

    coords=test(:,1:2);
    coords=table2array(coords);

    temps=table2array(test(:,3));

    clusters=kmeans(coords,[],'Start',startpos);
    
    
    %% Calculate variances for each shape in this layer
    for j = 1:size(startpos,1)
        shape = temps(find(clusters==j));
        results{i,j} = get_variance(shape);
    end

 end
 
figure()
scatter3(coords(:,1),coords(:,2),clusters,5,clusters);hold on;
view(0,90);
for ii = 1:size(startpos,1)
    text(startpos(ii,1),startpos(ii,2),size(startpos,1)+1,num2str(ii)); hold on;
end

save('Final_variances.mat','results')
saveas(gcf,'Numbering.png')