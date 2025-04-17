--!strict

local Players = game:GetService("Players")


local SEPERATOR: string = "_"
local TRANSPARENCY: number = 0.9
local SHADOW_TRANSPARENCY: number = 0.3
local POLL_INTERVAL: number = 0.05


local currentRegion: BasePart? = nil
local bufferedRegion: BasePart? = nil
local regions: { [BasePart]: boolean } = {}
local currentMap: Model = nil


local Regions = {}


local function isTouching(character: Model, region: BasePart): boolean
    local parts = workspace:GetPartsInPart(region)

    for _, part in parts do
        if part:IsDescendantOf(character) then
            return true
        end
    end

    return false
end


local function handleTransparency(currentFloor: number, currentRoom: number): ()
    for _, floorFolder in currentMap:GetChildren() do
        local floor = floorFolder.Name:match(`(%d){ SEPERATOR }.+`)

        if not floor then
            continue
        end

        local shadows = floorFolder:FindFirstChild("Shadows")

        if shadows then
            for _, shadow in shadows:GetChildren() do
                if not shadow:IsA("BasePart") then
                    continue
                end

                shadow.Transparency = SHADOW_TRANSPARENCY
            end
        end

        for _, roomFolder in floorFolder:GetChildren() do
            local room = roomFolder.Name:match(`(%d){ SEPERATOR }.+`)
            
            if not room then
                continue
            end

            local floorNumber, roomNumber = tonumber(floor) :: number, tonumber(room) :: number
            local shouldHide = floorNumber > currentFloor or roomNumber >= currentRoom
            local isInRoom = floorNumber == currentFloor and roomNumber == currentRoom
            
            for _, instance in roomFolder:GetChildren() do
                -- assume instance is basepart for now
                if not instance:IsA("BasePart") then
                    continue
                end

                instance.Transparency = if shouldHide then TRANSPARENCY else 0
            end

            if not isInRoom then
                continue
            end

            local shadowValue = roomFolder:FindFirstChild("Shadow") :: ObjectValue

            if not shadowValue then
                continue
            end

            local shadowPart = shadowValue.Value :: BasePart
            shadowPart.Transparency = 1
        end
    end
end


local function poll(character: Model, region: BasePart): ()
    while true do
        if not isTouching(character, region) then
            break
        end
        
        task.wait(POLL_INTERVAL)
    end
    
    regions[region] = false

    if bufferedRegion ~= nil and isTouching(character, bufferedRegion) then
        local floor, room = bufferedRegion.Name:match("(%d+).(%d+)")

        handleTransparency(tonumber(floor) :: number, tonumber(room) :: number)
        task.spawn(poll, character, bufferedRegion)
        
        currentRegion = bufferedRegion
        regions[bufferedRegion] = true
        bufferedRegion = nil
        
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
            return
        end

        local floor, room = region.Name:match("(%d+).(%d+)")

        local function touched(hit: BasePart): ()
            if regions[region] then
                return
            end

            local character = hit:FindFirstAncestorOfClass("Model")

            if not character then
                return
            end

            local player = Players:GetPlayerFromCharacter(character)

            if not player then
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

            task.spawn(poll, character, region)
        end

        region.Touched:Connect(touched)

        regions[region] = false
    end
end


return Regions