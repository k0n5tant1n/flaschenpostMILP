# testData.jl.jl
# Julia Script

#=
Description: 
Author: konstantin
Date: 23.08.26
=#

using flaschenpostMILP


######################### ONE LOCATION FEASIBLE #############################
time_windows = Tuple{Int, Int}[]
push!(time_windows, (0, 0))     # unused dummy time window of depot to enhance readability of time window constraint
push!(time_windows, (3, 123))
const ONE_LOCATION_FEASIBLE = ModelData(
    location_service_time=5,
    location_count=2,
    time_windows=time_windows,
    distance_matrix=[0 2; 2 0]
)

######################### ONE LOCATION INFEASIBLE #############################
time_windows = Tuple{Int, Int}[]
push!(time_windows, (0, 0))     # unused dummy time window of depot to enhance readability of time window constraint
push!(time_windows, (1, 4))
const ONE_LOCATION_INFEASIBLE = ModelData(
    location_service_time=5,
    location_count=2,
    time_windows=time_windows,
    distance_matrix=[0 5; 5 0]
)

######################### TWO LOCATION FEASIBLE #############################
time_windows = Tuple{Int, Int}[]
push!(time_windows, (0, 0))     # unused dummy time window of depot to enhance readability of time window constraint
push!(time_windows, (3, 123))
push!(time_windows, (10, 130))
const TWO_LOCATION_FEASIBLE = ModelData(
    location_service_time=5,
    location_count=3,
    time_windows=time_windows,
    distance_matrix=[0 5 7; 5 0 3; 7 3 0]
)