--[[ 
    Leyley's Premium Cheat V6.21 - THE STATUS & THEMES UPDATE
    - Fixed: Safety respawn Y coordinate is now 3 instead of 93.
    - Fixed: GUI stroke clipping issues on the corners.
    - Added: Floating Status Bar with dynamic positioning, draggable toggles, and display modes.
    - Added: "Status bar" Tab for full customization of the floating UI.
    - Added: Wallpapers to Themes (Background Images) and smoother UI logic.
    - Updated: Buy speed max increased to 20.
    - Updated: Real-time Cash and ESP updating (RenderStepped instead of slow loop).
    - Updated: Scientific + Suffix notation in Auto Buy ("3.38e+195 (3.38 Quattuorsexagintillion)").
    - Added: Everything saves to Config.
]]--

print("Leyley's Premium Cheat V6.21 loaded")

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

-- [ 0. FILE SYSTEM SETUP ]
if type(makefolder) == "function" and type(isfolder) == "function" then
    if not isfolder("Leyley's cheat") then makefolder("Leyley's cheat") end
    if not isfolder("Leyley's cheat/music") then makefolder("Leyley's cheat/music") end
end

-- [ 1. THEMES DATABASE WITH WALLPAPERS ]
local Themes = {
    Default={MainBg=Color3.fromRGB(20,20,25),PanelBg=Color3.fromRGB(30,30,38),Text=Color3.fromRGB(240,240,240),Accent=Color3.fromRGB(90,130,255),Success=Color3.fromRGB(60,180,90),Danger=Color3.fromRGB(220,70,70),Warning=Color3.fromRGB(220,160,50),Stroke=Color3.fromRGB(60,60,75),Group="Color",Wallpaper=""},
    Dracula={MainBg=Color3.fromRGB(40,42,54),PanelBg=Color3.fromRGB(68,71,90),Text=Color3.fromRGB(248,248,242),Accent=Color3.fromRGB(255,121,198),Success=Color3.fromRGB(80,250,123),Danger=Color3.fromRGB(255,85,85),Warning=Color3.fromRGB(241,250,140),Stroke=Color3.fromRGB(98,114,164),Group="Color",Wallpaper=""},
    Ocean={MainBg=Color3.fromRGB(10,25,47),PanelBg=Color3.fromRGB(17,34,64),Text=Color3.fromRGB(204,214,246),Accent=Color3.fromRGB(100,255,218),Success=Color3.fromRGB(0,200,150),Danger=Color3.fromRGB(255,100,100),Warning=Color3.fromRGB(255,200,0),Stroke=Color3.fromRGB(45,55,72),Group="Color",Wallpaper="rbxassetid://12345678"}, -- Placeholder
    Hacker={MainBg=Color3.fromRGB(0,5,0),PanelBg=Color3.fromRGB(5,15,5),Text=Color3.fromRGB(50,255,50),Accent=Color3.fromRGB(0,200,0),Success=Color3.fromRGB(100,255,100),Danger=Color3.fromRGB(200,0,0),Warning=Color3.fromRGB(200,200,0),Stroke=Color3.fromRGB(0,50,0),Group="Color",Wallpaper=""},
    Cyberpunk={MainBg=Color3.fromRGB(15,10,25),PanelBg=Color3.fromRGB(25,15,40),Text=Color3.fromRGB(255,255,0),Accent=Color3.fromRGB(255,0,255),Success=Color3.fromRGB(0,255,255),Danger=Color3.fromRGB(255,50,50),Warning=Color3.fromRGB(255,150,0),Stroke=Color3.fromRGB(100,0,150),Group="Color",Wallpaper="rbxassetid://7142478440"}, -- Cyberpunk grid vibe
    Synthwave={MainBg=Color3.fromRGB(30,15,45),PanelBg=Color3.fromRGB(45,25,70),Text=Color3.fromRGB(255,150,220),Accent=Color3.fromRGB(0,255,255),Success=Color3.fromRGB(50,255,150),Danger=Color3.fromRGB(255,50,100),Warning=Color3.fromRGB(255,180,0),Stroke=Color3.fromRGB(150,0,150),Group="Color",Wallpaper="rbxassetid://7040409890"}, -- Retrowave sun
    Matrix={MainBg=Color3.fromRGB(10,15,10),PanelBg=Color3.fromRGB(15,25,15),Text=Color3.fromRGB(100,255,100),Accent=Color3.fromRGB(50,200,50),Success=Color3.fromRGB(0,255,0),Danger=Color3.fromRGB(200,50,50),Warning=Color3.fromRGB(200,200,50),Stroke=Color3.fromRGB(30,100,30),Group="Color",Wallpaper="rbxassetid://6735515321"}, -- Matrix rain
    Mario={MainBg=Color3.fromRGB(20,120,255),PanelBg=Color3.fromRGB(220,40,40),Text=Color3.fromRGB(255,255,255),Accent=Color3.fromRGB(255,210,0),Success=Color3.fromRGB(50,200,50),Danger=Color3.fromRGB(150,0,0),Warning=Color3.fromRGB(255,150,0),Stroke=Color3.fromRGB(0,50,150),Group="Game",Wallpaper=""},
    Fallout={MainBg=Color3.fromRGB(15,20,15),PanelBg=Color3.fromRGB(25,35,25),Text=Color3.fromRGB(100,255,100),Accent=Color3.fromRGB(30,90,30),Success=Color3.fromRGB(0,200,0),Danger=Color3.fromRGB(200,50,50),Warning=Color3.fromRGB(200,200,50),Stroke=Color3.fromRGB(30,150,30),Group="Game",Wallpaper="rbxassetid://6924619717"},
}

-- [ 2. SUFFIX GENERATOR ]
local SuffixDict = {k=1, m=2, b=3, t=4, centillion=101, centillions=101}
local RevSuffix = {}

local function GenSuffixes()
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
GenSuffixes()

local function ParsePrice(str)
    if not str then return nil end; local low = string.lower(tostring(str))
    if low:match("free") or low:match("gratuit") then return 0 end
    local numStr, suf = low:gsub("[^%d%.%a]",""):match("^([%d%.]+)(%a*)$")
    if not numStr then return nil end; local num = tonumber(numStr)
    if not num then return nil end
    if suf and suf~="" then if SuffixDict[suf] then num = num * (10 ^ (SuffixDict[suf] * 3)) else return nil end end
    return num
end

local function FormatNumber(num) return (type(num)~="number") and "0" or (num < 1000 and tostring(math.floor(num)) or string.format("%.2e", num)) end

local function ToSuffixString(num)
    if not num or num ~= num or num == math.huge then return "0" end
    if num < 1000 then return tostring(math.floor(num)) end
    local power = math.floor(math.log10(num))
    local idx = math.floor(power / 3)
    local shortNum = num / (10 ^ (idx * 3))
    local suf = RevSuffix[idx] or ("e+" .. tostring(idx*3))
    return string.format("%.2f %s", shortNum, suf)
end

local function FormatScientificAndSuffix(num)
    if not num or type(num)~="number" or num < 1000 then return tostring(num or 0) end
    return string.format("%.2e (%s)", num, ToSuffixString(num))
end

-- [ 3. STATE MANAGER ]
local SolaraManager = {
    GuiName="LeyleysCheat_V6_21", CurrentThemeName="Default", CurrentTheme=Themes.Default, ActiveTab="Player",
    ThemeObjects={Backgrounds={},Panels={},Accents={},Strokes={},Texts={},Dividers={}},
    UI={TabButtons={},Pages={},Toggles={},Inputs={},Texts={},WaypointList=nil,PlaylistList=nil},
    IsAntiAfk=false, IsNoclip=false, IsESP=false, IsFly=false, IsInfJump=false, IsAimbot=false, ClickTP=false, AutoLoadConfig=false,
    SpeedOverride=nil, JumpOverride=nil, SelectedTarget=nil,
    ActiveFarmState="Off", FarmSpeed=2, ActiveBuyState="Off", BuySpeed=2, ActiveSmartState="Off", MyTycoon=nil, FarmCache={}, SpecialCount=0, LastCacheUpdate=0,
    HasSafetyRespawned=false, ClickDelay=0.1, LastCashValue=0, CashHistory={},
    CustomMusicInstance=nil, CustomMusicName="Unknown", CustomMusicId="", CustomMusicVolume=100, Playlists={}, Waypoints={},
    ESP_Dist=true, ESP_Name=true, ESP_Health=true, ESP_Pct=false, ESP_Tracer=false, ESP_LineColor=Color3.new(1,1,1), ESP_OutlineColor=Color3.new(1,1,1),
    ConfigFilename="Leyley's cheat/LeyleysCheat_Config.json", FlyCtrl={F=0,B=0,L=0,R=0},
    -- Status Bar Data
    StatusBar = { ShowMode="Minimized", Draggable=false, PosX=0.8, PosY=0.8, ShowCash=true, ShowFarm=true, ShowBuy=true }
}
local ESP_Lines = {}

