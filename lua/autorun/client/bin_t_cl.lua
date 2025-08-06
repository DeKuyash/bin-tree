


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

function deleteDuplicates(tbl)
    local newTbl = {}
    local hashTbl = {}

    for _, v in ipairs(tbl) do
        if not(hashTbl[v]) then
            table.insert(newTbl, v)
            hashTbl[v] = true            
        end
    end

    return newTbl
end


local button_MakeChild
button_MakeChild = function(buttonParent, frame, parents, buttonCount, buttonWidth, buttonHeight)

    if buttonCount <= 0 then return {} end

    buttonCount = buttonCount - 1
    buttonWidth = buttonWidth / 2
    buttonHeight = buttonHeight + 15

    local childs = {}

    local bChild1 = vgui.Create('DButton', frame)
    bChild1:SetSize(30, 30)
    bChild1:SetPos(buttonParent:GetX() - buttonWidth, buttonParent:GetY() + buttonHeight)
    bChild1:SetText('')
    button_DrawLine(buttonParent, bChild1, frame)


    local bChild2 = vgui.Create('DButton', frame)
    bChild2:SetSize(30, 30)
    bChild2:SetPos(buttonParent:GetX() + buttonWidth, buttonParent:GetY() + buttonHeight)
    bChild2:SetText('')
    button_DrawLine(buttonParent, bChild2, frame)

    -----------------------------------------------

    local parentsChild1 = {buttonParent, bChild1}
    local parentsChild2 = {buttonParent, bChild2}

    table.Add(parentsChild1, parents)
    table.Add(parentsChild2, parents)

    parentsChild1 = deleteDuplicates(parentsChild1)
    parentsChild2 = deleteDuplicates(parentsChild2)  

    ---

    local bChild1_childs = button_MakeChild(bChild1, frame, parentsChild1, buttonCount, buttonWidth, buttonHeight)
    local bChild2_childs = button_MakeChild(bChild2, frame, parentsChild2, buttonCount, buttonWidth, buttonHeight)

    table.Add(childs, bChild1_childs)
    table.Add(childs, bChild2_childs)
    table.insert(childs, bChild1)
    table.insert(childs, bChild2)


    -----------------------------------------------

    bChild1.DoClick = function()
        button_WasPressed(bChild1)

        for _, v in ipairs(parents) do
            button_AnotherPressed(v)
        end


        for _, v in ipairs(bChild1_childs) do
            button_AnotherPressed(v)
        end
    end


    bChild2.DoClick = function()
        button_WasPressed(bChild2)

        for _, v in ipairs(parents) do
            button_AnotherPressed(v)
        end


        for _, v in ipairs(bChild2_childs) do
            button_AnotherPressed(v)
        end
    end


    return childs

end






local function menu_BinTree()

    local startButton_childs = {} -- передача дочерних

    local baseFrame = vgui.Create('DFrame')
    baseFrame:SetSize(1000, 1000)
    baseFrame:Center()
    baseFrame:MakePopup()


    local startButton = vgui.Create('DButton', baseFrame)
    startButton:SetSize(30, 30)
    startButton:SetPos(ScrW()/4, 50)
    startButton:SetText('')

    startButton.DoClick = function()
        button_WasPressed(startButton)
        for _, v in ipairs(startButton_childs) do
            button_AnotherPressed(v)
        end
    end

    -----------------------------------------------

    local child1Button = vgui.Create('DButton', baseFrame)
    child1Button:SetSize(30, 30)
    child1Button:SetPos(startButton:GetX() - 200, startButton:GetY() + 50)
    child1Button:SetText('')
    button_DrawLine(startButton, child1Button, baseFrame)




    local child2Button = vgui.Create('DButton', baseFrame)
    child2Button:SetSize(30, 30)
    child2Button:SetPos(startButton:GetX() + 200, startButton:GetY() + 50)
    child2Button:SetText('')
    button_DrawLine(startButton, child2Button, baseFrame)



    -----------------------------------------------

    local startButton_parents1 = {} -- передача родителей
    local startButton_parents2 = {}
    table.insert(startButton_parents1, startButton)
    table.insert(startButton_parents2, startButton)


    table.insert(startButton_parents1, child1Button)
    table.insert(startButton_parents2, child2Button)

    -- передача дочерних
    table.insert(startButton_childs, child1Button)
    table.insert(startButton_childs, child2Button)

    local buttonCount = 3
    local buttonWidth = 60 * buttonCount
    local buttonHeight = 60

    local child1Button_childs = button_MakeChild(child1Button, baseFrame, startButton_parents1, buttonCount, buttonWidth, buttonHeight)
    local child2Button_childs = button_MakeChild(child2Button, baseFrame, startButton_parents2, buttonCount, buttonWidth, buttonHeight)

    table.Add(startButton_childs, child1Button_childs)
    table.Add(startButton_childs, child2Button_childs)

    -----------------------------------------------

    child1Button.DoClick = function()
        button_WasPressed(child1Button)
        button_AnotherPressed(startButton)

        for _, v in ipairs(child1Button_childs) do
            button_AnotherPressed(v)
        end
    end

    child2Button.DoClick = function()
        button_WasPressed(child2Button)
        button_AnotherPressed(startButton)

        for _, v in ipairs(child2Button_childs) do
            button_AnotherPressed(v)
        end
    end


end





hook.Add('OnPlayerChat', 'init.BinTree', function(ply, str)
    if str == '!bintree' then 
        menu_BinTree()

    end
end)