# Tile shifting game - Find the min cost to sort all the tiles
# Consider all possible legal moves for a config.
# If no legal move exists, cost = Inf
# If a legal move exists, perform the move, change the state and continue.


# Make a structure to store the problem
struct burrow
    room::Dict
    hallway::String
    cost::Int64
end

# Initialize the burrow
roomDict1 = Dict()

roomDict1["A"] = ["ABAA", 3, 1]
roomDict1["B"] = ["CDBB", 5, 10]
roomDict1["C"] = ["CACC", 7, 100]
roomDict1["D"] = ["DBDD", 9, 1000]

roomDict2 = Dict()
roomDict2["A"] = ["ADDB", 3, 1]
roomDict2["B"] = ["CCBD", 5, 10]
roomDict2["C"] = ["CBAA", 7, 100]
roomDict2["D"] = ["DACB", 9, 1000]

#roomDict["A"] = ["BAAA", 3, 1]
#roomDict["B"] = ["ABBB", 5, 10]
#roomDict["C"] = ["CCCC", 7, 100]
#roomDict["D"] = ["DDDD", 9, 1000]

burrowState1 = burrow(roomDict1,"...........",0)
burrowState2 = burrow(roomDict2,"...........",0)

# Make some support functions
# Check if the current state is the success state where all tiles are sorted
function checkSuccess(burrowState)
    # Are all rooms filled
    for roomName in keys(burrowState.room)
        if burrowState.room[roomName][1] != roomName^4
            return false
        end
    end
    return true
end

# Get the first tile in the current room
function getFirstEle(currRoom)
    # Use find first to get the first non empty location in the room
    posn = findfirst(x -> x!='.', currRoom[1])

    # If there are no non-empty loctions return nothing
    if posn == nothing
        return nothing, nothing
    # Otherwise return the tile in the location as well as the location
    else
        return currRoom[1][posn], posn
    end
end

