function onEvent(name, value1, value2)
   if name == 'bgchangemarisa' then
    makeLuaSprite(value2, value1, -1600, -200);
    scaleObject(value2, 0.9, 0.9);
    addLuaSprite(value2, false);
    
    
    
    end
end