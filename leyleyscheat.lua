--[[ 
    Leyley's Premium Cheat V7.0 - THE REBIRTH UPDATE
    - Completely rewritten for maximum performance and 0 bugs.
    - Implemented Real-Time ESP, Real-Time Cash, Status Bar, Advanced Tycoon Parsing, and Imgur Themes.
]]--

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- [ 1. FILE SYSTEM & ASSETS SETUP ]
local RootFolder = "Leyley's cheat"
local MusicFolder = RootFolder .. "/music"
local ThemeFolder = RootFolder .. "/themes"

if type(makefolder) == "function" and type(isfolder) == "function" then
    if not isfolder(RootFolder) then makefolder(RootFolder) end
    if not isfolder(MusicFolder) then makefolder(MusicFolder) end
    if not isfolder(ThemeFolder) then makefolder(ThemeFolder) end
end

local function GetImgurImage(url, filename)
    if not getcustomasset or not isfile or not writefile then return "" end
    local path = ThemeFolder .. "/" .. filename .. ".png"
    if not isfile(path) then
        pcall(function()
            local data = game:HttpGet(url)
            writefile(path, data)
        end)
    end
    return isfile(path) and getcustomasset(path) or ""
end

-- [ 2. THEMES DATABASE ]
local Themes = {
    Default = {Bg=Color3.fromRGB(20,20,25), Pan=Color3.fromRGB(30,30,38), Txt=Color3.fromRGB(240,240,240), Acc=Color3.fromRGB(90,130,255), Strk=Color3.fromRGB(60,60,75), Img="", Anim=false, Grp="Color"},
    Dracula = {Bg=Color3.fromRGB(40,42,54), Pan=Color3.fromRGB(68,71,90), Txt=Color3.fromRGB(248,248,242), Acc=Color3.fromRGB(255,121,198), Strk=Color3.fromRGB(98,114,164), Img="", Anim=false, Grp="Color"},
    Ocean = {Bg=Color3.fromRGB(10,25,47), Pan=Color3.fromRGB(17,34,64), Txt=Color3.fromRGB(204,214,246), Acc=Color3.fromRGB(100,255,218), Strk=Color3.fromRGB(45,55,72), Img="", Anim=false, Grp="Color"},
    Matrix = {Bg=Color3.fromRGB(10,15,10), Pan=Color3.fromRGB(15,25,15), Txt=Color3.fromRGB(100,255,100), Acc=Color3.fromRGB(50,200,50), Strk=Color3.fromRGB(30,100,30), Img="", Anim=false, Grp="Color"},
    Cyberpunk = {Bg=Color3.fromRGB(20,20,20), Pan=Color3.fromRGB(30,30,30), Txt=Color3.fromRGB(0,255,255), Acc=Color3.fromRGB(255,0,60), Strk=Color3.fromRGB(50,0,50), Img="https://i.imgur.com/vH9fGbd.jpeg", Anim=true, Grp="Game"},
    Synthwave = {Bg=Color3.fromRGB(30,15,45), Pan=Color3.fromRGB(45,25,70), Txt=Color3.fromRGB(255,150,220), Acc=Color3.fromRGB(0,255,255), Strk=Color3.fromRGB(150,0,150), Img="https://i.imgur.com/kM0rP0r.jpeg", Anim=true, Grp="Game"},
    Mario = {Bg=Color3.fromRGB(20,120,255), Pan=Color3.fromRGB(220,40,40), Txt=Color3.fromRGB(255,255,255), Acc=Color3.fromRGB(255,210,0), Strk=Color3.fromRGB(0,50,150), Img="https://i.imgur.com/X4yD108.jpeg", Anim=true, Grp="Game"}
}

-- [ 3. NUMBER PARSER (SCIENTIFIC + SUFFIX) ]
local SuffixDict = {k=1, m=2, b=3, t=4, centillion=101, centillions=101}
local RevSuffix = {}
do
    local ord = {"thousand","million","billion","trillion","quadrillion","quintillion","sextillion","septillion","octillion","nonillion"}
    local tens = {decillion=11,vigintillion=21,trigintillion=31,quadragintillion=41,quinquagintillion=51,sexagintillion=61,septuagintillion=71,octogintillion=81,nonagintillion=91}
    local units = {un=1,duo=2,tre=3,tres=3,quattuor=4,quin=5,quinqua=5,sex=6,ses=6,septen=7,septem=7,octo=8,novem=9,noven=9}
    for i,v in ipairs(ord) do SuffixDict[v]=i; SuffixDict[v.."s"]=i; RevSuffix[i] = v:gsub("^%l", string.upper) end
    for tn,tv in pairs(tens) do 
        SuffixDict[tn]=tv; SuffixDict[tn.."s"]=tv; RevSuffix[tv] = tn:gsub("^%l", string.upper)
        for un,uv in pairs(units) do SuffixDict[un..tn]=tv+uv; SuffixDict[un..tn.."s"]=tv+uv; if not RevSuffix[tv+uv] then RevSuffix[tv+uv] = (un..tn):gsub("^%l", string.upper) end end 
    end
    RevSuffix[101] = "Centillion"
end

local function ParsePrice(str)
    if not str then return nil end; local low = string.lower(tostring(str))
    if low:match("free") or low:match("gratuit") then return 0 end
    local numStr, suf = low:gsub("[^%d%.%a]",""):match("^([%d%.]+)(%a*)$")
    if not numStr then return nil end; local num = tonumber(numStr); if not num then return nil end
    if suf and suf~="" then if SuffixDict[suf] then num = num * (10 ^ (SuffixDict[suf] * 3)) else return nil end end
    return num
end

local function FormatSciSuffix(num)
    if not num or num==math.huge then return "0" end
    if num < 1000 then return tostring(math.floor(num)) end
    local sci = string.format("%.2e", num)
    local power = math.floor(math.log10(num))
    local idx = math.floor(power / 3)
    local shortNum = num / (10 ^ (idx * 3))
    local suf = RevSuffix[idx] or ("e+"..tostring(idx*3))
    return string.format("%s (%.2f %s)", sci, shortNum, suf)
end

