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

        triggerDistance = {
            thief = 1,
            kong = 12,
            kongStart = 3.5,
            scale = 12
        },

        lookThreshold = {
            thief = math.cos(math.rad(20)),
            kong = math.cos(math.rad(30)),
        },

        slideBreakRayLength = 2
    },

    invisicam = {
        wallTransparency = 0.8,
        shadowTransparency = 0.3
    }
}