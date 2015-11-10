%          Simple Agent Model           Assignment Week 5
%          Sander Martijn Kerkdijk      Max Turpijn
%          Course: Behaviour Dynamics in social Networks 
%               Vrije Universiteit Amsterdam 2015
%                   Copying will be punished

% INITIALIZATION

load EmpiricalData.mat;
load WeightEdges.mat;

Size = size(EmpiricalData);

Accurancy = 0.001;

StepSize = 1;

TriedUpdateParameters = 1;

NumberAgents = Size(1,2);

EndTime = Size(1,1);

UpdateSpeedParameter = Accurancy;
 
ScaleVector = sum(WeightOfEdges,2);

AggImpact = double(NumberAgents);

State = zeros(EndTime,NumberAgents);

ErrorOfUpdateParameter = zeros((1/Accurancy),1);

Error = 100;

BestValue = 0;


while TriedUpdateParameters <= (1/Accurancy)
    Steps = 1;
    State(1,:) = EmpiricalData(1,:);
    while Steps < EndTime 
        Steps = Steps + 1;
    % calculate AGGIMPACT
        for agent = 1:NumberAgents
            ssum = 0;
            AggImpact(agent) = 0;

            % calculate SUM
             for agents = 1:NumberAgents
                ssum = ssum + ((WeightOfEdges(agents,agent)*State((Steps-1),agents)));  
             end

            % add find sum to given agent by aggimpact(t) + (SSUM/ScaledVector)
            AggImpact(agent) = AggImpact(agent) +((ssum)/ScaleVector(agent)); 
        end 

            for agents = 1:NumberAgents
                % update rule 
                % applying the update rule
                State(Steps,agents) = State((Steps-1),agents) + (UpdateSpeedParameter*((AggImpact(agents) - State((Steps-1),agents))));    
            end


    end
   D = abs(EmpiricalData-State).^2;
   MSE = sum(D(:))/numel(EmpiricalData);   
   ErrorOfUpdateParameter(TriedUpdateParameters,1) = MSE;
   TriedUpdateParameters = TriedUpdateParameters +1;
   UpdateSpeedParameter = UpdateSpeedParameter + Accurancy;
   
end  

[MinimumError,PositionOfSmallestError] = min(ErrorOfUpdateParameter);
NumberOfMinimalError = (PositionOfSmallestError * Accurancy);

output = [' The lowest error is: ',num2str(MinimumError),' with updateparameter: ',num2str(NumberOfMinimalError)];
plot(ErrorOfUpdateParameter);
title({'Plot of Error within update', 'Lowest Error: ',num2str(MinimumError),' with a update-parameter:',num2str(NumberOfMinimalError)});
disp(output);
