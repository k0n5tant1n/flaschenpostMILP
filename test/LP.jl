# LP.jl.jl
# Julia Script

#=
Description: 
Author: konstantin
Date: 16.08.26
=#

using JuMP
using HiGHS

model = Model(HiGHS.Optimizer)

@variable(model, x >= 0)
@variable(model, y >= 0)

@constraint(model, x + y <= 10)
@constraint(model, 2x + y <= 16)

@objective(model, Max, 3x + 2y)

optimize!(model)

println("x = ", value(x))
println("y = ", value(y))
println("Optimum = ", objective_value(model))