myDir = uigetdir; %gets directory
myFiles = dir(fullfile(myDir,'*.mp3')); %gets all wav files in struct
list = [81, 54, 21, 181, 6,51,26,6,6,6, 151,151,6,6,6, 41,211,86,46,151,41,126,181,186,211,191,31,6,181,86,211,6,126,131,41,6,6,166,251,201];
errorcount = 0;
errorvals = zeros(1);
for k = 1:length(myFiles)
    baseName = strcat("music_raw/videoid_",string(k),".mp3");
    info = audioinfo(baseName);
    leng = info.Duration;
    if leng < (list(k)+60)
        errorcount = errorcount + 1;
        errorvals(errorcount) = k
    else
        [y1,fs1] = trimAudio(baseName,list(k));
        audiowrite(strcat("editedClips/","clip_",string(k),".wav"),y1,fs1);
        k
    end
end

for i =1:length(errorvals)
    baseName = strcat("music_raw/videoid_",string(errorvals(i)),".mp3");
    info = audioinfo(baseName);
    errorvals(i)
    leng = info.Duration
end

listError = [79, 208, 180, 177, 209, 187, 122, 200];
for j = 1:length(listError)
    baseName = strcat("music_raw/videoid_",string(errorvals(j)),".mp3");
    [y1,fs1] = trimAudio(baseName,listError(j));
    audiowrite(strcat("editedClips/","clip_",string(errorvals(j)),".wav"),y1,fs1);
    errorvals(j)
end