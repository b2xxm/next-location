--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local TweenUtils = require(client.TweenUtils)


local SEPERATOR: string = "_"
local TRANSPARENCY: number = 0.8
local SHADOW_TRANSPARENCY: number = 0.3
local POLL_INTERVAL: number = 0.05

local player: Player = Players.LocalPlayer
local tweenInfo: TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)


local currentRegion: BasePart? = nil
local bufferedRegion: BasePart? = nil
local regions: { [BasePart]: boolean } = {}
local currentMap: Model = nil


local Regions = {}


local function isTouching(region: BasePart): boolean
    local parts = workspace:GetPartsInPart(region)

    for _, part in parts do
        if part:IsDescendantOf(player.Character) then
            return true
        end
    end

    return false
end


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


local function poll(): ()
    local region = currentRegion :: BasePart

    while true do
        if not isTouching(region) then
            break
        end
        
        task.wait(POLL_INTERVAL)
    end
    
    regions[region] = false

    if bufferedRegion ~= nil and isTouching(bufferedRegion) then
        local floor, room = bufferedRegion.Name:match("(%d+).(%d+)")

        currentRegion = bufferedRegion
        regions[bufferedRegion] = true
        bufferedRegion = nil

        handleTransparency(tonumber(floor) :: number, tonumber(room) :: number)
        task.spawn(poll)
        
        return
    end
    
    currentRegion = nil
    bufferedRegion = nil

    handleTransparency(math.huge, math.huge)
end


function Regions.load(map: Model): ()
    table.clear(regions)

    local regionFolder = map:FindFirstChild("Regions") :: Folder
    currentMap = map

    for _, region in regionFolder:GetChildren() do
        if not region:IsA("BasePart") then
            continue
        end

        local floor, room = region.Name:match("(%d+).(%d+)")

        local function touched(hit: BasePart): ()
            if regions[region] then
                return
            end

            if not hit:IsDescendantOf(player.Character :: Model) then
                return
            end

            if currentRegion ~= nil and currentRegion ~= region then
                if region == bufferedRegion then
                    return
                end

                bufferedRegion = region

                return
            end
            
            currentRegion = region
            regions[region] = true

            handleTransparency(tonumber(floor) :: number, tonumber(room) :: number)

            task.wait(0.2) -- arbitrary wait time before polling

            task.spawn(poll)
        end

        region.Touched:Connect(touched)

        regions[region] = false
    end

    handleTransparency(math.huge, math.huge)
end


return Regions