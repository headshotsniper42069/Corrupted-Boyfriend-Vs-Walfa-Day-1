function onCreate()
	--Make Background
	makeLuaSprite('BG1','Backgrounds/YakumoChen/BG1',-180,-500)
	makeLuaSprite('BG2','Backgrounds/YakumoChen/BG2',-180,-450)
	makeLuaSprite('Table','Backgrounds/YakumoChen/Table',420,350)
        addLuaSprite('Table', true)
   
	--ScrollFactor
	setScrollFactor('BG1',1.1,1)
	setScrollFactor('BG2',1.2,1)
	setScrollFactor('Table',1,1)

	scaleObject('BG1',0.8,0.8);
	scaleObject('BG2',0.6,0.6);
	scaleObject('Table',0.8,0.8);

	--Add Sprite + Adjust Layer

	--Top = Back
	addLuaSprite('BG1',false)
	addLuaSprite('BG2',false)
	addLuaSprite('Table',false)
	addLuaSprite('bird',false)
	addLuaSprite('floor',false)
	addLuaSprite('cloud',true)
	--Below = Front
end