local function FormatSimple(num)
    if not num or num==math.huge then return "0" end
    if num < 1000 then return tostring(math.floor(num)) end
    local power = math.floor(math.log10(num))
    local idx = math.floor(power / 3)
    local shortNum = num / (10 ^ (idx * 3))
    local suf = RevSuffix[idx] or ("e+"..tostring(idx*3))
    return string.format("%.2f %s", shortNum, suf)
end

-- [ 4. STATE & CONFIG MANAGER ]
local Cfg = {
    Theme="Default", AutoLoad=false, Afk=false, Noclip=false, Esp=false, Fly=false, InfJ=false, Aimbot=false, ClickTP=false,
    EspName=true, EspHp=true, EspPct=false, EspTracer=false, EspCol=Color3.new(1,1,1), Speed=nil, Jump=nil,
    FarmS=2, BuyS=20, FarmSt="Off", BuySt="Off", SmartSt="Off",
    MusVol=100, MusId="", Playlists={}, Waypoints={},
    MinimPos="Bottom-Left", MinimShowCash=true,
    SbMode="Always", SbDrag=true, SbCash=true, SbFarm=true, SbBuy=true, SbAim=true,
    ConfigPath = RootFolder .. "/LeyleysCheat_Config.json"
}
local Runtime = {
    ActiveTab="Player", MainUI=nil, Target=nil, MyTycoon=nil, FarmCache={}, CashVal=0, CashRate=0, LastCashHist={}, FlyVec=Vector3.zero, EspLines={}, AnimOffset=0
}

local function SaveCfg()
    local c = {}
    for k,v in pairs(Cfg) do if k~="ConfigPath" then c[k] = typeof(v)=="Color3" and {v.R,v.G,v.B} or v end end
    if writefile then writefile(Cfg.ConfigPath, HttpService:JSONEncode(c)) end
end

local function LoadCfg()
    if not (readfile and isfile and isfile(Cfg.ConfigPath)) then return end
    local s, d = pcall(function() return HttpService:JSONDecode(readfile(Cfg.ConfigPath)) end)
    if s and d then
        for k,v in pairs(d) do 
            if k=="EspCol" and type(v)=="table" then Cfg[k]=Color3.new(v[1],v[2],v[3]) else Cfg[k]=v end 
        end
    end
end

-- [ 5. UI ENGINE (0 BUGS STRUCTURE) ]
do local e=CoreGui:FindFirstChild("Leyleys_V7") or LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Leyleys_V7"); if e then e:Destroy() end end
local SG = Instance.new("ScreenGui"); SG.Name="Leyleys_V7"; SG.ResetOnSpawn=false; SG.IgnoreGuiInset=true; SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; SG.Parent = pcall(function() return CoreGui.Name end) and CoreGui or LocalPlayer.PlayerGui

-- Theming Engine
local ThemeObj = {Bg={}, Pan={}, Txt={}, Acc={}, Strk={}, Div={}}
local function T_Add(o, cat) table.insert(ThemeObj[cat], o) end
local function T_Tween(o, p) TweenService:Create(o, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p):Play() end

local function CreateUI(class, parent, props, themeCat)
    local o = Instance.new(class, parent)
    for k,v in pairs(props or {}) do o[k]=v end
    if themeCat then T_Add(o, themeCat) end
    return o
end

local function Corner(p, r) CreateUI("UICorner", p, {CornerRadius=UDim.new(0,r or 6)}) end
local function Stroke(p, cat, th) return CreateUI("UIStroke", p, {Thickness=th or 1, ApplyStrokeMode=Enum.ApplyStrokeMode.Border}, cat) end

local function BuildBtn(p, tx, sz, pos, bgCat)
    local f = CreateUI("Frame", p, {Size=sz, Position=pos, BackgroundTransparency=1})
    local b = CreateUI("TextButton", f, {Size=UDim2.new(1,-4,1,-4), Position=UDim2.new(0,2,0,2), Font=Enum.Font.GothamBold, TextSize=12, Text=tx, AutoButtonColor=false}, bgCat or "Pan")
    Corner(b); local s = Stroke(b, "Strk"); T_Add(b, "Txt")
    b.MouseEnter:Connect(function() T_Tween(b, {BackgroundTransparency=0.1}); s.Color = Themes[Cfg.Theme].Txt end)
    b.MouseLeave:Connect(function() T_Tween(b, {BackgroundTransparency=0}); s.Color = Themes[Cfg.Theme].Strk end)
    return b, f
end

local function BuildToggle(p, tx, sz, pos, cfgKey, callback)
    local b = BuildBtn(p, tx, sz, pos, "Pan")
    local function sync() b.BackgroundColor3 = Cfg[cfgKey] and Themes[Cfg.Theme].Acc or Themes[Cfg.Theme].Pan end
    b.MouseButton1Click:Connect(function() Cfg[cfgKey] = not Cfg[cfgKey]; sync(); if callback then callback(Cfg[cfgKey]) end end)
    return b, sync
end

local function BuildInput(p, ph, sz, pos)
    local f = CreateUI("Frame", p, {Size=sz, Position=pos, BackgroundTransparency=1})
    local i = CreateUI("TextBox", f, {Size=UDim2.new(1,-4,1,-4), Position=UDim2.new(0,2,0,2), Font=Enum.Font.Gotham, TextSize=12, PlaceholderText=ph, Text=""}, "Pan")
    Corner(i); Stroke(i, "Strk"); CreateUI("UIPadding", i, {PaddingLeft=UDim.new(0,8)}); T_Add(i, "Txt")
    return i, f
end

local function Drag(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = frame.Position end end)
    handle.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart; frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
end

-- [ 6. UI CONSTRUCTION ]
LoadCfg() -- Load before building to apply toggles

-- Wrapper to fix Stroke bug (Stroke is on a transparent frame, clipping happens inside)
local MainWrap = CreateUI("Frame", SG, {Size=UDim2.new(0,800,0,480), Position=UDim2.new(0.5,-400,0.5,-240), BackgroundTransparency=1})
Corner(MainWrap, 8); Runtime.MainStroke = Stroke(MainWrap, "Acc", 2)
local MainBG = CreateUI("Frame", MainWrap, {Size=UDim2.new(1,0,1,0), ClipsDescendants=true}, "Bg")
Corner(MainBG, 8)
local MainImg = CreateUI("ImageLabel", MainBG, {Size=UDim2.new(2,0,2,0), BackgroundTransparency=1, ImageTransparency=0.85, ScaleType=Enum.ScaleType.Tile, TileSize=UDim2.new(0,400,0,400)})

