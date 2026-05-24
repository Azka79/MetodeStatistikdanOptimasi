%[text] # Nonlinear Constraints
%[text] Find the minimum of a function subject to nonlinear constraints
%[text] Find the point where Rosenbrock's function is minimized within a circle, also subject to bound constraints.
fun = @(x)100*(x(2)-x(1)^2)^2 + (1-x(1))^2;  
%%
%[text] Look within the region $0 \\le x(1) \\le 0.5$, $0.2 \\le x(2) \\le 0.8$.
lb = [0,0.2];
ub = [0.5,0.8];  
%%
%[text] Also look within the circle centered at \[1/3,1/3\] with radius 1/3. Use this code for the nonlinear constraint function.
function [ineqnonlin,eqnonlin] = circlecon(x)
ineqnonlin = (x(1)-1/3)^2 + (x(2)-1/3)^2 - (1/3)^2;
eqnonlin = [];
end
%[text] There are no linear constraints, so set those arguments to `[]`.
A = [];
b = [];
Aeq = [];
beq = [];  
%%
%[text] Choose an initial point satisfying all the constraints.
x0 = [1/4,1/4];  
%%
%[text] Solve the problem.
nonlcon = @circlecon;
x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon)    %[output:200a0d93] %[output:1015f8e7]
%%
%[text] *Copyright 2015-2024 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[output:200a0d93]
%   data: {"dataType":"text","outputData":{"text":"\n<a href = \"matlab: helpview('optim','local_min_found','CSHelpWindow');\">Local minimum found that satisfies the constraints<\/a>.\n\nOptimization completed because the objective function is non-decreasing in \n<a href = \"matlab: helpview('optim','feasible_directions','CSHelpWindow');\">feasible directions<\/a>, to within the value of the <a href = \"matlab: helpview('optim','optimality_tolerance_msgcsh','CSHelpWindow');\">optimality tolerance<\/a>,\nand constraints are satisfied to within the value of the <a href = \"matlab: helpview('optim','constraint_tolerance','CSHelpWindow');\">constraint tolerance<\/a>.\n\n<<a href = \"matlab: createExitMsg({'optimlib:sqpLineSearch:Exit1basic'},{'optimlib:sqpLineSearch:Exit1detailed','1.605029e-08','1.000000e-06','0.000000e+00','1.000000e-06'},true,true);;\">stopping criteria details<\/a>>\n","truncated":false}}
%---
%[output:1015f8e7]
%   data: {"dataType":"matrix","outputData":{"columns":2,"name":"x","rows":1,"type":"double","value":[["0.5000","0.2500"]]}}
%---
