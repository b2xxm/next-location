--!strict

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")


local POLL_INTERVAL: number = 0.05

local player: Player = Players.LocalPlayer


local currentRegions: { [string]: BasePart? } = {}
local bufferedRegions: { [string]: BasePart? } = {}


local Region = {}


local function isTouching(region: BasePart): boolean
    local parts = Workspace:GetPartsInPart(region)

    for _, part in parts do
        if part:IsDescendantOf(player.Character) then
            return true
        end
    end

    return false
end


local function poll(regionType: string, callback: (region: BasePart?) -> ()?): ()
    local region = currentRegions[regionType] :: BasePart

    while true do
        if not isTouching(region) then
            break
        end
        
        task.wait(POLL_INTERVAL)
    end
    
    local bufferedRegion = bufferedRegions[regionType]

    if bufferedRegion ~= nil and isTouching(bufferedRegion) then
        if callback then
            callback(bufferedRegion)
        end
        
        currentRegions[regionType] = bufferedRegion
        bufferedRegions[regionType] = nil

        task.spawn(poll, regionType, callback)
        
        return
    end
    
    currentRegions[regionType] = nil
    bufferedRegions[regionType] = nil

    if callback then
        callback(nil)
    end
end


function Region.load(addedRegions: { BasePart }, regionType: string, callback: (region: BasePart?) -> ()?): ()
    for _, region in addedRegions do
        local function touched(hit: BasePart): ()
            local currentRegion = currentRegions[regionType]

            if currentRegion == region then
                return
            end

            if not hit:IsDescendantOf(player.Character :: Model) then
                return
            end

            local bufferedRegion = bufferedRegions[regionType]

            if currentRegion ~= nil then
                if region == bufferedRegion then
                    return
                end

                bufferedRegions[regionType] = region

                return
            end
            
            currentRegions[regionType] = region

            if callback then
                callback(region)
            end

            task.spawn(poll, regionType, callback)
        end

        region.Touched:Connect(touched)
    end
end


function Region.getCurrentRegion(regionType: string): BasePart?
    return currentRegions[regionType]
end


return Region