-- [ 4. UI CREATION HELPERS ]
do local g=CoreGui:FindFirstChild(SolaraManager.GuiName) or LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(SolaraManager.GuiName); if g then g:Destroy() end end
local function ApplyTween(o, p, d) local tw = TweenService:Create(o, TweenInfo.new(d or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p); tw:Play(); return tw end
local function TrackTheme(o, c) if c then table.insert(SolaraManager.ThemeObjects[c], o) end end
local function UICorner(p, r) local c = Instance.new("UICorner", p); c.CornerRadius = UDim.new(0, r or 6); return c end
local function UIStroke(p, c, t) local s = Instance.new("UIStroke", p); s.Color = c or SolaraManager.CurrentTheme.Stroke; s.Thickness = t or 1; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; TrackTheme(s, "Strokes"); return s end
local function Frame(p, n, sz, pos, bg, tg) local f = Instance.new("Frame", p); f.Name=n; f.Size=sz; f.Position=pos; f.BackgroundColor3=bg or SolaraManager.CurrentTheme.MainBg; f.BorderSizePixel=0; TrackTheme(f, tg); return f end
local function Label(p, n, tx, sz, pos, al) local l = Instance.new("TextLabel", p); l.Name=n; l.Size=sz; l.Position=pos; l.BackgroundTransparency=1; l.TextColor3=SolaraManager.CurrentTheme.Text; l.Font=Enum.Font.GothamMedium; l.TextSize=13; l.TextXAlignment=al or Enum.TextXAlignment.Center; l.TextWrapped=true; l.Text=tx; TrackTheme(l, "Texts"); return l end
local function Button(p, n, tx, sz, pos, bg, tg) 
    local outer = Instance.new("Frame", p); outer.Size=sz; outer.Position=pos; outer.BackgroundTransparency=1
    local b = Instance.new("TextButton", outer); b.Name=n; b.Size=UDim2.new(1,-4,1,-4); b.Position=UDim2.new(0,2,0,2); b.BackgroundColor3=bg or SolaraManager.CurrentTheme.PanelBg; b.TextColor3=SolaraManager.CurrentTheme.Text; b.Font=Enum.Font.GothamBold; b.TextSize=12; b.Text=tx; b.AutoButtonColor=false
    UICorner(b); local s = UIStroke(b); TrackTheme(b, tg or "Panels"); TrackTheme(b, "Texts")
    b.MouseEnter:Connect(function() ApplyTween(b, {BackgroundTransparency=0.1}); ApplyTween(s, {Color=SolaraManager.CurrentTheme.Text}) end)
    b.MouseLeave:Connect(function() ApplyTween(b, {BackgroundTransparency=0}); ApplyTween(s, {Color=SolaraManager.CurrentTheme.Stroke}) end)
    return b, outer
end
local function Input(p, n, ph, sz, pos)
    local outer = Instance.new("Frame", p); outer.Size=sz; outer.Position=pos; outer.BackgroundTransparency=1
    local i = Instance.new("TextBox", outer); i.Name=n; i.Size=UDim2.new(1,-4,1,-4); i.Position=UDim2.new(0,2,0,2); i.BackgroundColor3=SolaraManager.CurrentTheme.PanelBg; i.TextColor3=SolaraManager.CurrentTheme.Text; i.PlaceholderText=ph; i.Font=Enum.Font.Gotham; i.TextSize=12; i.Text=""
    UICorner(i); UIStroke(i); Instance.new("UIPadding", i).PaddingLeft=UDim.new(0,8); TrackTheme(i, "Panels"); TrackTheme(i, "Texts"); return i, outer
end
local function Drag(f, h, isRatio)
    local dr, ds, sp = false, nil, nil
    h.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dr=true; ds=i.Position; sp=f.Position; i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dr=false end end) end end)
    UserInputService.InputChanged:Connect(function(i) 
        if dr and i.UserInputType==Enum.UserInputType.MouseMovement then 
            local delta = i.Position - ds
            if isRatio then
                local view = workspace.CurrentCamera.ViewportSize
                SolaraManager.StatusBar.PosX = math.clamp(sp.X.Scale + (delta.X / view.X), 0, 0.9)
                SolaraManager.StatusBar.PosY = math.clamp(sp.Y.Scale + (delta.Y / view.Y), 0, 0.9)
                f.Position = UDim2.new(SolaraManager.StatusBar.PosX, 0, SolaraManager.StatusBar.PosY, 0)
            else
                f.Position = UDim2.new(sp.X.Scale, sp.X.Offset+delta.X, sp.Y.Scale, sp.Y.Offset+delta.Y)
            end
        end 
    end)
end

-- [ 5. UI CONSTRUCTION ]
local SG = Instance.new("ScreenGui"); SG.Name=SolaraManager.GuiName; SG.ResetOnSpawn=false; SG.IgnoreGuiInset=true; SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; SG.Parent=pcall(function() return CoreGui.Name end) and CoreGui or LocalPlayer:WaitForChild("PlayerGui")
local ResB = Button(SG, "ResB", "➕ Open", UDim2.new(0,80,0,40), UDim2.new(0,20,1,-60), SolaraManager.CurrentTheme.Accent, "Accents"); ResB.Parent.Visible=false; ResB.Parent.ZIndex=10

local Main = Frame(SG, "Main", UDim2.new(0,800,0,480), UDim2.new(0.5,-400,0.5,-240)); Main.BackgroundTransparency=1
-- FIX FOR GUI OUTLINE CLIPPING (Apply stroke onto InnerClip, not Main)
local InnerClip = Instance.new("Frame", Main); InnerClip.Size=UDim2.new(1,0,1,0); InnerClip.BackgroundColor3=SolaraManager.CurrentTheme.MainBg; InnerClip.ClipsDescendants=true; UICorner(InnerClip,8); TrackTheme(InnerClip, "Backgrounds")
SolaraManager.UI.MainFrameStroke = UIStroke(InnerClip, SolaraManager.CurrentTheme.Accent, 2)

-- Wallpaper System
local Wallpaper = Instance.new("ImageLabel", InnerClip)
Wallpaper.Size = UDim2.new(1,0,1,0); Wallpaper.BackgroundTransparency=1; Wallpaper.ImageTransparency=0.8; Wallpaper.ScaleType=Enum.ScaleType.Crop; Wallpaper.ZIndex=0

local TBar = Frame(InnerClip, "TBar", UDim2.new(1,0,0,40), UDim2.new(), SolaraManager.CurrentTheme.PanelBg, "Panels"); Drag(Main, TBar, false)
local TLbl = Label(TBar, "TLbl", "  ✨ Leyley's Premium Cheat V6.21", UDim2.new(1,-100,1,0), UDim2.new(), Enum.TextXAlignment.Left); TLbl.Font=Enum.Font.GothamBold
local ClsB = Button(TBar, "ClsB", "X", UDim2.new(0,30,0,30), UDim2.new(1,-35,0,5), SolaraManager.CurrentTheme.Danger, nil)
local MinB = Button(TBar, "MinB", "-", UDim2.new(0,30,0,30), UDim2.new(1,-70,0,5), SolaraManager.CurrentTheme.Warning, nil)

-- STATUS BAR (FLOATING)
local StatBar = Frame(SG, "StatBar", UDim2.new(0,200,0,35), UDim2.new(SolaraManager.StatusBar.PosX,0,SolaraManager.StatusBar.PosY,0), SolaraManager.CurrentTheme.PanelBg, "Panels"); UICorner(StatBar); UIStroke(StatBar); StatBar.ZIndex=10; StatBar.Visible=false
local StatDrag = Instance.new("TextButton", StatBar); StatDrag.Size=UDim2.new(1,0,1,0); StatDrag.BackgroundTransparency=1; StatDrag.Text=""; Drag(StatBar, StatDrag, true)
local StatList = Instance.new("UIListLayout", StatBar); StatList.Padding=UDim.new(0,2); StatList.SortOrder=Enum.SortOrder.LayoutOrder; StatList.HorizontalAlignment=Enum.HorizontalAlignment.Center
local SCash = Label(StatBar, "SCash", "$0", UDim2.new(1,-10,0,15), UDim2.new()); SCash.TextColor3=Color3.fromRGB(60,180,90)
local SFarm = Label(StatBar, "SFarm", "Farm: Idle", UDim2.new(1,-10,0,15), UDim2.new()); SFarm.TextColor3=Color3.new(1,1,1)
local SBuy = Label(StatBar, "SBuy", "Buy: Idle", UDim2.new(1,-10,0,15), UDim2.new()); SBuy.TextColor3=Color3.new(1,1,1)

local function SyncStatusBar()
    local sb = SolaraManager.StatusBar
    StatBar.Visible = false
    if sb.ShowMode=="Always" then StatBar.Visible=true
    elseif sb.ShowMode=="Minimized" and not Main.Visible then StatBar.Visible=true end
    
    SCash.Visible=sb.ShowCash; SFarm.Visible=sb.ShowFarm; SBuy.Visible=sb.ShowBuy
    local c=0; if sb.ShowCash then c=c+1 end; if sb.ShowFarm then c=c+1 end; if sb.ShowBuy then c=c+1 end
    StatBar.Size = UDim2.new(0, 220, 0, math.max(10, c*17 + 5))
    
    -- Dynamic positioning (expand up if at bottom of screen, down if at top)
    if sb.PosY > 0.5 then StatList.VerticalAlignment = Enum.VerticalAlignment.Bottom else StatList.VerticalAlignment = Enum.VerticalAlignment.Top end
end

ClsB.MouseButton1Click:Connect(function() SG:Destroy() end)
MinB.MouseButton1Click:Connect(function() ApplyTween(Main, {Size=UDim2.new(0,800,0,0)}, 0.3).Completed:Connect(function() Main.Visible=false; ResB.Parent.Visible=true; Main.Size=UDim2.new(0,800,0,480); SyncStatusBar() end) end)
ResB.MouseButton1Click:Connect(function() ResB.Parent.Visible=false; Main.Size=UDim2.new(0,800,0,0); Main.Visible=true; ApplyTween(Main, {Size=UDim2.new(0,800,0,480)}, 0.4); SyncStatusBar() end)

local Side = Frame(InnerClip, "Side", UDim2.new(0,160,1,-40), UDim2.new(0,0,0,40), SolaraManager.CurrentTheme.PanelBg, "Panels"); Frame(Side, "Line", UDim2.new(0,1,1,0), UDim2.new(1,-1,0,0), SolaraManager.CurrentTheme.Stroke, "Dividers")
local SBtns = Instance.new("Frame", Side); SBtns.Size=UDim2.new(1,-1,1,0); SBtns.BackgroundTransparency=1; local sLyt=Instance.new("UIListLayout",SBtns); sLyt.Padding=UDim.new(0,5); sLyt.SortOrder=Enum.SortOrder.LayoutOrder; local sPad=Instance.new("UIPadding",SBtns); sPad.PaddingTop=UDim.new(0,10); sPad.PaddingBottom=UDim.new(0,10); sPad.PaddingLeft=UDim.new(0,10); sPad.PaddingRight=UDim.new(0,10)
local Cont = Frame(InnerClip, "Cont", UDim2.new(1,-160,1,-40), UDim2.new(0,160,0,40)); local cPad=Instance.new("UIPadding",Cont); cPad.PaddingTop=UDim.new(0,15); cPad.PaddingBottom=UDim.new(0,15); cPad.PaddingLeft=UDim.new(0,15); cPad.PaddingRight=UDim.new(0,15)

