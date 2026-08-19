# flaschenpost route optimization
Project `flaschenpostMILP` lives for modeling and solving the route optimization
problem of flaschenpost. The julia script flaschenpostMILP.jl exports method 
`build_method()` to build an optimization model with JuMP incorporating the 
following variables and constraints.

## Variables
- Adjacency matrix `A` binary activating travel edge from location i to j. 
- Arrival times `t` for every delivery location (and depot return).

## Constraints
- **Tour constraints** - Forcing deg(node)=2 to stop at every location only once.
- **Travel time constraints** - Using distance matrix (and location service time) 
to establish well-ordered and realistic arrival times for delivery at every 
location (and return to depot).
- **Delivery time windows** - Use calculated arrival times to meet all customers'
time window requests for delivery.

The tour constraints for itself would not be sufficient to get practical useful
tours (without subtours). But together with constraints on ordered arrival times
(and `location_service_time > 0`) the results meet (most of) all requirements 
for a realistic flaschenpost scenario.