% Creates an accelerated Power - Time profile

% Power Data
% input = HPR_2018.Output;

% To see an example of how this code work uncomment the below
 input = [0,5,5,7,10,12,14,10,7,2,1,10,1]';

% Time Step in sec
timeStep = 4;
 
% The minimum power threshold in MW
% Any power under power_Threshold will be scaled to this value
power_Threshold = 10;

% creates 2 vectors for the identification of concescutive datapoints under
% power_Threshold
powerBelowThreshold_indicator = input;
powerBelowThreshold_indicator(abs(input)>=power_Threshold) = 0;
powerBelowThreshold = powerBelowThreshold_indicator;
powerBelowThreshold_indicator(abs(input)<power_Threshold) = 1;

% finds end of concecutive points below threshold
lastConsPoint = diff(powerBelowThreshold_indicator,1,1)<0;
lastConsPoint = [lastConsPoint; input(end)<power_Threshold];

% creates a sum of consecutive values below threshold, restarting at every
% set of consecutive points
sumReplacablePowers = cumsum(powerBelowThreshold);
resetConsSums = sumReplacablePowers(lastConsPoint);
%powerBelowThreshold([false; lastConsPoint(1:end-1)]) = -[resetConsSums(1);diff(resetConsSums,1,1)];
powerBelowThreshold = [powerBelowThreshold;0];
powerBelowThreshold([false;lastConsPoint]) = -[resetConsSums(1);diff(resetConsSums,1,1)];
SumPwr = cumsum(powerBelowThreshold(1:end-1)); 

% creates accelerated aging protocol by replacing the last concecutive
% point below threshold with the min power and equivalent time (so as to
% maintain the same energy of those consecutive points) 
time = input.*0;
Power = input.*0;
time(abs(input)>=power_Threshold) = timeStep;
Power(abs(input)>=power_Threshold) = input(abs(input)>=power_Threshold);
time(lastConsPoint) = abs(SumPwr(lastConsPoint)) * timeStep / power_Threshold;
Power(lastConsPoint) = power_Threshold * sign(SumPwr(lastConsPoint));

% removes all points below the threshold other than the last consecutive
% point which has been replaced
Power(Power==0) = [];
time(time==0) = [];

newData = table(cumsum(time),Power,'VariableNames',{'Times','Values'});

figure
subplot(1,2,1)
plot(cumsum(ones(1,length(input)).*4)./3600/24,input)
ylabel('Power (MW)')
xlabel('Time (Days)')
subplot(1,2,2)
plot(newData.Times ./ 3600/24,newData.Values)
xlabel('Time (Days)')