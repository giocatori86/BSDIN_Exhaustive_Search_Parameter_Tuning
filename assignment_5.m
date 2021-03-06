%          Exhaustive search parameter tuning   Assignment Week 5
%          Sander Martijn Kerkdijk               Max Turpijn
%          Course: Behaviour Dynamics in social Networks 
%               Vrije Universiteit Amsterdam 2015
%                    Copying will be punished

% INITIALIZATION

%   Load reference Dataset
load EmpiricalData.mat;

%   Load given Weights of the edges.
load WeightEdges.mat;

%   Calculate size of Given Matrix
Size = size(EmpiricalData);

%   Set Accurancy of the search
Accurancy = 0.001;

%   Set Maximum Update
MaximumUpdate = 0.5;

%   Initialize first step
StepSize = 1;

%   Initialize First Atempt of an parameter
TriedUpdateParameters = 1;

%   Initialize number of agents
NumberAgents = Size(1,2);

%   Set endtime
EndTime = Size(1,1);

%   Make a Update Speed Parameter that goes up by every attempt
UpdateSpeedParameter = Accurancy;
 
%   Set the scalevector for every agent
ScaleVector = sum(WeightOfEdges,2);

%   Initialize AggImpact array
AggImpact = double(NumberAgents);

%   Initialize State matrix
State = zeros(EndTime,NumberAgents);

%   Initialize ErrorUpdateParameter Array (output of the errors + number of updateparameter
ErrorOfUpdateParameter = zeros((MaximumUpdate/Accurancy),1);

%   Set a initial error (High because of the threshold)
Error = 100;

%   Set a initial best value for the update parameter
BestValue = 0;

%   Begin Search
%   While loop with tried attempts for updateparameter in given range of maximum update / accurancy
while TriedUpdateParameters <= (MaximumUpdate/Accurancy)
    Steps = 1;
    
    %   Get first state from given reference dataset.
    State(1,:) = EmpiricalData(1,:);
    
    %   While Steps are Smaller then Endtime
    while Steps < EndTime 
        Steps = Steps + 1;
    %   calculate AGGIMPACT
        for agent = 1:NumberAgents
            ssum = 0;
            AggImpact(agent) = 0;
            %   calculate SUM
             for agents = 1:NumberAgents
                ssum = ssum + ((WeightOfEdges(agent,agents)*State((Steps-1),agents)));  
             end
            %   Add find sum to given agent by aggimpact(t) + (SSUM/ScaledVector)
            AggImpact(agent) = AggImpact(agent) +((ssum)/ScaleVector(agent)); 
        end 
            for agents = 1:NumberAgents
                %   Determine the opinions
                %   State (t+1) = State(t) + ((UpdateParameter * AggImpact)- State(t)
                State(Steps,agents) = State((Steps-1),agents) + (UpdateSpeedParameter*((AggImpact(agents) - State((Steps-1),agents))));    
            end
    end
    
   %    Calculate the SSR 
   
   %    Difference = ReferenceDataSet - DataSet by given update speed variable
    Difference =  EmpiricalData-State;
    
    %   SSR = (The sum of all differences between referencedataset and DataSet by given update Variable) ^2 
    SSR = sum(Difference(:).^2);
   
   %    Put the SSR into the Matrix ErrorUpdateParameter 
   ErrorOfUpdateParameter(TriedUpdateParameters,1) = SSR;
   
   %    Higher the TriedUpdateParamaters with 1
   TriedUpdateParameters = TriedUpdateParameters +1;
   %    Update the UpdateSpeedParameter with the given Accurancy
   UpdateSpeedParameter = UpdateSpeedParameter + Accurancy;
   
end  

%       Find the minimum error between the given set and a applied UpdateParameter
[MinimumError,PositionOfSmallestError] = min(ErrorOfUpdateParameter);

%       Convert row number to real value
ValueOfMinimalError = (PositionOfSmallestError * Accurancy);


%       Plot the X of the UpdateParameterValue and Y UpdateParameterError
plot(ErrorOfUpdateParameter);
ylabel('Mean Square Error')
xlabel('UpdateSpeed Parameter')
set(gca, 'XTickLabel',{num2str((Accurancy*0)*(MaximumUpdate/Accurancy)),num2str((Accurancy*0.1)*(MaximumUpdate/Accurancy)),num2str((Accurancy*0.2)*(MaximumUpdate/Accurancy)),num2str((Accurancy*0.3)*(MaximumUpdate/Accurancy)),num2str((Accurancy*0.4)*(MaximumUpdate/Accurancy)),num2str((Accurancy*0.5)*(MaximumUpdate/Accurancy)),num2str((Accurancy*0.6)*(MaximumUpdate/Accurancy)),num2str((Accurancy*0.7)*(MaximumUpdate/Accurancy)),num2str((Accurancy*0.8)*(MaximumUpdate/Accurancy)),num2str((Accurancy*0.9)*(MaximumUpdate/Accurancy)),num2str((Accurancy*1)*(MaximumUpdate/Accurancy))})
title({'Plot of Error within update', 'Lowest Error: ',num2str(MinimumError),' with Update-Parameter:',num2str(ValueOfMinimalError)});