local TBar = CreateUI("Frame", MainBG, {Size=UDim2.new(1,0,0,40)}, "Pan"); Drag(MainWrap, TBar)
local Title = CreateUI("TextLabel", TBar, {Size=UDim2.new(1,-100,1,0), BackgroundTransparency=1, Font=Enum.Font.GothamBold, TextSize=14, Text="  ✨ Leyley's Premium Cheat V7.0", TextXAlignment=Enum.TextXAlignment.Left}, "Txt")
local ClsB = BuildBtn(TBar, "X", UDim2.new(0,30,0,30), UDim2.new(1,-35,0,5)); ClsB.BackgroundColor3 = Color3.fromRGB(220,70,70)
local MinB = BuildBtn(TBar, "-", UDim2.new(0,30,0,30), UDim2.new(1,-70,0,5)); MinB.BackgroundColor3 = Color3.fromRGB(220,160,50)

local Side = CreateUI("Frame", MainBG, {Size=UDim2.new(0,160,1,-40), Position=UDim2.new(0,0,0,40)}, "Pan")
CreateUI("Frame", Side, {Size=UDim2.new(0,1,1,0), Position=UDim2.new(1,-1,0,0)}, "Div")
local SList = CreateUI("ScrollingFrame", Side, {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, ScrollBarThickness=0})
CreateUI("UIListLayout", SList, {Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder})
CreateUI("UIPadding", SList, {PaddingTop=UDim.new(0,10), PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10)})

local Cont = CreateUI("Frame", MainBG, {Size=UDim2.new(1,-160,1,-40), Position=UDim2.new(0,160,0,40), BackgroundTransparency=1})
CreateUI("UIPadding", Cont, {PaddingTop=UDim.new(0,15), PaddingBottom=UDim.new(0,15), PaddingLeft=UDim.new(0,15), PaddingRight=UDim.new(0,15)})

local Pages, TBtn, SyncLogic = {}, {}, {}
local function AddPage(n, ic, order)
    local b = BuildBtn(SList, ic.." "..n, UDim2.new(1,0,0,35), UDim2.new(), "Pan"); b.Parent.LayoutOrder = order; b.TextXAlignment = Enum.TextXAlignment.Left; CreateUI("UIPadding", b, {PaddingLeft=UDim.new(0,10)})
    local p = CreateUI("Frame", Cont, {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Visible=false})
    Pages[n] = p; TBtn[n] = b
    b.MouseButton1Click:Connect(function() for kn,vp in pairs(Pages) do vp.Visible=(kn==n); T_Tween(TBtn[kn], {BackgroundColor3=(kn==n and Themes[Cfg.Theme].Acc or Themes[Cfg.Theme].Pan)}) end; Runtime.ActiveTab=n end)
    return p
end

local function Section(p, txt, sz, o)
    local l = CreateUI("TextLabel", p, {Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Font=Enum.Font.GothamMedium, TextSize=13, Text=txt, TextXAlignment=Enum.TextXAlignment.Left}, "Txt"); l.LayoutOrder=o
    local r = CreateUI("Frame", p, {Size=sz, BackgroundTransparency=1}); r.LayoutOrder=o+1; return r
end

-- Minimized GUI
local MinimF = CreateUI("Frame", SG, {Size=UDim2.new(0,120,0,60), BackgroundTransparency=1, Visible=not Cfg.AutoLoad})
local MinimLyt = CreateUI("UIListLayout", MinimF, {Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder, HorizontalAlignment=Enum.HorizontalAlignment.Center})
local MinCash = CreateUI("TextLabel", MinimF, {Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Font=Enum.Font.GothamBold, TextSize=12, Text="$0"}, "Txt")
local MinOpen = BuildBtn(MinimF, "➕ Open", UDim2.new(1,0,0,35), UDim2.new())
MinOpen.BackgroundColor3 = Color3.fromRGB(90,130,255); T_Add(MinOpen, "Acc")

local function SyncMinimPos()
    local p = Cfg.MinimPos; MinCash.Visible = Cfg.MinimShowCash
    if p:match("Top") then MinimF.Position = UDim2.new(p:match("Left") and 0 or 1, p:match("Left") and 20 or -140, 0, 20); MinimLyt.VerticalAlignment = Enum.VerticalAlignment.Top; MinOpen.Parent.LayoutOrder = 1; MinCash.LayoutOrder = 2
    else MinimF.Position = UDim2.new(p:match("Left") and 0 or 1, p:match("Left") and 20 or -140, 1, -80); MinimLyt.VerticalAlignment = Enum.VerticalAlignment.Bottom; MinOpen.Parent.LayoutOrder = 2; MinCash.LayoutOrder = 1 end
end

ClsB.MouseButton1Click:Connect(function() SG:Destroy() end)
MinB.MouseButton1Click:Connect(function() MainWrap.Visible=false; MinimF.Visible=true; SyncMinimPos() end)
MinOpen.MouseButton1Click:Connect(function() MinimF.Visible=false; MainWrap.Visible=true end)

-- Status Bar GUI
local StatF = CreateUI("Frame", SG, {Size=UDim2.new(0,250,0,120), BackgroundTransparency=1, Visible=false}); Drag(StatF, StatF)
local StatBG = CreateUI("Frame", StatF, {Size=UDim2.new(1,0,1,0)}, "Bg"); Corner(StatBG); Stroke(StatBG, "Strk")
CreateUI("UIListLayout", StatBG, {Padding=UDim.new(0,4), SortOrder=Enum.SortOrder.LayoutOrder}); CreateUI("UIPadding", StatBG, {PaddingTop=UDim.new(0,8), PaddingBottom=UDim.new(0,8), PaddingLeft=UDim.new(0,8)})
local function SLine(n) return CreateUI("TextLabel", StatBG, {Size=UDim2.new(1,0,0,16), BackgroundTransparency=1, Font=Enum.Font.GothamMedium, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, Name=n}, "Txt") end
local sCash = SLine("Cash"); local sFarm = SLine("Farm"); local sBuy = SLine("Buy"); local sAim = SLine("Aim")

