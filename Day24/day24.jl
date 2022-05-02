# Making an ALU to check a number
inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day24\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")                   # Sanitize inputs
inputs = split(inputs,"\n")

# Support functions
# Run the instructions for numeric input
function evalNumeric(instruction, inputVal1, inputVal2)
    if instruction == "add"
        return inputVal1 + inputVal2
    elseif instruction == "mul"
        return inputVal1*inputVal2
    elseif instruction == "div"
        return Int(floor(inputVal1*inputVal2))
    elseif instruction == "mod"
        return mod(inputVal1,inputVal2)
    elseif instruction == "eql"
        return inputVal1==inputVal2 ? 1 : 0
    end
end

# Run the instructions for symbolic inputs
function evalSymbolic(instruction, inputVal1, inputVal2)
    if instruction == "add"
        return join(["(",inputVal1, '+', inputVal2,")"])
    elseif instruction == "mul"
        return join(["(",inputVal1, '*', inputVal2,")"])
    elseif instruction == "div"
        return join(["(",inputVal1, '/', inputVal2,")"])
    elseif instruction == "mod"
        return join(["mod(",inputVal1, ',', inputVal2,")"])
    elseif instruction == "eql"
        return join(["(",inputVal1, "==", inputVal2,")"])
    end
end

# Read the instructions one at a time
constantVars = Dict("w" =>0, "x" => 0, "y" =>0, "z"=>0)
variableVars = Dict()
inputNum = 1
reducedInstructions = []
modifiesZ = []

for inputLine in inputs
    println(inputLine)
    entries = split(inputLine, ' ')
    inputDependent = any([occursin(x, inputLine) for x in keys(variableVars)])

    # If we're inputing a number, then this instruction depends on the sub model
    if entries[1] == "inp"
        println("contains input")
        variableVars[entries[2]] = join(["input",string(inputNum)])
        delete!(constantVars, entries[2])

    # If the instruction depends on unknown numbers, then the result is also unknown
    elseif inputDependent
        println("contains dependent variable")

        # Special cases
        if entries[1] == "mul" && entries[3] == "0"
            println("Special case, can be ignored")
            constantVars[entries[2]] = 0
            delete!(variableVars, entries[2])
            continue
        end

        # This instruction depends on the value of the sub model number
        if in(entries[3], keys(constantVars))
            entries[3] = string(constantVars[entries[3]])
        elseif in(entries[3], keys(variableVars))
            entries[3] = variableVars[entries[3]]
        end

        if in(entries[2], keys(constantVars))
            variableVars[entries[2]] = evalSymbolic(entries[1], string(constantVars[entries[2]]), entries[3])
            delete!(constantVars,entries[2])
        else
            variableVars[entries[2]] = evalSymbolic(entries[1], string(variableVars[entries[2]]), entries[3])
        end

    else
        println("can be ignored")
        if !in(entries[3], ["w","x","y","z"])
            entryVal = parse(Int, entries[3])
            constantVars[entries[2]] = evalNumeric(entries[1], constantVars[entries[2]], entryVal)
        else
            constantVars[entries[2]] = evalNumeric(entries[1], constantVars[entries[2]], constantVars[entries[3]])
        end
    end
end

println(variableVars["z"])