-- [ THEME & VISUAL SYNC ]
SolaraManager.SyncVisuals = function()
    local d = (SolaraManager.CurrentThemeName == "Default"); local t = SolaraManager.CurrentTheme; local tl = SolaraManager.UI.Toggles; local il = SolaraManager.UI.Inputs
    local function gc(s) return s and (d and t.Success or t.Accent) or (d and t.Danger or t.PanelBg) end
    if tl.AutoLoad then tl.AutoLoad.BackgroundColor3=gc(SolaraManager.AutoLoadConfig) end
    if tl.Afk then tl.Afk.BackgroundColor3=gc(SolaraManager.IsAntiAfk) end; if tl.Noclip then tl.Noclip.BackgroundColor3=gc(SolaraManager.IsNoclip) end; if tl.Esp then tl.Esp.BackgroundColor3=gc(SolaraManager.IsESP) end; if tl.Fly then tl.Fly.BackgroundColor3=gc(SolaraManager.IsFly) end; if tl.InfJump then tl.InfJump.BackgroundColor3=gc(SolaraManager.IsInfJump) end; if tl.Aimbot then tl.Aimbot.BackgroundColor3=gc(SolaraManager.IsAimbot) end; if tl.ClickTP then tl.ClickTP.BackgroundColor3=gc(SolaraManager.ClickTP) end
    if tl.Farm then tl.Farm.BackgroundColor3=gc(SolaraManager.ActiveFarmState=="Normal") end; if tl.SafeFarm then tl.SafeFarm.BackgroundColor3=gc(SolaraManager.ActiveFarmState=="Safe") end; if tl.Buy then tl.Buy.BackgroundColor3=gc(SolaraManager.ActiveBuyState=="Normal") end; if tl.SafeBuy then tl.SafeBuy.BackgroundColor3=gc(SolaraManager.ActiveBuyState=="Safe") end; if tl.Smart then tl.Smart.BackgroundColor3=gc(SolaraManager.ActiveSmartState=="Normal") end; if tl.SafeSmart then tl.SafeSmart.BackgroundColor3=gc(SolaraManager.ActiveSmartState=="Safe") end
    if tl.eName then tl.eName.BackgroundColor3=gc(SolaraManager.ESP_Name) end; if tl.eHealth then tl.eHealth.BackgroundColor3=gc(SolaraManager.ESP_Health) end; if tl.ePct then tl.ePct.BackgroundColor3=gc(SolaraManager.ESP_Pct) end; if tl.eTracer then tl.eTracer.BackgroundColor3=gc(SolaraManager.ESP_Tracer) end
    if tl.SBCash then tl.SBCash.BackgroundColor3=gc(SolaraManager.StatusBar.ShowCash) end; if tl.SBFarm then tl.SBFarm.BackgroundColor3=gc(SolaraManager.StatusBar.ShowFarm) end; if tl.SBBuy then tl.SBBuy.BackgroundColor3=gc(SolaraManager.StatusBar.ShowBuy) end; if tl.SBMv then tl.SBMv.BackgroundColor3=gc(SolaraManager.StatusBar.Draggable) end
    if tl.SBAM then tl.SBAM.BackgroundColor3=gc(SolaraManager.StatusBar.ShowMode=="Always") end; if tl.SBMN then tl.SBMN.BackgroundColor3=gc(SolaraManager.StatusBar.ShowMode=="Minimized") end; if tl.SBNV then tl.SBNV.BackgroundColor3=gc(SolaraManager.StatusBar.ShowMode=="Never") end
    if il.Speed then il.Speed.Text=SolaraManager.SpeedOverride and tostring(SolaraManager.SpeedOverride) or "" end; if il.Jump then il.Jump.Text=SolaraManager.JumpOverride and tostring(SolaraManager.JumpOverride) or "" end
    if il.FarmS then il.FarmS.Text=tostring(SolaraManager.FarmSpeed) end; if il.BuyS then il.BuyS.Text=tostring(SolaraManager.BuySpeed) end; if il.Vol then il.Vol.Text="Vol: "..tostring(SolaraManager.CustomMusicVolume) end
    SyncStatusBar()
end

SolaraManager.ApplyTheme = function(tn)
    if not Themes[tn] then return end; SolaraManager.CurrentTheme=Themes[tn]; SolaraManager.CurrentThemeName=tn; local t=Themes[tn]
    for _,o in ipairs(SolaraManager.ThemeObjects.Backgrounds) do if o.Parent then ApplyTween(o,{BackgroundColor3=t.MainBg},0.5) end end
    for _,o in ipairs(SolaraManager.ThemeObjects.Panels) do if o.Parent then ApplyTween(o,{BackgroundColor3=t.PanelBg},0.5) end end
    for _,o in ipairs(SolaraManager.ThemeObjects.Accents) do if o.Parent then ApplyTween(o,{BackgroundColor3=t.Accent},0.5) end end
    for _,o in ipairs(SolaraManager.ThemeObjects.Strokes) do if o.Parent then ApplyTween(o,{Color=t.Stroke},0.5) end end
    for _,o in ipairs(SolaraManager.ThemeObjects.Dividers) do if o.Parent then ApplyTween(o,{BackgroundColor3=t.Stroke},0.5) end end
    for _,o in ipairs(SolaraManager.ThemeObjects.Texts) do if o.Parent then ApplyTween(o,{TextColor3=t.Text},0.5) end end
    if SolaraManager.UI.MainFrameStroke then ApplyTween(SolaraManager.UI.MainFrameStroke,{Color=t.Accent},0.5) end
    for n,b in pairs(SolaraManager.UI.TabButtons) do ApplyTween(b,{BackgroundColor3=(n==SolaraManager.ActiveTab) and t.Accent or t.PanelBg},0.5) end
    if t.Wallpaper and t.Wallpaper ~= "" then Wallpaper.Image = t.Wallpaper; ApplyTween(Wallpaper, {ImageTransparency=0.8}, 1) else ApplyTween(Wallpaper, {ImageTransparency=1}, 0.5) end
    SolaraManager.SyncVisuals()
end

local function SwitchTab(tn) for n,p in pairs(SolaraManager.UI.Pages) do p.Visible=(n==tn) end; for n,b in pairs(SolaraManager.UI.TabButtons) do ApplyTween(b,{BackgroundColor3=(n==tn) and SolaraManager.CurrentTheme.Accent or SolaraManager.CurrentTheme.PanelBg},0.2) end; SolaraManager.ActiveTab=tn end
local function BuildPage(n, i, o) local b, out = Button(SBtns, n.."Tb", i.." "..n, UDim2.new(1,0,0,35), UDim2.new(), nil, "Panels"); out.LayoutOrder=o; b.TextXAlignment=Enum.TextXAlignment.Left; Instance.new("UIPadding",b).PaddingLeft=UDim.new(0,10); local p = Instance.new("Frame", Cont); p.Size=UDim2.new(1,0,1,0); p.BackgroundTransparency=1; p.Visible=false; SolaraManager.UI.TabButtons[n]=b; SolaraManager.UI.Pages[n]=p; b.MouseButton1Click:Connect(function() SwitchTab(n) end); return p end

