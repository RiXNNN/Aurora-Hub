local TeleportModule = {}
local LP = game:GetService("Players").LocalPlayer

function TeleportModule.To(coords)
    if not coords or #coords < 3 then return end
    local char = LP.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(coords[1], coords[2], coords[3])
    end
end

TeleportModule.Data = {
    Places = {
        ["SafeZone"] = {-405, 8, -3945},
        ["Hayakawa Village"] = {474, 755, -1994},
        ["Okuiya Village"] = {-3204, 704, -1165},
        ["Kamakura Village"] = {-2148, 1161, -1675},
        ["Slayer Corps HQ"] = {-1785, 871, -6156},
        ["Entertainment Dist"] = {-5411, 744, -6382},
        ["Final Selection"] = {-5195, 792, -3045},
        ["Ubuyashiki Mansion"] = {-1968, 874, -6500},
        ["Crystal Boss Gate"] = {-3062, 845, 1162},
        ["Infinity Castle Entry"] = {1992, 1574, -7314},
        ["Frosty Forest"] = {1601, 950, -7015}
    },
    Perfect_Crystals = {
        ["Perfect Crystal 1"] = {24, 732, -232},
        ["Perfect Crystal 2"] = {-3722, 938, 1338},
        ["Perfect Crystal 3"] = {-2041, 833, -3994},
        ["Perfect Crystal 4"] = {-4527, 909, -2424},
        ["Perfect Crystal 5"] = {-566, 948, -6476},
        ["Perfect Crystal 6"] = {1752, 1207, -1587}
    },
    Shops_Utility = {
        ["Okuiya Soup Shop"] = {-3409, 705, -1584},
        ["Hayakawa Soup Shop"] = {814, 757, -2006},
        ["Slayer Corps Soup Shop"] = {-1362, 871, -6128},
        ["Blacksmith (Hayakawa)"] = {-727, 695, -1518},
        ["Blacksmith (Okuiya)"] = {-4401, 839, 535},
        ["Blacksmith (Kamakura)"] = {2393, 1166, -7351},
        ["Trinket Merchant (Hayakawa)"] = {-649, 697, -1477},
        ["Trinket Merchant (Okuiya)"] = {-4199, 834, 141}
    },
    Trainers_NPCs = {
        ["Flower (Kanoe)"] = {-1282, 871, -6435},
        ["Wind (Grimm)"] = {-3296, 703, -1256},
        ["Sanemi Raid NPC"] = {-3296, 703, -1256},
        ["Sun (Tanjiro)"] = {390, 816, -424},
        ["Moon (Kokushibo)"] = {1826, 1116, -5956},
        ["Flame (Rengoku)"] = {1503, 1236, -356},
        ["Water (Urokodaki)"] = {-915, 845, -984},
        ["Thunder (Jigoro)"] = {-725, 697, 558},
        ["Insect (Shinobu)"] = {-1641, 908, -6493},
        ["Sound (Uzui)"] = {-1268, 871, -6435},
        ["Mist (Muichiro)"] = {3242, 778, -4048},
        ["Love (Mitsuri)"] = {1179, 1077, -1107},
        ["Beast (Inosuke)"] = {-3106, 779, -6595},
        ["Serpent (Obanai)"] = {-7936, 2430, -824},
        ["Muzan NPC"] = {1992, 1574, -7321},
        ["Kaigaku NPC"] = {-2828, 779, -3258}
    },
    Bosses = {
        ["Ax Demon Boss"] = {-2515, 1161, -1486},
        ["Akaza"] = {3614, 3732, 1891},
        ["Douma"] = {3362, 3733, 1773},
        ["Kokushibo Boss"] = {3432, 4010, 1778},
        ["Rui"] = {19605, 3739, -9507},
        ["Gyutaro"] = {-6208, 801, -6144},
        ["Shadow Demon Boss"] = {-1886, 777, -2326},
        ["Crystal Boss"] = {-3062, 845, 1162}
    },
    Flowers = {
        ["Flower Spot 1"] = {-3546, 1306, -2852},
        ["Flower Spot 2"] = {-1531, 716, 476},
        ["Flower Spot 3"] = {-4805, 793, -4974}
    }
}

return TeleportModule
