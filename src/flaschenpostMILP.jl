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
    locations = 1:2
    N = length(locations)

    # Adjacency matrix A of locations to code tours. a_ij = 1 means to travel from stop i to j
    @variable(model, A[locations,locations], Bin)
    # Every stop is start and end of a traveled edge exactly once
    @constraint(model, [i in locations], sum(A[i,:]) == 1)
    @constraint(model, [j in locations], sum(A[:,j]) == 1)

    # Stop arrival times t for modeling travel distance and delivery time windows
    @variable(model, t[locations] >= 0)
    dist=[0 2; 2 0]
    unloading_service_minutes = 5
    # Stop arrival is limited by predecessor departure accounting also for travel and service time. Use bigM formulation
    # to activate restriction between stops i,j only in case of choosing to travel from i to j, that is A[i,j]=1.
    bigM = maximum(dist) + 60*24 + unloading_service_minutes
    @constraint(model, [j in locations], t[j] >= dist[1,j] - (1-A[1,j])*bigM)                 # starting from depot
    @constraint(model, [i in locations[2:N], j in locations],
                        t[j] >= t[i]+dist[i,j]+unloading_service_minutes - (1-A[i,j])*bigM)   # starting everywhere else

    @objective(model, Min, t[1])
    optimize!(model)
    return value(t[1])
end

end