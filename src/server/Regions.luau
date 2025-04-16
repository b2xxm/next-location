--!strict

local Players = game:GetService("Players")


local SEPERATOR: string = "_"
local TRANSPARENCY: number = 0.8


local currentRegion: BasePart? = nil
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
        local floor= floorFolder.Name:match(`(%d){ SEPERATOR }.+`)

        if not floor then
            continue
        end

        for _, roomFolder in floorFolder:GetChildren() do
            local room = roomFolder.Name:match(`(%d){ SEPERATOR }.+`)
            
            if not room then
                continue
            end

            local transparency = 0

            if tonumber(floor) :: number > currentFloor or tonumber(room) :: number >= currentRoom then
                transparency = TRANSPARENCY
            end

            print(room, currentRoom, transparency)
            
            for _, instance in roomFolder:GetChildren() do
                -- assume instance is basepart for now
                if not instance:IsA("BasePart") then
                    continue
                end

                instance.Transparency = transparency
            end
        end
    end
end


local function poll(character: Model, region: BasePart): ()
    while true do
        task.wait(0.2)

        if not isTouching(character, region) then
            break
        end
    end
    
    regions[region] = false
    
    if region == currentRegion then
        currentRegion = nil
        
        handleTransparency(math.huge, math.huge)
    end
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

            regions[region] = true
            currentRegion = region
            
            handleTransparency(tonumber(floor) :: number, tonumber(room) :: number)
            task.spawn(poll, character, region)
        end

        region.Touched:Connect(touched)

        regions[region] = false
    end
end


return Regions