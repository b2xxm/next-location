--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local TweenUtils = require(client.TweenUtils)
local Region = require(shared.Region)


local SEPERATOR: string = "_"
local TRANSPARENCY: number = 0.8
local SHADOW_TRANSPARENCY: number = 0.3

local tweenInfo: TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)


local currentMap: Model = nil


local HideWalls = {}


local function tweenTransparency(instance: BasePart, transparency: number): ()
    if instance.Transparency == transparency then
        return
    end

    TweenUtils.cancel(instance)

    local goal = { Transparency = transparency }
    local tween = TweenUtils.create(instance, tweenInfo, goal)

    tween:Play()
end


local function handleTransparency(currentFloor: number, currentRoom: number): ()
    for _, floorFolder in currentMap:GetChildren() do
        local floor = floorFolder.Name:match(`(%d){ SEPERATOR }.+`)

        if not floor then
            continue
        end

        local floorNumber = tonumber(floor) :: number
        
        if floorNumber > currentFloor then
            for _, instance in floorFolder:GetDescendants() do
                if not instance:IsA("BasePart") then
                    continue
                end

                tweenTransparency(instance, 1)
            end
            
            continue
        end

        if floorNumber < currentFloor then
            for _, roomFolder in floorFolder:GetChildren() do
                local room = roomFolder.Name:match(`(%d){ SEPERATOR }.+`)
                
                if not room then
                    continue
                end

                for _, instance in roomFolder:GetChildren() do
                    if not instance:IsA("BasePart") then
                        continue
                    end

                    tweenTransparency(instance, 0)
                end
            end

            local shadows = floorFolder:FindFirstChild("Shadows") :: Folder

            for _, shadow in shadows:GetChildren() do
                if not shadow:IsA("BasePart") then
                    continue
                end

                tweenTransparency(shadow, SHADOW_TRANSPARENCY)
            end

            continue
        end

        for _, roomFolder in floorFolder:GetChildren() do
            local room = roomFolder.Name:match(`(%d){ SEPERATOR }.+`)
            
            if not room then
                continue
            end

            local roomNumber = tonumber(room) :: number
            local shouldHide = roomNumber >= currentRoom
            local isInRoom = floorNumber == currentFloor and roomNumber == currentRoom
            
            for _, instance in roomFolder:GetChildren() do
                -- assume instance is basepart for now
                if not instance:IsA("BasePart") then
                    continue
                end

                tweenTransparency(instance, if shouldHide then TRANSPARENCY else 0)
            end

            if not isInRoom then
                continue
            end

            local shadows = floorFolder:FindFirstChild("Shadows") :: Folder
            local shadowValue = roomFolder:FindFirstChildOfClass("ObjectValue")

            for _, shadow in shadows:GetChildren() do
                if not shadow:IsA("BasePart") then
                    continue
                end

                tweenTransparency(shadow, if shadowValue and shadow == shadowValue.Value then 1 else SHADOW_TRANSPARENCY)
            end
        end
    end
end


local function regionEntered(region: BasePart?)
    if region == nil then
        handleTransparency(math.huge, math.huge)

        return
    end
    
    local floor, room = region.Name:match("(%d+).(%d+)")
    handleTransparency(tonumber(floor) :: number, tonumber(room) :: number)
end


function HideWalls.load(map: Model): ()
    local regionFolder = map:FindFirstChild("Regions") :: Folder
    currentMap = map

    local regions = {} :: { BasePart }

    for _, instance in regionFolder:GetChildren() do
        if not instance:IsA("BasePart") then
            continue
        end

        table.insert(regions, instance)
    end

    Region.load(regions, "HideWalls", regionEntered)

    handleTransparency(math.huge, math.huge)
end


return HideWalls