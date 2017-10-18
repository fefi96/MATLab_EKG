classdef audioHandler < handle
    properties(GetAccess = 'public', SetAccess = 'private')
        saDeviceList
    end
    
    properties(GetAccess = 'public', SetAccess = 'private')
        bIsInitialized = playrec('isInitialized')
    end
    
    properties(GetAccess = 'public', SetAccess = 'private')
        audioDevice
    end
    
    properties(GetAccess = 'private', Constant)
       deviceName = 'Microphone (USB Audio CODEC )';
    end
    
    methods(Access = public)
        function obj = audioHandler(nSampleRate, nPageLenInSamples, nNumPages)
            devices = playrec('getDevices');
            
            r = length(devices);
            
            for i = 1:r
               if(strcmp(devices(i).name, obj.deviceName))
                   obj.audioDevice = devices(i);
                   break
               end
            end
        end
        
        function initialize(obj, nDeviceID)
            
        end
        
        function start(obj)
            
        end
        
        function vmData = waitForData(obj)
            
        end
        
        function stop(obj)
            
        end
    end
end
