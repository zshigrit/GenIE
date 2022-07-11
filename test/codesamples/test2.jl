module test2

#println(tt1(1,3))

include("test1.jl")
# using .test1:test_a,test_b
import .test1: test_a as tt1
import .test1: test_b as tt2


println(tt1(1,3))
println(tt2(1,2))
end 
