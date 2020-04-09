--[[
Names: Michael Dahlquist & Kristen Qako
Class: csci324 - spring2020
File:  functions.lua
Purpose:

]]
function get_lines(file_name)
    --get_lines(file_name) returns a table of all the lines in file_name
    --does not include return characters
        new_table = {}
        count = 0
        local file = io.open(file_name, "rb")
        for line in io.lines(file_name) do
            count = count + 1
            --fixes formatting issues
            line1 = line
            line1 = string.gsub(line1, "%A", "*")
            if string.sub(line1,string.len(line1),string.len(line1)) == "*" then
                line = string.sub(line,1,string.len(line1)-1)
            end
            new_table[count] = line
            --new_table[count] = string.sub(line, 1, string.len(line))
        end
        file:close()
        return new_table
    --A portion of this code was inspired by:
    --https://stackoverflow.com/questions/11201262/how-to-read-data-from-a-file-in-lua
end

function concatenate(new_table, char) 
    --file_table = ""
    for i = 1, #new_table do
        new_table[i] = string.gsub(new_table[i],"%A", char)
        --file_table[i] = prefix..new_table[i]..".jpg"
    end
end

get_unsplash_jpgs = coroutine.create(function (phrases)
    unsplash_table = phrases
    concatenate(unsplash_table, ",")
    java_unsplash = function (x) return os.execute("java unsplash "..x) end -- ANNONYMOUS FUNCTION
    for i = 1, #phrases do
        java_unsplash(unsplash_table[i])
        print("Executed: "..unsplash_table[i])
        coroutine.yield()
    end
end)

secondary_table = coroutine.create(function (phrases)
    for i = 1, #phrases do
        print("Executed: "..i/#phrases)
        coroutine.yield()     
    end
end)

function all_sources(phrases)
    for i = 1, #phrases do
        coroutine.resume(get_unsplash_jpgs,phrases)
        coroutine.resume(secondary_table,phrases)
    end
end

function write_md(file_name,folder,new_table)
    --Input file names
    unsplash_table = new_table
    concatenate(unsplash_table, ",")
    --Write md
    local file = io.open(file_name, "w") --open file
    io.output(file) --set output to file

    io.write("# "..string.sub(file_name,1,-5)..'\n'..'\n') --Write title
    
    for i = 1, #_table do
        io.write("**".._table[i].."**"..'\n\n')
        io.write("!["..new_table[i].."](".."unsplash_"..unsplash_table[i]..".jpg)\n\n")
    end
    
    file:close() --close file
end