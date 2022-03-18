# Some dice rolling, mostly algebra and modulo operations with some book keeping tricks for part 2
inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day21\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")                   # Sanitize inputs
inputs = split(inputs,"\n")

# Parse these inputs to get player 1 and player 2 starting positions
player1Text = inputs[1]
player1Pos  = parse(Int, split(player1Text,"")[end])

player2Text = inputs[2]
player2Pos  = parse(Int, split(player2Text,"")[end])

# Case 1: Deterministic dice
score = [0, 0]
turnNum = 0
endScore = 1000

# Keep on rolling
while true
    # Increase the turn count
    global turnNum += 1
    # Increase player 1 score
    global score[1] += mod(player1Pos + 6*turnNum + 18*(turnNum - 1)*turnNum*0.5 - 1, 10) + 1
    # End game if condition met
    if score[1] >= endScore
        break
    end
    # Increase player 2 score
    global score[2] += mod(player2Pos + 15*turnNum + 18*(turnNum - 1)*turnNum*0.5 - 1, 10) + 1
    # End game if condition met
    if score[2] >= endScore
        break
    end
end

# Answer for case 1
println("#1 answer = ", minimum([score[1]*turnNum*2*3, score[2]*(2*turnNum - 1)*3]))

# Case2: Dirac dice
# Each turn produces 27 universes, some with the same increment in score
scoreCount = Dict()

# Check each possible universe
for triplet in Iterators.product(1:3,1:3,1:3)
    # Increase the count of this universe by 1
    if in(sum(triplet), keys(scoreCount))
        scoreCount[sum(triplet)] += 1
    else
        scoreCount[sum(triplet)] = 1
    end
end

# Set up a count and some dicts to store scores
# Keys have order - score1, score2, currPLayer, player 1 position, player 2 position
scoreDict = Dict([0, 0, 1, player1Pos, player2Pos] => 1)
finishedGames = Dict(1 => 0, 2=> 0)
endScore = 21

# PLay the game till all games are over
while length(scoreDict) > 0
    # End all games where a winner has been found
    for scoreVal in keys(scoreDict)
        if maximum(scoreVal[1:2]) >= endScore
            winner = scoreVal[3] == 1 ? 2 : 1
            finishedGames[winner] += scoreDict[scoreVal]
            delete!(scoreDict, scoreVal)
        end
    end

    # Make new dict to store the results of this turn
    newDict = Dict()

    # Find the new score for each score value
    for scoreVal in keys(scoreDict)
        for possibleScore in keys(scoreCount)
            newTriple = deepcopy(scoreVal)

            # Whose turn is it? player 1 or 2
            oldPlayer = scoreVal[3]

            # Find the new position and new score
            newPosition = mod(scoreVal[oldPlayer + 3] + possibleScore - 1, 10) + 1
            newTriple[oldPlayer + 3] = newPosition

            newScore = scoreVal[oldPlayer] + newPosition
            newTriple[oldPlayer] = newScore

            newPlayer = oldPlayer == 1 ? 2*scoreVal[3] : 1
            newTriple[3] = newPlayer

            # Check if this exact case already exists, if yes, just increase count
            if in(newTriple, keys(newDict))
                newDict[newTriple] += scoreCount[possibleScore]*scoreDict[scoreVal]
            else
                newDict[newTriple] = scoreCount[possibleScore]*scoreDict[scoreVal]
            end
        end
    end

    # Replace the old dictionary with the new one
    global scoreDict = newDict
end

# Answer for case 2
println("#2 answer = ", maximum(values(finishedGames)))
