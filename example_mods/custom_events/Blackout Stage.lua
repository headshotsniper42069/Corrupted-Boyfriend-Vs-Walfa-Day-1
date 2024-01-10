function onEvent(name, v1, v2)
if name == "Blackout Stage" then
makeLuaSprite('blk','',-500,-500)
makeGraphic('blk',5000,5000,"000000")
addLuaSprite('blk',true) --setting true here, makes it in front of the chars
end
end