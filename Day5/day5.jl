inputs = read("C:\\Users\\varunjos\\Documents\\GitHub\\AdventCode2021\\Day5\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")  # Sanitize inputs
inputs = split.(inputs,'\n') # Split by line
inputs = split.(inputs,"->") # Split into start and end coordinates

# find the starting and ending coordinates of the vents
startCoords = [split.(strip.(inputs[i][1]), ',') for i in 1:length(inputs)]
startCoords = [parse.(Int, startCoords[i]) for i in 1:length(startCoords)]
startCoords = [(startCoords[i][1], startCoords[i][2]) for i in 1:length(startCoords)]

endCoords = [split.(strip.(inputs[i][2]), ',') for i in 1:length(inputs)]
endCoords = [parse.(Int, endCoords[i]) for i in 1:length(endCoords)]
endCoords = [(endCoords[i][1], endCoords[i][2]) for i in 1:length(endCoords)]

# Make a list of vent points

maxXCoord = max(maximum(x[1] for x in startCoords), maximum(x[1] for x in endCoords))
maxYCoord = max(maximum(y[2] for y in startCoords), maximum(y[2] for y in endCoords))
ventList_pt1 = zeros(Int8, maxXCoord + 1, maxYCoord + 1)
ventList_pt2 = zeros(Int8, maxXCoord + 1, maxYCoord + 1)

# Loop through all the vents
for (ventNum, ventStart) in enumerate(startCoords)
	println("Checking vent ", ventNum)
	# Check vertical vents
	if ventStart[1] == endCoords[ventNum][1]
		s,e = minmax(ventStart[2], endCoords[ventNum][2])
		for ventPoint in s:e
			global ventList_pt1[ventStart[1] + 1, ventPoint + 1] +=1
			global ventList_pt2[ventStart[1] + 1, ventPoint + 1] +=1
		end
	
	# Check horizontal vents
	elseif ventStart[2] == endCoords[ventNum][2]
		s,e = minmax(ventStart[1], endCoords[ventNum][1])
		for ventPoint in s:e
			global ventList_pt1[ventPoint + 1, ventStart[2] + 1] +=1
			global ventList_pt2[ventPoint + 1, ventStart[2] + 1] +=1
		end
	
	# Check diagonal vents
	elseif abs(endCoords[ventNum][1] - ventStart[1]) == abs(endCoords[ventNum][2] - ventStart[2])
		println("Diagonal vent ", ventNum, startCoords[ventNum], " -> ", endCoords[ventNum])
		diff_x = (endCoords[ventNum][1] - ventStart[1])
		diff_y = (endCoords[ventNum][2] - ventStart[2])
		for i in 0:abs(diff_x)
			println("Passes through :", ventStart[1] + sign(diff_x)*i, ",", ventStart[2] + sign(diff_y)*i)
			global ventList_pt2[ventStart[1] + sign(diff_x)*i + 1,ventStart[2] + sign(diff_y)*i + 1]+=1 
		end
	end
end


# Display the total number of repeated vent points
println("#1 result = ", count(x-> x>=2, ventList_pt1))
println("#2 result = ", count(x-> x>=2, ventList_pt2))
