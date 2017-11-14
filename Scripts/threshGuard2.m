classdef threshGuard2 < handle
    
    
    properties
        nPrevMax
        bPrevWasOver
        nCurrentMax
        bHasMaxChanged
    end
    
    methods
        function obj= threshGuard2()
            obj.nCurrentMax=0;
            obj.bHasMaxChanged=false;
            obj.bPrevWasOver=false;
        end
        
        function vOverThresh = checkForPeak(obj, nThreshold, vDataSegment)
            vOverThresh = [];
            
            if(~obj.bPrevWasOver)
                obj.nCurrentMax=0;
            end
            
            i=1;
            
            while(i<length(vDataSegment))
                if(~obj.bPrevWasOver)
                    obj.bHasMaxChanged=false;
                end
                
                while(vDataSegment(i) > nThreshold && i < length(vDataSegment))
                    if(vDataSegment(i) > obj.nCurrentMax)
                        obj.nCurrentMax = vDataSegment(i);
                        obj.bHasMaxChanged = true;
                    end
                    
                    i = i + 1;
                end
                
                if(obj.bHasMaxChanged && i < length(vDataSegment))
                    obj.bPrevWasOver = false;
                    vOverThresh(end + 1) = obj.nCurrentMax;
                elseif(obj.bHasMaxChanged && i == length(vDataSegment))
                    obj.bPrevWasOver=true;
                end
                
                i = i + 1;
            end
        end
        
        function [vLowPeaks, vHighPeaks] = detectPeaks(obj, vDataSegment, nThreshold)
            nLength = length(vDataSegment);
            vLowPeaks = NaN(1, nLength);
            vHighPeaks = NaN(1, nLength);
            
            for i = 1:nLength
                
                obj.nCurrentTicks = obj.nCurrentTicks + 1;
                %                 disp(['nCurrentTicks: ' num2str(obj.nCurrentTicks)]);
                %                 if(vDataSegment(i) > nThreshold)
                %                     obj.bOverThreshold = true;
                %                     obj.vCurrentPeaks = [obj.vCurrentPeaks vDataSegment(i)];
                %                 else
                %                     if(obj.bOverThreshold)
                %                         [~, maxIndex] = max(obj.vCurrentPeaks);
                %
                %                         vLowPeaks(maxIndex) = nThreshold;
                %                         vHighPeaks(maxIndex) = obj.vCurrentPeaks(maxIndex);
                %                         obj.iHRCalculator.tellTicks(obj.nCurrentTicks);
                %                         obj.reset();
                %                     end
                %
                %                     obj.bOverThreshold = false;
                %                 end
                %
                %                 disp(['bOverThreshold: ' num2str(obj.bOverThreshold)]);
                
                if(vDataSegment(i) > nThreshold)
                    obj.bOverThreshold = true;
                    
                    if(vDataSegment(i) > obj.nCurrentMax)
                        obj.nCurrentMax = vDataSegment(i);
                        obj.nCurrentMaxIndex = i;
                        obj.bCurrentMaxChanged = true;
                    else
                        
                        obj.bCurrentMaxChanged = false;
                    end
                else
                    %if(obj.bCurrentMaxChanged)
                    if(obj.bOverThreshold)
                        
                        vLowPeaks(obj.nCurrentMaxIndex) = nThreshold;
                        vHighPeaks(obj.nCurrentMaxIndex) = obj.nCurrentMax;
                        obj.reset;
                    end
                    
                    obj.bOverThreshold = false;
                end
            end
            
            if(~obj.bCurrentMaxChanged && obj.bOverThreshold)
                vLowPeaks(obj.nCurrentMaxIndex) = nThreshold;
                vHighPeaks(obj.nCurrentMaxIndex) = obj.nCurrentMax;
                obj.reset;
            end
        end     
    end
end