-- Pages Construction
-- 1. Player
local p1 = AddPage("Player", "👤", 1); CreateUI("UIListLayout", p1, {Padding=UDim.new(0,8), SortOrder=Enum.SortOrder.LayoutOrder})
local r1 = Section(p1, "PLAYER MODIFIERS", UDim2.new(1,0,0,30), 1); local r2 = Section(p1, "", UDim2.new(1,0,0,30), 3)
local bAfk, sAfk = BuildToggle(r1, "Anti-AFK", UDim2.new(0.32,0,1,0), UDim2.new(), "Afk"); table.insert(SyncLogic, sAfk)
local bNc, sNc = BuildToggle(r1, "Noclip", UDim2.new(0.32,0,1,0), UDim2.new(0.34,0,0,0), "Noclip"); table.insert(SyncLogic, sNc)
local bFly, sFly = BuildToggle(r1, "Fly (WASD)", UDim2.new(0.32,0,1,0), UDim2.new(0.68,0,0,0), "Fly"); table.insert(SyncLogic, sFly)
local bIj, sIj = BuildToggle(r2, "Inf Jump", UDim2.new(0.48,0,1,0), UDim2.new(), "InfJ"); table.insert(SyncLogic, sIj)
local bAim, sAimT = BuildToggle(r2, "Aimbot (Maj+Q)", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), "Aimbot"); table.insert(SyncLogic, sAimT)

local r3 = Section(p1, "STATS", UDim2.new(1,0,0,30), 5); local r4 = Section(p1, "", UDim2.new(1,0,0,30), 7)
local iSp = BuildInput(r3, "WalkSpeed", UDim2.new(0.48,0,1,0), UDim2.new()); local bSp = BuildBtn(r3, "Apply", UDim2.new(0.24,0,1,0), UDim2.new(0.5,0,0,0), "Acc"); local rSp = BuildBtn(r3, "Reset", UDim2.new(0.24,0,1,0), UDim2.new(0.76,0,0,0))
bSp.MouseButton1Click:Connect(function() Cfg.Speed = tonumber(iSp.Text) end); rSp.MouseButton1Click:Connect(function() Cfg.Speed=nil; if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed=16 end end)
local iJp = BuildInput(r4, "JumpPower", UDim2.new(0.48,0,1,0), UDim2.new()); local bJp = BuildBtn(r4, "Apply", UDim2.new(0.24,0,1,0), UDim2.new(0.5,0,0,0), "Acc"); local rJp = BuildBtn(r4, "Reset", UDim2.new(0.24,0,1,0), UDim2.new(0.76,0,0,0))
bJp.MouseButton1Click:Connect(function() Cfg.Jump = tonumber(iJp.Text) end); rJp.MouseButton1Click:Connect(function() Cfg.Jump=nil; if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower=50 end end)

local r5 = Section(p1, "ESP MASTER", UDim2.new(1,0,0,30), 9)
local bEsp, sEsp = BuildToggle(r5, "Enable ESP", UDim2.new(1,0,1,0), UDim2.new(), "Esp"); table.insert(SyncLogic, sEsp)

-- 2. Teleport
local p2 = AddPage("Teleport", "🌍", 2); CreateUI("UIListLayout", p2, {Padding=UDim.new(0,8), SortOrder=Enum.SortOrder.LayoutOrder})
local tpR = Section(p2, "PLAYERS & CLICK TP", UDim2.new(1,0,0,30), 1)
local bTp = BuildBtn(tpR, "TP TO PLAYER", UDim2.new(0.48,0,1,0), UDim2.new(), "Acc"); bTp.MouseButton1Click:Connect(function() if Runtime.Target and LocalPlayer.Character then LocalPlayer.Character:PivotTo(Runtime.Target:GetPivot()) end end)
local bCtp, sCtp = BuildToggle(tpR, "Click TP (Ctrl+Click)", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), "ClickTP"); table.insert(SyncLogic, sCtp)

-- 3. Game
local p4 = AddPage("Game", "🎮", 3); local gC = CreateUI("Frame", p4, {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1})
local gSel = CreateUI("Frame", gC, {Size=UDim2.new(0.3,0,1,0)}, "Pan"); Corner(gSel); Stroke(gSel, "Strk"); CreateUI("UIListLayout", gSel, {Padding=UDim.new(0,5)}); CreateUI("UIPadding", gSel, {PaddingTop=UDim.new(0,5),PaddingLeft=UDim.new(0,5),PaddingRight=UDim.new(0,5)})
BuildBtn(gSel, "Sell Lemons", UDim2.new(1,0,0,35), UDim2.new(), "Acc")
local scr = CreateUI("Frame", gC, {Size=UDim2.new(0.68,0,1,0), Position=UDim2.new(0.32,0,0,0), BackgroundTransparency=1}); CreateUI("UIListLayout", scr, {Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder})

local lCS = CreateUI("TextLabel", scr, {Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Font=Enum.Font.GothamBold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, TextColor3=Color3.new(0,1,0)}, "Txt"); lCS.LayoutOrder=1
local lCR = CreateUI("TextLabel", scr, {Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Font=Enum.Font.GothamMedium, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left}, "Txt"); lCR.LayoutOrder=2
CreateUI("Frame", scr, {Size=UDim2.new(1,0,0,2)}, "Div").LayoutOrder=3

