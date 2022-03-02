# Syntax Scoring
# Read input file
inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day10\\input.txt", String) # Read all the inputs

# Parse the inputs
inputs = replace(inputs,'\r'=>"")  # Sanitize inputs
inputs = split.(inputs,'\n') # Split by line
inputs = [split.(line,"") for line in inputs]

# Closing brackets
bracketDict = Dict("("=>")", "["=>"]" ,"{"=>"}", "<"=>">")

# Scoring system
scoringDict = Dict(")"=>3, "]"=>57 ,"}"=>1197, ">"=>25137)
syntaxScore = 0

# Completion score
completionDict   = Dict(")"=>1, "]"=>2 ,"}"=>3, ">"=>4)
completionScores = []

# Go through the input lines one at a time
for line in inputs
    # Make an empty array of inputs so far
    inputHist = []
    incomplete = true

    # Loop through the full input till the end
    for testChar in line
        # Check if this is an open bracket
        if in(testChar, keys(bracketDict))
            # push open brackets into the history
            push!(inputHist, testChar)
        # Check if this is a closed bracket
    elseif in(testChar, values(bracketDict))
            # If the closed bracket matches the last open bracket pop
            if testChar == bracketDict[inputHist[end]]
                pop!(inputHist)
            # If the closed bracket doesn't match, increase the score and break
            else
                global syntaxScore += scoringDict[testChar]
                incomplete = false
                break
            end
        else
            # If the input isn't a key or a value then it's unexpected
            println("unexpected input => ", testChar)
        end
    end

    # Find the completion score
    if incomplete
        # Start at 0
        completionScore = 0

        # Go through each remaining character
        for char in reverse(inputHist)
            # Use the scoring rules of *5 + score value for each bracket
            completionScore = completionScore*5
            completionScore += completionDict[bracketDict[char]]
        end

        # Store the completion score
        push!(completionScores, completionScore)
    end
end

# Find the median score
completionScores = sort(completionScores)
medianScore = completionScores[convert(Int,(length(completionScores) + 1)/2)]

# Report the syntax and autocomplete score
println("#1 result = ", syntaxScore)
println("#2 result = ", medianScore)
