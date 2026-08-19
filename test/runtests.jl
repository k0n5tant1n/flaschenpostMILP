# flaschenpostMILPTest Tests

using Test
using flaschenpostMILP
using JuMP
using HiGHS
import MathOptInterface as MOI

time_windows = Tuple{Int, Int}[]
push!(time_windows, (0, 0))     # unused dummy time window of depot to enhance readability of time window constraint
push!(time_windows, (3, 123))
model_data_simple_feasible = Dict(
    "location_service_time" => 5,
    "locations" => 1:2,
    "time_windows" => time_windows,
    "distance_matrix" => [0 2; 2 0]
    )

time_windows = Tuple{Int, Int}[]
push!(time_windows, (0, 0))     # unused dummy time window of depot to enhance readability of time window constraint
push!(time_windows, (1, 4))
model_data_simple_infeasible = Dict(
    "location_service_time" => 5,
    "locations" => 1:2,
    "time_windows" => time_windows,
    "distance_matrix" => [0 5; 5 0]
    )

@testset "flaschenpostMILPTest Tests" begin
    @testset "Objective Value Tests" begin
        model = build_model(model_data_simple_feasible)
        set_optimizer(model, () -> HiGHS.Optimizer())
        optimize!(model)
        @test is_solved_and_feasible(model) == true
        @test objective_value(model) == 10
    end

    @testset "Solution Tests" begin
        model = build_model(model_data_simple_feasible)
        set_optimizer(model, () -> HiGHS.Optimizer())
        optimize!(model)
        @test is_solved_and_feasible(model) == true
        A = model[:A]
        t = model[:t]
        print(A)
        print(t)
        @test value(A[1,2]) == 1
        @test value(A[2,1]) == 1
        @test value(t[2]) == 3
        @test value(t[1]) == 10
    end

    @testset "Infeasible Tests" begin
        model = build_model(model_data_simple_infeasible)
        set_optimizer(model, () -> HiGHS.Optimizer())
        optimize!(model)
        @test is_solved_and_feasible(model) == false
        @test termination_status(model) == MOI.INFEASIBLE
    end
end
