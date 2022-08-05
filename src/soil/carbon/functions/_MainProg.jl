## main program
"""
note: there are in total 5 soil layers;
however, I add the 6th layer as a default for whole soil porfile
for comparison.
"""
nyear=10;ncycle=10;nlayer=5;
par_scenarios = ["con","dec","inc"]
# parameters to be added 
LF0 = 0.1
r0 = 0.01
fQOM = 0.05


# flux initilization (default values are 0s)
flux_pomo = Flux_POMo();flux_pomh = Flux_POMh();
flux_mom = Flux_MOM(); 
flux_dom = Flux_DOM(); # note: qom is wrapped in dom
flux_mba = Flux_MBA(); flux_mbd = Flux_MBD();

for par_scenario in par_scenarios
    @eval $(Symbol(:output_ly,"_",par_scenario)) = create_dataframe(AbstractFloat,nlayer);
    # output_ly = create_dataframe(AbstractFloat,nlayer);
    par_vary = @eval $(Symbol(:par,"_",par_scenario))
    output_ly = @eval $(Symbol(:output_ly,"_",par_scenario))
    

    for ilayer = 1:nlayer+1
        par = SoilPar();
        InitParDepth!(par,ilayer,par_vary)
        cpools = InitCPools(ilayer)
        input_c = InitCInputs(ilayer,par);
        ModRunDepth!(par,cpools,ilayer,output_ly,input_c,depth_output)
    end
end
