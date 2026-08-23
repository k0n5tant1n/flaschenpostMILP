# ModelData.jl
# Julia Script

#=
Description: 
Author: konstantin
Date: 23.08.26
=#

struct ModelData
    location_service_time::Int
    location_count::Int
    time_windows::Vector{Tuple{Int,Int}}
    distance_matrix::Matrix{Float64}

    function ModelData(;
        location_service_time::Int,
        location_count::Int,
        time_windows::Vector{Tuple{Int,Int}},
        distance_matrix::Matrix{Int})
            new(location_service_time, location_count, time_windows, distance_matrix)
    end
end