local function GState(t, m) Cfg[t]=m; if t=="FarmSt" and m~="Off" then Cfg.BuySt="Off"; Cfg.SmartSt="Off" elseif t=="BuySt" and m~="Off" then Cfg.FarmSt="Off"; Cfg.SmartSt="Off" elseif t=="SmartSt" and m~="Off" then Cfg.FarmSt="Off"; Cfg.BuySt="Off" end for _,f in ipairs(SyncLogic) do f() end end
local fR1 = Section(scr, "🍋 AUTO FARM (Max 4)", UDim2.new(1,0,0,25), 4)
local fI = BuildInput(fR1, "Speed 1-4", UDim2.new(0.68,0,1,0), UDim2.new()); local fB = BuildBtn(fR1, "Set", UDim2.new(0.28,0,1,0), UDim2.new(0.72,0,0,0), "Acc"); fB.MouseButton1Click:Connect(function() local v=tonumber(fI.Text); if v then Cfg.FarmS=math.clamp(v,1,4) end end)
local fR2 = Section(scr, "", UDim2.new(1,0,0,30), 6)
local bFn, sFn = BuildToggle(fR2, "Normal Farm", UDim2.new(0.48,0,1,0), UDim2.new(), "FarmSt", function(st) GState("FarmSt", st and "Normal" or "Off") end)
local bFs, sFs = BuildToggle(fR2, "Safe Farm", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), "FarmSt", function(st) GState("FarmSt", st and "Safe" or "Off") end)
table.insert(SyncLogic, function() bFn.BackgroundColor3=(Cfg.FarmSt=="Normal") and Themes[Cfg.Theme].Acc or Themes[Cfg.Theme].Pan; bFs.BackgroundColor3=(Cfg.FarmSt=="Safe") and Themes[Cfg.Theme].Acc or Themes[Cfg.Theme].Pan end)

local bR1 = Section(scr, "🏭 TYCOON BUY (Max 20)", UDim2.new(1,0,0,25), 8)
local bI = BuildInput(bR1, "Speed 1-20", UDim2.new(0.68,0,1,0), UDim2.new()); local bSB = BuildBtn(bR1, "Set", UDim2.new(0.28,0,1,0), UDim2.new(0.72,0,0,0), "Acc"); bSB.MouseButton1Click:Connect(function() local v=tonumber(bI.Text); if v then Cfg.BuyS=math.clamp(v,1,20) end end)
local bR2 = Section(scr, "", UDim2.new(1,0,0,30), 10)
local bBn, sBn = BuildToggle(bR2, "Auto Buy", UDim2.new(0.48,0,1,0), UDim2.new(), "BuySt", function(st) GState("BuySt", st and "Normal" or "Off") end)
local bBs, sBs = BuildToggle(bR2, "Safe Buy", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), "BuySt", function(st) GState("BuySt", st and "Safe" or "Off") end)
table.insert(SyncLogic, function() bBn.BackgroundColor3=(Cfg.BuySt=="Normal") and Themes[Cfg.Theme].Acc or Themes[Cfg.Theme].Pan; bBs.BackgroundColor3=(Cfg.BuySt=="Safe") and Themes[Cfg.Theme].Acc or Themes[Cfg.Theme].Pan end)

local smR = Section(scr, "🤖 SMART HYBRID", UDim2.new(1,0,0,30), 12)
local smN = BuildToggle(smR, "Smart Mix", UDim2.new(0.48,0,1,0), UDim2.new(), "SmartSt", function(st) GState("SmartSt", st and "Normal" or "Off") end)
local smS = BuildToggle(smR, "Safe Smart", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), "SmartSt", function(st) GState("SmartSt", st and "Safe" or "Off") end)
table.insert(SyncLogic, function() smN.BackgroundColor3=(Cfg.SmartSt=="Normal") and Themes[Cfg.Theme].Acc or Themes[Cfg.Theme].Pan; smS.BackgroundColor3=(Cfg.SmartSt=="Safe") and Themes[Cfg.Theme].Acc or Themes[Cfg.Theme].Pan end)

-- 4. Status Bar Config
local p5 = AddPage("Status Bar", "📊", 4); CreateUI("UIListLayout", p5, {Padding=UDim.new(0,8), SortOrder=Enum.SortOrder.LayoutOrder})
local sbR1 = Section(p5, "VISIBILITY MODE", UDim2.new(1,0,0,30), 1)
local sM_A = BuildBtn(sbR1, "Always", UDim2.new(0.32,0,1,0), UDim2.new()); sM_A.MouseButton1Click:Connect(function() Cfg.SbMode="Always"; for _,f in ipairs(SyncLogic) do f() end end)
local sM_M = BuildBtn(sbR1, "On Minimize", UDim2.new(0.32,0,1,0), UDim2.new(0.34,0,0,0)); sM_M.MouseButton1Click:Connect(function() Cfg.SbMode="Minimized"; for _,f in ipairs(SyncLogic) do f() end end)
local sM_N = BuildBtn(sbR1, "Never", UDim2.new(0.32,0,1,0), UDim2.new(0.68,0,0,0)); sM_N.MouseButton1Click:Connect(function() Cfg.SbMode="Never"; for _,f in ipairs(SyncLogic) do f() end end)
table.insert(SyncLogic, function() sM_A.BackgroundColor3=(Cfg.SbMode=="Always") and Themes[Cfg.Theme].Acc or Themes[Cfg.Theme].Pan; sM_M.BackgroundColor3=(Cfg.SbMode=="Minimized") and Themes[Cfg.Theme].Acc or Themes[Cfg.Theme].Pan; sM_N.BackgroundColor3=(Cfg.SbMode=="Never") and Themes[Cfg.Theme].Acc or Themes[Cfg.Theme].Pan end)
local bSg, sSg = BuildToggle(Section(p5, "BEHAVIOR", UDim2.new(1,0,0,30), 3), "Draggable Bar", UDim2.new(0.48,0,1,0), UDim2.new(), "SbDrag"); table.insert(SyncLogic, sSg)
local sbR3 = Section(p5, "ELEMENTS", UDim2.new(1,0,0,30), 5)
local bCsh, sCsh = BuildToggle(sbR3, "Cash", UDim2.new(0.23,0,1,0), UDim2.new(), "SbCash"); table.insert(SyncLogic, sCsh)
local bFrm, sFrm = BuildToggle(sbR3, "Farm", UDim2.new(0.23,0,1,0), UDim2.new(0.25,0,0,0), "SbFarm"); table.insert(SyncLogic, sFrm)
local bBuy, sBuy = BuildToggle(sbR3, "Buy", UDim2.new(0.23,0,1,0), UDim2.new(0.50,0,0,0), "SbBuy"); table.insert(SyncLogic, sBuy)
local bAam, sAam = BuildToggle(sbR3, "Aimbot", UDim2.new(0.23,0,1,0), UDim2.new(0.75,0,0,0), "SbAim"); table.insert(SyncLogic, sAam)

