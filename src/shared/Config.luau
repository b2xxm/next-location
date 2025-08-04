return {
    camera = {
        offset = Vector3.new(-7, 15, -7),
        smoothFactor = 0.05,
        targetFrameRate = 60
    },

    offset = {
        foot = -Vector3.yAxis * 3,
        waist = -Vector3.yAxis
    },

    locomotion = {
        speed = {
            walk = 8,
            run = 22,
            sneak = 4,
            slide = 22,
            perpendicularFall = 10,
            landWalk = 3,
            thief = 6,
            kong = 22
        },

        duration = {
            land = 0.4,
            slide = 1,
            thief = 0.7,
            kong = 0.4
        },

        vault = {
            thiefLookThreshold = math.cos(math.rad(20)),
            kongLookThreshold = math.cos(math.rad(30)),
            thiefTriggerDistance = 1,
            kongTriggerDistance = 12,
            kongStartDistance = 3.5
        },

        slideBreakRayLength = 2
    },

    invisicam = {
        wallTransparency = 0.8,
        shadowTransparency = 0.8
    }
}