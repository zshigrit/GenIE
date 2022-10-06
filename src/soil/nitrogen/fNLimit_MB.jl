function fNLimit_MB(MB_CN,MB_CN_min,MB_CN_max,wexp)
    #!!Nitrogen limitation level of microbes
    #!!higher MB_CN, higher fNLimit_MB, higher N limitation 
    # wexp !!exponential, >=1

    if MB_CN > MB_CN_max 
        CN = MB_CN_max
    elseif MB_CN < MB_CN_min
        CN = MB_CN_min
    else
        CN = MB_CN
    end #if
            
    fNLimit_MB = ((CN - MB_CN_min)/(MB_CN_max - MB_CN_min))^wexp
    
    return fNLimit_MB
end


