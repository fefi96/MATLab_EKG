classdef testData < handle
    
    properties(GetAccess = 'private', SetAccess = 'private')
        factor
    end
    
    methods(Access = 'public')
        function obj = testData()
           obj.factor = 0; 
        end
        
        function vData = getTestData(obj)
            x = -pi:0.1:pi;
            obj.factor = obj.factor + 1;
            vData = sin(x + obj.factor);
            pause(0.3);
        end
    end
end