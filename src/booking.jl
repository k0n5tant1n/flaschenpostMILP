# booking.jl.jl
# Julia Script

#=
Description: 
Author: konstantin
Date: 23.08.26
=#

struct Booking
    ID::Int
    timestamp::DateTime
    location::GeoCoordinate
    delivery_time_window::Tuple{DateTime,DateTime}
end
