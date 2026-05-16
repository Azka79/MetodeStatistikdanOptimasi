%% OPTIMAL SCHEDULED POWER FLOW FOR PV-WIND-DIESEL-BATTERY HYBRID SYSTEM
% Implementation of Kusakana (2015) paper using fmincon
% Continuous operation control strategy for 24 hours (N=48 sampling intervals)
clear all; close all; clc;

%% 1. SCENARIO SELECTION
% Choose your simulation case: 'summer' or 'winter'
scenario = 'summer'; 

%% 2. PARAMETERS DEFINITION
% Time parameters
dt = 0.5;                    % Sampling time interval [hours] = 30 minutes
N = 48;                      % Number of sampling intervals (24 hours * 2)

% Diesel generator parameters (fuel consumption curve)
a = 0.246;                   % Quadratic coefficient
b = 0.0815;                  % Linear coefficient
c = 0.4333;                  % Constant term
Cf = 1.4;                    % Diesel fuel price [$/L]
PDG_max = 8;                 % Maximum DG power output [kW]

% Battery parameters
Enom = 5.6;                  % Battery nominal energy capacity [kWh]
SOC_min = 0.40;              % Minimum state of charge [p.u.]
SOC_max = 0.95;              % Maximum state of charge [p.u.]
SOC_0 = 0.80;                % Initial state of charge [p.u.]
eta_bat = 0.85;              % Battery charging efficiency
db = 0;                      % Self-discharge rate (assumed negligible)
PBat_rated = 3;              % Battery rated power [kW] (assumed)

% Display parameters
fprintf('==================================================\n');
fprintf('HYBRID SYSTEM OPTIMIZATION - CONTINUOUS CONTROL\n');
fprintf('==================================================\n\n');
fprintf('System Parameters:\n');
fprintf('  Selected Scenario: %s\n', upper(scenario));
fprintf('  Sampling time: %.1f hours (%.0f minutes)\n', dt, dt*60);
fprintf('  Number of intervals: %d\n', N);
fprintf('  DG max power: %.1f kW\n', PDG_max);
fprintf('  Battery capacity: %.1f kWh\n', Enom);
fprintf('  Battery rated power: %.1f kW\n', PBat_rated);
fprintf('  SOC limits: %.0f%% - %.0f%%\n\n', SOC_min*100, SOC_max*100);

%% 3. LOAD AND RENEWABLE ENERGY DATA (24 Hours Table 1)
% --- SUMMER DATA ---
PL_summer = [0.3; 0.2; 0.1; 0.0; 0.3; 0.0; 2.4; 0.6; 4.3; 5.6; 3.2; 1.6; ...
             0.3; 2.0; 0.4; 0.8; 3.9; 1.8; 1.7; 1.9; 2.2; 0.9; 0.7; 0.3];

PPV_summer = [0.000; 0.000; 0.000; 0.000; 0.000; 0.000; 0.000; 0.002; 0.141; 0.417; 0.687; 0.940; ...
              1.062; 1.061; 0.978; 0.846; 0.679; 0.464; 0.208; 0.043; 0.000; 0.000; 0.000; 0.000];

PWT_summer = [0.821; 1.665; 0.998; 0.956; 2.549; 2.558; 2.775; 3.754; 2.948; 2.828; 2.870; 2.522; ...
              1.766; 2.576; 2.017; 2.282; 3.116; 2.626; 3.427; 2.972; 2.543; 2.336; 1.863; 1.231];

% --- WINTER DATA ---
PL_winter = [0.3; 0.2; 0.1; 0.0; 0.3; 0.0; 3.0; 0.7; 8.0; 5.6; 2.6; 3.0; ...
             0.5; 3.4; 0.7; 1.3; 1.4; 1.5; 3.8; 4.6; 5.9; 2.1; 0.8; 0.3];

PPV_winter = [0.000; 0.000; 0.000; 0.000; 0.000; 0.000; 0.000; 0.000; 0.145; 0.244; 0.306; 0.512; ...
              0.611; 0.614; 0.568; 0.428; 0.460; 0.266; 0.000; 0.000; 0.000; 0.000; 0.000; 0.000];

PWT_winter = [0.871; 0.381; 0.947; 1.425; 1.575; 1.463; 0.932; 1.560; 1.337; 1.761; 2.611; 3.542; ...
              3.956; 4.698; 4.898; 4.089; 5.544; 4.404; 4.547; 4.711; 3.881; 4.610; 2.537; 2.370];

