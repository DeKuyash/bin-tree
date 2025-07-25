


local function button_WasPressed(button) 
    if button:GetText() == '' and button:GetText() ~= 'another' then
        button:SetMaterial('phoenix_storms/wire/pcb_blue')
        button:SetText('self') -- как индикатор состояния, чтобы работало как переключатель, тк у кнопки не узнать материал

    elseif button:GetText() == 'self' and button:GetText() ~= 'another' then
        button:SetText('')
        button:SetMaterial(nil)

    end
end

local function button_AnotherPressed(button)
    if button:GetText() == '' and button:GetText() ~= 'self' then
        button:SetMaterial('phoenix_storms/wire/pcb_red')
        button:SetText('another')

    elseif button:GetText() == 'another' and button:GetText() ~= 'self' then
        button:SetText('')
        button:SetMaterial(nil)

    end
end


local function button_DrawLine(button1, button2, frame)
    local line = vgui.Create('DPanel', frame)
    line:SetSize(2000, 2000)
    line:SetDisabled(true)

    line.Paint = function(self, w, h)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawLine(button1:GetX()+15, button1:GetY()+15, button2:GetX()+15, button2:GetY()+15)
    end
end





local buttonMakeCount = 6

local buttonMakeChild
button_MakeChild = function(buttonParent, frame, buttonParent_tbl, buttonParent_parents) 

    if buttonMakeCount > 0 and buttonMakeCount ~= 1 then
        buttonMakeCount = buttonMakeCount - 1
        local bChild1 = vgui.Create('DButton', frame)
        bChild1:SetSize(30, 30)
        bChild1:SetPos(buttonParent:GetX() - 80, buttonParent:GetY() + 50)
        bChild1:SetText('')
        button_DrawLine(buttonParent, bChild1, frame)

        table.insert(buttonParent_parents, bChild1) -- передаем кнопку в список родителей

        table.insert(buttonParent_tbl, bChild1) -- buttonParent_tbl - подаем через список детей кнопки и саму кнопку, возвращаем в функции, тем самым снизу вверх передаем детей для AnotherPressed
        local bChild1_tbl = {}
        local bChild1_childs = button_MakeChild(bChild1, frame, bChild1_tbl, buttonParent_parents)
        table.Add(buttonParent_tbl, bChild1_childs)


        bChild1.DoClick = function() 
            button_WasPressed(bChild1)

            for _, v in pairs(buttonParent_parents) do
                if v ~= bChild1 then
                    button_AnotherPressed(v)
                end
            end
            
            for _, v in pairs(bChild1_childs) do
                if v ~= bChild1 then
                    button_AnotherPressed(v)
                end
            end

            for _, v in pairs(buttonParent_tbl) do
                if v ~= bChild1 then
                    button_AnotherPressed(v)
                end
            end


        end

        return buttonParent_tbl

    end


    if buttonMakeCount == 1 then -- последней паре нечего возвращать (дети), поэтому особые условия
        buttonMakeCount = buttonMakeCount - 1
        local bChild1 = vgui.Create('DButton', frame)
        bChild1:SetSize(30, 30)
        bChild1:SetPos(buttonParent:GetX() - 80, buttonParent:GetY() + 50)
        bChild1:SetText('')
        button_DrawLine(buttonParent, bChild1, frame)

        table.insert(buttonParent_parents, bChild1)

        table.insert(buttonParent_tbl, bChild1)

        bChild1.DoClick = function() 
            button_WasPressed(bChild1)

            for _, v in pairs(buttonParent_parents) do
                if v ~= bChild1 then
                    button_AnotherPressed(v)
                end
            end
            
            for _, v in pairs(buttonParent_tbl) do
                if v ~= bChild1 then
                    button_AnotherPressed(v)
                end
            end

        end

        return buttonParent_tbl

    end
end





















local function menu_BinTree()
    local baseFrame = vgui.Create('DFrame')
    baseFrame:SetSize(1000, 1000)
    baseFrame:Center()
    baseFrame:MakePopup()


    local startButton = vgui.Create('DButton', baseFrame)
    startButton:SetSize(30, 30)
    startButton:SetPos(ScrW()/4, 50)
    startButton:SetText('')

    local startButton_parents = {} -- передача родителей
    table.insert(startButton_parents, startButton)

    local startButton_tbl = {} -- передача детей
    local startButton_childs = button_MakeChild(startButton, baseFrame, startButton_tbl, startButton_parents)


    startButton.DoClick = function()
        button_WasPressed(startButton)
        for _, v in pairs(startButton_childs) do
            button_AnotherPressed(v)
        end
    end


end




hook.Add('OnPlayerChat', 'init.BinTree', function(ply, str)
    if str == '!bintree' then 
        menu_BinTree()

    end
end)