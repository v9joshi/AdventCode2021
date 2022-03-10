# Polymerization, more dict based substitution
inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day14\\input.txt", String) # Read all the inputs

# Parse the inputs
inputs = replace(inputs,'\r'=>"")  # Sanitize inputs
inputs = split.(inputs,'\n') # Split by line

polyChain = inputs[1]
subsList = inputs[3:end]

# Convert the substitution list into a dictionary
subsList = split.(subsList," -> ")
subsDict = Dict()
pairCount = Dict{String, Int64}()

for subRule in subsList
    elements = split.(subRule[1],"")
    subsDict[subRule[1]] = (join([elements[1],subRule[2]]),join([subRule[2],elements[2]]), subRule[2])
    pairCount[subRule[1]] = 0
end

# Find the pair count
polyChain  = split(polyChain,"")
chainPairs  = join.(zip(polyChain[1:end-1],polyChain[2:end]))

for pair in chainPairs
    global pairCount[pair] +=1
end

# What elements exist and how frequently do they occur?
eleCount = Dict{String, Int64}()
for ele in unique(split(join(keys(pairCount)),""))
    eleCount[ele] = 0
end

for ele in polyChain
    global eleCount[ele] +=1
end

# Run the polymerization chain
for currIter in 1:40
    # Start a local count
    localCount = Dict()

    # Fill this local count with 0s
    for pair in keys(pairCount)
        localCount[pair] = 0
    end

    # Replace the pairs in the pair count
    for pair in keys(pairCount)
        # Look up the substitution rules
        newPairs = subsDict[pair]

        # Replace the current pair with the newly formed pairs
        localCount[newPairs[1]] += pairCount[pair]
        localCount[newPairs[2]] += pairCount[pair]

        # Add the additional element from the polymerization to the total
        global eleCount[newPairs[3]] += pairCount[pair]
    end

    # Replace the global count with the local one
    global pairCount = localCount
end

# Find the most and least frequent element
maxCount = maximum([eleCount[ele] for ele in keys(eleCount)])
minCount = minimum([eleCount[ele] for ele in keys(eleCount)])

# Print the answers
println("#1 answer = ", maxCount - minCount)
