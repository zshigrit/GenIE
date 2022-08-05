module NiceStuff

export nice, DOG

struct Dog end      # singleton type, not exported

const DOG = Dog()   # named instance, exported

nice(x) = "nice $x" # function, exported

end