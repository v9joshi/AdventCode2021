inputs = read("C:\\Users\\Varun\\Documents\\GitHub\\AdventCode2021\\Day4\\test_input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")  # Sanitize inputs
inputs = split.(inputs,'\n') # Split by line
inputs = split.(inputs,"->") # Split into start and end coordinates

startCoords = [split.(strip.(inputs[i][1]), ',') for i in 1:length(inputs)]
startCoords = [parse.(Int, startCoords[i]) for i in 1:length(startCoords)]
startCoords = [(startCoords[i][1], startCoords[i][2]) for i in 1:length(startCoords)]

endCoords = [split.(strip.(inputs[i][2]), ',') for i in 1:length(inputs)]
endCoords = [parse.(Int, endCoords[i]) for i in 1:length(endCoords)]
endCoords = [(endCoords[i][1], endCoords[i][2]) for i in 1:length(endCoords)]
