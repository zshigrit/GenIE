module test1

#export test_a,test_b

include("a.jl")
include("b.jl")

 println(test_a(1,3)+test_b(2,3))
end 
