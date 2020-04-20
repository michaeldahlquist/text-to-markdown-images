--[[
Names: Michael Dahlquist & Kristen Qako
Class: csci324 - spring2020
File:  functions.lua
Purpose:
    Contains the functions for main.lua

]]

function initalize (java)
    folder_name = string.gsub(string.gsub(string.sub(os.date("%x"),1,8).."_"..string.sub(os.date("%c"),12,19), ":", "_"), "/",  "_")
    --folder_name = "test_git_05"

    --Compile all java files used
    javac = function (x) return os.execute("javac "..x..".java") end --Annonymous function
    for i = 1, #java do javac(java[i]) end

    --START MAIN
    io.write("Please input the .txt file: ")
    txt_file = io.read("*line")
    -- TO DO: Add check to see if this file is in the currect directory, and last 4 == ".txt"

    --Ask about git
    git_valid = false
    git = false
    while not git_valid  do -- THIS LOOP WILL NOT HAPPEN AT THE MOMENT
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
    a_table = get_lines(txt_file)
    return a_table, txt_file, folder_name, git
end

function get_lines(file_name)
    --get_lines(file_name) returns a table of all the lines in file_name
    --does not include return characters
        new_table = {}
        local file = io.open(file_name, "rb")
        for line in io.lines(file_name) do
            --fixes formatting issues
            line1 = line
            line1 = string.gsub(line1, "%A", "*")
            if string.sub(line1,string.len(line1),string.len(line1)) == "*" then
                line = string.sub(line,1,string.len(line1)-1)
            end
            new_table[#new_table+1] = line
        end
        file:close()
        return new_table
    --A portion of this code was inspired by:
    --https://stackoverflow.com/questions/11201262/how-to-read-data-from-a-file-in-lua
end

get_unsplash_jpgs = coroutine.create(function (phrases, time)
    --coroutine that downloads one image from unsplash each time it is resumed
    java_unsplash = function (x) return os.execute("java unsplash "..x) end -- ANNONYMOUS FUNCTION
    for i = 1, #phrases do
        time["unsplash"][i] = os.clock()
        java_unsplash(phrases[i])
        print("Executed unsplash: "..phrases[i])
        time["unsplash"][i] = os.clock() - time["unsplash"][i]
        coroutine.yield()
    end
end)

get_loremflickr = coroutine.create(function (phrases,time)
    --coroutine that downloads one image from loremflickr each time it is resumed
    java_loremflickr = function (x) return os.execute("java loremflickr "..x) end -- ANNONYMOUS FUNCTION
    for i = 1, #phrases do
        time["loremflickr"][i] = os.clock()
        java_loremflickr(phrases[i])
        print("Executed loremflickr: "..phrases[i])
        time["loremflickr"][i] = os.clock() - time["loremflickr"][i]
        coroutine.yield()
    end
end)

function all_sources(phrases)
    if #phrases == 0 then return end --if there are no images, don't execute
    count = 1
    phrases[count] = string.gsub(phrases[count],"%A", ",")
    time = {}
    time["unsplash"] = {}
    time["loremflickr"] = {}
    while coroutine.resume(get_unsplash_jpgs, phrases, time) and coroutine.resume(get_loremflickr,phrases,time) do
        if count < #phrases then
            count = count + 1
            phrases[count] = string.gsub(phrases[count],"%A", ",")
        end
    end
    return time
end

function write_md(file_name,new_table,time)
    --Write md
    local file = io.open(file_name, "w") --open file
    io.output(file) --set output to file

    io.write("# "..string.sub(file_name,1,-4)..'\n'..'\n') --Write title
    
    for i = 1, #new_table do
        if time["unsplash"][i] <= time["loremflickr"][i] then
            io.write("**"..new_table[i].."**"..'\n\n')
            io.write("!["..new_table[i].."](".."unsplash_"..new_table[i]..".jpg)\n\n")
        else
            io.write("**"..new_table[i].."**"..'\n\n')
            io.write("!["..new_table[i].."](".."loremflickr_"..new_table[i]..".jpg)\n\n")
        end
    end
    
    file:close() --close file
end

function github (folder)
    os.execute("git add "..folder.."/\\*.jpg") --"git add Documentation/\*.txt"
    os.execute("git add "..folder.."/\\*.md")
    os.execute("git commit -m \""..folder.."\"")
    os.execute("git push")
    print("Please note that the site might not be rendered for a while")
    print("Here is the link:")
    print("https://www.michaeldahlquist.github.io/test-to-markdown-images/"..folder.."/")
end