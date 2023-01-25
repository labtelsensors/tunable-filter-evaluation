%%
clear, clc, close all;
%% Set Paths
rootDir = 'C:\Users\Mariana Lyra\Documents\MATLAB\TunableFilterCharacterization';
dataDir = fullfile(rootDir,'Data','Pin12dbm');
fileList = dir(dataDir);
fileList = fileList(3:end);

% Optical Source File
osFile = fileList(~cellfun(@isempty,arrayfun(@(x) strfind(x.name,'OS'),fileList,'UniformOutput',false)));
% FSR File
fsrFile = fileList(~cellfun(@isempty,arrayfun(@(x) strfind(x.name,'FSR'),fileList,'UniformOutput',false)));

%Remove from list
fileList = fileList(cellfun(@isempty,arrayfun(@(x) strfind(x.name,'OS'),fileList,'UniformOutput',false)));
fileList = fileList(cellfun(@isempty,arrayfun(@(x) strfind(x.name,'FSR'),fileList,'UniformOutput',false)));

%% Set Paremeters
minPeakHeight = -80;
minPeakDistance = 10;
fsr = zeros(1,length(fileList));
peakTracking = cell(length(fileList),1);
voltage = [0:0.25:6,7:12];
%% LoadData
figure(1), hold on;
for i=1:length(fileList) 
    dataPath = fullfile(dataDir,fileList(i).name);
    spectralInfo = csvread(dataPath,28,0);
    spectralInfo = [spectralInfo(:,1),10*log10(abs(spectralInfo(:,2)))];
    [pks,locs] = findpeaks(spectralInfo(:,2),spectralInfo(:,1),'MinPeakDistance',minPeakDistance,'MinPeakHeight',minPeakHeight);   
    if (size(pks,1)>=2)
        fsr(i) = locs(2)-locs(1);
    end
    peakTracking{i} = locs;
    plot(spectralInfo(:,1),spectralInfo(:,2)),plot(locs,pks,'xr');
end    

% TODO: CHECK EQUAL LENGTHS OF peakTracking
p1 = cell2mat(peakTracking')'; 
%% Plot Figures
figure(2); hold on;
plot(voltage,p1(:,1),'o--'),plot(voltage,p1(:,2),'s--');
grid on;
xlabel('Voltage | V');
ylabel('Wavelength | nm');
title('Wavelength Tracking');

figure(3);
plot(voltage,fsr,'o--');
grid on;
xlabel('Voltage | V');
ylabel('FSR');
title('FSR');