-- [ PAGE 1: PLAYER ] 
do
    local pP = BuildPage("Player", "👤", 1); local pScr = Instance.new("Frame", pP); pScr.Size=UDim2.new(1,0,1,0); pScr.BackgroundTransparency=1; local lyt=Instance.new("UIListLayout",pScr); lyt.Padding=UDim.new(0,8); lyt.SortOrder=Enum.SortOrder.LayoutOrder
    Label(pScr, "pT", "PLAYER MODIFIERS", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=1
    local cR = Frame(pScr, "cR", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); cR.BackgroundTransparency=1; cR.LayoutOrder=2
    local aTg = Button(cR, "aTg", "Anti-AFK", UDim2.new(0.32,0,1,0), UDim2.new()); local nTg = Button(cR, "nTg", "Noclip", UDim2.new(0.32,0,1,0), UDim2.new(0.34,0,0,0)); local fTg = Button(cR, "fTg", "Fly (WASD)", UDim2.new(0.32,0,1,0), UDim2.new(0.68,0,0,0))
    SolaraManager.UI.Toggles.Afk=aTg; SolaraManager.UI.Toggles.Noclip=nTg; SolaraManager.UI.Toggles.Fly=fTg
    aTg.MouseButton1Click:Connect(function() SolaraManager.IsAntiAfk=not SolaraManager.IsAntiAfk; SolaraManager.SyncVisuals() end)
    nTg.MouseButton1Click:Connect(function() SolaraManager.IsNoclip=not SolaraManager.IsNoclip; SolaraManager.SyncVisuals() end)
    fTg.MouseButton1Click:Connect(function() SolaraManager.IsFly=not SolaraManager.IsFly; SolaraManager.SyncVisuals() end)
    local cR2 = Frame(pScr, "cR2", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); cR2.BackgroundTransparency=1; cR2.LayoutOrder=3
    local ijTg = Button(cR2, "ijTg", "Infinite Jump", UDim2.new(0.48,0,1,0), UDim2.new()); local aimTg = Button(cR2, "aimTg", "Aimbot (Maj+A)", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0))
    SolaraManager.UI.Toggles.InfJump=ijTg; SolaraManager.UI.Toggles.Aimbot=aimTg
    ijTg.MouseButton1Click:Connect(function() SolaraManager.IsInfJump=not SolaraManager.IsInfJump; SolaraManager.SyncVisuals() end)
    aimTg.MouseButton1Click:Connect(function() SolaraManager.IsAimbot=not SolaraManager.IsAimbot; SolaraManager.SyncVisuals() end)
    
    Label(pScr, "sT", "STAT OVERRIDES", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=4
    local spR = Frame(pScr, "spR", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); spR.BackgroundTransparency=1; spR.LayoutOrder=5
    local spI = Input(spR, "spI", "WalkSpeed", UDim2.new(0.48,0,1,0), UDim2.new()); local spB = Button(spR, "spB", "Apply", UDim2.new(0.24,0,1,0), UDim2.new(0.5,0,0,0), SolaraManager.CurrentTheme.Accent); local spRst = Button(spR, "spRst", "Défaut (16)", UDim2.new(0.24,0,1,0), UDim2.new(0.76,0,0,0), SolaraManager.CurrentTheme.PanelBg)
    SolaraManager.UI.Inputs.Speed=spI; spB.MouseButton1Click:Connect(function() SolaraManager.SpeedOverride=tonumber(spI.Text) end); spRst.MouseButton1Click:Connect(function() SolaraManager.SpeedOverride=nil; if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed=16 end end)
    local jR = Frame(pScr, "jR", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); jR.BackgroundTransparency=1; jR.LayoutOrder=6
    local jI = Input(jR, "jI", "JumpPower", UDim2.new(0.48,0,1,0), UDim2.new()); local jB = Button(jR, "jB", "Apply", UDim2.new(0.24,0,1,0), UDim2.new(0.5,0,0,0), SolaraManager.CurrentTheme.Accent); local jRst = Button(jR, "jRst", "Défaut (50)", UDim2.new(0.24,0,1,0), UDim2.new(0.76,0,0,0), SolaraManager.CurrentTheme.PanelBg)
    SolaraManager.UI.Inputs.Jump=jI; jB.MouseButton1Click:Connect(function() SolaraManager.JumpOverride=tonumber(jI.Text) end); jRst.MouseButton1Click:Connect(function() SolaraManager.JumpOverride=nil; if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower=50 end end)
    
    Label(pScr, "oT", "OTHER PLAYERS", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=7
    local eR = Frame(pScr, "eR", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); eR.BackgroundTransparency=1; eR.LayoutOrder=8
    local eTg = Button(eR, "eTg", "Enable Master ESP", UDim2.new(1,0,1,0), UDim2.new()); SolaraManager.UI.Toggles.Esp=eTg; eTg.MouseButton1Click:Connect(function() SolaraManager.IsESP=not SolaraManager.IsESP; SolaraManager.SyncVisuals() end)
end

-- [ PAGE 2: TELEPORT ]
do
    local tP = BuildPage("Teleport", "🌍", 2); local tLyt=Instance.new("UIListLayout",tP); tLyt.Padding=UDim.new(0,8); tLyt.SortOrder=Enum.SortOrder.LayoutOrder
    local topR = Frame(tP, "topR", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); topR.BackgroundTransparency=1; topR.LayoutOrder=1
    local tpB = Button(topR, "tpB", "TP TO PLAYER", UDim2.new(0.48,0,1,0), UDim2.new(), SolaraManager.CurrentTheme.Accent); tpB.MouseButton1Click:Connect(function() if SolaraManager.SelectedTarget and SolaraManager.SelectedTarget.Character and LocalPlayer.Character then LocalPlayer.Character:PivotTo(SolaraManager.SelectedTarget.Character:GetPivot()) end end)
    local ctTg = Button(topR, "ctTg", "Click TP (Ctrl+Click)", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), SolaraManager.CurrentTheme.PanelBg); SolaraManager.UI.Toggles.ClickTP=ctTg; ctTg.MouseButton1Click:Connect(function() SolaraManager.ClickTP=not SolaraManager.ClickTP; SolaraManager.SyncVisuals() end)
    local wR = Frame(tP, "wR", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); wR.BackgroundTransparency=1; wR.LayoutOrder=2
    local wI = Input(wR, "wI", "Waypoint Name", UDim2.new(0.7,0,1,0), UDim2.new()); local wB = Button(wR, "wB", "Save Pos", UDim2.new(0.28,0,1,0), UDim2.new(0.72,0,0,0), SolaraManager.CurrentTheme.Success)
    local listsF = Frame(tP, "listsF", UDim2.new(1,0,1,-76), UDim2.new(), nil, "Backgrounds"); listsF.BackgroundTransparency=1; listsF.LayoutOrder=3
    local pLF = Frame(listsF, "pLF", UDim2.new(0.48,0,1,0), UDim2.new(), SolaraManager.CurrentTheme.PanelBg, "Panels"); UICorner(pLF); UIStroke(pLF)
    local pS = Instance.new("ScrollingFrame", pLF); pS.Size=UDim2.new(1,-10,1,-10); pS.Position=UDim2.new(0,5,0,5); pS.BackgroundTransparency=1; pS.AutomaticCanvasSize=Enum.AutomaticSize.Y; pS.ScrollBarThickness=4; local pSLyt=Instance.new("UIListLayout",pS); pSLyt.Padding=UDim.new(0,5)
    local wLF = Frame(listsF, "wLF", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), SolaraManager.CurrentTheme.PanelBg, "Panels"); UICorner(wLF); UIStroke(wLF)
    local wS = Instance.new("ScrollingFrame", wLF); wS.Size=UDim2.new(1,-10,1,-10); wS.Position=UDim2.new(0,5,0,5); wS.BackgroundTransparency=1; wS.AutomaticCanvasSize=Enum.AutomaticSize.Y; wS.ScrollBarThickness=4; local wSLyt=Instance.new("UIListLayout",wS); wSLyt.Padding=UDim.new(0,5)
    SolaraManager.UI.WaypointList = wS
    local function UpdWP() for _,c in ipairs(wS:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end for i, wp in ipairs(SolaraManager.Waypoints) do local f = Frame(wS, "wp"..i, UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); f.BackgroundTransparency=1; local b = Button(f, "wpB", wp.Name, UDim2.new(0.8,0,1,0), UDim2.new(), SolaraManager.CurrentTheme.MainBg, "Backgrounds"); local del = Button(f, "del", "X", UDim2.new(0.18,0,1,0), UDim2.new(0.82,0,0,0), SolaraManager.CurrentTheme.Danger); b.MouseButton1Click:Connect(function() if LocalPlayer.Character then LocalPlayer.Character:PivotTo(wp.CFrame) end end); del.MouseButton1Click:Connect(function() table.remove(SolaraManager.Waypoints, i); UpdWP() end) end end
    wB.MouseButton1Click:Connect(function() if wI.Text~="" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then table.insert(SolaraManager.Waypoints, {Name=wI.Text, CFrame=LocalPlayer.Character.HumanoidRootPart.CFrame}); wI.Text=""; UpdWP() end end)
    local sLbl = Label(pLF, "sLbl", "Player Selected: None", UDim2.new(1,0,0,20), UDim2.new(0,0,-0.15,0), Enum.TextXAlignment.Left); sLbl.TextColor3 = SolaraManager.CurrentTheme.Text
    local function Upd() for _,c in ipairs(pS:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end local ps=Players:GetPlayers(); table.sort(ps, function(a,b) return a.Name:lower()<b.Name:lower() end); for _,p in ipairs(ps) do if p~=LocalPlayer then local b=Button(pS, "pb", p.Name, UDim2.new(1,0,0,30), UDim2.new(), SolaraManager.CurrentTheme.MainBg, "Backgrounds"); b.MouseButton1Click:Connect(function() SolaraManager.SelectedTarget=p; sLbl.Text="Selected: "..p.Name end) end end end
    Players.PlayerAdded:Connect(Upd); Players.PlayerRemoving:Connect(Upd); Upd()
end

-- [ PAGE 3: EXPLORER ]
do
    local eP = BuildPage("Explorer", "🔍", 3); local eLyt=Instance.new("UIListLayout",eP); eLyt.Padding=UDim.new(0,10); eLyt.SortOrder=Enum.SortOrder.LayoutOrder
    Label(eP, "dDesc", "Load Moon Dex Explorer to view the game's file structure. Bypasses most anti-cheats.", UDim2.new(1,0,0,40), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=1
    local dB = Button(eP, "dB", "Launch Moon Dex", UDim2.new(1,0,0,40), UDim2.new(), Color3.fromRGB(130,50,200)); dB.Parent.LayoutOrder=2
    dB.MouseButton1Click:Connect(function() dB.Text="Loading Moon Dex..."; task.spawn(function() local s = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end); dB.Text=s and "Moon Dex Launched!" or "Failed to load!"; ApplyTween(dB,{BackgroundColor3=s and SolaraManager.CurrentTheme.Success or SolaraManager.CurrentTheme.Danger}); task.wait(2); dB.Text="Launch Moon Dex"; ApplyTween(dB,{BackgroundColor3=Color3.fromRGB(130,50,200)}) end) end)
end

-- [ PAGE 4: GAME ] 
do
    local gP = BuildPage("Game", "🎮", 4); local gC = Instance.new("Frame", gP); gC.Size=UDim2.new(1,0,1,0); gC.BackgroundTransparency=1
    local gSel = Frame(gC, "gSel", UDim2.new(0.3,0,1,0), UDim2.new(), SolaraManager.CurrentTheme.PanelBg, "Panels"); UICorner(gSel); UIStroke(gSel); local slLyt=Instance.new("UIListLayout",gSel); slLyt.Padding=UDim.new(0,5); local slPad=Instance.new("UIPadding",gSel); slPad.PaddingTop=UDim.new(0,5); slPad.PaddingLeft=UDim.new(0,5); slPad.PaddingRight=UDim.new(0,5)
    local gCF = Instance.new("Frame", gC); gCF.Size=UDim2.new(0.68,0,1,0); gCF.Position=UDim2.new(0.32,0,0,0); gCF.BackgroundTransparency=1
    local scr = Instance.new("Frame", gCF); scr.Size=UDim2.new(1,0,1,0); scr.BackgroundTransparency=1; local lemLyt=Instance.new("UIListLayout",scr); lemLyt.Padding=UDim.new(0,5); lemLyt.SortOrder=Enum.SortOrder.LayoutOrder
    
    Label(scr, "cT", "💰 ECONOMY STATS", UDim2.new(1,0,0,15), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=1
    SolaraManager.UI.CashStatusLbl = Label(scr, "cS", "Cash: $0", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left); SolaraManager.UI.CashStatusLbl.LayoutOrder=2; SolaraManager.UI.CashStatusLbl.TextColor3=SolaraManager.CurrentTheme.Success
    SolaraManager.UI.CashRateLbl = Label(scr, "cR", "Rate: $0/sec", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left); SolaraManager.UI.CashRateLbl.LayoutOrder=3; SolaraManager.UI.CashRateLbl.TextColor3=Color3.fromRGB(150,150,150)
    Frame(scr, "d0", UDim2.new(1,0,0,2), UDim2.new(), SolaraManager.CurrentTheme.Stroke, "Dividers").LayoutOrder=4
    
    Label(scr, "fT", "🍋 AUTO FARM", UDim2.new(1,0,0,15), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=5
    SolaraManager.UI.FarmStatusLbl = Label(scr, "fS", "Status: Idle", UDim2.new(1,0,0,15), UDim2.new(), Enum.TextXAlignment.Left); SolaraManager.UI.FarmStatusLbl.LayoutOrder=6
    local fSR = Frame(scr, "fSR", UDim2.new(1,0,0,25), UDim2.new(), nil, "Backgrounds"); fSR.BackgroundTransparency=1; fSR.LayoutOrder=7
    local fSI = Input(fSR, "fSI", "Speed (1-4)", UDim2.new(0.68,0,1,0), UDim2.new()); local fSB = Button(fSR, "fSB", "Set", UDim2.new(0.28,0,1,0), UDim2.new(0.72,0,0,0), SolaraManager.CurrentTheme.Accent); SolaraManager.UI.Inputs.FarmS=fSB
    local fAR = Frame(scr, "fAR", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); fAR.BackgroundTransparency=1; fAR.LayoutOrder=8
    local fB = Button(fAR, "fB", "Normal Farm", UDim2.new(0.48,0,1,0), UDim2.new(), SolaraManager.CurrentTheme.PanelBg); local sfB = Button(fAR, "sfB", "Safe Farm", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), SolaraManager.CurrentTheme.PanelBg); SolaraManager.UI.Toggles.Farm=fB; SolaraManager.UI.Toggles.SafeFarm=sfB
    Frame(scr, "d1", UDim2.new(1,0,0,2), UDim2.new(), SolaraManager.CurrentTheme.Stroke, "Dividers").LayoutOrder=9
    
    Label(scr, "tT", "🏭 TYCOON BUY", UDim2.new(1,0,0,15), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=10
    SolaraManager.UI.TycoonStatusLbl = Label(scr, "tS", "Status: Idle", UDim2.new(1,0,0,15), UDim2.new(), Enum.TextXAlignment.Left); SolaraManager.UI.TycoonStatusLbl.LayoutOrder=11
    local bSR = Frame(scr, "bSR", UDim2.new(1,0,0,25), UDim2.new(), nil, "Backgrounds"); bSR.BackgroundTransparency=1; bSR.LayoutOrder=12
    local bSI = Input(bSR, "bSI", "Speed (1-20)", UDim2.new(0.68,0,1,0), UDim2.new()); local bSB = Button(bSR, "bSB", "Set", UDim2.new(0.28,0,1,0), UDim2.new(0.72,0,0,0), SolaraManager.CurrentTheme.Accent); SolaraManager.UI.Inputs.BuyS=bSB
    local bAR = Frame(scr, "bAR", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); bAR.BackgroundTransparency=1; bAR.LayoutOrder=13
    local aB = Button(bAR, "aB", "Auto Buy", UDim2.new(0.48,0,1,0), UDim2.new(), SolaraManager.CurrentTheme.PanelBg); local saB = Button(bAR, "saB", "Safe Buy", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), SolaraManager.CurrentTheme.PanelBg); SolaraManager.UI.Toggles.Buy=aB; SolaraManager.UI.Toggles.SafeBuy=saB
    Frame(scr, "d2", UDim2.new(1,0,0,2), UDim2.new(), SolaraManager.CurrentTheme.Stroke, "Dividers").LayoutOrder=14
    
    Label(scr, "smT", "🤖 SMART HYBRID", UDim2.new(1,0,0,15), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=15
    local smAR = Frame(scr, "smAR", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); smAR.BackgroundTransparency=1; smAR.LayoutOrder=16
    local smB = Button(smAR, "smB", "Smart Mix", UDim2.new(0.48,0,1,0), UDim2.new(), SolaraManager.CurrentTheme.PanelBg); local ssmB = Button(smAR, "ssmB", "Safe Smart", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), SolaraManager.CurrentTheme.PanelBg); SolaraManager.UI.Toggles.Smart=smB; SolaraManager.UI.Toggles.SafeSmart=ssmB
    
    Button(gSel, "g1B", "Sell Lemons", UDim2.new(1,0,0,35), UDim2.new(), SolaraManager.CurrentTheme.Accent, "Panels")
    SolaraManager.UI.GameTabCash = Label(gSel, "gtc", "$0", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Center); SolaraManager.UI.GameTabCash.TextColor3 = SolaraManager.CurrentTheme.Success
    
    local function SetTextF(lbl, statLbl, t) lbl.Text=t; statLbl.Text=t end
    local function UpdG() 
        SolaraManager.SyncVisuals(); 
        if SolaraManager.ActiveFarmState=="Off" and SolaraManager.ActiveSmartState=="Off" then workspace.CurrentCamera.CameraType=Enum.CameraType.Custom; SetTextF(SolaraManager.UI.FarmStatusLbl, SFarm, "Status: Idle") end; 
        if SolaraManager.ActiveBuyState=="Off" and SolaraManager.ActiveSmartState=="Off" then SetTextF(SolaraManager.UI.TycoonStatusLbl, SBuy, "Status: Idle") end 
    end
    fSB.MouseButton1Click:Connect(function() local v=tonumber(fSI.Text); if v and v>0 then SolaraManager.FarmSpeed=math.min(v,4); fSB.Text=tostring(SolaraManager.FarmSpeed) end end)
    bSB.MouseButton1Click:Connect(function() local v=tonumber(bSI.Text); if v and v>0 then SolaraManager.BuySpeed=math.min(v,20); bSB.Text=tostring(SolaraManager.BuySpeed) end end)
    
    fB.MouseButton1Click:Connect(function() SolaraManager.ActiveFarmState=(SolaraManager.ActiveFarmState=="Normal") and "Off" or "Normal"; if SolaraManager.ActiveFarmState=="Normal" then SolaraManager.ActiveBuyState="Off"; SolaraManager.ActiveSmartState="Off" end; UpdG() end)
    sfB.MouseButton1Click:Connect(function() SolaraManager.ActiveFarmState=(SolaraManager.ActiveFarmState=="Safe") and "Off" or "Safe"; if SolaraManager.ActiveFarmState=="Safe" then SolaraManager.ActiveBuyState="Off"; SolaraManager.ActiveSmartState="Off" end; SolaraManager.HasSafetyRespawned=false; UpdG() end)
    aB.MouseButton1Click:Connect(function() SolaraManager.ActiveBuyState=(SolaraManager.ActiveBuyState=="Normal") and "Off" or "Normal"; if SolaraManager.ActiveBuyState=="Normal" then SolaraManager.ActiveFarmState="Off"; SolaraManager.ActiveSmartState="Off" end; UpdG() end)
    saB.MouseButton1Click:Connect(function() SolaraManager.ActiveBuyState=(SolaraManager.ActiveBuyState=="Safe") and "Off" or "Safe"; if SolaraManager.ActiveBuyState=="Safe" then SolaraManager.ActiveFarmState="Off"; SolaraManager.ActiveSmartState="Off" end; SolaraManager.HasSafetyRespawned=false; UpdG() end)
    smB.MouseButton1Click:Connect(function() SolaraManager.ActiveSmartState=(SolaraManager.ActiveSmartState=="Normal") and "Off" or "Normal"; if SolaraManager.ActiveSmartState=="Normal" then SolaraManager.ActiveFarmState="Off"; SolaraManager.ActiveBuyState="Off" end; UpdG() end)
    ssmB.MouseButton1Click:Connect(function() SolaraManager.ActiveSmartState=(SolaraManager.ActiveSmartState=="Safe") and "Off" or "Safe"; if SolaraManager.ActiveSmartState=="Safe" then SolaraManager.ActiveFarmState="Off"; SolaraManager.ActiveBuyState="Off" end; SolaraManager.HasSafetyRespawned=false; UpdG() end)
end

-- [ PAGE 5: MUSIC ] 
do
    local mP = BuildPage("Music", "🎵", 5); local mScr = Instance.new("Frame", mP); mScr.Size=UDim2.new(1,0,1,0); mScr.BackgroundTransparency=1; local mLyt=Instance.new("UIListLayout",mScr); mLyt.Padding=UDim.new(0,4); mLyt.SortOrder=Enum.SortOrder.LayoutOrder
    Label(mScr, "mT", "🎵 CUSTOM MUSIC PLAYER", UDim2.new(1,0,0,15), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=1
    local mR2 = Frame(mScr, "mR2", UDim2.new(1,0,0,25), UDim2.new(), nil, "Backgrounds"); mR2.BackgroundTransparency=1; mR2.LayoutOrder=2
    local mI = Input(mR2, "mI", "Audio ID ou Fichier", UDim2.new(0.48,0,1,0), UDim2.new()); local vI = Input(mR2, "vI", "Vol: 100", UDim2.new(0.20,0,1,0), UDim2.new(0.52,0,0,0)); SolaraManager.UI.Inputs.Vol=vI; local pB = Button(mR2, "pB", "Load", UDim2.new(0.24,0,1,0), UDim2.new(0.76,0,0,0), SolaraManager.CurrentTheme.Accent)
    local mR3 = Frame(mScr, "mR3", UDim2.new(1,0,0,25), UDim2.new(), nil, "Backgrounds"); mR3.BackgroundTransparency=1; mR3.LayoutOrder=3
    local psB = Button(mR3, "psB", "Pause", UDim2.new(0.48,0,1,0), UDim2.new(0,0,0,0), SolaraManager.CurrentTheme.Warning); local stB = Button(mR3, "stB", "Stop", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), SolaraManager.CurrentTheme.Danger)
    SolaraManager.UI.MusicStatusLbl = Label(mScr, "mSL", "Status: No music", UDim2.new(1,0,0,15), UDim2.new(), Enum.TextXAlignment.Left); SolaraManager.UI.MusicStatusLbl.LayoutOrder=4; SolaraManager.UI.MusicStatusLbl.TextColor3=Color3.fromRGB(150,150,150)
    Frame(mScr, "sD", UDim2.new(1,0,0,2), UDim2.new(), SolaraManager.CurrentTheme.Stroke, "Dividers").LayoutOrder=5
    
    local ptR = Frame(mScr, "ptR", UDim2.new(1,0,0,20), UDim2.new(), nil, "Backgrounds"); ptR.BackgroundTransparency=1; ptR.LayoutOrder=6
    Label(ptR, "pT", "📂 PLAYLIST MANAGER", UDim2.new(0.6,0,1,0), UDim2.new(), Enum.TextXAlignment.Left)
    local scanB = Button(ptR, "scanB", "Scan Files", UDim2.new(0.38,0,1,0), UDim2.new(0.62,0,0,0), SolaraManager.CurrentTheme.Accent)
    
    local pwR = Frame(mScr, "pwR", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); pwR.BackgroundTransparency=1; pwR.LayoutOrder=7
    local piI = Input(pwR, "piI", "ID/Fichier", UDim2.new(0.3,0,1,0), UDim2.new()); local pnI = Input(pwR, "pnI", "Nom", UDim2.new(0.4,0,1,0), UDim2.new(0.32,0,0,0)); local pwB = Button(pwR, "pwB", "Ajouter", UDim2.new(0.26,0,1,0), UDim2.new(0.74,0,0,0), SolaraManager.CurrentTheme.Success)
    
    local plLF = Frame(mScr, "plLF", UDim2.new(1,0,1,-170), UDim2.new(), SolaraManager.CurrentTheme.PanelBg, "Panels"); plLF.LayoutOrder=8; UICorner(plLF); UIStroke(plLF)
    local plS = Instance.new("ScrollingFrame", plLF); plS.Size=UDim2.new(1,-10,1,-10); plS.Position=UDim2.new(0,5,0,5); plS.BackgroundTransparency=1; plS.AutomaticCanvasSize=Enum.AutomaticSize.Y; plS.ScrollBarThickness=4; local plSLyt=Instance.new("UIListLayout",plS); plSLyt.Padding=UDim.new(0,5)
    SolaraManager.UI.PlaylistList = plS
    
    local function PlayCustomAudio(idTxt)
        local assetId = idTxt; local n = tonumber(idTxt)
        if n then assetId = "rbxassetid://"..idTxt task.spawn(function() local s,pI=pcall(function() return MarketplaceService:GetProductInfo(n) end); SolaraManager.CustomMusicName=(s and pI) and pI.Name or "Audio ID: "..idTxt end)
        else if getcustomasset and isfile and isfile(idTxt) then assetId = getcustomasset(idTxt); SolaraManager.CustomMusicName = "Local: " .. (idTxt:match("([^/\\]+)$") or idTxt) else SolaraManager.CustomMusicName = "Invalid Audio/File"; return end end
        SolaraManager.CustomMusicId = idTxt
        local vN = tonumber(string.match(vI.Text, "%d+")); if vN then SolaraManager.CustomMusicVolume=math.max(0,math.min(100,vN)) end
        if SolaraManager.CustomMusicInstance then SolaraManager.CustomMusicInstance:Destroy() end
        local nS=Instance.new("Sound"); nS.SoundId=assetId; nS.Looped=true; nS.Volume=SolaraManager.CustomMusicVolume/100; nS.Parent=CoreGui; SolaraManager.CustomMusicInstance=nS; nS:Play()
        psB.Text="Pause"
    end
    
    local function UpdPL() for _,c in ipairs(plS:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end for i, pl in ipairs(SolaraManager.Playlists) do local f = Frame(plS, "pl"..i, UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); f.BackgroundTransparency=1; local b = Button(f, "plB", pl.Name, UDim2.new(0.8,0,1,0), UDim2.new(), SolaraManager.CurrentTheme.MainBg, "Backgrounds"); local del = Button(f, "del", "X", UDim2.new(0.18,0,1,0), UDim2.new(0.82,0,0,0), SolaraManager.CurrentTheme.Danger); b.MouseButton1Click:Connect(function() mI.Text=pl.Id; PlayCustomAudio(pl.Id) end); del.MouseButton1Click:Connect(function() table.remove(SolaraManager.Playlists, i); UpdPL() end) end end
    scanB.MouseButton1Click:Connect(function() if listfiles and isfolder and isfolder("Leyley's cheat/music") then local files = listfiles("Leyley's cheat/music"); local added = 0 for _, file in ipairs(files) do if file:lower():match("%.mp3$") then local filename = file:match("([^/\\]+)$") or file; local exists = false for _, pl in ipairs(SolaraManager.Playlists) do if pl.Id == file then exists = true; break end end if not exists then table.insert(SolaraManager.Playlists, {Id=file, Name=filename}); added = added + 1 end end end UpdPL(); scanB.Text = "+"..added.." Files"; task.wait(1.5); scanB.Text = "Scan Files" else scanB.Text = "Not Supported"; task.wait(1.5); scanB.Text = "Scan Files" end end)
    pwB.MouseButton1Click:Connect(function() if piI.Text~="" and pnI.Text~="" then table.insert(SolaraManager.Playlists, {Id=piI.Text, Name=pnI.Text}); piI.Text=""; pnI.Text=""; UpdPL() end end)
    pB.MouseButton1Click:Connect(function() if mI.Text~="" then PlayCustomAudio(mI.Text) end end)
    vI.FocusLost:Connect(function() local vN=tonumber(string.match(vI.Text,"%d+")); if vN then SolaraManager.CustomMusicVolume=math.max(0,math.min(100,vN)); vI.Text="Vol: "..SolaraManager.CustomMusicVolume; if SolaraManager.CustomMusicInstance then SolaraManager.CustomMusicInstance.Volume=SolaraManager.CustomMusicVolume/100 end end end)
    psB.MouseButton1Click:Connect(function() local ci=SolaraManager.CustomMusicInstance; if ci then if ci.IsPlaying then ci:Pause(); psB.Text="Resume" else ci:Resume(); psB.Text="Pause" end end end)
    stB.MouseButton1Click:Connect(function() local ci=SolaraManager.CustomMusicInstance; if ci then ci:Stop(); ci.TimePosition=0; psB.Text="Pause" end end)
end

-- [ PAGE 6: STATUS BAR TAB ]
do
    local sbP = BuildPage("Status bar", "📊", 6); local sbScr = Instance.new("Frame", sbP); sbScr.Size=UDim2.new(1,0,1,0); sbScr.BackgroundTransparency=1; local sbLyt=Instance.new("UIListLayout",sbScr); sbLyt.Padding=UDim.new(0,8); sbLyt.SortOrder=Enum.SortOrder.LayoutOrder
    Label(sbScr, "sbT1", "VISIBILITY & POSITION", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=1
    local vR = Frame(sbScr, "vR", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); vR.BackgroundTransparency=1; vR.LayoutOrder=2
    local sbAM = Button(vR, "sbAM", "Show Always", UDim2.new(0.32,0,1,0), UDim2.new()); local sbMN = Button(vR, "sbMN", "Only Minimized", UDim2.new(0.32,0,1,0), UDim2.new(0.34,0,0,0)); local sbNV = Button(vR, "sbNV", "Never Show", UDim2.new(0.32,0,1,0), UDim2.new(0.68,0,0,0))
    SolaraManager.UI.Toggles.SBAM=sbAM; SolaraManager.UI.Toggles.SBMN=sbMN; SolaraManager.UI.Toggles.SBNV=sbNV
    sbAM.MouseButton1Click:Connect(function() SolaraManager.StatusBar.ShowMode="Always"; SolaraManager.SyncVisuals() end)
    sbMN.MouseButton1Click:Connect(function() SolaraManager.StatusBar.ShowMode="Minimized"; SolaraManager.SyncVisuals() end)
    sbNV.MouseButton1Click:Connect(function() SolaraManager.StatusBar.ShowMode="Never"; SolaraManager.SyncVisuals() end)
    
    local mR = Frame(sbScr, "mR", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); mR.BackgroundTransparency=1; mR.LayoutOrder=3
    local mvTg = Button(mR, "mvTg", "Enable Dragging", UDim2.new(0.48,0,1,0), UDim2.new()); SolaraManager.UI.Toggles.SBMv=mvTg
    mvTg.MouseButton1Click:Connect(function() SolaraManager.StatusBar.Draggable = not SolaraManager.StatusBar.Draggable; StatDrag.Active=SolaraManager.StatusBar.Draggable; StatDrag.Visible=SolaraManager.StatusBar.Draggable; SolaraManager.SyncVisuals() end)

    Label(sbScr, "sbT2", "DISPLAY ELEMENTS", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=4
    local eR = Frame(sbScr, "eR", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); eR.BackgroundTransparency=1; eR.LayoutOrder=5
    local cTg = Button(eR, "cTg", "Show Cash", UDim2.new(0.32,0,1,0), UDim2.new()); local fTg = Button(eR, "fTg", "Show Farm Status", UDim2.new(0.32,0,1,0), UDim2.new(0.34,0,0,0)); local bTg = Button(eR, "bTg", "Show Buy Status", UDim2.new(0.32,0,1,0), UDim2.new(0.68,0,0,0))
    SolaraManager.UI.Toggles.SBCash=cTg; SolaraManager.UI.Toggles.SBFarm=fTg; SolaraManager.UI.Toggles.SBBuy=bTg
    cTg.MouseButton1Click:Connect(function() SolaraManager.StatusBar.ShowCash=not SolaraManager.StatusBar.ShowCash; SolaraManager.SyncVisuals() end)
    fTg.MouseButton1Click:Connect(function() SolaraManager.StatusBar.ShowFarm=not SolaraManager.StatusBar.ShowFarm; SolaraManager.SyncVisuals() end)
    bTg.MouseButton1Click:Connect(function() SolaraManager.StatusBar.ShowBuy=not SolaraManager.StatusBar.ShowBuy; SolaraManager.SyncVisuals() end)
end

-- [ PAGE 7: SETTINGS & CONFIG ] 
local function LoadConfigData(cD)
    if cD.AutoLoadConfig~=nil then SolaraManager.AutoLoadConfig=cD.AutoLoadConfig end
    if cD.IsAntiAfk~=nil then SolaraManager.IsAntiAfk=cD.IsAntiAfk end; if cD.IsNoclip~=nil then SolaraManager.IsNoclip=cD.IsNoclip end; if cD.IsESP~=nil then SolaraManager.IsESP=cD.IsESP end; if cD.IsFly~=nil then SolaraManager.IsFly=cD.IsFly end; if cD.IsInfJump~=nil then SolaraManager.IsInfJump=cD.IsInfJump end; if cD.IsAimbot~=nil then SolaraManager.IsAimbot=cD.IsAimbot end
    if cD.ESP_Name~=nil then SolaraManager.ESP_Name=cD.ESP_Name end; if cD.ESP_Health~=nil then SolaraManager.ESP_Health=cD.ESP_Health end; if cD.ESP_Pct~=nil then SolaraManager.ESP_Pct=cD.ESP_Pct end; if cD.ESP_Tracer~=nil then SolaraManager.ESP_Tracer=cD.ESP_Tracer end
    SolaraManager.SpeedOverride=cD.Speed; SolaraManager.JumpOverride=cD.Jump; if cD.FarmSpeed then SolaraManager.FarmSpeed=cD.FarmSpeed end; if cD.BuySpeed then SolaraManager.BuySpeed=cD.BuySpeed end; if cD.ActiveFarmState then SolaraManager.ActiveFarmState=cD.ActiveFarmState end; if cD.ActiveBuyState then SolaraManager.ActiveBuyState=cD.ActiveBuyState end; if cD.ActiveSmartState then SolaraManager.ActiveSmartState=cD.ActiveSmartState end; if cD.CustomMusicId then SolaraManager.CustomMusicId=cD.CustomMusicId end; if cD.CustomMusicVolume then SolaraManager.CustomMusicVolume=cD.CustomMusicVolume end
    if cD.StatusBar then SolaraManager.StatusBar = cD.StatusBar; StatBar.Position = UDim2.new(SolaraManager.StatusBar.PosX,0,SolaraManager.StatusBar.PosY,0); StatDrag.Active=SolaraManager.StatusBar.Draggable; StatDrag.Visible=SolaraManager.StatusBar.Draggable end
    if cD.Playlists then SolaraManager.Playlists=cD.Playlists end
    if cD.Waypoints then SolaraManager.Waypoints={}; for i,v in ipairs(cD.Waypoints) do table.insert(SolaraManager.Waypoints, {Name=v.Name, CFrame=CFrame.new(v.X,v.Y,v.Z)}) end end
    if cD.Theme then SolaraManager.ApplyTheme(cD.Theme) else SolaraManager.SyncVisuals() end
end

do
    local sP = BuildPage("Settings", "⚙️", 7); local sScr = Instance.new("Frame", sP); sScr.Size=UDim2.new(1,0,1,0); sScr.BackgroundTransparency=1; local sLyt=Instance.new("UIListLayout",sScr); sLyt.Padding=UDim.new(0,5); sLyt.SortOrder=Enum.SortOrder.LayoutOrder
    
    Label(sScr, "cT", "💾 SCRIPT CONFIG", UDim2.new(1,0,0,15), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=1
    local cR0 = Frame(sScr, "cR0", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); cR0.BackgroundTransparency=1; cR0.LayoutOrder=2
    local aLdTg = Button(cR0, "aLdTg", "Auto-Load Config on Launch", UDim2.new(1,0,1,0), UDim2.new(), SolaraManager.CurrentTheme.PanelBg); SolaraManager.UI.Toggles.AutoLoad=aLdTg
    aLdTg.MouseButton1Click:Connect(function() SolaraManager.AutoLoadConfig=not SolaraManager.AutoLoadConfig; SolaraManager.SyncVisuals() end)
    local cR = Frame(sScr, "cR", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); cR.BackgroundTransparency=1; cR.LayoutOrder=3
    local svB = Button(cR, "svB", "Save Config", UDim2.new(0.48,0,1,0), UDim2.new(0,0,0,0), SolaraManager.CurrentTheme.Success); local ldB = Button(cR, "ldB", "Load Config", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), SolaraManager.CurrentTheme.Warning)
    Frame(sScr, "dC", UDim2.new(1,0,0,2), UDim2.new(), SolaraManager.CurrentTheme.Stroke, "Dividers").LayoutOrder=4
    
    svB.MouseButton1Click:Connect(function()
        local cD = {AutoLoadConfig=SolaraManager.AutoLoadConfig, Theme=SolaraManager.CurrentThemeName, IsAntiAfk=SolaraManager.IsAntiAfk, IsNoclip=SolaraManager.IsNoclip, IsESP=SolaraManager.IsESP, IsFly=SolaraManager.IsFly, IsInfJump=SolaraManager.IsInfJump, IsAimbot=SolaraManager.IsAimbot, ESP_Name=SolaraManager.ESP_Name, ESP_Health=SolaraManager.ESP_Health, ESP_Pct=SolaraManager.ESP_Pct, ESP_Tracer=SolaraManager.ESP_Tracer, Speed=SolaraManager.SpeedOverride, Jump=SolaraManager.JumpOverride, FarmSpeed=SolaraManager.FarmSpeed, BuySpeed=SolaraManager.BuySpeed, ActiveFarmState=SolaraManager.ActiveFarmState, ActiveBuyState=SolaraManager.ActiveBuyState, ActiveSmartState=SolaraManager.ActiveSmartState, CustomMusicId=SolaraManager.CustomMusicId, CustomMusicVolume=SolaraManager.CustomMusicVolume, Playlists=SolaraManager.Playlists, Waypoints={}, StatusBar=SolaraManager.StatusBar}
        for i,v in ipairs(SolaraManager.Waypoints) do table.insert(cD.Waypoints, {Name=v.Name, X=v.CFrame.X, Y=v.CFrame.Y, Z=v.CFrame.Z}) end
        if writefile then writefile(SolaraManager.ConfigFilename, HttpService:JSONEncode(cD)); svB.Text="Saved!"; task.wait(1); svB.Text="Save Config" end
    end)
    ldB.MouseButton1Click:Connect(function()
        if readfile and isfile and isfile(SolaraManager.ConfigFilename) then
            local cD = HttpService:JSONDecode(readfile(SolaraManager.ConfigFilename))
            if cD then LoadConfigData(cD); ldB.Text="Loaded!"; task.wait(1); ldB.Text="Load Config" end
        end
    end)
    
    Label(sScr, "psT", "👤 PLAYER SETTINGS", UDim2.new(1,0,0,15), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=5
    local eR2 = Frame(sScr, "eR2", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); eR2.BackgroundTransparency=1; eR2.LayoutOrder=6
    local enTg = Button(eR2, "enTg", "Show Name", UDim2.new(0.32,0,1,0), UDim2.new()); local ehTg = Button(eR2, "ehTg", "Show Health", UDim2.new(0.32,0,1,0), UDim2.new(0.34,0,0,0)); local epTg = Button(eR2, "epTg", "Health as %", UDim2.new(0.32,0,1,0), UDim2.new(0.68,0,0,0))
    SolaraManager.UI.Toggles.eName=enTg; SolaraManager.UI.Toggles.eHealth=ehTg; SolaraManager.UI.Toggles.ePct=epTg
    enTg.MouseButton1Click:Connect(function() SolaraManager.ESP_Name=not SolaraManager.ESP_Name; SolaraManager.SyncVisuals() end)
    ehTg.MouseButton1Click:Connect(function() SolaraManager.ESP_Health=not SolaraManager.ESP_Health; SolaraManager.SyncVisuals() end)
    epTg.MouseButton1Click:Connect(function() SolaraManager.ESP_Pct=not SolaraManager.ESP_Pct; SolaraManager.SyncVisuals() end)
    
    local eR3 = Frame(sScr, "eR3", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); eR3.BackgroundTransparency=1; eR3.LayoutOrder=7
    local etTg = Button(eR3, "etTg", "Show Tracers (Line)", UDim2.new(0.48,0,1,0), UDim2.new()); local eCol = Button(eR3, "eCol", "Change Tracer/Outline Color", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), SolaraManager.CurrentTheme.Accent)
    SolaraManager.UI.Toggles.eTracer=etTg; etTg.MouseButton1Click:Connect(function() SolaraManager.ESP_Tracer=not SolaraManager.ESP_Tracer; SolaraManager.SyncVisuals() end)
    local espColors = {Color3.new(1,1,1), Color3.new(1,0,0), Color3.new(0,1,0), Color3.new(0,0,1), Color3.new(1,1,0), Color3.new(1,0,1), Color3.new(0,1,1)}
    local cId = 1
    eCol.MouseButton1Click:Connect(function() cId=(cId%#espColors)+1; SolaraManager.ESP_LineColor=espColors[cId]; SolaraManager.ESP_OutlineColor=espColors[cId]; eCol.TextColor3=espColors[cId] end)

    Frame(sScr, "dPs", UDim2.new(1,0,0,2), UDim2.new(), SolaraManager.CurrentTheme.Stroke, "Dividers").LayoutOrder=8

    local function BGrp(t, g, o) Label(sScr, t.."L", t, UDim2.new(1,0,0,15), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=o; local tg=Instance.new("Frame",sScr); tg.BackgroundTransparency=1; tg.LayoutOrder=o+1; local gl=Instance.new("UIGridLayout",tg); gl.CellSize=UDim2.new(0.31,0,0,25); gl.CellPadding=UDim2.new(0.035,0,0,5); gl.SortOrder=Enum.SortOrder.LayoutOrder; local c=0; for tn,td in pairs(Themes) do if td.Group==g then c=c+1; local b=Button(tg, tn.."B", tn, UDim2.new(), UDim2.new(), SolaraManager.CurrentTheme.PanelBg, "Panels"); b.MouseButton1Click:Connect(function() SolaraManager.ApplyTheme(tn) end) end end tg.Size=UDim2.new(1,0,0,math.ceil(c/3)*30); return o+2 end
    BGrp("🕹️ VIDEO GAMES THEMES", "Game", BGrp("🎨 COLOR THEMES", "Color", 9))
end

SwitchTab("Player"); StatDrag.Visible=SolaraManager.StatusBar.Draggable; StatDrag.Active=SolaraManager.StatusBar.Draggable; SolaraManager.SyncVisuals()

-- [ INPUTS & ACTIONS ]
UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.W then SolaraManager.FlyCtrl.F=1 elseif i.KeyCode == Enum.KeyCode.S then SolaraManager.FlyCtrl.B=-1 elseif i.KeyCode == Enum.KeyCode.A then SolaraManager.FlyCtrl.L=-1 elseif i.KeyCode == Enum.KeyCode.D then SolaraManager.FlyCtrl.R=1 
    elseif i.KeyCode == Enum.KeyCode.Q and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then SolaraManager.IsAimbot = not SolaraManager.IsAimbot; SolaraManager.SyncVisuals() end
    if i.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and SolaraManager.ClickTP then if Mouse.Hit and LocalPlayer.Character then LocalPlayer.Character:PivotTo(CFrame.new(Mouse.Hit.p + Vector3.new(0,3,0))) end end
end)
UserInputService.InputEnded:Connect(function(i, gp)
    if i.KeyCode == Enum.KeyCode.W then SolaraManager.FlyCtrl.F=0 elseif i.KeyCode == Enum.KeyCode.S then SolaraManager.FlyCtrl.B=0 elseif i.KeyCode == Enum.KeyCode.A then SolaraManager.FlyCtrl.L=0 elseif i.KeyCode == Enum.KeyCode.D then SolaraManager.FlyCtrl.R=0 end
end)
UserInputService.JumpRequest:Connect(function() if SolaraManager.IsInfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping) end end)

-- [ ANTI-AFK CORE LOGIC ]
LocalPlayer.Idled:Connect(function() if SolaraManager.IsAntiAfk then VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame); task.wait(1); VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end end)

-- [ AUTO LOAD INIT ]
if readfile and isfile and isfile(SolaraManager.ConfigFilename) then local s, cD = pcall(function() return HttpService:JSONDecode(readfile(SolaraManager.ConfigFilename)) end); if s and cD and cD.AutoLoadConfig then LoadConfigData(cD) end end

-- [ 7. LOOPS & LOGIC ENGINE - REALTIME OPTIMIZED ]
RunService.RenderStepped:Connect(function()
    local c = LocalPlayer.Character; local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if SolaraManager.IsNoclip and c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end end end
    if SolaraManager.IsFly and hrp then local cam = workspace.CurrentCamera; local dir = (cam.CFrame.LookVector * (SolaraManager.FlyCtrl.F + SolaraManager.FlyCtrl.B)) + (cam.CFrame.RightVector * (SolaraManager.FlyCtrl.L + SolaraManager.FlyCtrl.R)); hrp.CFrame = hrp.CFrame + (dir * 2); hrp.Velocity = Vector3.new(0,0,0) end
    if SolaraManager.IsAimbot then
        local closest, shortest = nil, math.huge
        for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health>0 and hrp then local d = (hrp.Position - p.Character.Head.Position).Magnitude; if d < shortest then shortest = d; closest = p.Character.Head end end end
        if closest then workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, closest.Position) end
    end
    
    -- Realtime ESP
    pcall(function() 
        local eF=CoreGui:FindFirstChild("LeyleyESP"); if not eF then eF=Instance.new("Folder", CoreGui); eF.Name="LeyleyESP" end
        local cam=workspace.CurrentCamera
        if SolaraManager.IsESP then 
            for _,p in ipairs(Players:GetPlayers()) do 
                if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then 
                    local dist = hrp and math.floor((hrp.Position - p.Character.HumanoidRootPart.Position).Magnitude) or 0
                    local h_val = math.floor(p.Character.Humanoid.Health); local h_max = math.floor(p.Character.Humanoid.MaxHealth)
                    local hp_str = SolaraManager.ESP_Pct and math.floor((h_val/h_max)*100).."%" or h_val.." / "..h_max
                    local h=eF:FindFirstChild(p.Name.."_ESP"); if not h then h=Instance.new("Highlight", eF); h.Name=p.Name.."_ESP" end
                    h.Adornee=p.Character; h.FillColor=Color3.new(1,0,0); h.OutlineColor=SolaraManager.ESP_OutlineColor
                    local bg=eF:FindFirstChild(p.Name.."_BG"); if not bg then bg=Instance.new("BillboardGui", eF); bg.Name=p.Name.."_BG"; bg.AlwaysOnTop=true; bg.Size=UDim2.new(0,200,0,50); bg.ExtentsOffset=Vector3.new(0,3,0); local tl=Instance.new("TextLabel", bg); tl.Name="Txt"; tl.Size=UDim2.new(1,0,1,0); tl.BackgroundTransparency=1; tl.Font=Enum.Font.GothamBold; tl.TextSize=12; tl.TextColor3=Color3.new(1,1,1); tl.TextStrokeTransparency=0; tl.TextStrokeColor3=Color3.new(0,0,0) end
                    bg.Adornee=p.Character.HumanoidRootPart
                    local txt = ""
                    if SolaraManager.ESP_Name then txt=txt..p.Name.."\n" end
                    if SolaraManager.ESP_Health then txt=txt.."❤ "..hp_str.."\n" end
                    if SolaraManager.ESP_Dist then txt=txt.."["..dist.."m]" end
                    bg.Txt.Text=txt
                    if SolaraManager.ESP_Tracer then
                        local pos, vis = cam:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                        if not vis and pos.Z < 0 then local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2); local d = (Vector2.new(pos.X, pos.Y) - center).Unit; pos = Vector3.new(center.X - d.X * 2000, center.Y - d.Y * 2000, 0) end
                        if not ESP_Lines[p.Name] and Drawing then ESP_Lines[p.Name] = Drawing.new("Line") end
                        if ESP_Lines[p.Name] then ESP_Lines[p.Name].Visible=true; ESP_Lines[p.Name].From=Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2); ESP_Lines[p.Name].To=Vector2.new(pos.X, pos.Y); ESP_Lines[p.Name].Color=SolaraManager.ESP_LineColor; ESP_Lines[p.Name].Thickness=1 end
                    else if ESP_Lines[p.Name] then ESP_Lines[p.Name].Visible = false end end
                else if ESP_Lines[p.Name] then ESP_Lines[p.Name].Visible = false end end 
            end 
        else eF:ClearAllChildren(); for k,v in pairs(ESP_Lines) do v.Visible=false end end 
    end)
    
    -- Realtime Cash Update
    pcall(function() local cl=LocalPlayer.PlayerGui:FindFirstChild("HUD") and LocalPlayer.PlayerGui.HUD:FindFirstChild("Balance") and LocalPlayer.PlayerGui.HUD.Balance:FindFirstChild("Main") and LocalPlayer.PlayerGui.HUD.Balance.Main:FindFirstChild("Cash")
        if cl and cl:IsA("TextLabel") then
            local pNum = ParsePrice(cl.Text); if pNum then
                local stTxt = string.format("$%s (%s)", FormatNumber(pNum), ToSuffixString(pNum))
                if SolaraManager.UI.CashStatusLbl then SolaraManager.UI.CashStatusLbl.Text="Cash: "..stTxt end
                if SCash then SCash.Text=stTxt end
                if SolaraManager.UI.GameTabCash then SolaraManager.UI.GameTabCash.Text=stTxt end
                if pNum~=SolaraManager.LastCashValue then SolaraManager.LastCashValue=pNum; table.insert(SolaraManager.CashHistory, {time=tick(), cash=pNum}); while #SolaraManager.CashHistory>0 and (tick()-SolaraManager.CashHistory[1].time>15) do table.remove(SolaraManager.CashHistory,1) end end
                local ch=SolaraManager.CashHistory; if #ch>1 then local dt=ch[#ch].time-ch[1].time; local dc=ch[#ch].cash-ch[1].cash; if dt>0 and dc>=0 and SolaraManager.UI.CashRateLbl then SolaraManager.UI.CashRateLbl.Text=string.format("Rate: $%s/sec (%s)", FormatNumber(dc/dt), ToSuffixString(dc/dt)) end else if SolaraManager.UI.CashRateLbl then SolaraManager.UI.CashRateLbl.Text="Rate: $0/sec" end end
            end
        end
    end)
end)

task.spawn(function()
    while SG.Parent do
        local c = LocalPlayer.Character; local hrp = c and c:FindFirstChild("HumanoidRootPart"); local hum = c and c:FindFirstChild("Humanoid")
        if hum then if SolaraManager.SpeedOverride then hum.WalkSpeed=SolaraManager.SpeedOverride end; if SolaraManager.JumpOverride then hum.UseJumpPower=true; hum.JumpPower=SolaraManager.JumpOverride end end
        
        local cm = SolaraManager.CustomMusicInstance; local msl = SolaraManager.UI.MusicStatusLbl
        if cm and cm.IsLoaded then local p=cm.TimePosition; local l=cm.TimeLength; if msl then msl.Text=string.format("Now Playing: %s | %02d:%02d / %02d:%02d", SolaraManager.CustomMusicName, p/60, p%60, l/60, l%60) end else if msl and msl.Text~="Status: No music" then msl.Text="Status: No music" end end
        
        local sMP=false; local aFS=SolaraManager.ActiveFarmState; local aBS=SolaraManager.ActiveBuyState; local aSS=SolaraManager.ActiveSmartState
        local function SetTextF(lbl, statLbl, t) lbl.Text=t; statLbl.Text=t end
        
        if #Players:GetPlayers()>1 and (aFS=="Safe" or aBS=="Safe" or aSS=="Safe") then
            sMP=true; if not SolaraManager.HasSafetyRespawned and c and hrp then c:PivotTo(CFrame.new(0,3,0)); hrp.Velocity=Vector3.zero; hrp.RotVelocity=Vector3.zero; SolaraManager.HasSafetyRespawned=true end
            local txt="PAUSED (Player Near)"
            if aFS=="Safe" then SetTextF(SolaraManager.UI.FarmStatusLbl, SFarm, "Status: "..txt) end
            if aBS=="Safe" then SetTextF(SolaraManager.UI.TycoonStatusLbl, SBuy, "Status: "..txt) end
            if aSS=="Safe" then SetTextF(SolaraManager.UI.FarmStatusLbl, SFarm, "Status: "..txt); SetTextF(SolaraManager.UI.TycoonStatusLbl, SBuy, "Status: "..txt) end
        else SolaraManager.HasSafetyRespawned=false end
        
        if not sMP then
            local cb=nil
            if (aBS~="Off" or aSS~="Off") and c and hrp then
                pcall(function()
                    if not SolaraManager.MyTycoon then for _,fol in ipairs(workspace:GetChildren()) do local oV=fol:FindFirstChild("Owner"); if oV and string.lower(oV:IsA("ObjectValue") and oV.Value and oV.Value.Name or oV:IsA("StringValue") and oV.Value or "")==string.lower(LocalPlayer.Name) then SolaraManager.MyTycoon=fol; break end end end
                    if SolaraManager.MyTycoon then
                        local bL={}; local function sB(m) if m and m:FindFirstChild("Button") and m.Button:IsA("BasePart") then local g=m.Button:FindFirstChild("Gui") or m:FindFirstChild("Gui"); if g and g:FindFirstChild("Price") then local pT=(g.Price:IsA("ValueBase") and tostring(g.Price.Value) or g.Price.Text); local mT=(g:FindFirstChild("PriceMag") and (g.PriceMag:IsA("ValueBase") and tostring(g.PriceMag.Value) or g.PriceMag.Text) or ""); local rT=pT..mT; local p=ParsePrice(rT); if p and p>=0 then table.insert(bL, {Part=m.Button, Price=p, Raw=rT}) end end end end
                        if SolaraManager.MyTycoon:FindFirstChild("Purchases") then local cats={Structure=true, Other=true, Multiplier=true, Multipliers=true}; for _,sf in ipairs(SolaraManager.MyTycoon.Purchases:GetChildren()) do if sf:FindFirstChild("Buttons") then for _,cfol in ipairs(sf.Buttons:GetChildren()) do if cats[cfol.Name] then for _,b in ipairs(cfol:GetChildren()) do sB(b) end elseif cfol:IsA("Model") then sB(cfol) end end end if sf.Name=="Hills" then for _,d in ipairs(sf:GetDescendants()) do if d:IsA("Model") and d:FindFirstChild("Button") then sB(d) end end end end end
                        if #bL>0 then table.sort(bL, function(a,b) return a.Price<b.Price end); cb=bL[1] end
                    end
                end)
            end
            
            if aSS~="Off" then
                if cb and SolaraManager.LastCashValue >= cb.Price then
                    aBS=aSS; aFS="Off"; SetTextF(SolaraManager.UI.FarmStatusLbl, SFarm, "Status: Smart (Switching to Buy)")
                else
                    aFS=aSS; aBS="Off"; SetTextF(SolaraManager.UI.TycoonStatusLbl, SBuy, cb and "Status: Smart (Need $"..FormatNumber(cb.Price)..")" or "Status: Smart (No Buttons)")
                end
            end
            
            if aBS~="Off" and c and hrp then
                if cb then
                    SetTextF(SolaraManager.UI.TycoonStatusLbl, SBuy, "Buying: " .. FormatScientificAndSuffix(cb.Price)); c:PivotTo(cb.Part.CFrame*CFrame.new(0,1,0)); hrp.Velocity=Vector3.zero; hrp.RotVelocity=Vector3.zero; task.wait(1/SolaraManager.BuySpeed)
                else
                    SetTextF(SolaraManager.UI.TycoonStatusLbl, SBuy, "Status: No buttons."); task.wait(1)
                end
            end
            
            if aFS~="Off" and c and hrp then
                if tick()-SolaraManager.LastCacheUpdate>=10 then
                    SolaraManager.FarmCache={}; SolaraManager.SpecialCount=0
                    for _,wO in ipairs(workspace:GetDescendants()) do if wO.Name=="LemonTree" then for _,fO in ipairs(wO:GetDescendants()) do if fO.Name=="Fruit" and fO:FindFirstChild("ClickPart") and fO.ClickPart:IsA("BasePart") and fO.ClickPart:FindFirstChildOfClass("ClickDetector") then local isS=fO:FindFirstChild("SpecialAttachment") or fO.ClickPart:FindFirstChild("SpecialAttachment"); if isS then SolaraManager.SpecialCount=SolaraManager.SpecialCount+1 end; table.insert(SolaraManager.FarmCache, {Part=fO.ClickPart, Detector=fO.ClickPart:FindFirstChildOfClass("ClickDetector"), Special=isS~=nil}) end end end end
                    table.sort(SolaraManager.FarmCache, function(a,b) return a.Special and not b.Special end); SolaraManager.LastCacheUpdate=tick()
                end
                
                if #SolaraManager.FarmCache>0 then
                    local tFD=table.remove(SolaraManager.FarmCache, 1); if aSS=="Off" then SetTextF(SolaraManager.UI.FarmStatusLbl, SFarm, string.format("Status: Harvesting (%d left, %d Special)", #SolaraManager.FarmCache, SolaraManager.SpecialCount)) else SetTextF(SolaraManager.UI.FarmStatusLbl, SFarm, string.format("Status: Smart Harvesting (%d left)", #SolaraManager.FarmCache)) end
                    if tFD.Part and tFD.Part.Parent then if tFD.Special then SolaraManager.SpecialCount=math.max(0,SolaraManager.SpecialCount-1) end pcall(function() c:PivotTo(tFD.Part.CFrame*CFrame.new(0,0,2.5)); hrp.Velocity=Vector3.zero; task.wait(math.max(0.15,(1/SolaraManager.FarmSpeed)*0.4)); if fireclickdetector then fireclickdetector(tFD.Detector) end; local cam=workspace.CurrentCamera; cam.CameraType=Enum.CameraType.Scriptable; cam.CFrame=CFrame.lookAt(cam.CFrame.Position, tFD.Part.Position); task.wait(math.max(0.05,(1/SolaraManager.FarmSpeed)*0.4)); local sc=cam.ViewportSize/2; VirtualUser:Button1Down(sc); task.wait(0.05); VirtualUser:Button1Up(sc); cam.CameraType=Enum.CameraType.Custom; cam.CFrame=CFrame.lookAt(cam.CFrame.Position, cam.CFrame.Position+hrp.CFrame.LookVector*10); task.wait(math.max(0.1,(1/SolaraManager.FarmSpeed)*0.2)) end) end
                else SetTextF(SolaraManager.UI.FarmStatusLbl, SFarm, "Status: Waiting for respawns...") end
            end
        end
        task.wait(SolaraManager.ClickDelay)
    end
end)
