% Stimulusgeneration
r=rand(48000,1);
r = r.*1.99;
r=r-1.0;

% Stimulus loading, alternatively
[y,fs,nbits] = wavread('Sine_440Hz_48.0kHz_-3dB_10sec.wav');

% for help type playrec
% for detailled help type e.g. playrec('help','playrec')

dev = playrec('getDevices');
a=dev(end);
pDevice = a.deviceID;
rDevice = a.deviceID;
%Fs = 48000;
Fs = fs;
duration = Fs;
playChanNum = a.inputChans;
recChanNum = a.outputChans;
playChan = 1:2;
recChan = 1:2;

playrec('init',Fs,pDevice,rDevice,playChanNum,recChanNum)

whos y
%pn = playrec('playrec',r,playChan,duration,recChan);
pn = playrec('playrec',[y(:,1) y(:,2)],playChan,-1,recChan);
playrec('block',pn);
[y,chanNum] = playrec('getRec',pn);

playrec('reset')

