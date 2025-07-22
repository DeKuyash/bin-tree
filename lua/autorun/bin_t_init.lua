if SERVER then
    include('server/bin_t_sv.lua')
    AddCSLuaFile('client/bin_t_cl.lua')

end

if CLIENT then
    include('client/bin_t_cl.lua')

end