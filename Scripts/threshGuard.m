classdef threshGuard < handle
    
    properties(GetAccess = 'public', SetAccess = 'private')
        iHRCalculator;
        bOverThreshold = false;
        bCurrentMaxChanged = false;
        nCurrentTicks;
        %vCurrentPeaks;
        nCurrentMax = 0;
        nCurrentMaxIndex = 0;
    end
    
    methods(Access = 'public')
        function obj = threshGuard(iHRCalculator)
            obj.iHRCalculator = iHRCalculator;
            obj.nCurrentTicks = 0;
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
    
    methods(Access = 'private')
        function reset(obj)
            %obj.nCurrentTicks = 0;
            %obj.vCurrentPeaks = [];
            obj.nCurrentMax = 0;
            obj.nCurrentMaxIndex = 0;
        end
    end
end