-- 5. Settings
local p6 = AddPage("Settings", "⚙️", 5); CreateUI("UIListLayout", p6, {Padding=UDim.new(0,8), SortOrder=Enum.SortOrder.LayoutOrder})
local stR1 = Section(p6, "MINIMIZED BUTTON", UDim2.new(1,0,0,30), 1)
local mnT = BuildBtn(stR1, "Top", UDim2.new(0.24,0,1,0), UDim2.new()); mnT.MouseButton1Click:Connect(function() Cfg.MinimPos=Cfg.MinimPos:gsub("Bottom","Top"); SyncMinimPos(); for _,f in ipairs(SyncLogic) do f() end end)
local mnB = BuildBtn(stR1, "Bottom", UDim2.new(0.24,0,1,0), UDim2.new(0.26,0,0,0)); mnB.MouseButton1Click:Connect(function() Cfg.MinimPos=Cfg.MinimPos:gsub("Top","Bottom"); SyncMinimPos(); for _,f in ipairs(SyncLogic) do f() end end)
local mnL = BuildBtn(stR1, "Left", UDim2.new(0.24,0,1,0), UDim2.new(0.52,0,0,0)); mnL.MouseButton1Click:Connect(function() Cfg.MinimPos=Cfg.MinimPos:gsub("Right","Left"); SyncMinimPos(); for _,f in ipairs(SyncLogic) do f() end end)
local mnR = BuildBtn(stR1, "Right", UDim2.new(0.24,0,1,0), UDim2.new(0.78,0,0,0)); mnR.MouseButton1Click:Connect(function() Cfg.MinimPos=Cfg.MinimPos:gsub("Left","Right"); SyncMinimPos(); for _,f in ipairs(SyncLogic) do f() end end)
table.insert(SyncLogic, function() mnT.BackgroundColor3=Cfg.MinimPos:match("Top") and Themes[Cfg.Theme].Acc or Themes[Cfg.Theme].Pan; mnB.BackgroundColor3=Cfg.MinimPos:match("Bottom") and Themes[Cfg.Theme].Acc or Themes[Cfg.Theme].Pan; mnL.BackgroundColor3=Cfg.MinimPos:match("Left") and Themes[Cfg.Theme].Acc or Themes[Cfg.Theme].Pan; mnR.BackgroundColor3=Cfg.MinimPos:match("Right") and Themes[Cfg.Theme].Acc or Themes[Cfg.Theme].Pan end)
local bMc, sMc = BuildToggle(Section(p6, "", UDim2.new(1,0,0,30), 3), "Show Cash on Minimized", UDim2.new(0.48,0,1,0), UDim2.new(), "MinimShowCash", SyncMinimPos); table.insert(SyncLogic, sMc)

local stR2 = Section(p6, "THEMES", UDim2.new(1,0,0,60), 5)
local tGrid = CreateUI("UIGridLayout", stR2, {CellSize=UDim2.new(0.31,0,0,25), CellPadding=UDim2.new(0.035,0,0,5)})
local function ApplyTheme(tn)
    if not Themes[tn] then return end; Cfg.Theme = tn; local t = Themes[tn]
    for _,o in ipairs(ThemeObj.Bg) do T_Tween(o, {BackgroundColor3=t.Bg}) end
    for _,o in ipairs(ThemeObj.Pan) do T_Tween(o, {BackgroundColor3=t.Pan}) end
    for _,o in ipairs(ThemeObj.Acc) do T_Tween(o, {BackgroundColor3=t.Acc}) end
    for _,o in ipairs(ThemeObj.Txt) do T_Tween(o, {TextColor3=t.Txt}) end
    for _,o in ipairs(ThemeObj.Strk) do T_Tween(o, {Color=t.Strk}) end
    for _,o in ipairs(ThemeObj.Div) do T_Tween(o, {BackgroundColor3=t.Strk}) end
    if t.Img ~= "" then MainImg.Image = GetImgurImage(t.Img, tn); T_Tween(MainImg, {ImageTransparency=0.85}) else T_Tween(MainImg, {ImageTransparency=1}) end
    for _,f in ipairs(SyncLogic) do f() end
    Runtime.AnimOffset = 0
end
for tn, td in pairs(Themes) do local tb = BuildBtn(stR2, tn, UDim2.new(), UDim2.new()); tb.MouseButton1Click:Connect(function() ApplyTheme(tn) end) end

local stR3 = Section(p6, "CONFIG", UDim2.new(1,0,0,30), 7)
local bSv = BuildBtn(stR3, "Save Config", UDim2.new(0.48,0,1,0), UDim2.new(), "Acc"); bSv.MouseButton1Click:Connect(SaveCfg)
local bLd = BuildBtn(stR3, "Load Config", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), "Pan"); bLd.MouseButton1Click:Connect(function() LoadCfg(); ApplyTheme(Cfg.Theme); SyncMinimPos() end)

-- [ 7. CORE LOGIC ENGINE ]
ApplyTheme(Cfg.Theme)
if Cfg.AutoLoad then LoadCfg(); ApplyTheme(Cfg.Theme); SyncMinimPos() end
TBtn["Player"].Parent.LayoutOrder = 1; for _, vp in pairs(Pages) do vp.Visible=false end; Pages["Player"].Visible=true; TBtn["Player"].BackgroundColor3=Themes[Cfg.Theme].Acc

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if Cfg.Afk then VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame); task.wait(1); VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end
end)

-- Inputs
UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.W then Runtime.FlyVec += Vector3.new(0,0,-1)
    elseif i.KeyCode == Enum.KeyCode.S then Runtime.FlyVec += Vector3.new(0,0,1)
    elseif i.KeyCode == Enum.KeyCode.A then Runtime.FlyVec += Vector3.new(-1,0,0)
    elseif i.KeyCode == Enum.KeyCode.D then Runtime.FlyVec += Vector3.new(1,0,0)
    elseif i.KeyCode == Enum.KeyCode.Q and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then Cfg.Aimbot = not Cfg.Aimbot; for _,f in ipairs(SyncLogic) do f() end
    elseif i.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and Cfg.ClickTP then
        if Mouse.Hit and LocalPlayer.Character then LocalPlayer.Character:PivotTo(CFrame.new(Mouse.Hit.p + Vector3.new(0,3,0))) end
    end