# Find all legal states that the current state can transition to
function allLegalStates(burrowState)
    # Make an empty list
    legalStates = []

    # All moves from the hallway to a room
    # Check every tile in the hallway
    for (pos,ele) in enumerate(split(burrowState.hallway,""))
        # If the tile is empty or the tile position lies above a room, skip
        if ele == "." || in(pos, [3,5,7,9])
            continue
        # Otherwise try to move this tile
        else
            # println("Making a move from hall to room ", ele)
            # What room must this tile go to?
            roomNum = burrowState.room[ele][2]
            # What is the cost of moving this tile by 1 space?
            moveCost = burrowState.room[ele][3]

            # Check all possible "ideal states" of the room
            roomStates = ["."^4, "."^3*ele,"."^2*ele^2, "."*ele^3,ele^4]
            stateNum = findfirst(x -> roomStates[x] == burrowState.room[ele][1], 1:5)

            # Check that room is either empty or only contains only the correct tile
            if isnothing(stateNum)
                # println("Room not ready for movein")
                continue
            # If that condition is met, check that the route is clear
            elseif (pos > roomNum && count( x-> burrowState.hallway[x]!='.',pos-1:-1:roomNum) > 0) || (pos < roomNum && count( x-> burrowState.hallway[x]!='.',pos+1:roomNum) > 0)
                #println("Route not clear")
                continue
            # If the route is clear, put the new state together
            else
                # Replace the tile in the hallway with an empty marker
                newHallway = join([burrowState.hallway[1:pos-1],".",burrowState.hallway[pos+1:end]])
                # Replace the empty marker in the room with the tile
                newRoom = deepcopy(burrowState.room)
                newRoom[ele][1] = roomStates[stateNum+1]

                # Calculate the cost to get to the new state
                newCost = burrowState.cost + moveCost*abs(pos - roomNum) + moveCost*(5 - stateNum)

                # Put all struct elements together to make the new state
                newBurrowState = burrow(newRoom, newHallway, newCost)
            end

            # Add this new state configuration to the list
            push!(legalStates, newBurrowState)
        end
    end

    # All moves from a room to the hallway
    # Check every single room
    for roomKey in keys(burrowState.room)
        # println("Making a move from room ",roomKey," to hall")
        # What's the room number?
        roomNum = burrowState.room[roomKey][2]

        # Check if the room contains all the right elements already
        # if yes, then skip this room.
        roomStates = ["."^4, "."^3*roomKey,"."^2*roomKey^2, "."*roomKey^3,roomKey^4]
        if in(burrowState.room[roomKey][1],roomStates)
            continue
        end

        # Find the top-most non-empty tile in the room
        roomEle, roomPos = getFirstEle(burrowState.room[roomKey])

        # What is the cost to move this tile by 1 space?
        moveCost = burrowState.room[string(roomEle)][3]

        # Find all the empty tiles in the hall
        for (pos,ele) in enumerate(split(burrowState.hallway,""))
            # If the tile is empty, make sure it's a legal spot to enter
            if ele == "." && !in(pos, [3,5,7,9])
                # Check that the route to this spot is clear. If not, skip.
                if (pos > roomNum && count( x-> burrowState.hallway[x]!='.',pos:-1:roomNum) > 0) || (pos < roomNum && count( x-> burrowState.hallway[x]!='.',pos:roomNum) > 0)
                    continue
                # If the route is clear, make the new state corresponding to this move.
                else
                    # Replace the empty hallway tile with the filled tile.
                    newHallway = join([burrowState.hallway[1:pos-1],roomEle,burrowState.hallway[pos+1:end]])
                    # Replace the room tile with an empty tile
                    newRoom = deepcopy(burrowState.room)
                    newRoom[roomKey][1] = replace(burrowState.room[roomKey][1], roomEle => ".", count=1)
                    # Find the cost to get to this new state.
                    newCost = burrowState.cost + moveCost*abs(pos - roomNum) + moveCost*(roomPos)

                    # Put all the structure elements together
                    newBurrowState = burrow(newRoom, newHallway, newCost)
                end
                # Add this new state configuration to the list
                push!(legalStates, newBurrowState)
            else
                continue
            end
        end
    end

    # Return all the legal state configurations
    return legalStates
end

# Find the best route
function findCost(burrowState, costDict = Dict())
    # If we already know the route from this state to the end, we can determine
    # the cost for the current state.
    if in((burrowState.hallway, burrowState.room), keys(costDict))
        return (burrowState.cost + costDict[(burrowState.hallway, burrowState.room)])
    end

    # If we don't, make a list of all legal moves from this state
    allMoves = allLegalStates(burrowState)

    # For each legal move, determine the cost to reach the end state
    costVal = []
    for newState in allMoves
        # println(newState.hallway)
        # If the move brings you to the end configuration, store the cost
        if checkSuccess(newState)
            #println(burrowState.hallway, newState.cost)
            push!(costVal,newState.cost)
        # If the move doesn't reach the end configuration, use recursion to find the cost
        else
            push!(costVal, findCost(newState, costDict))
        end
    end

    # If there are no legal moves from the current state, the cost to the goal is infinite
    if isempty(costVal)
        # Store the current state and the corresponding cost for future reference
        costDict[(burrowState.hallway, burrowState.room)] = Inf
        return Inf
    # If there is at least one legal move, find the minimum cost to the final configuration
    else
        # Store the current state and the corresponding cost for future reference
        costDict[(burrowState.hallway, burrowState.room)] = minimum(costVal) - burrowState.cost
        return minimum(costVal)
    end
end

# What's the answer?
costDict = Dict()
costToSort1 = findCost(burrowState1, costDict)
costToSort2 = findCost(burrowState2, costDict)
println("#1 answer: ", costToSort1)
println("#2 answer: ", costToSort2)

# legalState = allLegalStates(burrowState)

#for state in legalState
#    println(state)
#    println("----------")
#end
