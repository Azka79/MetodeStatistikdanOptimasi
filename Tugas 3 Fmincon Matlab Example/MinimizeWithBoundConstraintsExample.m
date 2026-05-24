%[text] # Minimize with Bound Constraints
%[text] Find the minimum of an objective function in the presence of bound constraints.
%[text] The objective function is a simple algebraic function of two variables.
fun = @(x)1+x(1)/(1+x(2)) - 3*x(1)*x(2) + x(2)*(1+x(1));
%[text] Look in the region where $x$ has positive values, $x(1) \\le 1$, and $x(2) \\le 2$.
lb = [0,0];
ub = [1,2];
%[text] The problem has no linear constraints, so set those arguments to `[]`.
A = [];
b = [];
Aeq = [];
beq = [];
%[text] Try an initial point in the middle of the region.
x0 = (lb + ub)/2;
%[text] Solve the problem.
x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub) %[output:05ac8446] %[output:51bf9f23]
%[text] A different initial point can lead to a different solution.
x0 = x0/5;
x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub) %[output:49c9d60e] %[output:1da28d79]
%[text] To determine which solution is better, see [Obtain the Objective Function Value](docid:optim_ug#busow0w-1).
%[text] *Copyright 2019 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[output:05ac8446]
%   data: {"dataType":"text","outputData":{"text":"\n<a href = \"matlab: helpview('optim','local_min_found','CSHelpWindow');\">Local minimum found that satisfies the constraints<\/a>.\n\nOptimization completed because the objective function is non-decreasing in \n<a href = \"matlab: helpview('optim','feasible_directions','CSHelpWindow');\">feasible directions<\/a>, to within the value of the <a href = \"matlab: helpview('optim','optimality_tolerance_msgcsh','CSHelpWindow');\">optimality tolerance<\/a>,\nand constraints are satisfied to within the value of the <a href = \"matlab: helpview('optim','constraint_tolerance','CSHelpWindow');\">constraint tolerance<\/a>.\n\n<<a href = \"matlab: createExitMsg({'optimlib:sqpLineSearch:Exit1basic'},{'optimlib:sqpLineSearch:Exit1detailed','2.181818e-08','1.000000e-06','0.000000e+00','1.000000e-06'},true,true);;\">stopping criteria details<\/a>>\n","truncated":false}}
%---
%[output:51bf9f23]
%   data: {"dataType":"matrix","outputData":{"columns":2,"name":"x","rows":1,"type":"double","value":[["1.0000","2.0000"]]}}
%---
%[output:49c9d60e]
%   data: {"dataType":"text","outputData":{"text":"\n<a href = \"matlab: helpview('optim','local_min_found','CSHelpWindow');\">Local minimum found that satisfies the constraints<\/a>.\n\nOptimization completed because the objective function is non-decreasing in \n<a href = \"matlab: helpview('optim','feasible_directions','CSHelpWindow');\">feasible directions<\/a>, to within the value of the <a href = \"matlab: helpview('optim','optimality_tolerance_msgcsh','CSHelpWindow');\">optimality tolerance<\/a>,\nand constraints are satisfied to within the value of the <a href = \"matlab: helpview('optim','constraint_tolerance','CSHelpWindow');\">constraint tolerance<\/a>.\n\n<<a href = \"matlab: createExitMsg({'optimlib:sqpLineSearch:Exit1basic'},{'optimlib:sqpLineSearch:Exit1detailed','4.000001e-07','1.000000e-06','0.000000e+00','1.000000e-06'},true,true);;\">stopping criteria details<\/a>>\n","truncated":false}}
%---
%[output:1da28d79]
%   data: {"dataType":"matrix","outputData":{"columns":2,"exponent":"-6","name":"x","rows":1,"type":"double","value":[["0.4000","0.4000"]]}}
%---
