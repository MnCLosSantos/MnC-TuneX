Config = {}

Config.Locale = 'en'
Config.RequiredItem = "tunerlaptop" -- Tuner Laptop Item Name
Config.Item = 'tunerchip'           -- Tuner Chip Item Name
Config.UsePlateChangeCommand = true -- true or false
Config.PlateBlacklist = {"faggot", "nigger", "queer", "kkk", "nazi", "eulen"} -- add more as you please
Config.SpeedModifiers = {
    ['0'] = 10.0,   -- Compacts
    ['1'] = 20.0,   -- Sedans
    ['2'] = 30.0,   -- SUVs
    ['3'] = 40.0,   -- Coupes
    ['4'] = 50.0,   -- Muscle
    ['5'] = 60.0,   -- Sports Classics
    ['6'] = 70.0,   -- Sports
    ['7'] = 80.0,   -- Super
	['18'] = 50.0,  -- Emergency        add more classes as you please
}



Locales = {
    ['en'] = {
        ['chip_used'] = 'TuneX plugin applied to %s',
        ['no_vehicle'] = 'You are not in a vehicle!', -- not used
    }
}
