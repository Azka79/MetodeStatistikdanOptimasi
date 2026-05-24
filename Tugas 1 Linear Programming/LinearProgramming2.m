%% ========================================================================
%  LINEAR PROGRAMMING MODEL - SECTION 3.2
%  Hillier & Lieberman
%  Demonstrasi:
%   1. Feasible Solution
%   2. Infeasible Solution
%   3. CPF Solution
%   4. Multiple Optimal Solution
%   5. Unbounded Solution
%   6. No Feasible Solution
%% ========================================================================

clear; clc; close all;

fprintf('========================================================\n');
fprintf('        SECTION 3.2 - LINEAR PROGRAMMING MODEL\n');
fprintf('========================================================\n\n');

%% ========================================================================
%% 1. STANDARD FORM LINEAR PROGRAMMING
%% ========================================================================

fprintf('1. STANDARD FORM LP MODEL\n\n');

fprintf('Maximize Z = 3x1 + 5x2\n\n');

fprintf('Subject to:\n');
fprintf('x1 <= 4\n');
fprintf('2x2 <= 12\n');
fprintf('3x1 + 2x2 <= 18\n');
fprintf('x1, x2 >= 0\n\n');

%% Parameter LP

f = [-3; -5];

A = [1 0;
     0 2;
     3 2];

b = [4;
     12;
     18];

lb = [0;0];

%% Solve LP

[x,fval,exitflag] = linprog(f,A,b,[],[],lb,[]);

Z = -fval;

fprintf('Optimal Solution:\n');
fprintf('x1 = %.2f\n',x(1));
fprintf('x2 = %.2f\n',x(2));
fprintf('Z  = %.2f\n\n',Z);

%% ========================================================================
%% 2. FEASIBLE DAN INFEASIBLE SOLUTION
%% ========================================================================

fprintf('========================================================\n');
fprintf('2. FEASIBLE VS INFEASIBLE SOLUTION\n');
fprintf('========================================================\n\n');

% Contoh feasible solution
x_feasible = [2;3];

check1 = A*x_feasible <= b;

fprintf('Feasible Solution Test:\n');
fprintf('x = [2 ; 3]\n');

if all(check1)
    fprintf('STATUS: FEASIBLE SOLUTION\n\n');
else
    fprintf('STATUS: INFEASIBLE SOLUTION\n\n');
end

% Contoh infeasible solution
x_infeasible = [4;4];

check2 = A*x_infeasible <= b;

fprintf('Infeasible Solution Test:\n');
fprintf('x = [4 ; 4]\n');

if all(check2)
    fprintf('STATUS: FEASIBLE\n\n');
else
    fprintf('STATUS: INFEASIBLE SOLUTION\n\n');
end

%% ========================================================================
%% 3. CORNER POINT FEASIBLE (CPF)
%% ========================================================================

fprintf('========================================================\n');
fprintf('3. CORNER POINT FEASIBLE (CPF)\n');
fprintf('========================================================\n\n');

cpf = [
    0 0;
    4 0;
    4 3;
    2 6;
    0 6
];

fprintf('CPF Points:\n\n');

fprintf('Point\t\tZ\n');
fprintf('----------------------\n');

for i = 1:size(cpf,1)

    x1 = cpf(i,1);
    x2 = cpf(i,2);

    Zcpf = 3*x1 + 5*x2;

    fprintf('(%.0f,%.0f)\t\t%.2f\n',x1,x2,Zcpf);

end

fprintf('\nOptimal CPF = (2,6)\n');
fprintf('Maximum Z = 36\n\n');

%% ========================================================================
%% 4. MULTIPLE OPTIMAL SOLUTION
%% ========================================================================

fprintf('========================================================\n');
fprintf('4. MULTIPLE OPTIMAL SOLUTION\n');
fprintf('========================================================\n\n');

fprintf('Modified Objective Function:\n');
fprintf('Maximize Z = 3x1 + 2x2\n\n');

f_multi = [-3; -2];

[xm,fm] = linprog(f_multi,A,b,[],[],lb,[]);

Zm = -fm;

fprintf('One Optimal Solution Found:\n');
fprintf('x1 = %.2f\n',xm(1));
fprintf('x2 = %.2f\n',xm(2));
fprintf('Z  = %.2f\n\n',Zm);

fprintf('NOTE:\n');
fprintf('Infinite optimal solutions exist\n');
fprintf('along the line segment between:\n');
fprintf('(2,6) and (4,3)\n\n');

%% ========================================================================
%% 5. UNBOUNDED SOLUTION
%% ========================================================================

fprintf('========================================================\n');
fprintf('5. UNBOUNDED SOLUTION\n');
fprintf('========================================================\n\n');

% Constraint dikurangi
A_unbounded = [1 0];
b_unbounded = [4];

[xu,fu,exitflag_u,output_u] = linprog(f,A_unbounded,b_unbounded,[],[],lb,[]);

fprintf('Exitflag = %d\n',exitflag_u);

if exitflag_u == -3
    fprintf('STATUS: UNBOUNDED SOLUTION\n');
    fprintf('Objective function can increase indefinitely\n\n');
end

%% ========================================================================
%% 6. NO FEASIBLE SOLUTION
%% ========================================================================

fprintf('========================================================\n');
fprintf('6. NO FEASIBLE SOLUTION\n');
fprintf('========================================================\n\n');

% Tambah constraint baru:
% 3x1 + 5x2 >= 50

A_nf = [
    1 0;
    0 2;
    3 2;
   -3 -5
];

b_nf = [
    4;
    12;
    18;
   -50
];

[xnf,fnf,exitflag_nf,output_nf] = linprog(f,A_nf,b_nf,[],[],lb,[]);

fprintf('Exitflag = %d\n',exitflag_nf);

if exitflag_nf == -2
    fprintf('STATUS: NO FEASIBLE SOLUTION\n');
    fprintf('No point satisfies all constraints\n\n');
end

%% ========================================================================
%% 7. KESIMPULAN
%% ========================================================================

fprintf('========================================================\n');
fprintf('KESIMPULAN SECTION 3.2\n');
fprintf('========================================================\n\n');

fprintf('Linear Programming memiliki konsep:\n\n');

fprintf('1. Feasible Solution\n');
fprintf('2. Infeasible Solution\n');
fprintf('3. Feasible Region\n');
fprintf('4. CPF Solution\n');
fprintf('5. Multiple Optimal Solution\n');
fprintf('6. Unbounded Solution\n');
fprintf('7. No Feasible Solution\n\n');

fprintf('Optimal solution LP selalu berada pada CPF\n');
fprintf('jika feasible region bounded.\n\n');