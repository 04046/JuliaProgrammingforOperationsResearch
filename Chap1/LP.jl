#= 
   Define a simple LP problem for demonstration purposes
   Author: 
   Date: 2024-9-4
        max x + 2*y +5z
 s.t.  -x + y +3z <= -5
        x + 3y -7z <= 10
        0 <= x <= 10, y >= 0, z >= 0
=# 

## Approach (1): direct form
using JuMP, GLPK
# 准备一个优化模型
model = Model(GLPK.Optimizer)
# 声明变量
@variable(model, 0 <= x <= 10)
@variable(model, y >= 0)
@variable(model, z >= 0)
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
# 打印最优对偶变量
println("Dual Value =")
println("DualCons1=", JuMP.shadow_price(cons1))
println("DualCons2=", JuMP.shadow_price(cons2))
# 注: 上述代码适合简单LP问题，约束较多时代码比较繁琐

## Approach (2): array form
using JuMP, Gurobi
model = Model(Gurobi.Optimizer)
#      sum_{i=1:3} c_{i}*x_{i}
# s.t. Ax <= b
c = [1; 2; 5]
A = [-1 1 3; 1 3 -7]
b = [-5 10]
@variable(model, x[1:3] >= 0)
@objective(model, Max, sum(c[i]*x[i] for i in 1:3))
@constraint(model, cons[j in 1:2], sum(A[j,i]*x[i] for i in 1:3) <= b[j])
@constraint(model, bound, x[1] <= 10)
JuMP.optimize!(model)

println("Optimize Value =")
for i in 1:3
    println("x[$i] =", JuMP.value(x[i]))
end

println("Dual Value =")
for j in 1:2
    println("Dual[$j] =", JuMP.shadow_price(cons[j]))
end
# 注: 上述代码如果想解决同一个结构的另一个问题，改变索引只能手动改变所有的数字3和2，很乏味且容易出现Bug

## Approach (3): standard form
using JuMP, CPLEX
model = Model(CPLEX.Optimizer)
#      sum_{i=1:3} c_{i}*x_{i}
# s.t. Ax <= b
c = [1; 2; 5]
A = [-1 1 3; 1 3 -7]
b = [-5 10]
index_x = 1:3
index_cons = 1:2
@variable(model, x[index_x] >= 0)
@objective(model, Max, sum(c[i]*x[i] for i in index_x))
@constraint(model, cons[j in index_cons], sum(A[j,i]*x[i] for i in index_x) <= b[j])
@constraint(model, bound, x[1] <= 10)
JuMP.optimize!(model)

println("Optimize Value =")
for i in index_x
    println("x[$i] =", JuMP.value(x[i]))
end

println("Dual Value =")
for j in index_cons
    println("Dual[$j] =", JuMP.shadow_price(cons[j]))
end 