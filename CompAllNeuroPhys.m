function [] = CompAllNeuroPhys()
%COMPEALLNEUROPHYS create struct of 

% Get list for error checking
if exist('Y:\','dir')
    cd('Y:\AlphaOmegaMatlabData')
    dirfolders = dir;
    foldernamesTemp = {dirfolders.name};
    foldernamesCheck = foldernamesTemp(3:end);
else
    warndlg('Check for Y:\DBS Drive');
end

% Set directory location for Matlab files
neuro_dir = uigetdir;
% Navigate to Matlab directory with date folders
cd(neuro_dir);
% Generate list cases by date
dirFolderFiles = dir;
dirIndexTransform = {dirFolderFiles.isdir};
dirIndexTransform = dirIndexTransform(3:end);
dirIndex = cell2mat(dirIndexTransform);
fileTemp = {dirFolderFiles.name};
fileTemp = fileTemp(3:end);
caseNames = fileTemp(dirIndex);

% Check if directroy is correct
dirCheck = 1;
while dirCheck
    if isequal(caseNames,foldernamesCheck)
        dirCheck = 0;
    else
        % Set directory location for Matlab files
        neuro_dir = uigetdir;
        % Navigate to Matlab directory with date folders
        cd(neuro_dir);
        % Generate list cases by date
        dirFolderFiles = dir;
        dirIndexTransform = {dirFolderFiles.isdir};
        dirIndexTransform = dirIndexTransform(3:end);
        dirIndex = cell2mat(dirIndexTransform);
        fileTemp = {dirFolderFiles.name};
        fileTemp = fileTemp(3:end);
        caseNames = fileTemp(dirIndex);
    end
end

% User defined case selection
select_case = listdlg('PromptString','Select a Case:',...
    'SelectionMode','single','ListString',caseNames);
% Index into the case names array and case date
dateCase = caseNames{select_case};
% Combine information
caseLoc = strcat(neuro_dir,'\',dateCase);
% Change to selected directory
cd(caseLoc)

% Get mat file names : these are associated with depths
depthFiles = cellstr(ls('*.mat'));

for dfi = 1:length(depthFiles);
   load(depthFiles{dfi}) 
    
    
    
    
end

colors = {'r','g','b','k'};

for i = 1:4
    
tempLFP = strcat('CLFP',num2str(i));
tempLFPp = eval(tempLFP);
plot(tempLFPp,colors{i});
hold on


end

