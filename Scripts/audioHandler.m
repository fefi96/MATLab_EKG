classdef audioHandler < handle
    %properties(GetAccess = 'public', SetAccess = 'private')
    %    saDeviceList
    %end
    
    properties(GetAccess = 'public', SetAccess = 'private')
        nAudioDeviceID
    end
    
    properties(GetAccess = 'private', SetAccess = 'private')
        nSampleRate
        nPageLenInSamples
        nNumPages
        pageIDStore
    end
    
    properties(GetAccess = 'private', Constant)
        sDeviceName = 'Microphone (USB Audio CODEC )';
    end
    
    methods(Access = 'public')
        function obj = audioHandler(nSampleRate, nPageLenInSamples, nNumPages)
            obj.initialize(obj.getDeviceIDByName(obj.sDeviceName), nSampleRate, nPageLenInSamples, nNumPages);
            obj.nAudioDeviceID
        end
        
        function initialize(obj, nDeviceID, nSampleRate, nPageLenInSamples, nNumPages)
            obj.nAudioDeviceID = nDeviceID;
            obj.nSampleRate = nSampleRate;
            obj.nPageLenInSamples = nPageLenInSamples;
            obj.nNumPages = nNumPages;
            obj.pageIDStore = fifoBuffer;
            
            playrec('init', obj.nSampleRate, -1, obj.nAudioDeviceID);
        end
        
        function start(obj)
            playrec('delPage');
            obj.pageIDStore.enqueue(playrec('rec', obj.nPageLenInSamples, 1));
        end
        
        function vmData = waitForData(obj)
            nCurrentPageID = obj.pageIDStore.dequeue();
            playrec('block', nCurrentPageID);
            vmData = playrec('getRec', nCurrentPageID);
            playrec('delPage', currentPageID);
            obj.pageIDStore.enqueue(playrec('rec', obj.nPageLenInSamples, 1));
        end
        
        function stop(~)
            if(playrec('isInitialized'))
                playrec('delPage');     
            end
            
            playrec('reset');
        end
    end
    
    methods(Access = 'private')
        function nDeviceID = getDeviceIDByName(~, sDeviceName)
            devices = playrec('getDevices');
            
            r = length(devices);
            
            for i = 1:r
                disp(devices(i).name);
                if(strcmp(devices(i).name, sDeviceName))
                    nDeviceID = devices(i).deviceID;
                    return;
                end
            end
            
            nDeviceID  = -1;
        end
    end
end