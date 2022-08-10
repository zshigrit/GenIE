---
marp: true
---

# running nitrogenlimitation!()
1. comment out three lines for computing nitrogen_supply to  test code; make nitrogen_supply = 0.85*nitrogen_demand; **need to convert $\Delta$LAI from daily to hourly (dividing 24)**
2. works; now connect nitrogen_supply with soil N module
   1). nitrogen uptake is between -0.4 g/m2 to 0.4 g/m2 on a hourly interval;checking with soil nitrogen uptake in MEND; 
   2). in MEND Nim_VG (**max**) = 1.00878e-05 'mgC-cm3-h' => 0.01 g/m2/hour;
   3). the LAI might be too large (8) for nitrogen uptake; anyway continue to link canopy gpp to MEND and nitrogen uptake from MEND to leaf to modify Vm25; **"be ware of unit conversion"**

## test


Table example
| Syntax | Description |
| ----------- | ----------- |
| Header | Title |
| Paragraph | Text |
