myDir = 'editedClips'; %gets directory
myFiles = dir(fullfile(myDir,'*.wav'));
df = struct;
for k = 1:length(myFiles)
    baseName = strcat('editedClips/clip_',string(k),'.wav');
    baseName = convertStringsToChars(baseName);
    %%Dynamics, 1
    rms = mirrms(baseName);
    rms = get(rms, 'Data');
    df(k).rms = cell2mat(rms{1});
    'completed Dynamics'
    
    %%Timbre, 3
    spec = mircentroid(baseName);
    spec = get(spec, 'Data');
    spec = spec{1};
    df(k).spectralCentroid = cell2mat(spec{1});
    
    spr = mirspread(baseName);
    spr = get(spr, 'Data');
    spr = spr{1};
    df(k).spectralSpread = cell2mat(spr{1});
    
    ent = mirentropy(baseName);
    ent = get(ent, 'Data');
    ent = ent{1};
    df(k).spectralEntropy = cell2mat(ent);
    'completed Timbre'
    
    %%Harmony, 4
    x = mirhcdf(baseName);
    dat = get(x, 'Data');
    dat = dat{1};
    df(k).harmonicChange = mean(dat{1});
    
    [key,keystr] = mirkey(baseName);
    keystr = get(keystr, 'Data');
    keystr = keystr{1};
    df(k).keyClarity = cell2mat(keystr);
    
    mode = mirmode(baseName);
    mode = get(mode, 'Data');
    mode = mode{1};
    df(k).majorness = cell2mat(mode);
    
    x = mirroughness(baseName);
    dat = get(x, 'Data');
    dat = dat{1};
    df(k).roughness = mean(dat{1});
    'completed Harmony'
    
    %%Register, 2
    pit = mirpitch(baseName);
    pit = get(pit, 'Data');
    pit = pit{1};
    df(k).pitch = cell2mat(pit{1});
    
    c = mirchromagram(baseName,'Frame','Wrap',0,'Pitch',0);
    cp = mirpeaks(c, 'Total',1);
    cp = get(cp,'PeakPosUnit');
    cp = cp{1};
    cp = cell2mat(cp{1});
    df(k).chromaStd = std(cp);
    'completed Register'
    
    %%Rhythm, 3
    x = mirfluctuation(baseName, 'Summary');
    dat = get(x, 'Data');
    dat = dat{1};
    df(k).fluctation = max(dat{1});
    
    temp = mirtempo(baseName);
    temp = get(temp, 'Data');
    temp = temp{1};
    df(k).tempo = cell2mat(temp{1});
    
    pul = mirpulseclarity(baseName);
    pul = get(pul, 'Data');
    pul = pul{1};
    df(k).pulseClarity = cell2mat(pul);
    'completed Rhythm'
    
    %%Structure, 1
    x = mirnovelty(baseName);
    dat = get(x, 'Data');
    dat = dat{1};
    df(k).novelty = mean(dat{1});
   
    strcat('completed clip number ',string(k))
end
    
save('musicFeatures','df')
    