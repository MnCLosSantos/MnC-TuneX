Config = {}

Config.Locale = 'en'


-- WIP Ignore
--
Config.UsePlateChangeCommand = false  -- true or false
Config.PlateBlacklist = {"faggot", "nigger", "queer", "kkk", "nazi", "eulen"} -- add more as you please



-- TuneX decryption tuning Configs
--
Config.RequiredItem = "tunerdrive2"    -- Tuner Laptop Item Name
Config.Item = 'tunerlaptop'          -- Tuner Chip Item Name
Config.SpeedModifiers = {
    ['0'] = 10.0,    -- Compacts
    ['1'] = 11.0,    -- Sedans
    ['2'] = 12.0,    -- SUVs
    ['3'] = 13.0,    -- Coupes
    ['4'] = 14.0,    -- Muscle
    ['5'] = 15.0,    -- Sports Classics
    ['6'] = 16.0,    -- Sports
    ['7'] = 17.0,    -- Super
	['8'] = 10.0,    -- Motorcycles
    ['9'] = 10.0,    -- Off Road
    ['10'] = 30.0,   -- Industrial
    ['11'] = 10.0,   -- Utility
    ['12'] = 10.0,   -- Vans
	['17'] = 10.0,   -- Service
	['18'] = 50.0,   -- Emergency (jobtune)
	['20'] = 10.0,   -- Commercial
    ['22'] = 10.0,   -- Openwheel
}



-- TuneX driftmode Config
--
Config.handleMods = {
    {"fInitialDragCoeff", 90.22},
    {"fDriveInertia", .31},
    {"fSteeringLock", 22},
    {"fTractionCurveMax", -1.1},
    {"fTractionCurveMin", -.4},
    {"fTractionCurveLateral", 2.5},
    {"fLowSpeedTractionLossMult", -.57}
}



-- TuneX rollback and handbreak Config
--
Config.betterRollback = {
    -- Whether better rollback should be enabled
    enabled = true,
    -- Duration/period of the rollback
    duration = 30,
    -- Strength/speed of the rollback
    strength = 50,
}

-- These handbrake turns happen when the player lets off their throttle (W). Turns their wheel and applies the handbrake
Config.betterHandbrakeTurns = {
    -- Whether to enable better hand brake turns
    enabled = true,
    -- Strength of the improved handbrake turns system
    strength = 1.5,
}



-- Ignore
--
Locales = {
    ['en'] = {
        ['chip_used'] = 'TuneX plugin applied to %s',
        ['no_vehicle'] = 'You are not in a vehicle!', -- not used
    }
}
