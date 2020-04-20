--[[
Names: Michael Dahlquist & Kristen Qako
Class: csci324 - spring2020
File:  main.lua
Date:  April 21st, 2020
Purpose:
    This program takes in a file that contains only lines of rows with keyword(s)
    of images to be randomly pulled from two sources. This is given by the user.
    The results of these random searches may (and probably will) vary greatly. 
    The program then writes a markdown file of all of the images and the keyword 
    phrase searched. After, if the user prompted and has the current files in a 
    cloned github repository, the program will push all of the files into GitHub
    where it can be viewed in the repository or on a GitHub Pages site.
]]

--Define functions:
dofile("functions.lua")

--Add java file names to compile
java = {}
java[1] = "unsplash"
java[2] = "loremflickr"

--Get table of phrases, the name of the text file where the phrases were, 
phrase_table, txt_file, folder, do_git = initialize(java) -- multiple return values of different types

time = all_sources(phrase_table) --Downloads pictures and returns download time tables

_2md = function (x) return string.sub(x,1,-4).."md" end

write_md(_2md(txt_file),phrase_table,time) --write md file of fastest downloaded image of each word

--Move files into the folder, which has the data and time of the start of the execution.
os.execute("mkdir "..folder)
os.execute("mv *.jpg "..folder.."/")
os.execute("mv ".._2md(txt_file).." "..folder.."/README.md")

--If the user wishes to send markdown files to GitHub they may.
if do_git then 
    github(folder)
end