classdef ringBuffer < handle
    
    properties(GetAccess = 'public', SetAccess = 'private')
        bufferSize
        vData
        readIndex
        writeIndex
    end
    
    methods(Access = public)
        function obj = ringBuffer(bufferSize)
            obj.readIndex = 0;
            obj.bufferSize = bufferSize;
        end
        
        function store(obj, newElement)
            if isFilled(obj)
               
               obj.vData(1,1) = newElement;
            else 
               obj.vData = [newElement, obj.vData];
            end
        end
        
        function filled = isFilled(obj)
            [~, c] = size(obj.vData);
            
            filled = (c >= obj.bufferSize);
        end
    end
end