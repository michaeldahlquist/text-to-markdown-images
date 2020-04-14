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
_table, do_git, folder = initalize(java) -- AN EXAMPLE OF MULTIPLE RETURN VALUES!

all_sources(_table)

_2md = function (x) return string.sub(x,1,-4).."md" end --Another annonymous function

write_md("README.md",folder,_table)

--Move files into the folder, which has the data and time of the start of the execution.
os.execute("mkdir "..folder)
os.execute("cp -r *.jpg "..folder.."/")
os.execute("rm -r *.jpg")
os.execute("cp  ".."README.md".." "..folder.."/README.md")
os.execute("rm ".."README.md")

if do_git then 
    print("Sorry, I have not yet configured the GitHub portion...")
    --github(folder)
end