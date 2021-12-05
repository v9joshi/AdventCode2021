inputs = read("C:\\Users\\Varun\\Documents\\GitHub\\AdventCode2021\\Day4\\test_input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")  # Sanitize inputs
inputs = strip(inputs,'\n') # Trailing end line is annoying
inputs = split.(inputs,"\n\n")

calledNums = parse.(Int,split(inputs[1],','))

boards = []

for i = 2:length(inputs)
    board = split.(split(inputs[i],'\n'))
    board = hcat(board...)
    board = parse.(Int, board)

    push!(boards, board)
end

winval = []
winnum = []
winboard = []
checkval = -1*size(boards[1],1)

for inputNum in calledNums
    global boards = replace.(boards, inputNum => -1)
    wincon = 0
    for (boardnum, board) in enumerate(boards)
        if boardnum in winboard
            continue
        elseif min(sum(eachrow(board))...) == checkval || min(sum(eachcol(board))...) == checkval
            tempBoard = replace(board, -1=> 0)
            push!(winval, sum(tempBoard))
            push!(winboard, boardnum)
            push!(winnum, inputNum)
        end
    end

    if length(winboard )== length(boards)
        break
    end
end

# determine the answer
result = winnum[1]*winval[1]
println("#1 result = ", result)

# determine the answer
result = winnum[end]*winval[end]
println("#2 result = ", result)