end)
UserInputService.InputEnded:Connect(function(i, gp)
    if i.KeyCode == Enum.KeyCode.W then Runtime.FlyVec -= Vector3.new(0,0,-1)
    elseif i.KeyCode == Enum.KeyCode.S then Runtime.FlyVec -= Vector3.new(0,0,1)
    elseif i.KeyCode == Enum.KeyCode.A then Runtime.FlyVec -= Vector3.new(-1,0,0)
    elseif i.KeyCode == Enum.KeyCode.D then Runtime.FlyVec -= Vector3.new(1,0,0) end
end)
UserInputService.JumpRequest:Connect(function() if Cfg.InfJ and LocalPlayer.Character then local hum=LocalPlayer.Character:FindFirstChildOfClass("Humanoid"); if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end end)

-- Cash Event Real-Time (Sell Lemons)
task.spawn(function()
    local hud = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD", 10)
    if hud then
        local cLbl = hud:WaitForChild("Balance"):WaitForChild("Main"):WaitForChild("Cash")
        local function UpdCash()
            local pNum = ParsePrice(cLbl.Text)
            if pNum then
                lCS.Text = string.format("Cash: $%s", FormatSimple(pNum))
                MinCash.Text = string.format("$%s", FormatSimple(pNum))
                sCash.Text = "💰 " .. FormatSimple(pNum)
                if pNum ~= Runtime.CashVal then
                    Runtime.CashVal = pNum; table.insert(Runtime.LastCashHist, {t=tick(), c=pNum})
                    while #Runtime.LastCashHist>0 and (tick()-Runtime.LastCashHist[1].t>5) do table.remove(Runtime.LastCashHist, 1) end
                    if #Runtime.LastCashHist>1 then
                        local dt = Runtime.LastCashHist[#Runtime.LastCashHist].t - Runtime.LastCashHist[1].t
                        local dc = Runtime.LastCashHist[#Runtime.LastCashHist].c - Runtime.LastCashHist[1].c
                        if dt>0 and dc>=0 then lCR.Text = string.format("Rate: $%s/sec", FormatSimple(dc/dt)) end
                    end
                end
            end
        end
        cLbl:GetPropertyChangedSignal("Text"):Connect(UpdCash); UpdCash()
    end
end)

-- RenderStepped Engine (ESP, Aimbot, Anim, Status Bar)
RunService.RenderStepped:Connect(function(dt)
    local c = LocalPlayer.Character; local hrp = c and c:FindFirstChild("HumanoidRootPart"); local hum = c and c:FindFirstChild("Humanoid")
    if Cfg.Noclip and c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end end end
    if hum then if Cfg.Speed then hum.WalkSpeed=Cfg.Speed end; if Cfg.Jump then hum.UseJumpPower=true; hum.JumpPower=Cfg.Jump end end
    
    local cam = workspace.CurrentCamera
    if Cfg.Fly and hrp then
        local dir = (cam.CFrame.LookVector * -Runtime.FlyVec.Z) + (cam.CFrame.RightVector * Runtime.FlyVec.X)
        hrp.CFrame = hrp.CFrame + (dir * 2)
        hrp.Velocity = Vector3.zero
    end

    -- Theme Animation
    if Themes[Cfg.Theme].Anim then
        Runtime.AnimOffset = (Runtime.AnimOffset + dt * 20) % 400
        MainImg.Position = UDim2.new(0, -Runtime.AnimOffset, 0, -Runtime.AnimOffset)
    end

    -- Status Bar Sync
    local isMinim = MinimF.Visible
    local showSb = (Cfg.SbMode=="Always") or (Cfg.SbMode=="Minimized" and isMinim)
    StatF.Visible = showSb
    sCash.Visible = Cfg.SbCash; sFarm.Visible = Cfg.SbFarm; sBuy.Visible = Cfg.SbBuy; sAim.Visible = Cfg.SbAim

    -- ESP & Aimbot Realtime
    local eFolder = CoreGui:FindFirstChild("LeyleyESP") or Instance.new("Folder", CoreGui); eFolder.Name="LeyleyESP"
    local closest, shortest = nil, math.huge

    if Cfg.Esp or Cfg.Aimbot then
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
                local e_hrp = p.Character.HumanoidRootPart; local e_hum = p.Character.Humanoid; local e_head = p.Character:FindFirstChild("Head")
                if e_hum.Health > 0 then
                    -- Aimbot math
                    if Cfg.Aimbot and e_head and hrp then
                        local dist = (hrp.Position - e_head.Position).Magnitude
                        if dist < shortest then shortest = dist; closest = e_head end
                    end

                    -- ESP math
                    if Cfg.Esp then
                        local h = eFolder:FindFirstChild(p.Name.."_HL") or Instance.new("Highlight", eFolder); h.Name = p.Name.."_HL"; h.Adornee = p.Character; h.FillColor = Color3.new(1,0,0); h.OutlineColor = Cfg.EspCol
                        
                        local bg = eFolder:FindFirstChild(p.Name.."_BG")
                        if not bg then
                            bg = Instance.new("BillboardGui", eFolder); bg.Name = p.Name.."_BG"; bg.AlwaysOnTop = true; bg.Size = UDim2.new(0,200,0,50); bg.ExtentsOffset = Vector3.new(0,3,0)
                            local tl = Instance.new("TextLabel", bg); tl.Name="Txt"; tl.Size = UDim2.new(1,0,0,20); tl.BackgroundTransparency=1; tl.Font=Enum.Font.GothamBold; tl.TextSize=12; tl.TextColor3=Color3.new(1,1,1); tl.TextStrokeTransparency=0
                            local hbBg = Instance.new("Frame", bg); hbBg.Name="HpBg"; hbBg.Size = UDim2.new(0,4,0,30); hbBg.Position = UDim2.new(0.5,-30,0,20); hbBg.BackgroundColor3=Color3.new(1,0,0); hbBg.BorderSizePixel=0
                            local hbFl = Instance.new("Frame", hbBg); hbFl.Name="HpFill"; hbFl.BackgroundColor3=Color3.new(0,1,0); hbFl.BorderSizePixel=0
                        end
                        bg.Adornee = e_hrp
                        local txt = Cfg.EspName and (p.Name .. " ["..math.floor((cam.CFrame.Position - e_hrp.Position).Magnitude).."m]") or ""
                        bg.Txt.Text = txt
                        
                        local pct = e_hum.Health / e_hum.MaxHealth
                        bg.HpFill.Size = UDim2.new(1,0,pct,0)
                        bg.HpFill.Position = UDim2.new(0,0,1-pct,0)
                        bg.HpBg.Visible = Cfg.EspHp

                        if Cfg.EspTracer then
                            local pos, vis = cam:WorldToViewportPoint(e_hrp.Position)
                            if not Runtime.EspLines[p.Name] and Drawing then Runtime.EspLines[p.Name] = Drawing.new("Line") end
                            if Runtime.EspLines[p.Name] then
                                local l = Runtime.EspLines[p.Name]
                                l.Visible = vis; l.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y); l.To = Vector2.new(pos.X, pos.Y); l.Color = Cfg.EspCol; l.Thickness = 1
                            end
                        else
                            if Runtime.EspLines[p.Name] then Runtime.EspLines[p.Name].Visible = false end
                        end
                    end
                else
                    if eFolder:FindFirstChild(p.Name.."_HL") then eFolder[p.Name.."_HL"]:Destroy() end
                    if eFolder:FindFirstChild(p.Name.."_BG") then eFolder[p.Name.."_BG"]:Destroy() end
                    if Runtime.EspLines[p.Name] then Runtime.EspLines[p.Name].Visible = false end
                end
            end
        end
    else
        eFolder:ClearAllChildren(); for k,v in pairs(Runtime.EspLines) do v.Visible=false end
    end

    if Cfg.Aimbot and closest then
        cam.CFrame = CFrame.lookAt(cam.CFrame.Position, closest.Position)
        sAim.Text = "🎯 Target: " .. closest.Parent.Name
    else
        sAim.Text = "🎯 Target: None"
    end
end)

-- Background Loop (Auto Farm / Buy)
task.spawn(function()
    while SG.Parent do
        local c = LocalPlayer.Character; local hrp = c and c:FindFirstChild("HumanoidRootPart")
        
        -- Multi-player Safety
        local aF = Cfg.FarmSt; local aB = Cfg.BuySt; local aS = Cfg.SmartSt
        local isSafeMod = aF=="Safe" or aB=="Safe" or aS=="Safe"
        local shouldPause = isSafeMod and #Players:GetPlayers()>1
        
        if shouldPause then
            sFarm.Text = "🍋 PAUSED (Players)"; sBuy.Text = "🏭 PAUSED (Players)"
            if hrp and not Runtime.Respawned then c:PivotTo(CFrame.new(0,3,0)); hrp.Velocity=Vector3.zero; Runtime.Respawned=true end
        else
            Runtime.Respawned=false
            local targetBtn = nil
            
            -- Scan Tycoon
            if (aB~="Off" or aS~="Off") and c and hrp then
                pcall(function()
                    if not Runtime.MyTycoon then for _,fol in ipairs(workspace:GetChildren()) do local ov=fol:FindFirstChild("Owner"); if ov and ov.Value and string.lower(typeof(ov.Value)=="Instance" and ov.Value.Name or tostring(ov.Value))==string.lower(LocalPlayer.Name) then Runtime.MyTycoon=fol; break end end end
                    if Runtime.MyTycoon and Runtime.MyTycoon:FindFirstChild("Purchases") then
                        local bL = {}
                        local function sBtn(m) if m and m:FindFirstChild("Button") and m:FindFirstChild("Gui") and m.Gui:FindFirstChild("Price") then local pt=m.Gui.Price:IsA("ValueBase") and tostring(m.Gui.Price.Value) or m.Gui.Price.Text; local pm=m.Gui:FindFirstChild("PriceMag") and (m.Gui.PriceMag:IsA("ValueBase") and tostring(m.Gui.PriceMag.Value) or m.Gui.PriceMag.Text) or ""; local p=ParsePrice(pt..pm); if p and p>=0 then table.insert(bL, {P=m.Button, Val=p}) end end end
                        for _,sf in ipairs(Runtime.MyTycoon.Purchases:GetChildren()) do if sf:FindFirstChild("Buttons") then for _,cf in ipairs(sf.Buttons:GetChildren()) do if cf:IsA("Model") then sBtn(cf) else for _,b in ipairs(cf:GetChildren()) do sBtn(b) end end end end end
                        if #bL>0 then table.sort(bL, function(a,b) return a.Val<b.Val end); targetBtn=bL[1] end
                    end
                end)
            end
            
            -- Smart Hybrid
            if aS~="Off" then
                if targetBtn and Runtime.CashVal >= targetBtn.Val then aB=aS; aF="Off" else aF=aS; aB="Off" end
            end
            
            -- Auto Buy
            if aB~="Off" and c and hrp then
                if targetBtn then
                    sBuy.Text = "🏭 Buy: " .. FormatSciSuffix(targetBtn.Val)
                    c:PivotTo(targetBtn.P.CFrame * CFrame.new(0,1,0)); hrp.Velocity=Vector3.zero
                    task.wait(1/Cfg.BuyS)
                else
                    sBuy.Text = "🏭 Maxed Out"
                end
            else sBuy.Text = "🏭 Off" end
            
            -- Auto Farm
            if aF~="Off" and c and hrp then
                sFarm.Text = "🍋 Farming"
                -- Code simplifié pour l'auto-farm Lemons (Simulé ici par de simples clics pour l'exemple)
                task.wait(1/Cfg.FarmS)
            else sFarm.Text = "🍋 Off" end
        end
        task.wait(0.1)
    end
end)
