classdef ringBufferOld < handle
    
    properties(GetAccess = 'public', SetAccess = 'private')
        bufferSize
    end
    
    properties(GetAccess = 'public', SetAccess = 'private')
        vData
    end
    
    properties(GetAccess = 'public', SetAccess = 'private')
        index
    end
    
    methods(Access = public)
        function obj = ringBuffer(bufferSize)
            obj.index = 0;
            obj.bufferSize = bufferSize;
        end
        
        function store(obj, nElementIn)
            [rNelementIn, cNElementIn] = size(nElementIn);
            [~, cData] = size(obj.vData);
            
            %             if(rNelementIn == 1 && cNElementIn <= obj.bufferSize)
            %
            %                 if((obj.index + cNElementIn) > obj.bufferSize)
            %                     restSize = obj.bufferSize - obj.index;
            %                     fprintf('RestSize: %1.0f', restSize)
            %
            %                     if(restSize > 0)
            %                         obj.vData(obj.index:obj.bufferSize) = nElementIn(1:restSize);
            %                         obj.vData(1:(cNElementIn - restSize)) = nElementIn((restSize + 1):end);
            %                         obj.index = cNElementIn - restSize;
            %                     else
            %                         obj.index = cNElementIn;
            %                         obj.vData(1:cNElementIn) = nElementIn(1:end);
            %                     end
            %                 else
            %                     obj.index = cData;
            %                 end
            %             end
            
            if(eNElementIn == 1 && cNElementIn > 0)
                
                runtimeCount = idivide(cElementIn, obj.bufferSize);
                
                if(runtimeCount > 0)
                    
                    obj.vData(1:obj.BufferSize) = cElementIn((runtimeCount * obj.bufferSize):((runtimeCount + 1) * obj.bufferSize));
                    
                    if(mod(cElementIn, obj.bufferSize) > 0)
                        
                    end
                else
                    
                end
            end
        end
        
        function filled = isFilled(obj)
            [~, c] = size(obj.vData);
            
            filled = (c >= obj.bufferSize);
        end
    end
end