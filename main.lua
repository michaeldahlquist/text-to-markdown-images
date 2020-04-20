--[[
Names: Michael Dahlquist & Kristen Qako
Class: csci324 - spring2020
File:  main.lua
Purpose:

]]

--Define functions:
dofile("functions.lua")

--Add java file names to compile
java = {}
java[1] = "unsplash"
java[2] = "loremflickr"

--Get table of phrases, the name of the text file where the phrases were, 
_table, txt_file, folder, do_git = initalize(java) -- AN EXAMPLE OF MULTIPLE RETURN VALUES!

time = all_sources(_table) --Downloads pictures and returns download time tables

_2md = function (x) return string.sub(x,1,-4).."md" end --Another annonymous function

write_md(_2md(txt_file),_table,time) --write md file of fastest downloaded image of each word

--Move files into the folder, which has the data and time of the start of the execution.
os.execute("mkdir "..folder)
os.execute("mv *.jpg "..folder.."/")
os.execute("mv ".._2md(txt_file).." "..folder.."/README.md")

--If user wishes to send markdown files to GitHub they may.
if do_git then 
    github(folder)
end