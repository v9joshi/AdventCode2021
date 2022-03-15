# Snailfish math - more parsing
inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day18\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")                   # Sanitize inputs

inputs = split(inputs,'\n')

# Support functions
# Add a pair of numbers
function addPair(input1, input2)
    if length(input1) > 0
        input1 = join(["[", input1, ",", input2, "]"])
    elseif length(input2) > 0
        return input2
    end

    return input1
end

# Find how many nested "[]" there are
function maxNest(input)
    nestval = 0
    maxval = 0
    # Check each input
    for ele in split(input,"")
        # If we open more brackets we're more nested
        if ele == "["
            nestval += 1
        # If we close brackets we're less nested
        elseif ele == "]"
            nestval -= 1
        end
        maxval = maximum([maxval, nestval])
    end

    return maxval
end

# Check if any number exceeds 9, return the first one that does
function maxNum(input)
    # Remove the brackets
    input = replace(input,']'=>"")
    input = replace(input,'['=>"")

    # Split the numbers
    input = split(input,',')

    # Parse the numbers
    input = parse.(Int, input)

    #println(input)

    # Return the first number that exceeds 9
    if maximum(input) > 9
        return input[findfirst(x-> x > 9, input)]
    else
        return maximum(input)
    end
end

# Reduce the number based on exploding and splitting rules
function reduceNum(input)
    #println("reducing")

    oldNum = deepcopy(input)

    while true
        # Check if an explosion needs to happen
        if maxNest(oldNum) > 4
            input = explodeNum(input)
            oldNum = deepcopy(input)
        # Check if a split needs to happen
        elseif maxNum(oldNum) > 9
            #println("max too big")
            input = splitNum(input)
            oldNum = deepcopy(input)
        # If nothing needs to happen break the loop
        else
            break
        end
    end

    # Return the reduced number
    return input
end

# Explode the number
function explodeNum(input)
    #println("exploding")
    pos = 0
    nestval = 0
    digitStrings = string.(0:9)
    splitInput = split(input,"")

    # Check each input till you get to the correct depth
    for ele in splitInput
        pos = pos + 1
        # If we open more brackets we're more nested
        if ele == "["
            nestval += 1
        # If we close brackets we're less nested
        elseif ele == "]"
            nestval -= 1
        end

        if nestval > 4
            break
        end
    end

    # Find the corresponding "]" for this depth
    currNumPos = [pos, findnext(==("]"), splitInput, pos)]

    # Extract the pair
    currNum = splitInput[currNumPos[1] + 1:currNumPos[2] - 1]
    currNum = parse.(Int, split(join(currNum),','))

    # Get the position of the right number
    pos = currNumPos[2]

    while true
        # Keep looking till you hit a digit
        pos +=1
        if in(splitInput[pos], digitStrings)
            endPos = pos
            # Keep looking till you don't hit any more digits
            while true
                endPos +=1
                if !in(splitInput[endPos], digitStrings)
                    endPos = endPos - 1
                    break
                end
            end
            nextNumVal = parse(Int, join(splitInput[pos:endPos])) + currNum[2]
            splitInput = vcat(splitInput[1:(pos - 1)], string(nextNumVal), splitInput[endPos+1:end])
            input = join(splitInput)
            break
        elseif pos == length(splitInput)
            break
        end
    end

    # Replace the exploded number
    splitInput = vcat(splitInput[1:currNumPos[1]-1],"0",splitInput[currNumPos[2]+1:end])
    input = join(splitInput)

    # Reset position
    pos = currNumPos[1]
    # Get the previous number position
    while true
        # Keep looking till you hit a digit
        pos -=1
        if in(splitInput[pos], digitStrings)
            endPos = pos
            # Keep looking till you don't hit any more digits
            while true
                pos -=1
                if !in(splitInput[pos], digitStrings)
                    pos = pos+1
                    break
                end
            end
            prevNumVal = parse(Int, join(splitInput[pos:endPos])) + currNum[1]
            splitInput = vcat(splitInput[1:(pos[1] - 1)], string(prevNumVal), splitInput[endPos+1:end])
            input = join(splitInput)
            break
        elseif pos == 1
            break
        end
    end
    #println(input)
    return input
end

# Split the number if any element is too big
function splitNum(input)
    #println("splitting")
    # Make a deep copy
    oldNum = deepcopy(input)

    # Find the maximum number and its replacement
    maxNumVal = maxNum(oldNum)
    newNumVal = join(["[", string(Int(floor(maxNumVal/2))),",", string(Int(ceil(maxNumVal/2))), "]"])

    # Replace the first occurence of this maximum number
    #println(input)
    input = replace(input, string(maxNumVal) => newNumVal, count = 1)
    #println(input)
    return input
end

# Recursively find the magnitude of the number
function magNum(input)
    # Split the number up
    splitInput = split(input, "")

    # If there are any brackets, find the left and right half of the number
    if in("[", splitInput)
        nestVal = 0
        # Keep looking through elements till the "," for this depth is found
        for (currpoint, ele) in enumerate(splitInput)
            # Check the depth of the brackets
            if ele == "["
                nestVal += 1
            elseif ele == "]"
                nestVal -=1
            end

            # When you find the "," split the left and right side and find the magnitude
            if (nestVal == 1) && (ele ==",")
                leftHalf = join(splitInput[2:currpoint - 1])
                rightHalf = join(splitInput[currpoint+1:end-1])
                return 3*magNum(leftHalf) + 2*magNum(rightHalf)
            end
        end
    # If there are no brackets, this is just a single digit, convert it to an Int
    else
        return parse(Int, input)
    end
end

# Main section, start with an empty string
currResult = ""

# Add all the inputs together
for input in inputs
    global currResult = addPair(currResult, input)
    #println(currResult)
    global currResult = reduceNum(currResult)
    #println(currResult)
end

# Print the magnitude
println("magnitude = ", magNum(currResult))

# Find the max magnitude from adding any pair from the inputs
magnitudeStore = []

# Use the product to make pairs, add them, reduce them and then find the magnitude
for (input1, input2) in Iterators.product(inputs, inputs)
    sumResult = addPair(input1, input2)
    reducedSum = reduceNum(sumResult)
    currMag =  magNum(reducedSum)
    push!(magnitudeStore, currMag)
end

# Print the maximum magnitude
println("Max magnitude = ", maximum(magnitudeStore))
