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
    while coroutine.resume(get_unsplash_jpgs, phrases) and coroutine.resume(secondary_table,phrases) do end
    --[[
    for i = 1, #phrases do
        coroutine.resume(get_unsplash_jpgs,phrases)
        coroutine.resume(secondary_table,phrases)
    end  
    ]]
end

function write_md(file_name,new_table)
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

function initalize (java)
    folder_name = string.gsub(string.gsub(string.sub(os.date("%x"),1,8).."_"..string.sub(os.date("%c"),12,19), ":", "_"), "/",  "_")

    --Compile all java files used
    javac = function (x) return os.execute("javac "..x..".java") end --Annonymous function
    for i = 1, #java do javac(java[i]) end

    --START MAIN
    io.write("Please input the .txt file: ")
    txt_file = io.read("*line")
    -- TO DO: Add check to see if this file is in the currect directory, and last 4 == ".txt"

    --Ask about git
    git_valid = false
    while not git_valid and false do -- THIS LOOP WILL NOT HAPPEN AT THE MOMENT
        io.write("Would you like to push the final product to a GitHub website?: ")
        git_ans = io.read("*line")
        if string.upper(string.sub(git_ans,1,1)) == 'Y' then
            git = true
            git_valid = true
        elseif string.upper(string.sub(git_ans,1,1)) == 'N' then
            git = false
            git_valid = true
        end
    end

    return get_lines(txt_file), git, folder_name;


end


function github (folder)
    os.execute("git add "..folder.."/\\*.txt") --"git add Documentation/\*.txt"
    os.execute("git add "..folder.."/\\*.md")
    os.execute("git commit "..folder)
    os.execute("git push")
end