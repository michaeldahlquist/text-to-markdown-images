--[[
Names: Michael Dahlquist & Kristen Qako
Class: csci324 - spring2020
File:  main.lua
Purpose:

]]

--Add functions:
dofile("functions.lua")

--Add java file names to compile
java = {}
java[1] = "unsplash"

--Get table of phrases, the name of the text file where the phrases were, 
_table, txt_file, folder = initalize(java) -- AN EXAMPLE OF MULTIPLE RETURN VALUES!

all_sources(_table)

_2md = function (x) return string.sub(x,1,-4).."md" end --Another annonymous function

write_md(_2md(txt_file),_table)

--Move files into the folder, which has the data and time of the start of the execution.

os.execute("mkdir "..folder)
os.execute("cp -r *.jpg "..folder.."/")
os.execute("rm -r *.jpg")
os.execute("cp  ".._2md(txt_file).." "..folder.."/README.md")
os.execute("rm ".._2md(txt_file))


if do_git then 
    print("Sorry, I have not yet configured the GitHub portion...")
    --github(folder)
end