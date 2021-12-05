inputs = read("C:\\Users\\Varun\\Documents\\GitHub\\AdventCode2021\\Day4\\test_input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")  # Sanitize inputs
inputs = strip(inputs,'\n') # Trailing end line is annoying
inputs = split.(inputs,"\n\n") # Split blocks of data into different vectors

# Separate all the inputs into one variable
calledNums = parse.(Int,split(inputs[1],','))

# Make a set of all boards
boards = []

# Store each individual board in the big set
for i = 2:length(inputs)
    # Split lines for each block to make rows
    board = split.(split(inputs[i],'\n'))
    # Concatenate the lines
    board = hcat(board...)
    # Convert chars into integers
    board = parse.(Int, board)

    # Store the board
    push!(boards, board)
end

# Play Bingo
winval = []
winnum = []
winboard = []

# For a board to win, either a row or a column must sum to this value
checkval = -1*size(boards[1],1)

# Go through the called numbers
for inputNum in calledNums
    # Replace a called number with -1
    global boards = replace.(boards, inputNum => -1)

    # Go through all the boards and check for wins
    for (boardnum, board) in enumerate(boards)
        # If the board has already won, skip it
        if boardnum in winboard
            continue
        # Check win condition on each row and each column of the board
        elseif min(sum(eachrow(board))...) == checkval || min(sum(eachcol(board))...) == checkval
            # If the board won, score it
            tempBoard = replace(board, -1=> 0)
            # Add to the list of won boards along with a score and the winning input
            push!(winval, sum(tempBoard))
            push!(winboard, boardnum)
            push!(winnum, inputNum)
        end
    end

    # If all the boards have already won, end the game
    if length(winboard )== length(boards)
        break
    end
end

# determine the answer for part 1
result = winnum[1]*winval[1]
println("#1 result = ", result)

# determine the answer for part 2
result = winnum[end]*winval[end]
println("#2 result = ", result)
