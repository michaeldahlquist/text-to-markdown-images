--[[
Names: Michael Dahlquist & Kristen Qako
Class: csci324 - spring2020
File:  functions.lua
Purpose:
    Contains the functions for text-to-markdown-images
    Functions included:
        - initialize(table)
        - get_lines(String)
        - get_unsplash_jpgs(table,table) [coroutine]
        - get_loremflickr(table,table)   [coroutine]
        - all_sources(table)
        - wwrite_md(String,table,table)
        - github(String)
]]

function initialize (java)
    folder_name = string.gsub(string.gsub(string.sub(os.date("%x"),1,8).."_"..string.sub(os.date("%c"),12,19), ":", "_"), "/",  "_")

    --Compile all java files used
    javac = function (x) return os.execute("javac "..x..".java") end --Anonymous function
    for i = 1, #java do 
        javac(java[i]) 
    end

    --Get text file name
    io.write("Please input the .txt file: ")
    txt_file = io.read("*line")
    while (function(x) --Anonymous function that returns whether a valid name needs to be found
        local f=io.open(x,"r")
        if f~=nil then 
            io.close(f) 
            return false 
        else 
            return true 
        end
    end)(txt_file) do
        io.write("Sorry, couldn't find that file. Please input the .txt file: ")
        txt_file = io.read("*line")
    end

    --Ask about git
    io.write("Would you like to push the final product to a GitHub website? (Y/N): ")
    git = {} -- git will be a table (to pass by reference to while anonymous functions)
    git[1] = io.read("*line")   -- git[1] => User response as a String
    git[2] = false              -- git[2] => User response as a boolean
    while (function(x) -- Anonymous function that returns whether your 
        if string.upper(string.sub(x[1],1,1)) == 'Y' then
            x[2] = true --push to github
            return false
        elseif string.upper(string.sub(x[1],1,1)) == 'N' then
            x[2] = false --dont push to github
            return false
        else
            return true
        end
    end)(git) do
        io.write("Invalid response. Would you like to push the final product to a GitHub website? (Y/N): ")
        git[1] = io.read("*line")
    end
    a_table = get_lines(txt_file)
    return a_table, txt_file, folder_name, git[2] --multiple return values: table, String, String, boolean
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

get_unsplash = coroutine.create(function (phrases, time)
    --coroutine that downloads one image from unsplash each time it is resumed
    java_unsplash = function (x) return os.execute("java unsplash "..x) end
    for i = 1, #phrases do
        time["unsplash"][i] = os.clock()
        java_unsplash(phrases[i])
        time["unsplash"][i] = os.clock() - time["unsplash"][i]
        print("Downloaded from unsplash: "..phrases[i])
        coroutine.yield()
    end
end)

get_loremflickr = coroutine.create(function (phrases,time)
    --coroutine that downloads one image from loremflickr each time it is resumed
    java_loremflickr = function (x) return os.execute("java loremflickr "..x) end
    for i = 1, #phrases do
        --File download time:
        time["loremflickr"][i] = os.clock()
        java_loremflickr(phrases[i])
        time["loremflickr"][i] = os.clock() - time["loremflickr"][i]
        print("Downloaded from loremflickr: "..phrases[i])
        coroutine.yield()
    end
end)

function all_sources(phrases)
    if #phrases == 0 then return end --if there are no images, don't execute
    count = 1
    phrases[count] = string.gsub(phrases[count],"%A", ",")
    time = {}
    time["unsplash"] = {}       --Example of tables inside table
    time["loremflickr"] = {}
    while coroutine.resume(get_unsplash, phrases, time) and coroutine.resume(get_loremflickr,phrases,time) do
        if count < #phrases then
            count = count + 1
            phrases[count] = string.gsub(phrases[count],"%A", ",")
        end
    end
    return time
end

function write_md(file_name,new_table,time)
    function write_picture(i)
        if time["unsplash"][i] >= time["loremflickr"][i] then
            return function (x)
                io.write("**"..new_table[x].."**"..'\n\n') 
                io.write("!["..new_table[x].."](".."unsplash_"..new_table[x]..".jpg)\n\n")
                io.write("*this image was randomly found via https://source.unsplash.com/400x300/?"..new_table[x].."*\n\n") 
            end
        else 
            return function (x) 
                io.write("**"..new_table[x].."**"..'\n\n')
                io.write("!["..new_table[x].."](".."loremflickr_"..new_table[x]..".jpg)\n\n") 
                io.write("*this image was randomly found via https://loremflickr.com/g/400/300/"..new_table[x].."*\n\n") 
            end
        end
    end
    --Begin writing the markdown file:
    local file = io.open(file_name, "w") --open file
    io.output(file) --set output to file

    io.write("# "..string.sub(file_name,1,-4)..'\n'..'\n') --Write title
    for i = 1, #new_table do
        write_picture(i)(i)
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