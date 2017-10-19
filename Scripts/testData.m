classdef testData < handle
    
    properties(GetAccess = 'private', SetAccess = 'private')
        factor
    end
    methods(Access = 'public')
        function obj = testData()
           obj.factor = 1; 
        end
        
        function vData = getTestData(obj)
            x = linspace(0,10);
            obj.factor = obj.factor + 1;
            vData = sin(x + obj.factor);
        end
    end
end