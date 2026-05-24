%[text] # Linear Inequality and Equality Constraint
%[text] Find the minimum value of Rosenbrock's function when there are both a linear inequality constraint and a linear equality constraint. 
%[text] Set the objective function `fun` to be Rosenbrock's function. 
fun = @(x)100*(x(2)-x(1)^2)^2 + (1-x(1))^2;
%%
%[text] Find the minimum value starting from the point `[0.5,0]`, constrained to have $x(1) + 2x(2) \\le 1$ and $2x(1) + x(2) = 1$. 
%[text] - Express the linear inequality constraint in the form `A*x <= b` by taking `A = [1,2]` and `b = 1`.
%[text] - Express the linear equality constraint in the form `Aeq*x = beq` by taking `Aeq = [2,1]` and `beq = 1`.  \
x0 = [0.5,0];
A = [1,2];
b = 1;
Aeq = [2,1];
beq = 1;
x = fmincon(fun,x0,A,b,Aeq,beq) %[output:8c343f58] %[output:8492c503]
%[text] *Copyright 2015 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[output:8c343f58]
%   data: {"dataType":"text","outputData":{"text":"\n<a href = \"matlab: helpview('optim','local_min_found','CSHelpWindow');\">Local minimum found that satisfies the constraints<\/a>.\n\nOptimization completed because the objective function is non-decreasing in \n<a href = \"matlab: helpview('optim','feasible_directions','CSHelpWindow');\">feasible directions<\/a>, to within the value of the <a href = \"matlab: helpview('optim','optimality_tolerance_msgcsh','CSHelpWindow');\">optimality tolerance<\/a>,\nand constraints are satisfied to within the value of the <a href = \"matlab: helpview('optim','constraint_tolerance','CSHelpWindow');\">constraint tolerance<\/a>.\n\n<<a href = \"matlab: createExitMsg({'optimlib:sqpLineSearch:Exit1basic'},{'optimlib:sqpLineSearch:Exit1detailed','2.000038e-08','1.000000e-06','0.000000e+00','1.000000e-06'},true,true);;\">stopping criteria details<\/a>>\n","truncated":false}}
%---
%[output:8492c503]
%   data: {"dataType":"matrix","outputData":{"columns":2,"name":"x","rows":1,"type":"double","value":[["0.4149","0.1701"]]}}
%---
