#= 
   Define a simple LP problem for demonstration purposes
   Author: Xiang
   Date: 2024-9-5
        max x + 2*y +5z
 s.t.  -x + y +3z <= -5
        x + 3y -7z <= 10
        0 <= x <= 10, y 为非负整数, z \in {0,1}
=# 

## Approach (1): direct form
using JuMP, GLPK
# 准备一个优化模型
model = Model(GLPK.Optimizer)
# 声明变量
@variable(model, 0 <= x <= 10)
@variable(model, y >= 0, Int)
@variable(model, z >= 0, Bin)
# 设置目标函数
@objective(model, Max, x + 2y + 5z)
# 添加约束
@constraint(model, cons1, -x + y +3z <= -5)
@constraint(model, cons2, x + 3y -7z <= 10)
return model
# 求解模型
JuMP.optimize!(model)
# 打印最优解
println("Optimize Value =")
println("X=", JuMP.value(x))
println("Y=", JuMP.value(y))
println("Z=", JuMP.value(z))
# 注: JuMP指定整数型变量和二元变量比较简单