% Select active scenario data
if strcmp(scenario, 'summer')
    PL_hourly = PL_summer;
    PPV_hourly = PPV_summer;
    PWT_hourly = PWT_summer;
elseif strcmp(scenario, 'winter')
    PL_hourly = PL_winter;
    PPV_hourly = PPV_winter;
    PWT_hourly = PWT_winter;
else
    error('Unknown scenario! Choose either ''summer'' or ''winter''.');
end

% Convert hourly data to 30-min intervals (duplicate each hour into two 30-min slots)
PL = repelem(PL_hourly, 2);
PPV = repelem(PPV_hourly, 2);
PWT = repelem(PWT_hourly, 2);

fprintf('Data loaded successfully for %s scenario (%d intervals).\n\n', upper(scenario), N);

%% 4. OPTIMIZATION PROBLEM SETUP
% Total number of control variables: 2*N
% x = [PDG(1...N), PBat(1...N)]'

%% 4.1 OBJECTIVE FUNCTION
% Minimize fuel cost: F = Cf * sum[a*PDG^2 + b*PDG + c]
% In matrix form: F = Cf * [x'*Q*x + c_vec'*x + k]

% Dynamic Quadratic term matrix Q (2N x 2N) - only affects PDG variables
Q_diag = [repmat(a, N, 1); zeros(N, 1)];
Q = diag(Q_diag);

% Dynamic Linear term vector (2N x 1)
c_vec = [repmat(b, N, 1); zeros(N, 1)];

% Constant term
k = N * c;  

% Define objective function handle
objective = @(x) Cf * (x' * Q * x + c_vec' * x + k);

%% 4.2 EQUALITY CONSTRAINTS (Power Balance)
% PDG(j) + PBat(j) + PPV(j) + PWT(j) = PL(j)
% Rearranged: PDG(j) + PBat(j) = PL(j) - PPV(j) - PWT(j)

% Create Aeq matrix: [Identity Matrix for PDG, Identity Matrix for PBat]
Aeq = [eye(N), eye(N)]; 
beq = PL - PPV - PWT;       % Net load (N x 1)

%% 4.3 INEQUALITY CONSTRAINTS (SOC Limits)
% SOC(j) = beta - alpha * sum(PBat(1:j))
alpha = dt * eta_bat / Enom;
beta = (1 - db) * SOC_0;

A_ineq = zeros(2*N, 2*N);   % (2N x 2N) matrix
% Upper SOC constraints (first N rows)
for j = 1:N
    A_ineq(j, N+1:N+j) = -alpha;  % Cumulative sum of PBat
end
% Lower SOC constraints (last N rows)
for j = 1:N
    A_ineq(N+j, N+1:N+j) = alpha;  % Cumulative sum of PBat
end

% Right-hand side vector
b_ineq = [repmat(SOC_max - beta, N, 1);    % Upper limits
          repmat(beta - SOC_min, N, 1)];   % Lower limits

%% 4.4 VARIABLE BOUNDS
% Lower bounds: lb <= x
lb = [zeros(N,1);                    % PDG >= 0
      -PBat_rated * ones(N,1)];      % PBat >= -PBat_rated (max charging)

% Upper bounds: x <= ub
ub = [PDG_max * ones(N,1);           % PDG <= PDG_max
      PBat_rated * ones(N,1)];       % PBat <= PBat_rated (max discharging)

%% 5. INITIAL GUESS
x0 = zeros(2*N, 1);

%% 6. SOLVER OPTIONS
options = optimoptions('fmincon', ...
    'Display', 'iter', ...              
    'Algorithm', 'sqp', ...             
    'MaxIterations', 2000, ...          
    'MaxFunctionEvaluations', 10000, ...
    'OptimalityTolerance', 1e-6, ...
    'StepTolerance', 1e-10);

fprintf('==================================================\n');
fprintf('STARTING OPTIMIZATION (fmincon - SQP Algorithm)\n');
fprintf('==================================================\n\n');

%% 7. SOLVE OPTIMIZATION PROBLEM
[x_opt, fval, exitflag, output] = fmincon(objective, x0, ...
    A_ineq, b_ineq, Aeq, beq, lb, ub, [], options);

%% 8. EXTRACT RESULTS
PDG_opt = x_opt(1:N);           % Optimal DG power
PBat_opt = x_opt(N+1:2*N);      % Optimal battery power

% Calculate resulting SOC trajectory
SOC = zeros(N,1);
for j = 1:N
    SOC(j) = beta - alpha * sum(PBat_opt(1:j));
