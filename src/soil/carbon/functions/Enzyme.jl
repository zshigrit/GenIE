## 3 developing functions: enzymes

function EnzymeProduction(par::SoilPar,pools::Pools)
    @unpack pENZP, Vm, pENZM = par
    @unpack MBA,POMo,POMh = pools 
    
    frPOMh = POMh/(POMh + POMo)
    mba_enzph = frPOMh * pENZP * Vm * MBA
    mba_enzpo = (1-frPOMh) * pENZP * Vm * MBA
    mba_enzm =  pENZM * Vm * MBA
    return mba_enzph, mba_enzpo, mba_enzm 
end 

function EnzymeTurnover(par::SoilPar,pools::Pools)
    epo_dom = par.rENZPo * pools.EPO
    eph_dom = par.rENZPh * pools.EPH
    em_dom  = par.rENZM * pools.EM
    return epo_dom,eph_dom,em_dom
end

# """ enzymes for mineral nitrogen cycling """

# function EnzymeProduction(par::SoilPar,pools::Pools)
#     @unpack pENZP, Vm, pENZM = par
#     @unpack MBA,POMo,POMh = pools 
    
#     frPOMh = POMh/(POMh + POMo)
#     mba_enzph = frPOMh * pENZP * Vm * MBA
#     mba_enzpo = (1-frPOMh) * pENZP * Vm * MBA
#     mba_enzm =  pENZM * Vm * MBA
#     return mba_enzph, mba_enzpo, mba_enzm 
# end 