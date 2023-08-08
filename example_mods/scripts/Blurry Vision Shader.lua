local shaderName = "think fast chucklenuts"
function onCreate()
    size = 0
    shaderCoordFix()

    makeLuaSprite("think fast chucklenuts")
    makeGraphic("shaderImage", screenWidth, screenHeight)

    setSpriteShader("shaderImage", "think fast chucklenuts")


    runHaxeCode([[
        var shaderName = "]] .. shaderName .. [[";
        
        game.initLuaShader(shaderName);
        
        var shader0 = game.createRuntimeShader(shaderName);
        game.camGame.setFilters([new ShaderFilter(shader0)]);
        game.getLuaObject("think fast chucklenuts").shader = shader0; // setting it into temporary sprite so luas can set its shader uniforms/properties
        game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("think fast chucklenuts").shader)]);
        return;
    ]])
end

function onUpdate(elapsed)
    setShaderFloat("think fast chucklenuts", "iTime", os.clock())
    if size > 0 then
        size = size - elapsed * 4
    end
    setShaderFloat("think fast chucklenuts", "Size", size)
end

function trigger()
    size = 14 -- that wasnt so hard was it?
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