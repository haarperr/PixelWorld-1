function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end
Citizen.CreateThread(function()
    AddTextEntry('F82M4', '2015 BMW F82 M4') -- Enter Gamename from vehicles.lua and what you want it to display.
    AddTextEntry('F82M4ST', '2015 BMW F82 M4 (ST)')
	AddTextEntry('M4DUKE', '2015 BMW F82 M4 (Duke)')
	AddTextEntry('4SERLW', '2015 BMW F82 M4 (SLW)')
	AddTextEntry('M4LW', '2015 BMW F82 M4 (LW)')
	AddTextEntry('M4Lucra', '2015 BMW F82 M4 (HS)')
	AddTextEntry('m8gte', '2019 BMW M8 GTE')
	AddTextEntry('X5E53', 'BMW X5 E53')
	AddTextEntry('m5e34', '1984 BMW M5')
	AddTextEntry('BMWZ4', '2019 BMW Z4')
	AddTextEntry('2019M5', '2019 BMW M5')
	AddTextEntry('440i', '2018 BMW 400i')
	AddTextEntry('m3e46', '2006 BMW e46 M3')
	AddTextEntry('rmodmi8lb', '2019 BMW i8 (LW)')
	AddTextEntry('bmwm8', '2019 BMW M8')


end)