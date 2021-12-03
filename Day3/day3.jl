using DelimitedFiles
using StatsBase

# Read the dlm file
binaries = readdlm("C:\\Users\\Varun\\Documents\\GitHub\\AdventCode2021\\Day3\\input.txt",String)
# Split the string into characters
numcol = length(binaries[1])

# part 1
extract_col(vec, col) = [parse(Int, vec[i][col]) for i in 1:length(vec)]
# gamma_val(vec) = [mode(extract_col(vec, i)) for i in 1:length(vec[1])]

# Initialize the gamma and epsilon rates
gamma_rate = 0
epsilon_rate = 0

for i = 1:numcol
    bitval = mode(extract_col(binaries,i))
    global gamma_rate += bitval*(2^(numcol-i))
    global epsilon_rate += (1 - bitval)*(2^(numcol-i))
end

result = gamma_rate*epsilon_rate
println("#1 result = ", result)

# Part 2
extract_col(vec, col) = [parse(Int, vec[i][col]) for i in 1:length(vec)]
extract_row(vec, val) = [i for i in 1:length(vec) if vec[i]==val]

ox_bin  = binaries
co2_bin = binaries

for i = 1:numcol
    ox_col = extract_col(ox_bin,i)
    co2_col = extract_col(co2_bin,i)

    if mean(ox_col) < 0.5
        ox_bit = 0
    else
        ox_bit = 1
    end

    if mean(co2_col) < 0.5
        co2_bit = 1
    else
        co2_bit = 0
    end

    if length(co2_col) == 1
        co2_bit = mean(co2_col)
    end

    ox_rows = extract_row(ox_col, ox_bit)
    global ox_bin = ox_bin[ox_rows]

    co2_rows = extract_row(co2_col, co2_bit)
    global co2_bin = co2_bin[co2_rows]
end

oxygen_gen_rating = 0 #parse(Int, ox_bin; 2)
co2_scrubber_rating = 0 #parse(Int, co2_bin; 2)

for i = 1:numcol
    global oxygen_gen_rating += parse(Int, ox_bin[1][i])*(2^(numcol-i))
    global co2_scrubber_rating += parse(Int, co2_bin[1][i])*(2^(numcol-i))
end

result = oxygen_gen_rating*co2_scrubber_rating
println("#2 result = ", result)
