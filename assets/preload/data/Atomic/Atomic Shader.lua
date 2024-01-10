local shaderName = "Atomic Heat Distortion"
function onCreatePost()
    if songName == 'atomic' then
    shaderCoordFix()
    
    makeLuaSprite("Atomic Heat Distortion")
    makeGraphic("shaderImage", screenWidth, screenHeight)

    setSpriteShader("shaderImage", "Atomic Heat Distortion")

    luaDebugMode = true

    runHaxeCode([[
        var shaderName = "]] .. shaderName .. [[";

        game.initLuaShader(shaderName);

        var shader0 = game.createRuntimeShader(shaderName);
        game.camGame.setFilters([new ShaderFilter(shader0)]);
        game.getLuaObject("Atomic Heat Distortion").shader = shader0;
    //    game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("Atomic Heat Distortion").shader)]);
        for (note in game.strumLineNotes)
        {
            note.shader = game.createRuntimeShader(shaderName);
        }
        for (note in game.unspawnNotes)
        {
            note.shader = game.createRuntimeShader(shaderName);
        }
        return;
    ]])
    end
end

function onUpdate(elapsed)
    setShaderFloat("Atomic Heat Distortion", "iTime", os.clock())
end

function shaderCoordFix()
    runHaxeCode([[
        resetCamCache = function(?spr) {
            if (spr == null || spr.filters == null) return;
            spr.__cacheBitmap = null;
            spr.__cacheBitmapData = null;
        }
        
        fixShaderCoordFix = function(?_) {
            resetCamCache(game.camGame.flashSprite);
            resetCamCache(game.camHUD.flashSprite);
            resetCamCache(game.camOther.flashSprite);
        }
    
        FlxG.signals.gameResized.add(fixShaderCoordFix);
        fixShaderCoordFix();
        return;
    ]])
    
    local temp = onDestroy
    function onDestroy()
        runHaxeCode([[
            FlxG.signals.gameResized.remove(fixShaderCoordFix);
            return;
        ]])
        if (temp) then temp() end
    end
end