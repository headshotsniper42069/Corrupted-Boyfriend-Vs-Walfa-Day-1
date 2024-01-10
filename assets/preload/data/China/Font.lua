function onUpdate()
	setTextFont("timeTxt", "DFPOCOC.ttf")          setTextFont("menuTxt","DFPOCOC.ttf")
	setTextFont("scoreTxt","DFPOCOC.ttf")	  setTextFont("botplayTxt","DFPOCOC.ttf")
end
function opponentNoteHit()
    health = getProperty('health')
    if getProperty('health') > 0.05 then
        setProperty('health', health- 0.02);
    end
end