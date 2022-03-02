# Fix the 7-segment display
# input wires map to these locations but have been mixed up
#   aaaa
#  b    c
#  b    c
#   dddd
#  e    f
#  e    f
#   gggg

inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day8\\input.txt", String) # Read all the inputs

inputs = replace(inputs,'\r'=>"")  # Sanitize inputs
inputs = split.(inputs,'\n') # Split by line
inputs = split.(inputs,'|')  # Split into input values and output values

# Read all the input codes
inputCodes = [split.(inputText[1]) for inputText in inputs]

# Read all the output number codes
outputCodes = [split.(inputText[2]) for inputText in inputs]

# Replace each code by its length
outputCodeLength = [length.(outputCode) for outputCode in outputCodes]

# Flatten the sequence
outputCodeLength = vcat(outputCodeLength...)
uniqueSequenceLengths = [2,3,4,7]

# Make a map of wires
sevenSegDict = Dict("cf"=> "1", "acf"=> "7","bcdf"=>"4","abdfg"=>"5","acdeg"=>"2","acdfg"=>"3","abdefg"=>"6","abcdfg"=>"9","abcefg"=>"0","abcdefg"=>"8")

# Initialize some storage variables
outputList = []
summedOutputs = 0

# Go through each input one at a time
for currLine in 1:length(inputs)
    currInput = inputCodes[currLine]

    codeSet = [Set(split.(inputEle,"")) for inputEle in currInput]
    codeSet_sorted = sort(collect(zip(length.(codeSet), codeSet)); by = first)

    # Find the segments that are used in all five segment and six segment numbers
    uniqueToFive = union(setdiff(codeSet_sorted[10][2],codeSet_sorted[4][2]), setdiff(codeSet_sorted[10][2], codeSet_sorted[6][2]), setdiff(codeSet_sorted[10][2], codeSet_sorted[5][2]))
    uniqueToSix  = union(setdiff(codeSet_sorted[10][2],codeSet_sorted[9][2]), setdiff(codeSet_sorted[10][2], codeSet_sorted[8][2]), setdiff(codeSet_sorted[10][2], codeSet_sorted[7][2]))

    # Find the wire mapping one letter at a time
    aEle = setdiff(codeSet_sorted[2][2], codeSet_sorted[1][2])
    bEle = setdiff(intersect(uniqueToFive, codeSet_sorted[3][2]), codeSet_sorted[1][2])
    cEle = intersect(uniqueToSix, codeSet_sorted[1][2])
    fEle = setdiff(codeSet_sorted[1][2], cEle)
    dEle = setdiff(codeSet_sorted[3][2], union(bEle, cEle, fEle))
    eEle = setdiff(uniqueToFive, union(bEle, cEle, fEle))
    gEle = setdiff(codeSet_sorted[10][2], union(aEle, bEle, cEle, dEle, eEle, fEle))

    # Make a dictionary of all the LED input to output maps
    correctionDict = Dict()

    # Put the answers in the dictionary
    aEle = pop!(aEle)
    correctionDict[aEle] = 'a'
    bEle = pop!(bEle)
    correctionDict[bEle] = 'b'
    cEle = pop!(cEle)
    correctionDict[cEle] = 'c'
    dEle = pop!(dEle)
    correctionDict[dEle] = 'd'
    eEle = pop!(eEle)
    correctionDict[eEle] = 'e'
    fEle = pop!(fEle)
    correctionDict[fEle] = 'f'
    gEle = pop!(gEle)
    correctionDict[gEle] = 'g'

    # Use the dictionary to fix the wire inputs
    correctedOutputs = []
    for output in outputCodes[currLine]
        correctedWires = sort([correctionDict[wire] for wire in split.(output,"")])
        correctedOutput = join(correctedWires)
        push!(correctedOutputs, correctedOutput)
    end

    # Use the corrected wires to find the displayed number
    outputNumber = join([sevenSegDict[output] for output in correctedOutputs])
    push!(outputList, outputNumber)
    global summedOutputs += parse(Int64, outputNumber)
end

# Display the number of unique output codes
println("#1 result = ", count(x-> x in uniqueSequenceLengths, outputCodeLength))

# Display the sum of all corrected seven segment outputs
println("#2 result = ", summedOutputs)
