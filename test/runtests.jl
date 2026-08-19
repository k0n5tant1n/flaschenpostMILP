# flaschenpostMILPTest Tests

using Test
using flaschenpostMILP
using JuMP
using HiGHS
import MathOptInterface as MOI

include("testGraphs/graphviz.jl")
include("testGraphs/tikz.jl")

time_windows = Tuple{Int, Int}[]
push!(time_windows, (0, 0))     # unused dummy time window of depot to enhance readability of time window constraint
push!(time_windows, (3, 123))
one_location_feasible = Dict(
    "location_service_time" => 5,
    "locations" => 1:2,
    "time_windows" => time_windows,
    "distance_matrix" => [0 2; 2 0]
    )

@testset "One location feasible tests" begin
    @testset "Objective Value Tests" begin
        model = build_model(one_location_feasible)
        set_silent(model)
        set_optimizer(model, () -> HiGHS.Optimizer())
        optimize!(model)
        export_graphviz("./testGraphs/OneLocationFeasible.dot", one_location_feasible, model[:A], model[:t])
        export_tikz("./testGraphs/OneLocationFeasible.tex", one_location_feasible, model[:A], model[:t])
        @test is_solved_and_feasible(model) == true
        @test objective_value(model) == 10
    end

    @testset "Solution Tests" begin
        model = build_model(one_location_feasible)
        set_silent(model)
        set_optimizer(model, () -> HiGHS.Optimizer())
        optimize!(model)
        @test is_solved_and_feasible(model) == true
        A = model[:A]
        t = model[:t]
        #print(A)
        #print(t)
        @test value(A[1,2]) == 1
        @test value(A[2,1]) == 1
        @test value(t[2]) == 3
        @test value(t[1]) == 10
    end
end


time_windows = Tuple{Int, Int}[]
push!(time_windows, (0, 0))     # unused dummy time window of depot to enhance readability of time window constraint
push!(time_windows, (1, 4))
one_location_infeasible = Dict(
"location_service_time" => 5,
"locations" => 1:2,
"time_windows" => time_windows,
"distance_matrix" => [0 5; 5 0]
)

@testset "One location infeasible tests" begin
    model = build_model(one_location_infeasible)
    set_silent(model)
    set_optimizer(model, () -> HiGHS.Optimizer())
    optimize!(model)
    @test is_solved_and_feasible(model) == false
    @test termination_status(model) == MOI.INFEASIBLE
end


time_windows = Tuple{Int, Int}[]
push!(time_windows, (0, 0))     # unused dummy time window of depot to enhance readability of time window constraint
push!(time_windows, (3, 123))
push!(time_windows, (10, 130))
two_location_feasible = Dict(
"location_service_time" => 5,
"locations" => 1:3,
"time_windows" => time_windows,
"distance_matrix" => [0 5 7; 5 0 3; 7 3 0]
)

@testset "Two location feasible tests" begin
    model = build_model(two_location_feasible)
    set_silent(model)
    set_optimizer(model, () -> HiGHS.Optimizer())
    optimize!(model)
    export_graphviz("./testGraphs/TwoLocationFeasible.dot", two_location_feasible, model[:A], model[:t])
    export_tikz("./testGraphs/TwoLocationFeasible.tex", two_location_feasible, model[:A], model[:t])
    @test is_solved_and_feasible(model) == true
    A = model[:A]
    t = model[:t]
    #print(A)
    #print(t)
    @test value(A[1,2]) == 1
    @test value(A[2,3]) == 1
    @test value(A[3,1]) == 1
    @test value(t[2]) == 5
    @test value(t[3]) == 13
    @test value(t[1]) == 25
end