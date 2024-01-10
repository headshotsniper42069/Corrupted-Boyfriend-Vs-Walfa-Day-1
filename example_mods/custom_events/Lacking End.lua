function onEvent(name, value1, value2)
    if name == 'Lacking End' then
        setProperty('camHUD.alpha', 0)
        setProperty('camGame.alpha', 0)
        setProperty('camOther.alpha', 0)
    end
end