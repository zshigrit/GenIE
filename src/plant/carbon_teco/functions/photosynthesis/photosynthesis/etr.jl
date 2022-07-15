
const _θj = 0.9

"""
note: alpha here is quantum use efficiency (how many electrons per photon)
"""

function leaf_ETR(
    leaf::Leaf{FT}
)
    @unpack α, APAR, Jmax, J = leaf; 

    a = FT(_θj);
    b = α*APAR + Jmax; 
    c = α*APAR*Jmax;

    if b^FT(2.0) - FT(4.0)*a*c >= FT(0)
        J = (b-sqrt(b^FT(2.0) - FT(4.0)*a*c))/(FT(2.0)*a)
    else
        J = b/(FT(2.0)*a)
    end

    leaf.J = J 

    return nothing

end 