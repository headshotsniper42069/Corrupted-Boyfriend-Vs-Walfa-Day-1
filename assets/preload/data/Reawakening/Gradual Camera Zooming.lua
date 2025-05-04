-- Flanchan zooming in script
-- Also works with playback speed, i did that for testing LOL
-- Does not work with camera zoom changing events

local zoomRate = 1 -- Adjust this for how much it should zoom in

function onUpdate(elapsed)
    setProperty('defaultCamZoom', getProperty('defaultCamZoom') + (zoomRate / 500 * elapsed * playbackRate))
    setProperty('camGame.zoom', getProperty('camGame.zoom') + (zoomRate / 500 * elapsed * playbackRate))
end