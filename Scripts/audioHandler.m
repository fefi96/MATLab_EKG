classdef audioHandler < handle
    %properties(GetAccess = 'public', SetAccess = 'private')
    %    saDeviceList
    %end
    
    properties(GetAccess = 'public', SetAccess = 'private')
        bIsInitialized = playrec('isInitialized')
        audioDeviceID
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
    
    methods(Access = public)
        function obj = audioHandler(nSampleRate, nPageLenInSamples, nNumPages)
            obj.initialize(obj.getDeviceIDByName(obj.sDeviceName), nSampleRate, nPageLenInSamples, nNumPages);
        end
        
        function initialize(obj, nDeviceID, nSampleRate, nPageLenInSamples, nNumPages)
            obj.audioDeviceID = nDeviceID;
            obj.nSampleRate = nSampleRate;
            obj.nPageLenInSamples = nPageLenInSamples;
            obj.nNumPages = nNumPages;
            obj.pageIDStore = fifoBuffer;
            
            playrec('init', obj.nSampleRate, -1, obj.audioDeviceID);
        end
        
        function start(obj)
            playrec('delPage');
            obj.pageIDStore.enqueue(playrec('rec', obj.nPageLenInSamples, 1));
        end
        
        function vmData = waitForData(obj)
            nCurrentPageID = obj.pageIDStore.dequeue();
            playrec('block', nCurrentPageID);
            vmData = playrec('getRec', nCurrentPageID);
        end
        
        function stop(obj)
            if(obj.bIsInitialized)
                playrec('delPage');
                playrec('reset');
            end
        end
    end
    
    methods(Access = private)
        function nDeviceID = getDeviceIDByName(~, sDeviceName)
            devices = playrec('getDevices');
            
            r = length(devices);
            
            for i = 1:r
                if(strcmp(devices(i).name, sDeviceName))
                    nDeviceID = devices(i).deviceID;
                    break;
                end
            end
        end
    end
end
