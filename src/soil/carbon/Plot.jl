## data processing

# df = Dict("output_ly_con" => output_ly_con,
#         "output_ly_dec" => output_ly_dec,
#         "output_ly_inc" => output_ly_inc)

# output_ly_scenarios = ["output_ly_con","output_ly_dec","output_ly_inc"]
# output_ly = df["output_ly_con"]

output_ly_con[:,"SOM"] = output_ly_con[:,"POMh"] + output_ly_con[:,"POMo"] + output_ly_con[:,"MOM"];
output_ly_dec[:,"SOM"] = output_ly_dec[:,"POMh"] + output_ly_dec[:,"POMo"] + output_ly_dec[:,"MOM"];
output_ly_inc[:,"SOM"] = output_ly_inc[:,"POMh"] + output_ly_inc[:,"POMo"] + output_ly_inc[:,"MOM"];


