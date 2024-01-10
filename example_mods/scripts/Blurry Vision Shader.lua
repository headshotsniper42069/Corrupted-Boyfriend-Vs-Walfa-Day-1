local shaderName = "think fast chucklenuts"
shaderIsEnabled = false
function initCameraShader()
    size = 0
    shaderQuality = 4
    shaderCoordFix()

    makeLuaSprite("think fast chucklenuts")
    makeGraphic("shaderImage", screenWidth, screenHeight)

    setSpriteShader("shaderImage", "think fast chucklenuts")

    runHaxeCode([[
        var shaderName = "]] .. shaderName .. [[";

        game.initLuaShader(shaderName);

        var shader0 = game.createRuntimeShader(shaderName);
        game.camGame.setFilters([new ShaderFilter(shader0)]);
        game.getLuaObject("think fast chucklenuts").shader = shader0;
        game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("think fast chucklenuts").shader)]);
        return;
    ]])
    shaderIsEnabled = true
end

function onUpdate(elapsed)
    if shaderIsEnabled then
        setShaderFloat("think fast chucklenuts", "iTime", os.clock())
        if size > 0 then
            size = size - elapsed * 4
        else
            shaderQuality = 0
        end
        setShaderFloat("think fast chucklenuts", "Size", size)
        setShaderFloat("think fast chucklenuts", "Quality", shaderQuality)
    end
end

function trigger()
    size = 14 -- that wasnt so hard was it?
    shaderQuality = 4
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