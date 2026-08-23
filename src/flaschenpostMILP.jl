# flaschenpostMILP.jl.jl
# Julia Script

#=
Description: 
Author: konstantin
Date: 18.08.26
=#

module flaschenpostMILP

using JuMP
using Dates

include("model_data.jl")
include("geo_coordinate.jl")
include("booking.jl")
include("vehicle.jl")

export ModelData
export GeoCoordinate
export Booking
export Vehicle
export build_model

function build_model(model_data::ModelData)
    model = Model()
    N = model_data.location_count
    locations = 1:N
    time_windows = model_data.time_windows
    dist = model_data.distance_matrix
    location_service_time = model_data.location_service_time

    # Adjacency matrix A of locations to code tours. a_ij = 1 means to travel from stop i to j
    @variable(model, A[locations,locations], Bin)
    # Every stop is start and end of a traveled edge exactly once
    @constraint(model, [i in locations], sum(A[i,:]) == 1)
    @constraint(model, [j in locations], sum(A[:,j]) == 1)

    # Stop arrival times t for modeling travel distance and delivery time windows
    @variable(model, t[locations] ≥ 0)
    # Stop arrival is limited by predecessor departure accounting also for travel and service time. Use bigM formulation
    # to activate restriction between stops i,j only in case of choosing to travel from i to j, that is A[i,j]=1.
    bigM = maximum(dist) + 60*24 + location_service_time
    @constraint(model, [j in locations], t[j] ≥ dist[1,j] - (1-A[1,j])*bigM)                 # starting from depot
    @constraint(model, [i in locations[2:N], j in locations],
                        t[j] ≥ t[i]+dist[i,j]+ location_service_time - (1-A[i,j])*bigM)   # starting everywhere else

    # Delivery time windows have to be met by arrival times
    @constraint(model, [i in locations[2:N]], time_windows[i][1] ≤ t[i] ≤ time_windows[i][2])

    # Optimize on earliest possible return to depot which implies shortest tour duration
    @objective(model, Min, t[1])
    return model
end

end