classdef dataRecorder < handle
   properties(GetAccess = 'public', SetAccess = 'private')
      vData; 
   end
   
   methods(Access = 'public')
       function obj = dataRecorder()
           
       end
       
       function store(obj, vDataIn)
          obj.vData = [obj.vData vDataIn]; 
       end
   end
end