end

% Calculate fuel consumption
fuel_consumption = zeros(N,1);
for j = 1:N
    fuel_consumption(j) = a * PDG_opt(j)^2 + b * PDG_opt(j) + c;
end
total_fuel = sum(fuel_consumption);  % [Liters]

%% 9. DISPLAY RESULTS
fprintf('\n==================================================\n');
fprintf('OPTIMIZATION RESULTS (%s SCENARIO)\n', upper(scenario));
fprintf('==================================================\n\n');
fprintf('Exit Flag: %d\n', exitflag);
if exitflag > 0
    fprintf('Status: SUCCESS - Optimization converged\n');
elseif exitflag == 0
    fprintf('Status: WARNING - Maximum iterations reached\n');
else
    fprintf('Status: FAILED - Optimization did not converge\n');
end

fprintf('Cost Summary:\n');
fprintf('  Total fuel consumption: %.4f Liters\n', total_fuel);
fprintf('  TOTAL FUEL COST: $%.4f\n\n', fval);

%% 10. COMPARISON WITH DG-ONLY OPERATION
% Calculate DG-only scenario (DG supplies entire load)
% Note: Fuel is only consumed when load > 0
PDG_only = PL;  
fuel_DG_only = zeros(N,1);
for j = 1:N
    if PDG_only(j) > 0
        fuel_DG_only(j) = a * PDG_only(j)^2 + b * PDG_only(j) + c;
    else
        fuel_DG_only(j) = 0;
    end
end
total_fuel_DG_only = sum(fuel_DG_only);
cost_DG_only = Cf * total_fuel_DG_only;

% Calculate savings
fuel_saved = total_fuel_DG_only - total_fuel;
cost_saved = cost_DG_only - fval;
percent_saved = (fuel_saved / total_fuel_DG_only) * 100;

fprintf('Savings Summary (Compared to DG-Only):\n');
fprintf('  Fuel saved: %.4f L (%.2f%%)\n', fuel_saved, percent_saved);
fprintf('  Cost saved: $%.4f\n\n', cost_saved);

%% 11. VISUALIZATION
figure('Position', [100 100 1200 800]);

% Create time vector representing hours for x-axis
time_hours = dt:dt:(N*dt); 

% Subplot 1: Power dispatch
subplot(3,1,1);
bar_data = [PDG_opt, PBat_opt, PPV, PWT];
bar(time_hours, bar_data, 'stacked');
hold on;
plot(time_hours, PL, 'r-o', 'LineWidth', 2, 'MarkerSize', 5);
hold off;
xlabel('Time [Hours]');
ylabel('Power [kW]');
title(['Optimal Power Dispatch (24 Hours) - ' upper(scenario) ' Scenario']);
legend('P_{DG}', 'P_{Bat}', 'P_{PV}', 'P_{WT}', 'Load', 'Location', 'bestoutside');
grid on;
xlim([0 24.5]);
xticks(0:2:24);

% Subplot 2: Battery SOC
subplot(3,1,2);
plot(time_hours, SOC*100, 'b-o', 'LineWidth', 2, 'MarkerSize', 5);
hold on;
yline(SOC_min*100, 'r--', 'LineWidth', 1.5, 'Label', 'SOC_{min}');
yline(SOC_max*100, 'g--', 'LineWidth', 1.5, 'Label', 'SOC_{max}');
hold off;
xlabel('Time [Hours]');
ylabel('SOC [%]');
title(['Battery State of Charge - ' upper(scenario) ' Scenario']);
ylim([SOC_min*100-5, SOC_max*100+5]);
xlim([0 24.5]);
xticks(0:2:24);
grid on;

% Subplot 3: Fuel consumption comparison
subplot(3,1,3);
bar_data_fuel = [fuel_DG_only, fuel_consumption];
bar(time_hours, bar_data_fuel);
xlabel('Time [Hours]');
ylabel('Fuel Consumption [L]');
title('Fuel Consumption Comparison: DG-Only vs Hybrid System');
legend('DG-Only', 'Hybrid (Optimized)', 'Location', 'bestoutside');
xlim([0 24.5]);
xticks(0:2:24);
grid on;

% Save figure
fig_filename = ['optimization_results_24h_' scenario '.png'];
saveas(gcf, fig_filename);
fprintf('Figure saved as: %s\n\n', fig_filename);
fprintf('==================================================\n');
fprintf('PROGRAM COMPLETED SUCCESSFULLY\n');
fprintf('==================================================\n');