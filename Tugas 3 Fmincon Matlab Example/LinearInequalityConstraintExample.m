%[text] # Linear Inequality Constraint
%[text] Find the minimum value of Rosenbrock's function when there is a linear inequality constraint. 
%[text] Set the objective function `fun` to be Rosenbrock's function. Rosenbrock's function is well-known to be difficult to minimize. It has its minimum objective value of 0 at the point (1,1). For more information, see [Solve a Constrained Nonlinear Problem](docid:optim_ug.brg0p3g-1). 
fun = @(x)100*(x(2)-x(1)^2)^2 + (1-x(1))^2;
%%
%[text] Find the minimum value starting from the point `[-1,2]`, constrained to have $x(1) + 2x(2) \\le 1$. Express this constraint in the form `Ax <= b` by taking `A = [1,2]` and `b = 1`. Notice that this constraint means that the solution will not be at the unconstrained solution (1,1), because at that point $x(1) + 2x(2) = 3 \> 1$.
x0 = [-1,2];
A = [1,2];
b = 1;
x = fmincon(fun,x0,A,b) %[output:34820c17] %[output:159c473f]
%[text] *Copyright 2015 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[output:34820c17]
%   data: {"dataType":"text","outputData":{"text":"\n<a href = \"matlab: helpview('optim','local_min_found','CSHelpWindow');\">Local minimum found that satisfies the constraints<\/a>.\n\nOptimization completed because the objective function is non-decreasing in \n<a href = \"matlab: helpview('optim','feasible_directions','CSHelpWindow');\">feasible directions<\/a>, to within the value of the <a href = \"matlab: helpview('optim','optimality_tolerance_msgcsh','CSHelpWindow');\">optimality tolerance<\/a>,\nand constraints are satisfied to within the value of the <a href = \"matlab: helpview('optim','constraint_tolerance','CSHelpWindow');\">constraint tolerance<\/a>.\n\n<<a href = \"matlab: createExitMsg({'optimlib:sqpLineSearch:Exit1basic'},{'optimlib:sqpLineSearch:Exit1detailed','8.020761e-08','1.000000e-06','0.000000e+00','1.000000e-06'},true,true);;\">stopping criteria details<\/a>>\n","truncated":false}}
%---
%[output:159c473f]
%   data: {"dataType":"matrix","outputData":{"columns":2,"name":"x","rows":1,"type":"double","value":[["0.5022","0.2489"]]}}
%---
