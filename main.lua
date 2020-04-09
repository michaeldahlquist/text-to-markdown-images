--[[
Names: Michael Dahlquist & Kristen Qako
Class: csci324 - spring2020
File:  main.lua
Purpose:

]]

--Add functions:
dofile("functions.lua")

--Compile java files used
javac = function (x) return os.execute("javac "..x..".java") end --Annonymous function
javac("unsplash")

--START MAIN
io.write("Please input the .txt file: ")
input_text = io.read("*line")
-- TO DO: Add check to see if this file is in the currect directory, and last 4 == ".txt"
_table = get_lines(input_text)
all_sources(_table)
--Move into a folder date_time/

folder =    string.gsub(
                string.gsub(
                    string.gsub(
                        string.sub(os.date("%x"),1,8).." "..string.sub(os.date("%c"),12,19), 
                    ":", "_"), 
                " ", "_"), 
            "/",  "_")

os.execute("mkdir "..folder)
os.execute("cp -r *.jpg "..folder.."/")
os.execute("rm -r *.jpg")

_2md = function (x) return string.sub(x,1,-4).."md" end --Another annonymous function

write_md(_2md(input_text),folder,_table)
os.execute("cp  ".._2md(input_text).." "..folder.."/")
os.execute("rm ".._2md(input_text))