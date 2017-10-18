classdef fifoBuffer < handle
    
    properties(GetAccess = 'public', SetAccess = 'private')
        vData
    end
    
    properties(GetAccess = 'public', SetAccess = 'private')
        vInd;
    end
    
    methods(Access = 'public')
        
        function obj = fifoBuffer(elements)
            
            if(nargin > 0)
                [r, ~] = size(elements);
                
                if(r == 1)
                    obj.vData = elements;
                end
            end
        end
        
        function enqueue(obj, nElementIn)
            
            [r, ~] = size(nElementIn);
            
            if(r == 1)
                obj.vData = [obj.vData nElementIn];
                obj.vInd = [obj.vInd length(obj.vData)];
            end
        end
        
        function elementOut = dequeue(obj)
            
            [~, c] = size(obj.vData);
            
            if(c >= 1)
                elementOut = obj.vData(1:obj.vInd(1));
                obj.vData = obj.vData((obj.vInd(1) + 1):end);
                obj.vInd = obj.vInd - obj.vInd(1);
                obj.vInd = obj.vInd(2:end);
            end
        end
    end
end