# flaschenpostMILP.jl.jl
# Julia Script

#=
Description: 
Author: konstantin
Date: 18.08.26
=#

module flaschenpostMILP

using JuMP
using HiGHS

export main

function main()
    model = Model(HiGHS.Optimizer)
    @variable(model, x>=0)
    @objective(model, Min, x)
    optimize!(model)
    println("Hello, Julia!")
    return value(x)
end

end