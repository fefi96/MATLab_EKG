classdef testData < handle
    
    properties(GetAccess = 'public', SetAccess = 'private')
        vData
        nPageLen
        nIteration = 0;
        nDataAmount;
    end
    
    methods(Access = 'public')
        function obj = testData(nPageLen)
            load('recordedData', 'data');
            obj.vData = data;
            obj.nPageLen = nPageLen;
            [r, c] = size(obj.vData);
            obj.nDataAmount = r * c;
        end
        
        function start(~)
            disp('Started');
        end
        
        function vData = waitForData(obj)
            currentIndex = obj.nIteration * obj.nPageLen + 1;
            
            if((currentIndex + obj.nPageLen) >= obj.nDataAmount)
                currentIndex = 1;
                obj.nIteration = 0;
            end
            
            vData = (obj.vData(currentIndex:(obj.nPageLen + currentIndex)))';
            obj.nIteration = obj.nIteration + 1;
            pause(0.1);
        end
    end
end