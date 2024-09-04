# Define a simple LP problem for demonstration purposes
# Author: 
# Date: 2024-9-4
#        max x + 2*y +5z
# s.t.  -x + y +3z <= -5
#        x + 3y -7z <= 10
#        0 <= x <= 10, y >= 0, z >= 0

using JuMP, GLPK
## 准备一个优化模型
model = Model(GLPK.Optimizer)
# 声明变量
@variable(model, 0 <= x <= 10)
@variable(model, y >= 0)
@variable(model, z >= 0)
# 设置目标函数
@objective(model, Max, x + 2y + 5z)
# 添加约束
@constraint(model, -x + y +3z <= -5)
@constraint(model, x + 3y -7z <= 10)
return model
# 求解模型
JuMP.optimize!(model)

println("Optimize Value")
println("X=", JuMP.value(x))
println("Y=", JuMP.value(y))
println("Z=", JuMP.value(z))