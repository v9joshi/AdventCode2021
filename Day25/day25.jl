# Moving some sea-cucumbers
inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day25\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")                   # Sanitize inputs
inputs = split(inputs,"\n")

# store the inputy
yMax = length(inputs)
xMax = length(inputs[1])

storageMat = fill('.', yMax, xMax)
for (rownum, rowval) in enumerate(inputs)
    for (colnum, colval) in enumerate(split(rowval,""))
        storageMat[rownum, colnum] = only(colval)
    end
end

# Now run this till you reach steady state
stepNum = 0
hist  = 0
while true
    state = mod(stepNum,2)
    # Make a list of every sea cucumber that's moving in this step
    moveList = []
    for rownum in 1:yMax
        for colnum in 1:xMax
            nextcol = mod(colnum, xMax) + 1
            nextrow = mod(rownum, yMax) + 1

            if state == 0
                # Check the eastern move
                if storageMat[rownum, colnum] == '>' && storageMat[rownum, nextcol] == '.'
                    push!(moveList, ((rownum, colnum),(rownum, nextcol)))
                end
            elseif state == 1
                # Check the southern move
                if storageMat[rownum, colnum] == 'v' && storageMat[nextrow, colnum] == '.'
                    push!(moveList, ((rownum, colnum),(nextrow, colnum)))
                end
            end
        end
    end

    # If we evaluated the south move and nothing moved east or south
    if state == 1 && (hist + length(moveList)) == 0
        break
    # Otherwise if we just evaluated the east move
    elseif state == 0
        global hist += length(moveList)
    # If we evaluated the south move and something moved either east or south
    else
        global hist = 0
    end

    # Increase the step count
    global stepNum += 1

    # Make all the moves
    for (prevPos, newPos) in moveList
        ele = storageMat[prevPos[1], prevPos[2]]
        storageMat[prevPos[1], prevPos[2]] = '.'
        storageMat[newPos[1], newPos[2]] = ele
    end
end

# Print the result
println("#1 result = ", ceil(stepNum/2))
