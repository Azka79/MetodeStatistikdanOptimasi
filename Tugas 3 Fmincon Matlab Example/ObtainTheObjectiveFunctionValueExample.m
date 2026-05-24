%[text] # Obtain the Objective Function Value
%[text] Call `fmincon` with the `fval` output to obtain the value of the objective function at the solution.
%[text] The [Bound Constraints](docid:optim_ug#busowz9-1) example shows two solutions. Which is better? Run the example requesting the `fval` output as well as the solution.
fun = @(x)1+x(1)./(1+x(2)) - 3*x(1).*x(2) + x(2).*(1+x(1));
lb = [0,0];
ub = [1,2];
A = [];
b = [];
Aeq = [];
beq = [];
x0 = (lb + ub)/2;
[x,fval] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub) %[output:06d9b68e] %[output:71846a4a] %[output:21708a14]
%[text] Run the problem using a different starting point `x0`.
x0 = x0/5;
[x2,fval2] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub) %[output:6d0299da] %[output:650c95aa] %[output:56dcc5c9]
%[text] This solution has an objective function value `fval2` = 1, which is higher than the first value `fval` = –0.6667. The first solution `x` has a lower local minimum objective function value.
%[text] *Copyright 2019 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[output:06d9b68e]
%   data: {"dataType":"text","outputData":{"text":"\n<a href = \"matlab: helpview('optim','local_min_found','CSHelpWindow');\">Local minimum found that satisfies the constraints<\/a>.\n\nOptimization completed because the objective function is non-decreasing in \n<a href = \"matlab: helpview('optim','feasible_directions','CSHelpWindow');\">feasible directions<\/a>, to within the value of the <a href = \"matlab: helpview('optim','optimality_tolerance_msgcsh','CSHelpWindow');\">optimality tolerance<\/a>,\nand constraints are satisfied to within the value of the <a href = \"matlab: helpview('optim','constraint_tolerance','CSHelpWindow');\">constraint tolerance<\/a>.\n\n<<a href = \"matlab: createExitMsg({'optimlib:sqpLineSearch:Exit1basic'},{'optimlib:sqpLineSearch:Exit1detailed','2.181818e-08','1.000000e-06','0.000000e+00','1.000000e-06'},true,true);;\">stopping criteria details<\/a>>\n","truncated":false}}
%---
%[output:71846a4a]
%   data: {"dataType":"matrix","outputData":{"columns":2,"name":"x","rows":1,"type":"double","value":[["1.0000","2.0000"]]}}
%---
%[output:21708a14]
%   data: {"dataType":"textualVariable","outputData":{"name":"fval","value":"-0.6667"}}
%---
%[output:6d0299da]
%   data: {"dataType":"text","outputData":{"text":"\n<a href = \"matlab: helpview('optim','local_min_found','CSHelpWindow');\">Local minimum found that satisfies the constraints<\/a>.\n\nOptimization completed because the objective function is non-decreasing in \n<a href = \"matlab: helpview('optim','feasible_directions','CSHelpWindow');\">feasible directions<\/a>, to within the value of the <a href = \"matlab: helpview('optim','optimality_tolerance_msgcsh','CSHelpWindow');\">optimality tolerance<\/a>,\nand constraints are satisfied to within the value of the <a href = \"matlab: helpview('optim','constraint_tolerance','CSHelpWindow');\">constraint tolerance<\/a>.\n\n<<a href = \"matlab: createExitMsg({'optimlib:sqpLineSearch:Exit1basic'},{'optimlib:sqpLineSearch:Exit1detailed','4.000001e-07','1.000000e-06','0.000000e+00','1.000000e-06'},true,true);;\">stopping criteria details<\/a>>\n","truncated":false}}
%---
%[output:650c95aa]
%   data: {"dataType":"matrix","outputData":{"columns":2,"exponent":"-6","name":"x2","rows":1,"type":"double","value":[["0.4000","0.4000"]]}}
%---
%[output:56dcc5c9]
%   data: {"dataType":"textualVariable","outputData":{"name":"fval2","value":"1.0000"}}
%---
