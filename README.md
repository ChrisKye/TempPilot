## Project Guide  

### Scripts
1. eegProcessing.R  
All the processing for EEG data. Divides data into epochs, creates feature sets (1. average PSD across 32 channels 2. individual PSD across 32 channels). Reshapes frequency features into long format. Unaveraged frequency features was written, but not run because my laptop is doodoo.  
Files: epochedList.rds (processedRaw) , freqFeatures.rds (sumPSD), x_freq.rds  
2. FeatureBuilding.R  
Redid labels to 0 or 1. Reshaped to match feature set length. Reformatted music features from MATLAB & repeated to concatenate with frequency features from EEG.  
Files: finalLabs.rds, x_music.rds, featureFull.rds  
3. DeepNNModel.R  
built MLP with dropoutlayers and stuff, used featureFull and finalLabs. Failed but good stuff in there.  
4. SVM_Testing.R  
tried SVM with same data, used E1071 package (or something like that).  
5. prototype.R  
testing stuff out for EEG, not that important.  

### Data
1. data_preprocessed  
Folder with full data from DEAP. EEG from every subject in dataset.  
2. videos.csv  
List of videos & average ratings, stuff like that. Raw from DEAP
3. videolist.xlsx  
List of videos actually used. Orange & yellow were problematic ones, redid time stamps on some to match max length.  
3. epochedList.rds  
List of length 32 (subjects). Each element is an array of dims 32 (channels) x 128 (time points) x 2400 (40 clips x 60 seconds each)  
4. freqFeatures.rds  
Array of dims 32 (subjects) x 5 (bands) x 2400 (40 clips x 60 seconds each)  
5. x_freq.rds  
long format of freqFeatures. Matrix of 76800 (32 subjects x 2400 examples) x 5 (bands)
6. x_music.rds  
long format of music stuff, repeated. Matrix of 76800 (cross-subject training examples) x 13 (music features)  
7. featureFull.rds  
concatenated x_freq & x_music. 76800x18  
8. finalLabs.rds  
labels of length 76800 x 6 (subno, trial no, val, arou, dom, lik)  

### music_anal
All the MATLAB processing stuff stored in here.
1. trimAudio.m  
function to trim audio files into 60 seconds with input 'filename' and 'startpoint' in seconds.  
2. AudioEpoch.m  
Writes new files into folder 'editedClips' first with good files, then with files that go over time limit.  
Files: editedClips  
3. FeatureExtraction.m  
Extracts 13 features using MIRToolbox. Writes data into struct df. 
Files: musicFeatures.mat  
4. music_raw  
raw audio files from youtube links.  

### venv
Virtual environment, must install tensorflow with pip.


