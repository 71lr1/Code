local _p=game:GetService("Players")
local _h=game:GetService("HttpService")
local _ms=game:GetService("MarketplaceService")
local _ts=game:GetService("TweenService")
local _ui=game:GetService("UserInputService")

local _cfg={
	rs=true,rf=true,sg=true,sp=false,spl=true,
	pg=true,bp=false,ps=true,ws=false,rem=false,
	pd=true,nil_=false,li=false,sn=false,an=false,bi=false,
}

local _nf={"ModuleScript","LocalScript","Script"}

local _st={lfs=10,lbs=11,dfs=10,tfs=9,sw=210}

local _cfgpath="Vault/vault_cfg.json"
pcall(function()
	if isfile and isfile(_cfgpath) then
		local raw=readfile(_cfgpath)
		local ok,data=pcall(function() return game:GetService("HttpService"):JSONDecode(raw) end)
		if ok and type(data)=="table" then
			if type(data.lfs)=="number" then _st.lfs=math.clamp(data.lfs,8,16) end
			if type(data.lbs)=="number" then _st.lbs=math.clamp(data.lbs,8,16) end
			if type(data.dfs)=="number" then _st.dfs=math.clamp(data.dfs,8,14) end
			if type(data.tfs)=="number" then _st.tfs=math.clamp(data.tfs,7,14) end
		end
	end
end)

---@return nil
local function _savecfg()
	pcall(function()
		if not isfolder("Vault") then makefolder("Vault") end
		writefile(_cfgpath,game:GetService("HttpService"):JSONEncode({
			lfs=_st.lfs,lbs=_st.lbs,dfs=_st.dfs,tfs=_st.tfs
		}))
	end)
end

local _c={
	bg=Color3.fromRGB(18,18,18),sf=Color3.fromRGB(24,24,24),
	sf2=Color3.fromRGB(30,30,30),bd=Color3.fromRGB(45,45,45),
	bd2=Color3.fromRGB(60,60,60),tx=Color3.fromRGB(230,230,230),
	tx2=Color3.fromRGB(140,140,140),tx3=Color3.fromRGB(90,90,90),
	ac=Color3.fromRGB(220,220,220),gn=Color3.fromRGB(74,222,128),
	am=Color3.fromRGB(251,191,36),rd=Color3.fromRGB(248,113,113),
	pu=Color3.fromRGB(167,139,250),wh=Color3.fromRGB(255,255,255),
	bl=Color3.fromRGB(0,0,0),bb=Color3.fromRGB(235,235,235),
	bt=Color3.fromRGB(10,10,10),
}

local _fm=Enum.Font.Code
local _fu=Enum.Font.GothamMedium
local _fb=Enum.Font.Gotham
local _lp=_p.LocalPlayer
local _pgs = _lp:WaitForChild("PlayerGui")
local _cg = game:GetService("CoreGui")

local function _getParent()
    local ok, res = pcall(function() return _cg end)
    return (ok and res) and res or _pgs
end

local _guiParent = _getParent()

local function _uuid()
	local t={"a","b","c","d","e","f","0","1","2","3","4","5","6","7","8","9"}
	local u=""
	for i=1,8 do u=u..t[math.random(1,#t)] end
	return u
end
local _sid=_uuid()

do
	local _ls=Instance.new("ScreenGui")
	_ls.Name="VaultLoader_".._sid
	_ls.ResetOnSpawn=false
	_ls.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
	_ls.DisplayOrder=1000
	_ls.Parent=_guiParent
	local _lbg=Instance.new("Frame")
	_lbg.Size=UDim2.new(1,0,1,0)
	_lbg.BackgroundTransparency=1
	_lbg.BorderSizePixel=0
	_lbg.ZIndex=1
	_lbg.Parent=_ls
	local _lcrd=Instance.new("Frame")
	_lcrd.Size=UDim2.new(0,220,0,110)
	_lcrd.Position=UDim2.new(0.5,0,0.5,0)
	_lcrd.AnchorPoint=Vector2.new(0.5,0.5)
	_lcrd.BackgroundColor3=Color3.fromRGB(18,18,18)
	_lcrd.BorderSizePixel=0
	_lcrd.BackgroundTransparency=1
	_lcrd.ZIndex=2
	_lcrd.Parent=_lbg
	local _lcrc=Instance.new("UICorner") _lcrc.CornerRadius=UDim.new(0,10) _lcrc.Parent=_lcrd
	local _lcrs=Instance.new("UIStroke") _lcrs.Color=Color3.fromRGB(42,42,42) _lcrs.Thickness=1 _lcrs.Transparency=1 _lcrs.Parent=_lcrd
	local function _mkl(txt,sz,fn,col,yoff)
		local l=Instance.new("TextLabel")
		l.Size=UDim2.new(1,0,0,26)
		l.Position=UDim2.new(0,0,0.5,yoff)
		l.AnchorPoint=Vector2.new(0,0.5)
		l.BackgroundTransparency=1
		l.Text=txt
		l.TextColor3=col
		l.TextSize=sz
		l.Font=fn
		l.TextTransparency=1
		l.TextXAlignment=Enum.TextXAlignment.Center
		l.ZIndex=3
		l.Parent=_lcrd
		return l
	end
	local _ltx=_mkl("vault",20,Enum.Font.GothamMedium,Color3.fromRGB(210,210,210),-22)
	local _lby=_mkl("made by vanish",10,Enum.Font.Code,Color3.fromRGB(65,65,65),4)
	local _lln=Instance.new("Frame")
	_lln.Size=UDim2.new(0,0,0,1)
	_lln.Position=UDim2.new(0.5,0,0.5,26)
	_lln.AnchorPoint=Vector2.new(0.5,0)
	_lln.BackgroundColor3=Color3.fromRGB(36,36,36)
	_lln.BorderSizePixel=0
	_lln.ZIndex=3
	_lln.Parent=_lcrd
	local _ldot=_mkl("loading...",9,Enum.Font.Code,Color3.fromRGB(50,50,50),44)
	local _lxb=Instance.new("TextButton")
	_lxb.Size=UDim2.new(0,20,0,20)
	_lxb.Position=UDim2.new(1,-8,0,8)
	_lxb.AnchorPoint=Vector2.new(1,0)
	_lxb.BackgroundTransparency=1
	_lxb.BorderSizePixel=0
	_lxb.Text="×"
	_lxb.TextColor3=Color3.fromRGB(55,55,55)
	_lxb.TextSize=13
	_lxb.Font=Enum.Font.GothamMedium
	_lxb.TextTransparency=1
	_lxb.ZIndex=4
	_lxb.AutoButtonColor=false
	_lxb.Parent=_lcrd
	local _done=false
	local function _finish()
		if _done then return end _done=true
		local function _tw2(o,p,t) _ts:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),p):Play() end
		_tw2(_ldot,{TextTransparency=1},0.2)
		_tw2(_lxb,{TextTransparency=1},0.2)
		_tw2(_ltx,{TextTransparency=1},0.3)
		_tw2(_lby,{TextTransparency=1},0.3)
		_tw2(_lln,{Size=UDim2.new(0,0,0,1)},0.25)
		task.wait(0.25)
		_tw2(_lcrd,{BackgroundTransparency=1},0.35)
		_tw2(_lcrs,{Transparency=1},0.35)
		task.wait(0.4)
		_ls:Destroy()
	end
	_lxb.MouseButton1Click:Connect(_finish)
	_lxb.MouseEnter:Connect(function() _lxb.TextColor3=Color3.fromRGB(150,150,150) end)
	_lxb.MouseLeave:Connect(function() _lxb.TextColor3=Color3.fromRGB(55,55,55) end)
	local function _tw(o,p,t) return _ts:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),p) end
	_tw(_lcrd,{BackgroundTransparency=0},0.4):Play()
	_tw(_lcrs,{Transparency=0},0.4):Play()
	task.wait(0.18)
	_tw(_ltx,{TextTransparency=0},0.5):Play()
	task.wait(0.2)
	_tw(_lby,{TextTransparency=0},0.45):Play()
	_tw(_lxb,{TextTransparency=0},0.4):Play()
	task.wait(0.18)
	_tw(_lln,{Size=UDim2.new(0,140,0,1)},0.45):Play()
	task.wait(0.12)
	_tw(_ldot,{TextTransparency=0},0.35):Play()
	task.wait(1.3)
	_finish()
end

local _sg2=Instance.new("ScreenGui")
_sg2.Name="Vault_".._sid
_sg2.ResetOnSpawn=false
_sg2.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
_sg2.DisplayOrder=999
_sg2.Parent=_guiParent

---@param r number
---@param p Instance
---@return UICorner
local function _cr(r,p) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r) c.Parent=p return c end

---@param t number
---@param c Color3
---@param tr number
---@param p Instance
---@return UIStroke
local function _sk(t,c,tr,p) local s=Instance.new("UIStroke") s.Thickness=t s.Color=c s.Transparency=tr s.Parent=p return s end

---@param o {bg:Color3?,sz:UDim2?,ps:UDim2?,ap:Vector2?,cl:boolean?,pr:Instance?,nm:string?,zi:number?}
---@return Frame
local function _mf(o)
	local f=Instance.new("Frame")
	f.BackgroundColor3=o.bg or _c.sf f.BorderSizePixel=0
	if o.sz then f.Size=o.sz end if o.ps then f.Position=o.ps end
	if o.ap then f.AnchorPoint=o.ap end if o.cl~=nil then f.ClipsDescendants=o.cl end
	if o.pr then f.Parent=o.pr end if o.nm then f.Name=o.nm end
	if o.zi then f.ZIndex=o.zi end return f
end

---@param o {tx:string?,cl:Color3?,sz:number?,fn:Enum.Font?,xa:Enum.TextXAlignment?,ya:Enum.TextYAlignment?,wr:boolean?,s:UDim2?,ps:UDim2?,ap:Vector2?,pr:Instance?,nm:string?,zi:number?}
---@return TextLabel
local function _ml(o)
	local l=Instance.new("TextLabel") l.BackgroundTransparency=1
	l.Text=o.tx or "" l.TextColor3=o.cl or _c.tx l.TextSize=o.sz or 13
	l.Font=o.fn or _fb l.TextXAlignment=o.xa or Enum.TextXAlignment.Left
	l.TextYAlignment=o.ya or Enum.TextYAlignment.Center l.TextWrapped=o.wr or false
	if o.s then l.Size=o.s end if o.ps then l.Position=o.ps end
	if o.ap then l.AnchorPoint=o.ap end if o.pr then l.Parent=o.pr end
	if o.nm then l.Name=o.nm end if o.zi then l.ZIndex=o.zi end return l
end

---@param o {tx:string?,bg:Color3?,cl:Color3?,sz:number?,fn:Enum.Font?,s:UDim2?,ps:UDim2?,ap:Vector2?,pr:Instance?,nm:string?}
---@return TextButton
local function _mb(o)
	local b=Instance.new("TextButton") b.BackgroundColor3=o.bg or _c.sf2
	b.BorderSizePixel=0 b.Text=o.tx or "" b.TextColor3=o.cl or _c.tx
	b.TextSize=o.sz or 13 b.Font=o.fn or _fu b.AutoButtonColor=false
	if o.s then b.Size=o.s end if o.ps then b.Position=o.ps end
	if o.ap then b.AnchorPoint=o.ap end if o.pr then b.Parent=o.pr end
	if o.nm then b.Name=o.nm end return b
end

local _mnw,_mxw,_mnh,_mxh=480,1100,360,820

local _mfr=_mf({bg=_c.bg,sz=UDim2.new(0,620,0,500),ps=UDim2.new(0.5,0,0.5,0),ap=Vector2.new(0.5,0.5),cl=true,pr=_sg2,nm="Main"})
_cr(8,_mfr) _sk(1,_c.bd,0,_mfr)

local _dg=false local _ds,_dp

---@param h GuiObject
---@return nil
local function _sd(h)
	h.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then _dg=true _ds=i.Position _dp=_mfr.Position end
	end)
	h.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then _dg=false end
	end)
end

_ui.InputChanged:Connect(function(i)
	if _dg and i.UserInputType==Enum.UserInputType.MouseMovement then
		local d=i.Position-_ds
		_mfr.Position=UDim2.new(_dp.X.Scale,_dp.X.Offset+d.X,_dp.Y.Scale,_dp.Y.Offset+d.Y)
	end
end)

local _rs2={} local _rst={} local _rfs={}
local _es=6

---@param nm string
---@return nil
local function _mrh(nm)
	local h=Instance.new("TextButton") h.Name="R_"..nm h.BackgroundTransparency=1
	h.BorderSizePixel=0 h.Text="" h.AutoButtonColor=false h.ZIndex=50
	if nm=="Right" then h.Size=UDim2.new(0,_es,1,-16) h.Position=UDim2.new(1,-_es,0,8)
	elseif nm=="Left" then h.Size=UDim2.new(0,_es,1,-16) h.Position=UDim2.new(0,0,0,8)
	elseif nm=="Bottom" then h.Size=UDim2.new(1,-16,0,_es) h.Position=UDim2.new(0,8,1,-_es)
	elseif nm=="Top" then h.Size=UDim2.new(1,-16,0,_es) h.Position=UDim2.new(0,8,0,0)
	elseif nm=="BottomRight" then h.Size=UDim2.new(0,12,0,12) h.Position=UDim2.new(1,-12,1,-12)
	elseif nm=="BottomLeft" then h.Size=UDim2.new(0,12,0,12) h.Position=UDim2.new(0,0,1,-12)
	elseif nm=="TopRight" then h.Size=UDim2.new(0,12,0,12) h.Position=UDim2.new(1,-12,0,0)
	elseif nm=="TopLeft" then h.Size=UDim2.new(0,12,0,12) h.Position=UDim2.new(0,0,0,0) end
	h.AnchorPoint=Vector2.new(0,0) h.Parent=_mfr
	h.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then
			_rs2[nm]=true _rst[nm]=i.Position
			_rfs[nm]={x=_mfr.Position.X.Offset,y=_mfr.Position.Y.Offset,w=_mfr.AbsoluteSize.X,h=_mfr.AbsoluteSize.Y}
		end
	end)
	h.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then _rs2[nm]=false end
	end)
end

for _,n in ipairs({"Right","Left","Bottom","Top","BottomRight","BottomLeft","TopRight","TopLeft"}) do _mrh(n) end

_ui.InputChanged:Connect(function(i)
	if i.UserInputType~=Enum.UserInputType.MouseMovement then return end
	for nm,act in pairs(_rs2) do
		if not act then continue end
		local st=_rst[nm] local fs=_rfs[nm] local d=i.Position-st
		local nw=fs.w local nh=fs.h local nx=fs.x local ny=fs.y
		if nm=="Right" or nm=="BottomRight" or nm=="TopRight" then nw=math.clamp(fs.w+d.X,_mnw,_mxw) end
		if nm=="Left" or nm=="BottomLeft" or nm=="TopLeft" then nw=math.clamp(fs.w-d.X,_mnw,_mxw) nx=fs.x+(fs.w-nw) end
		if nm=="Bottom" or nm=="BottomRight" or nm=="BottomLeft" then nh=math.clamp(fs.h+d.Y,_mnh,_mxh) end
		if nm=="Top" or nm=="TopRight" or nm=="TopLeft" then nh=math.clamp(fs.h-d.Y,_mnh,_mxh) ny=fs.y+(fs.h-nh) end
		_mfr.Size=UDim2.new(0,nw,0,nh)
		_mfr.Position=UDim2.new(0.5,nx-_mfr.AbsoluteSize.X*0.5+nw*0.5,0.5,ny-_mfr.AbsoluteSize.Y*0.5+nh*0.5)
	end
end)

local _tb=_mf({bg=_c.sf,sz=UDim2.new(1,0,0,36),ps=UDim2.new(0,0,0,0),pr=_mfr,nm="TitleBar"})
_sd(_tb)

_ml({tx="Vault",cl=_c.tx2,sz=11,fn=_fm,s=UDim2.new(0,70,1,0),ps=UDim2.new(0,14,0,0),pr=_tb})

local _bf2=_mf({bg=_c.sf2,sz=UDim2.new(0,32,0,16),ps=UDim2.new(0,74,0.5,0),ap=Vector2.new(0,0.5),pr=_tb})
_cr(20,_bf2) _sk(1,_c.bd2,0,_bf2)
_ml({tx="v1.0",cl=_c.tx3,sz=9,fn=_fm,s=UDim2.new(1,0,1,0),ps=UDim2.new(0,0,0,0),xa=Enum.TextXAlignment.Center,pr=_bf2})

local _sl=_ml({tx=_sid,cl=_c.tx3,sz=9,fn=_fm,s=UDim2.new(0,80,1,0),ps=UDim2.new(1,-88,0,0),xa=Enum.TextXAlignment.Right,pr=_tb,nm="SL"})

local _cb=_mb({tx="×",bg=_c.bg,cl=_c.tx3,sz=16,fn=_fu,s=UDim2.new(0,28,0,28),ps=UDim2.new(1,-4,0.5,0),ap=Vector2.new(1,0.5),pr=_tb,nm="CB"})
_cb.BackgroundTransparency=1
_cb.MouseButton1Click:Connect(function() _sg2:Destroy() end)

local _pb=_mf({bg=_c.sf2,sz=UDim2.new(1,0,0,2),ps=UDim2.new(0,0,0,36),pr=_mfr})
local _pf=_mf({bg=_c.ac,sz=UDim2.new(0,0,1,0),ps=UDim2.new(0,0,0,0),pr=_pb,nm="Fill"})

---@param pct number
local function _sp(pct) _ts:Create(_pf,TweenInfo.new(0.25),{Size=UDim2.new(pct/100,0,1,0)}):Play() end

local _at="config"

local _tbr=_mf({bg=_c.sf,sz=UDim2.new(1,0,0,28),ps=UDim2.new(0,0,0,38),pr=_mfr})
_mf({bg=_c.bd,sz=UDim2.new(1,0,0,1),ps=UDim2.new(0,0,1,0),pr=_tbr})

local _tll=Instance.new("UIListLayout") _tll.FillDirection=Enum.FillDirection.Horizontal
_tll.SortOrder=Enum.SortOrder.LayoutOrder _tll.VerticalAlignment=Enum.VerticalAlignment.Center
_tll.Padding=UDim.new(0,0) _tll.Parent=_tbr

local _tp=Instance.new("UIPadding") _tp.PaddingLeft=UDim.new(0,12) _tp.Parent=_tbr

local _tbs={} local _tps={}

local _bdf=_mf({bg=_c.bg,sz=UDim2.new(1,0,1,-68),ps=UDim2.new(0,0,0,68),pr=_mfr,nm="Body"})

---@param nm string
---@param ord number
---@return Frame
local function _mkt(nm,ord)
	local b=_mb({tx=nm,bg=_c.sf,cl=_c.tx3,sz=10,fn=_fm,s=UDim2.new(0,62,0,28),pr=_tbr})
	b.LayoutOrder=ord b.BackgroundTransparency=1
	local ind=_mf({bg=_c.ac,sz=UDim2.new(0,0,0,1),ps=UDim2.new(0.5,0,1,-1),ap=Vector2.new(0.5,0),pr=b})
	local pn=_mf({bg=_c.bg,sz=UDim2.new(1,0,1,0),ps=UDim2.new(0,0,0,0),pr=_bdf,nm="P_"..nm})
	pn.Visible=(nm=="config") _tbs[nm]={b=b,i=ind} _tps[nm]=pn
	b.MouseButton1Click:Connect(function()
		_at=nm
		for n,t in pairs(_tbs) do
			t.b.TextColor3=(n==nm) and _c.tx or _c.tx3
			_ts:Create(t.i,TweenInfo.new(0.15,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.new((n==nm) and 0.6 or 0,0,0,1)}):Play()
		end
		for n,p in pairs(_tps) do p.Visible=(n==nm) end
	end)
	return pn
end

local _cp=_mkt("config",1) local _sep=_mkt("settings",2)
_tbs["config"].b.TextColor3=_c.tx
_ts:Create(_tbs["config"].i,TweenInfo.new(0),{Size=UDim2.new(0.6,0,0,1)}):Play()

local _sb=_mf({bg=_c.bg,sz=UDim2.new(0,_st.sw,1,0),ps=UDim2.new(0,0,0,0),pr=_cp,nm="Sb"})
_mf({bg=_c.bd,sz=UDim2.new(0,1,1,0),ps=UDim2.new(1,0,0,0),pr=_sb})
_ml({tx="SERVICES",cl=_c.tx3,sz=9,fn=_fu,s=UDim2.new(1,-14,0,24),ps=UDim2.new(0,14,0,0),pr=_sb})

local _os=Instance.new("ScrollingFrame") _os.Size=UDim2.new(1,0,1,-46) _os.Position=UDim2.new(0,0,0,24)
_os.BackgroundTransparency=1 _os.BorderSizePixel=0 _os.ScrollBarThickness=2
_os.ScrollBarImageColor3=_c.bd2 _os.CanvasSize=UDim2.new(0,0,0,0)
_os.AutomaticCanvasSize=Enum.AutomaticSize.Y _os.Parent=_sb

local _ol=Instance.new("UIListLayout") _ol.SortOrder=Enum.SortOrder.LayoutOrder _ol.Padding=UDim.new(0,0) _ol.Parent=_os

local _opts={
	{id="rs",lb="ReplicatedStorage",ds="saves UI hierarchies and scripts"},
	{id="rf",lb="ReplicatedFirst",ds="saves early-load scripts and assets"},
	{id="sg",lb="StarterGui",ds="saves the starter GUI hierarchy"},
	{id="sp",lb="StarterPack",ds="saves starter pack tool instances"},
	{id="spl",lb="StarterPlayer",ds="saves StarterPlayerScripts content"},
	{id="pg",lb="PlayerGui",ds="saves the live PlayerGui at runtime"},
	{id="bp",lb="Backpack",ds="saves tools currently in the backpack"},
	{id="ps",lb="PlayerScripts",ds="saves all client-side scripts"},
	{id="ws",lb="Workspace",ds="maps parts, models and folder structure"},
	{id="rem",lb="Remotes",ds="lists all RemoteEvent and RemoteFunction paths"},
	{id="pd",lb="PlayerData",ds="dumps stats, attributes and character data"},
	{id="nil_",lb="Nil Instances",ds="scans getnilinstances for hidden scripts"},
	{id="li",lb="Lighting",ds="saves lighting properties, fog and children"},
	{id="sn",lb="Sounds",ds="collects all Sound instances with their IDs"},
	{id="an",lb="Animations",ds="collects Animation IDs and active tracks"},
	{id="bi",lb="Bindables",ds="lists all BindableEvent and BindableFunction paths"},
}

local _cr2={} local _olr={}

local _ttFrame=Instance.new("Frame")
_ttFrame.BackgroundColor3=Color3.fromRGB(22,22,22)
_ttFrame.BorderSizePixel=0
_ttFrame.ZIndex=30
_ttFrame.AutomaticSize=Enum.AutomaticSize.X
_ttFrame.Size=UDim2.new(0,0,0,22)
_ttFrame.BackgroundTransparency=1
_ttFrame.Parent=_sg2
local _ttc2=Instance.new("UICorner") _ttc2.CornerRadius=UDim.new(0,5) _ttc2.Parent=_ttFrame
local _tts2=Instance.new("UIStroke") _tts2.Color=Color3.fromRGB(48,48,48) _tts2.Thickness=1 _tts2.Transparency=1 _tts2.Parent=_ttFrame
local _ttp2=Instance.new("UIPadding") _ttp2.PaddingLeft=UDim.new(0,8) _ttp2.PaddingRight=UDim.new(0,8) _ttp2.Parent=_ttFrame
local _ttl2=Instance.new("TextLabel")
_ttl2.BackgroundTransparency=1
_ttl2.Text=""
_ttl2.TextColor3=Color3.fromRGB(160,160,160)
_ttl2.TextTransparency=1
_ttl2.TextSize=10
_ttl2.Font=Enum.Font.Gotham
_ttl2.Size=UDim2.new(0,0,1,0)
_ttl2.AutomaticSize=Enum.AutomaticSize.X
_ttl2.TextXAlignment=Enum.TextXAlignment.Left
_ttl2.ZIndex=31
_ttl2.Parent=_ttFrame

local _ttVisible=false

local function _showTooltip(txt,anchor)
	_ttVisible=true
	_ttl2.Text=txt
	local ap=anchor.AbsolutePosition
	local as=anchor.AbsoluteSize
	_ttFrame.Position=UDim2.new(0,ap.X+as.X+8,0,ap.Y+as.Y/2-11)
	_ts:Create(_ttFrame,TweenInfo.new(0.12,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency=0}):Play()
	_ts:Create(_tts2,TweenInfo.new(0.12,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Transparency=0}):Play()
	_ts:Create(_ttl2,TweenInfo.new(0.12,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{TextTransparency=0}):Play()
end

local function _hideTooltip()
	_ttVisible=false
	_ts:Create(_ttFrame,TweenInfo.new(0.08,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency=1}):Play()
	_ts:Create(_tts2,TweenInfo.new(0.08,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Transparency=1}):Play()
	_ts:Create(_ttl2,TweenInfo.new(0.08,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{TextTransparency=1}):Play()
end

---@param opt {id:string,lb:string,ds:string}
---@param ord number
---@return nil
local function _mco(opt,ord)
	local row=_mf({bg=_c.bg,sz=UDim2.new(1,0,0,34),pr=_os}) row.LayoutOrder=ord row.Name="R_"..opt.id
	_mf({bg=Color3.fromRGB(35,35,35),sz=UDim2.new(1,0,0,1),ps=UDim2.new(0,0,1,-1),pr=row})
	local co=_mf({bg=_cfg[opt.id] and _c.bb or _c.sf2,sz=UDim2.new(0,14,0,14),ps=UDim2.new(0,14,0.5,0),ap=Vector2.new(0,0.5),pr=row})
	_cr(2,co) _sk(1,_c.bd2,0,co)
	local ct=_ml({tx="✓",cl=_c.bt,sz=9,fn=_fu,s=UDim2.new(1,0,1,0),ps=UDim2.new(0,0,0,0),xa=Enum.TextXAlignment.Center,pr=co})
	ct.Visible=_cfg[opt.id]
	local nl=_ml({tx=opt.lb,cl=_c.tx,sz=_st.lbs,fn=_fm,s=UDim2.new(1,-36,0,16),ps=UDim2.new(0,34,0.5,0),ap=Vector2.new(0,0.5),pr=row})
	_cr2[opt.id]={o=co,t=ct} table.insert(_olr,nl)
	local btn=_mb({tx="",bg=_c.bg,s=UDim2.new(1,0,1,0),ps=UDim2.new(0,0,0,0),pr=row}) btn.BackgroundTransparency=1 btn.ZIndex=5
	btn.MouseButton1Click:Connect(function()
		_cfg[opt.id]=not _cfg[opt.id] ct.Visible=_cfg[opt.id] co.BackgroundColor3=_cfg[opt.id] and _c.bb or _c.sf2
	end)
	btn.MouseEnter:Connect(function()
		_ts:Create(row,TweenInfo.new(0.1),{BackgroundColor3=_c.sf}):Play()
		_showTooltip(opt.ds,row)
	end)
	btn.MouseLeave:Connect(function()
		_ts:Create(row,TweenInfo.new(0.1),{BackgroundColor3=_c.bg}):Play()
		_hideTooltip()
	end)
end

for i,o in ipairs(_opts) do _mco(o,i) end

local _rb2=_mf({bg=_c.sf,sz=UDim2.new(1,0,0,46),ps=UDim2.new(0,0,1,-46),pr=_sb})
_sk(1,_c.bd,0,_rb2)

local _rbn=_mb({tx="run vault",bg=_c.bb,cl=_c.bt,sz=11,fn=_fm,s=UDim2.new(1,-28,0,28),ps=UDim2.new(0,14,0.5,0),ap=Vector2.new(0,0.5),pr=_rb2,nm="RB"})
_cr(5,_rbn)
_rbn.MouseEnter:Connect(function() _ts:Create(_rbn,TweenInfo.new(0.1),{BackgroundColor3=_c.wh}):Play() end)
_rbn.MouseLeave:Connect(function() _ts:Create(_rbn,TweenInfo.new(0.1),{BackgroundColor3=_c.bb}):Play() end)

local _lp2=_mf({bg=_c.bg,sz=UDim2.new(1,-(_st.sw+1),1,0),ps=UDim2.new(0,_st.sw+1,0,0),pr=_cp,cl=true,nm="LP"})
local _lt=_mf({bg=_c.sf,sz=UDim2.new(1,0,0,32),ps=UDim2.new(0,0,0,0),pr=_lp2})

local _fl={"all","info","warn","error","ok","nil"}
local _fc={all=_c.tx2,info=_c.tx2,warn=_c.am,error=_c.rd,ok=_c.gn,["nil"]=_c.pu}

local _fbs={} local _afi="all" local _les={} local _als={} local _lo=0

local _fll=Instance.new("UIListLayout") _fll.FillDirection=Enum.FillDirection.Horizontal
_fll.SortOrder=Enum.SortOrder.LayoutOrder _fll.VerticalAlignment=Enum.VerticalAlignment.Center
_fll.Padding=UDim.new(0,2) _fll.Parent=_lt

local _flp=Instance.new("UIPadding") _flp.PaddingLeft=UDim.new(0,10) _flp.Parent=_lt

for i,lv in ipairs(_fl) do
	local fb=_mb({tx=lv,bg=_c.bg,cl=_c.tx3,sz=9,fn=_fm,s=UDim2.new(0,36,0,20),pr=_lt})
	fb.BackgroundTransparency=1 fb.LayoutOrder=i fb.Name="F_"..lv _cr(20,fb) _fbs[lv]=fb
	fb.MouseButton1Click:Connect(function()
		_afi=lv
		for l2,b in pairs(_fbs) do b.BackgroundTransparency=1 b.TextColor3=_c.tx3 end
		fb.BackgroundTransparency=0 fb.BackgroundColor3=_c.sf2 fb.TextColor3=_fc[lv] or _c.tx
		for _,e in pairs(_les) do
			local sh=(lv=="all") or (lv==e.lv) or (lv==e.ml)
			e.row.Visible=sh
		end
	end)
end
_fbs["all"].BackgroundTransparency=0 _fbs["all"].BackgroundColor3=_c.sf2 _fbs["all"].TextColor3=_c.tx2

local _lcl=_ml({tx="0 entries",cl=_c.tx3,sz=9,fn=_fm,s=UDim2.new(0,60,1,0),ps=UDim2.new(1,-130,0,0),xa=Enum.TextXAlignment.Right,pr=_lt})
local _clb=_mb({tx="clear",bg=_c.sf2,cl=_c.tx3,sz=9,fn=_fm,s=UDim2.new(0,42,0,20),ps=UDim2.new(1,-50,0.5,0),ap=Vector2.new(0,0.5),pr=_lt})
_cr(4,_clb) _sk(1,_c.bd2,0,_clb)
_clb.MouseEnter:Connect(function() _clb.TextColor3=_c.tx end)
_clb.MouseLeave:Connect(function() _clb.TextColor3=_c.tx3 end)

local _lsc=Instance.new("ScrollingFrame") _lsc.Size=UDim2.new(1,0,1,-64) _lsc.Position=UDim2.new(0,0,0,32)
_lsc.BackgroundTransparency=1 _lsc.BorderSizePixel=0 _lsc.ScrollBarThickness=2
_lsc.ScrollBarImageColor3=_c.bd2 _lsc.CanvasSize=UDim2.new(0,0,0,0)
_lsc.AutomaticCanvasSize=Enum.AutomaticSize.Y _lsc.Parent=_lp2

local _lll=Instance.new("UIListLayout") _lll.SortOrder=Enum.SortOrder.LayoutOrder _lll.Padding=UDim.new(0,0) _lll.Parent=_lsc

local _stb=_mf({bg=_c.sf,sz=UDim2.new(1,0,0,32),ps=UDim2.new(0,0,1,-32),pr=_lp2})

local _sd2={
	{k="total",px="entries"},{k="warn",px="warn"},
	{k="err",px="error"},{k="nil_found",px="nil"},
}

local _stl2=Instance.new("UIListLayout") _stl2.FillDirection=Enum.FillDirection.Horizontal
_stl2.SortOrder=Enum.SortOrder.LayoutOrder _stl2.VerticalAlignment=Enum.VerticalAlignment.Center
_stl2.Padding=UDim.new(0,0) _stl2.Parent=_stb

local _sbp=Instance.new("UIPadding") _sbp.PaddingLeft=UDim.new(0,14) _sbp.Parent=_stb

local _sls={}
for i,d in ipairs(_sd2) do
	local c=_mf({bg=_c.bg,sz=UDim2.new(0,80,1,0),pr=_stb}) c.BackgroundTransparency=1 c.LayoutOrder=i
	local l=_ml({tx=d.px.." 0",cl=_c.tx3,sz=9,fn=_fm,s=UDim2.new(1,0,1,0),ps=UDim2.new(0,0,0,0),pr=c})
	_sls[d.k]={l=l,px=d.px}
end

local _lvc={info=_c.tx2,warn=_c.am,error=_c.rd,success=_c.gn,["nil"]=_c.pu}
local _lbc={info=_c.bd,warn=Color3.fromRGB(120,80,0),error=Color3.fromRGB(120,30,30),success=Color3.fromRGB(30,100,50),["nil"]=Color3.fromRGB(90,50,150)}

local _es2={total=0,warn=0,err=0,nil_found=0,ui=0,scripts=0}

---@return nil
local function _usb()
	for k,r in pairs(_sls) do r.l.Text=r.px..(" ")..(_es2[k] or 0) end
end

---@return nil
local function _stb2()
	task.defer(function()
		_lsc.CanvasPosition=Vector2.new(0,math.max(0,_lsc.AbsoluteCanvasSize.Y-_lsc.AbsoluteSize.Y))
	end)
end

---@param msg string
---@param lv string?
---@return nil
local function _ale(msg,lv)
	lv=lv or "info" _lo=_lo+1
	local ml=lv=="success" and "ok" or lv
	local row=_mf({bg=_c.bg,sz=UDim2.new(1,0,0,22),pr=_lsc}) row.LayoutOrder=_lo
	_mf({bg=_lbc[lv] or _c.bd,sz=UDim2.new(0,2,1,0),ps=UDim2.new(0,0,0,0),pr=row})
	local tl=_ml({tx=os.date("%H:%M:%S"),cl=_c.tx3,sz=_st.tfs,fn=_fm,s=UDim2.new(0,58,1,0),ps=UDim2.new(0,6,0,0),pr=row})
	local ll=_ml({tx="["..lv:upper().."]",cl=_lvc[lv] or _c.tx2,sz=_st.lfs-1,fn=_fm,s=UDim2.new(0,54,1,0),ps=UDim2.new(0,62,0,0),pr=row})
	local ml2=_ml({tx=msg,cl=_lvc[lv] or _c.tx,sz=_st.lfs,fn=_fm,s=UDim2.new(1,-120,1,0),ps=UDim2.new(0,118,0,0),pr=row,wr=false})
	local sh=(_afi=="all") or (_afi==lv) or (_afi==ml)
	row.Visible=sh
	table.insert(_als,{msg=msg,lv=lv})
	_les[_lo]={row=row,lv=lv,ml=ml,tl=tl,ll=ll,ml2=ml2}
	_lcl.Text=#_als.." entries" _stb2()
end

_clb.MouseButton1Click:Connect(function()
	for _,e in pairs(_les) do e.row:Destroy() end
	_les={} _als={} _lo=0 _lcl.Text="0 entries"
	_es2={total=0,warn=0,err=0,nil_found=0,ui=0,scripts=0} _usb()
end)

---@param msg string
---@param lv string?
---@return nil
local function _lm(msg,lv)
	lv=lv or "info" _es2.total=_es2.total+1
	if lv=="warn" then _es2.warn=_es2.warn+1 end
	if lv=="error" then _es2.err=_es2.err+1 end
	if lv=="nil" then _es2.nil_found=_es2.nil_found+1 end
	_ale(msg,lv) _usb()
end

---@return nil
local function _afs()
	for _,e in pairs(_les) do
		if e.tl then e.tl.TextSize=_st.tfs end
		if e.ll then e.ll.TextSize=_st.lfs-1 end
		if e.ml2 then e.ml2.TextSize=_st.lfs end
	end
	for _,l in ipairs(_olr) do l.TextSize=_st.lbs end
end

---@param par Instance
---@param lb string
---@param key string
---@param mn number
---@param mx number
---@param yp number
---@return nil
local function _msr(par,lb,key,mn,mx,yp)
	_ml({tx=lb,cl=_c.tx2,sz=11,fn=_fm,s=UDim2.new(0,160,0,20),ps=UDim2.new(0,24,0,yp),pr=par})
	local vl=_ml({tx=tostring(_st[key]),cl=_c.tx3,sz=10,fn=_fm,s=UDim2.new(0,30,0,20),ps=UDim2.new(0,190,0,yp),pr=par})
	local tbg=_mf({bg=_c.sf2,sz=UDim2.new(0,200,0,4),ps=UDim2.new(0,24,0,yp+26),pr=par}) _cr(4,tbg)
	local tf2=_mf({bg=_c.ac,sz=UDim2.new((_st[key]-mn)/(mx-mn),0,1,0),ps=UDim2.new(0,0,0,0),pr=tbg}) _cr(4,tf2)
	local th=_mf({bg=_c.wh,sz=UDim2.new(0,10,0,10),ps=UDim2.new((_st[key]-mn)/(mx-mn),-5,0.5,0),ap=Vector2.new(0,0.5),pr=tbg}) _cr(10,th)
	local ds3=false
	local function _us(ip)
		local r=(ip.X-tbg.AbsolutePosition.X)/tbg.AbsoluteSize.X r=math.clamp(r,0,1)
		local nv=math.round(mn+r*(mx-mn)) _st[key]=nv vl.Text=tostring(nv)
		tf2.Size=UDim2.new(r,0,1,0) th.Position=UDim2.new(r,-5,0.5,0) _afs() _savecfg()
	end
	tbg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then ds3=true _us(i.Position) end end)
	th.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then ds3=true end end)
	_ui.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then ds3=false end end)
	_ui.InputChanged:Connect(function(i) if ds3 and i.UserInputType==Enum.UserInputType.MouseMovement then _us(i.Position) end end)
end

local _ssc=Instance.new("ScrollingFrame") _ssc.Size=UDim2.new(1,0,1,0) _ssc.Position=UDim2.new(0,0,0,0)
_ssc.BackgroundTransparency=1 _ssc.BorderSizePixel=0 _ssc.ScrollBarThickness=2
_ssc.ScrollBarImageColor3=_c.bd2 _ssc.CanvasSize=UDim2.new(0,0,0,0)
_ssc.AutomaticCanvasSize=Enum.AutomaticSize.Y _ssc.Parent=_sep

_ml({tx="TYPOGRAPHY",cl=_c.tx3,sz=9,fn=_fu,s=UDim2.new(1,-24,0,24),ps=UDim2.new(0,24,0,8),pr=_ssc})
_mf({bg=_c.bd,sz=UDim2.new(1,-24,0,1),ps=UDim2.new(0,12,0,32),pr=_ssc})
_msr(_ssc,"log font size","lfs",8,16,40)
_msr(_ssc,"label font size","lbs",8,16,100)
_msr(_ssc,"desc font size","dfs",8,14,160)
_msr(_ssc,"timestamp size","tfs",7,14,220)
_ml({tx="WINDOW",cl=_c.tx3,sz=9,fn=_fu,s=UDim2.new(1,-24,0,24),ps=UDim2.new(0,24,0,290),pr=_ssc})
_mf({bg=_c.bd,sz=UDim2.new(1,-24,0,1),ps=UDim2.new(0,12,0,314),pr=_ssc})
_ml({tx="drag edges to resize   •   drag title bar to move",cl=_c.tx3,sz=10,fn=_fm,s=UDim2.new(1,-24,0,20),ps=UDim2.new(0,24,0,322),pr=_ssc})
_ml({tx="min  480 × 360   •   max  1100 × 820",cl=_c.tx3,sz=10,fn=_fm,s=UDim2.new(1,-24,0,20),ps=UDim2.new(0,24,0,346),pr=_ssc})

local _rsb=_mb({tx="reset settings",bg=_c.sf2,cl=_c.tx2,sz=10,fn=_fm,s=UDim2.new(0,120,0,26),ps=UDim2.new(0,24,0,388),pr=_ssc})
_cr(5,_rsb) _sk(1,_c.bd2,0,_rsb)
_rsb.MouseButton1Click:Connect(function()
	_st.lfs=10 _st.lbs=11 _st.dfs=10 _st.tfs=9
	_savecfg()
	_sg2:Destroy() warn("[Vault] reset — re-run to apply")
end)

local _svs={
	{id="rs",svc=game:GetService("ReplicatedStorage"),nm="ReplicatedStorage"},
	{id="rf",svc=game:GetService("ReplicatedFirst"),nm="ReplicatedFirst"},
	{id="sg",svc=game:GetService("StarterGui"),nm="StarterGui"},
	{id="sp",svc=game:GetService("StarterPack"),nm="StarterPack"},
	{id="spl",svc=game:GetService("StarterPlayer"),nm="StarterPlayer"},
	{id="pg",svc=_lp:WaitForChild("PlayerGui"),nm="PlayerGui"},
	{id="bp",svc=_lp:WaitForChild("Backpack"),nm="Backpack"},
	{id="ps",svc=_lp:WaitForChild("PlayerScripts"),nm="PlayerScripts"},
}

local _uc={
	ScreenGui=true,BillboardGui=true,SurfaceGui=true,Frame=true,TextLabel=true,
	TextButton=true,TextBox=true,ImageLabel=true,ImageButton=true,ScrollingFrame=true,
	CanvasGroup=true,ViewportFrame=true,UICorner=true,UIStroke=true,UIPadding=true,
	UIListLayout=true,UIGridLayout=true,UITableLayout=true,UIPageLayout=true,UIScale=true,
	UIGradient=true,UIAspectRatioConstraint=true,UISizeConstraint=true,UITextSizeConstraint=true,
	UIFlexItem=true,LocalScript=true,ModuleScript=true,Folder=true,Configuration=true,
	StringValue=true,IntValue=true,NumberValue=true,BoolValue=true,ObjectValue=true,
	Color3Value=true,Vector3Value=true,CFrameValue=true,RayValue=true,NumberRange=true,
	Sound=true,SoundGroup=true,SoundService=true,Animation=true,AnimationController=true,
	Animator=true,RemoteEvent=true,RemoteFunction=true,BindableEvent=true,BindableFunction=true,
	Tool=true,Script=true,SelectionBox=true,SelectionSphere=true,Decal=true,Texture=true,
	SpecialMesh=true,BlockMesh=true,CylinderMesh=true,PointLight=true,SpotLight=true,
	SurfaceLight=true,Attachment=true,WeldConstraint=true,Motor6D=true,ProximityPrompt=true,
	ClickDetector=true,Model=true,Part=true,UnionOperation=true,MeshPart=true,
}

local _pm={
	GuiObject={"Size","Position","AnchorPoint","BackgroundColor3","BackgroundTransparency","BorderSizePixel","BorderColor3","Visible","ZIndex","LayoutOrder","ClipsDescendants","Rotation","AutomaticSize"},
	TextLabel={"Text","TextColor3","TextSize","Font","TextScaled","TextWrapped","RichText","TextXAlignment","TextYAlignment","TextTransparency","LineHeight","MaxVisibleGraphemes"},
	TextButton={"Text","TextColor3","TextSize","Font","TextScaled","TextWrapped","RichText","AutoButtonColor"},
	TextBox={"Text","PlaceholderText","PlaceholderColor3","TextColor3","TextSize","Font","ClearTextOnFocus","MultiLine"},
	ImageLabel={"Image","ImageColor3","ImageTransparency","ScaleType","SliceCenter","SliceScale","TileSize","ImageRectOffset","ImageRectSize","ResampleMode"},
	ImageButton={"Image","ImageColor3","ImageTransparency","ScaleType","AutoButtonColor","SliceCenter","SliceScale"},
	ScrollingFrame={"ScrollBarThickness","ScrollingDirection","CanvasSize","ScrollBarImageColor3","ElasticBehavior","AutomaticCanvasSize"},
	CanvasGroup={"GroupTransparency","GroupColor3"},
	UICorner={"CornerRadius"},UIStroke={"Color","Thickness","Transparency","ApplyStrokeMode","LineJoinMode"},
	UIPadding={"PaddingTop","PaddingBottom","PaddingLeft","PaddingRight"},
	UIListLayout={"FillDirection","HorizontalAlignment","VerticalAlignment","Padding","SortOrder"},
	UIGridLayout={"CellSize","CellPadding","FillDirection","SortOrder"},
	UIAspectRatioConstraint={"AspectRatio","AspectType","DominantAxis"},
	UISizeConstraint={"MinSize","MaxSize"},UITextSizeConstraint={"MinTextSize","MaxTextSize"},
	UIScale={"Scale"},UIGradient={"Color","Offset","Rotation","Transparency"},
	ScreenGui={"ResetOnSpawn","IgnoreGuiInset","DisplayOrder","Enabled","ZIndexBehavior"},
	BillboardGui={"Size","StudsOffset","Active","AlwaysOnTop","MaxDistance","LightInfluence"},
	SurfaceGui={"Face","CanvasSize","Active","LightInfluence"},
	LocalScript={"Enabled"},ModuleScript={},ViewportFrame={"ImageColor3","ImageTransparency"},
	ValueBase={"Value"},
	Sound={"SoundId","Volume","Pitch","Looped","PlayOnRemove","RollOffMaxDistance","RollOffMinDistance","TimePosition"},
	Decal={"Texture","Color3","Transparency","Face"},
	Texture={"Texture","StudsPerTileU","StudsPerTileV","Face","Transparency"},
	SpecialMesh={"MeshId","TextureId","MeshType","Scale","Offset"},
	PointLight={"Brightness","Color","Range","Shadows"},
	SpotLight={"Brightness","Color","Range","Angle","Shadows"},
	SurfaceLight={"Brightness","Color","Range","Angle","Shadows"},
	Tool={"RequiresHandle","CanBeDropped","ToolTip","GripPos","GripUp","GripRight","GripForward"},
	ProximityPrompt={"ActionText","ObjectText","HoldDuration","MaxActivationDistance","RequiresLineOfSight"},
	ClickDetector={"MaxActivationDistance"},Animation={"AnimationId"},
	WeldConstraint={"Enabled"},Motor6D={"C0","C1","MaxVelocity"},
	BasePart={"Size","CFrame","Anchored","CanCollide","CanTouch","CastShadow","Transparency","Reflectance","Material","Color","Massless","CollisionGroupId"},
	Model={"PrimaryPart"},
}

---@param v any
---@return string
local function _fv(v)
	local t=typeof(v)
	if t=="UDim2" then return string.format("UDim2.new(%s,%s,%s,%s)",v.X.Scale,v.X.Offset,v.Y.Scale,v.Y.Offset)
	elseif t=="UDim" then return string.format("UDim.new(%s,%s)",v.Scale,v.Offset)
	elseif t=="Vector3" then return string.format("Vector3.new(%s,%s,%s)",v.X,v.Y,v.Z)
	elseif t=="Vector2" then return string.format("Vector2.new(%s,%s)",v.X,v.Y)
	elseif t=="Color3" then return string.format("Color3.fromRGB(%d,%d,%d)",v.R*255,v.G*255,v.B*255)
	elseif t=="BrickColor" then return string.format("BrickColor.new(\"%s\")",tostring(v))
	elseif t=="EnumItem" then return tostring(v)
	elseif t=="Rect" then return string.format("Rect.new(%s,%s,%s,%s)",v.Min.X,v.Min.Y,v.Max.X,v.Max.Y)
	elseif t=="ColorSequence" then
		local kps={}
		for _,kp in ipairs(v.Keypoints) do table.insert(kps,string.format("ColorSequenceKeypoint.new(%s,Color3.fromRGB(%d,%d,%d))",kp.Time,kp.Value.R*255,kp.Value.G*255,kp.Value.B*255)) end
		return "ColorSequence.new({"..table.concat(kps,",").."}"
	elseif t=="NumberSequence" then
		local kps={}
		for _,kp in ipairs(v.Keypoints) do table.insert(kps,string.format("NumberSequenceKeypoint.new(%s,%s)",kp.Time,kp.Value)) end
		return "NumberSequence.new({"..table.concat(kps,",").."}"
	elseif t=="boolean" then return tostring(v)
	elseif t=="number" then return tostring(v)
	elseif t=="string" then return string.format("%q",v)
	end
	return tostring(v)
end

---@param inst Instance
---@return table<string,string>
local function _gp(inst)
	local props={}
	for cn,pl in pairs(_pm) do
		if inst:IsA(cn) or inst.ClassName==cn then
			for _,p in ipairs(pl) do pcall(function() props[p]=_fv(inst[p]) end) end
		end
	end
	return props
end

---@param inst LuaSourceContainer
---@return string?
local function _gs(inst)
	if not(inst:IsA("LocalScript") or inst:IsA("ModuleScript")) then return nil end
	local ok,src=pcall(function() if decompile then return decompile(inst) end return nil end)
	if ok and src then return src end
	return nil
end

---@param inst Instance
---@return boolean
local function _ir(inst)
	if _uc[inst.ClassName] then return true end
	if inst:IsA("GuiObject") or inst:IsA("UIBase") or inst:IsA("LayerCollector") then return true end
	for _,c in ipairs(inst:GetDescendants()) do
		if _uc[c.ClassName] or c:IsA("GuiObject") or c:IsA("LocalScript") or c:IsA("ModuleScript") then return true end
	end
	return false
end

local _gn="Game"
pcall(function()
	_gn=_ms:GetProductInfo(game.PlaceId).Name
	_gn=_gn:gsub("[^%w_ ]",""):gsub(" ","_")
end)

local _rt="Vault/".._gn.."_".._sid

---@param path string
---@return nil
local function _ef(path) if not isfolder(path) then makefolder(path) end end

---@param str string
---@return string
local function _sn(str) return str:gsub("[^%w_%- ]",""):gsub(" ","_") end

local _vc=0
---@return string
local function _nv() _vc=_vc+1 return "v".._vc end

---@param inst Instance
---@param pv string?
---@param dp number?
---@return string
local function _sui(inst,pv,dp)
	if not _ir(inst) then return "" end
	if inst:IsA("LocalScript") or inst:IsA("ModuleScript") then return "" end
	dp=dp or 0
	local ind=string.rep("    ",dp) local ls={} local v=_nv()
	table.insert(ls,ind..string.format("local %s = Instance.new(\"%s\")",v,inst.ClassName))
	table.insert(ls,ind..string.format("%s.Name = %q",v,inst.Name))
	local props=_gp(inst)
	for p,val in pairs(props) do table.insert(ls,ind..string.format("%s.%s = %s",v,p,val)) end
	if pv then table.insert(ls,ind..string.format("%s.Parent = %s",v,pv)) end
	table.insert(ls,"")
	for _,c in ipairs(inst:GetChildren()) do
		local out=_sui(c,v,dp+1)
		if out~="" then table.insert(ls,out) end
	end
	return table.concat(ls,"\n")
end

---@param inst Instance
---@param fp string
---@return nil
local function _ssr(inst,fp)
	if inst:IsA("LocalScript") or inst:IsA("ModuleScript") then
		local src=_gs(inst)
		if src then
			writefile(fp.."/"..(_sn(inst.Name))..".lua",inst.ClassName..": "..inst:GetFullName().."\n\n"..src)
			_lm("script: "..inst:GetFullName(),"info") _es2.scripts=_es2.scripts+1
		end
	end
	for _,c in ipairs(inst:GetChildren()) do
		if _ir(c) then
			if c:IsA("LocalScript") or c:IsA("ModuleScript") then _ssr(c,fp)
			elseif #c:GetChildren()>0 then
				local sf=fp.."/"..(_sn(c.Name)) local hs=false
				for _,d in ipairs(c:GetDescendants()) do if d:IsA("LocalScript") or d:IsA("ModuleScript") then hs=true break end end
				if hs then _ef(sf) _ssr(c,sf) end
			end
		end
	end
end

---@param v any
---@return string
local function _sv2(v)
	local t=typeof(v)
	if t=="string" then return string.format("%q",v)
	elseif t=="number" then return tostring(v)
	elseif t=="boolean" then return tostring(v)
	elseif t=="Vector3" then return string.format("Vector3.new(%s,%s,%s)",v.X,v.Y,v.Z)
	elseif t=="Color3" then return string.format("Color3.fromRGB(%d,%d,%d)",v.R*255,v.G*255,v.B*255)
	elseif t=="BrickColor" then return string.format("BrickColor.new(\"%s\")",tostring(v))
	elseif t=="EnumItem" then return tostring(v)
	elseif t=="CFrame" then local c={v:GetComponents()} return "CFrame.new("..table.concat(c,", ")..")"
	elseif t=="Instance" then return v:GetFullName()
	elseif t=="nil" then return "nil"
	end
	return tostring(v)
end

---@param inst Instance
---@param dp number?
---@return string
local function _di(inst,dp)
	dp=dp or 0 local ind=string.rep("  ",dp) local ls={}
	local at={} pcall(function() at=inst:GetAttributes() end)
	local ha=false for _ in pairs(at) do ha=true break end
	local iv=inst:IsA("ValueBase") local vs,hv="",false
	if iv then pcall(function() vs=_sv2(inst.Value) hv=true end) end
	local hdr=ind.."["..inst.ClassName.."] "..inst.Name
	if hv then hdr=hdr.." = "..vs end
	table.insert(ls,hdr)
	if ha then for n,v in pairs(at) do table.insert(ls,ind.."  @"..n.." = ".._sv2(v)) end end
	for _,c in ipairs(inst:GetChildren()) do
		local out=_di(c,dp+1) if out~="" then table.insert(ls,out) end
	end
	return table.concat(ls,"\n")
end

---@return nil
local function _spd()
	_ef(_rt.."/Data/PlayerData")
	local plr=_lp local ls={}
	table.insert(ls,"Player Data Dump")
	table.insert(ls,"Player: "..plr.Name.." ("..plr.UserId..")")
	table.insert(ls,os.date("%Y-%m-%d %H:%M:%S"))
	table.insert(ls,"") table.insert(ls,"== PLAYER INFO ==")
	table.insert(ls,"Name: "..plr.Name) table.insert(ls,"DisplayName: "..plr.DisplayName)
	table.insert(ls,"UserId: "..plr.UserId)
	pcall(function() table.insert(ls,"AccountAge: "..plr.AccountAge.." days") end)
	pcall(function() table.insert(ls,"MembershipType: "..tostring(plr.MembershipType)) end)
	pcall(function() table.insert(ls,"Team: "..tostring(plr.Team)) end)
	table.insert(ls,"") table.insert(ls,"== LEADERSTATS ==")
	local lss=plr:FindFirstChild("leaderstats")
	if lss then for _,s in ipairs(lss:GetChildren()) do pcall(function() table.insert(ls,"  "..s.Name.." = ".._sv2(s.Value).."  ["..s.ClassName.."]") end) end
	else table.insert(ls,"  (no leaderstats)") end
	table.insert(ls,"") table.insert(ls,"== PLAYER ATTRIBUTES ==")
	pcall(function()
		local at=plr:GetAttributes() local ha=false
		for n,v in pairs(at) do table.insert(ls,"  @"..n.." = ".._sv2(v)) ha=true end
		if not ha then table.insert(ls,"  (none)") end
	end)
	table.insert(ls,"")
	local sk={PlayerGui=true,Backpack=true,StarterGear=true,PlayerScripts=true,leaderstats=true}
	table.insert(ls,"== PLAYER CHILDREN ==")
	for _,c in ipairs(plr:GetChildren()) do if not sk[c.Name] then table.insert(ls,_di(c,1)) end end
	table.insert(ls,"")
	local char=plr.Character
	if char then
		table.insert(ls,"-- CHARACTER ATTRIBUTES --")
		pcall(function()
			local at=char:GetAttributes() local ha=false
			for n,v in pairs(at) do table.insert(ls,"  @"..n.." = ".._sv2(v)) ha=true end
			if not ha then table.insert(ls,"  (none)") end
		end)
		table.insert(ls,"")
		local hum=char:FindFirstChildOfClass("Humanoid")
		if hum then
			table.insert(ls,"-- HUMANOID --")
			pcall(function() table.insert(ls,"  Health: "..hum.Health.." / "..hum.MaxHealth) end)
			pcall(function() table.insert(ls,"  WalkSpeed: "..hum.WalkSpeed) end)
			pcall(function() table.insert(ls,"  JumpPower: "..hum.JumpPower) end)
			pcall(function() table.insert(ls,"  JumpHeight: "..hum.JumpHeight) end)
		end
	end
	table.insert(ls,"") table.insert(ls,"-- BACKPACK --")
	local bk=plr:FindFirstChild("Backpack")
	if bk then
		for _,t in ipairs(bk:GetChildren()) do
			if t:IsA("Tool") then
				local tl2="  [Tool] "..t.Name
				pcall(function() tl2=tl2.."  ToolTip: "..t.ToolTip end)
				table.insert(ls,tl2)
			end
		end
	end
	writefile(_rt.."/Data/PlayerData/PlayerData.txt",table.concat(ls,"\n"))
	local jd={} pcall(function()
		jd.player={Name=plr.Name,DisplayName=plr.DisplayName,UserId=plr.UserId,AccountAge=plr.AccountAge,Attributes=plr:GetAttributes()}
	end)
	if lss then jd.leaderstats={} for _,s in ipairs(lss:GetChildren()) do pcall(function() jd.leaderstats[s.Name]={ClassName=s.ClassName,Value=s.Value} end) end end
	pcall(function() writefile(_rt.."/Data/PlayerData/PlayerData.json",_h:JSONEncode(jd)) end)
	_lm("PlayerData saved (txt + json)","success")
end

local _rl={} local _rtf=0

---@param svc Instance
---@param snm string
---@return nil
local function _scr(svc,snm)
	local f=0
	for _,d in ipairs(svc:GetDescendants()) do
		if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
			f=f+1 _rtf=_rtf+1
			local path=d:GetFullName():gsub("%.","/")
			local ln=string.format("%-18s %s","["..d.ClassName.."]",path)
			table.insert(_rl,ln) _lm("remote ["..d.ClassName.."] "..path,"info")
		end
	end
	if f>0 then _lm(snm..": "..f.." remote(s)","success") else _lm(snm..": no remotes","warn") end
end

---@return nil
local function _frf()
	if _rtf==0 then return end
	_ef(_rt.."/Misc/Remotes")
	local out={"Remotes Dump","Game: ".._gn,"Date: "..os.date("%Y-%m-%d %H:%M:%S"),"Total: ".._rtf,"",string.rep("-",60),""}
	for _,l in ipairs(_rl) do table.insert(out,l) end
	writefile(_rt.."/Misc/Remotes/remotes.txt",table.concat(out,"\n"))
	_lm("remotes.txt — ".._rtf.." total","success") _rl={} _rtf=0
end

---@return nil
local function _sw2()
	_ef(_rt.."/Misc/Workspace")
	local ws=game:GetService("Workspace") local pts,flds=0,0 local ls={}
	for _,c in ipairs(ws:GetChildren()) do
		if c:IsA("Folder") or c:IsA("Model") then flds=flds+1 table.insert(ls,"["..c.ClassName.."] "..c.Name) end
	end
	for _,d in ipairs(ws:GetDescendants()) do if d:IsA("BasePart") then pts=pts+1 end end
	table.insert(ls,1,"Workspace Dump — "..os.date("%Y-%m-%d %H:%M:%S"))
	table.insert(ls,2,"BaseParts: "..pts.."  Folders/Models: "..flds)
	table.insert(ls,3,"")
	writefile(_rt.."/Misc/Workspace/workspace_map.txt",table.concat(ls,"\n"))
	_lm("Workspace: "..pts.." parts, "..flds.." folders","success")
end

local _snc={RemoteEvent=true,RemoteFunction=true,BindableEvent=true,BindableFunction=true}

---@param inst Instance
---@return string?
local function _gs2(inst)
	local ok,src=pcall(decompile,inst)
	if ok and src and #src>0 then return src end
	local ok2,raw=pcall(function() return inst.Source end)
	if ok2 and raw and #raw>0 then return raw end
	return nil
end

---@return nil
local function _sni()
	_ef(_rt.."/Misc/NilInstances")
	if not getnilinstances then _lm("getnilinstances not available","error") return end
	local fs3={} for _,c in ipairs(_nf) do if not _snc[c] then fs3[c]=true end end
	local found=0 local ls={}
	table.insert(ls,"Nil Instances Dump — "..os.date("%Y-%m-%d %H:%M:%S"))
	table.insert(ls,"Filters: "..table.concat(_nf,", "))
	table.insert(ls,"")

	---@param inst Instance
	---@param pfld string
	---@return nil
	local function _proc(inst,pfld)
		local cfld=pfld.."/"..(_sn(inst.Name))
		_ef(cfld)
		if inst:IsA("LocalScript") or inst:IsA("ModuleScript") or inst:IsA("Script") then
			local src=_gs2(inst)
			if src then
				writefile(cfld.."/"..(_sn(inst.Name))..".lua",src)
				_lm("decompiled: "..inst.Name,"nil")
			end
		end
		for _,c in ipairs(inst:GetChildren()) do
			_proc(c,cfld)
		end
	end

	for _,v in next,getnilinstances() do
		if fs3[v.ClassName] then
			found=found+1
			local pn=v.Parent and v.Parent.Name or "nil"
			table.insert(ls,"["..v.ClassName.."] "..v.Name.." — parent: "..pn)
			_lm("[!] nil: "..v.ClassName.." '"..v.Name.."' parent="..pn,"nil")
			local bf=_rt.."/Misc/NilInstances/".._sn(v.Name)
			_proc(v,_rt.."/Misc/NilInstances")
			table.insert(ls,"")
		end
	end

	if found==0 then _lm("nil scan: nothing found","warn")
	else _lm("nil scan done — "..found.." instance(s)","success") end
	table.insert(ls,string.rep("-",50))
	table.insert(ls,"Total: "..found)
	writefile(_rt.."/Misc/NilInstances/nil_instances.txt",table.concat(ls,"\n"))
end

---@return nil
local function _sli()
	_ef(_rt.."/Misc/Lighting")
	local li=game:GetService("Lighting")
	local ls={"Lighting Dump","Date: "..os.date("%Y-%m-%d %H:%M:%S"),"","-- PROPERTIES --"}
	for _,p in ipairs({"Ambient","OutdoorAmbient","Brightness","ClockTime","GeographicLatitude","FogColor","FogEnd","FogStart","GlobalShadows","Technology","EnvironmentDiffuseScale","EnvironmentSpecularScale","ExposureCompensation"}) do
		pcall(function() table.insert(ls,"  "..p..": "..tostring(li[p])) end)
	end
	table.insert(ls,"") table.insert(ls,"-- CHILDREN --")
	for _,c in ipairs(li:GetChildren()) do
		table.insert(ls,"  ["..c.ClassName.."] "..c.Name)
		pcall(function() local at=c:GetAttributes() for k,v in pairs(at) do table.insert(ls,"    @"..k.." = "..tostring(v)) end end)
	end
	table.insert(ls,"") table.insert(ls,"-- SOUNDS --")
	for _,d in ipairs(li:GetDescendants()) do
		if d:IsA("Sound") then table.insert(ls,"  [Sound] "..d.Name.." id="..tostring(d.SoundId).." vol="..tostring(d.Volume)) end
	end
	writefile(_rt.."/Misc/Lighting/lighting.txt",table.concat(ls,"\n"))
	_lm("Lighting saved","success")
end

---@return nil
local function _ssn()
	_ef(_rt.."/Misc/Sounds")
	local ls={"Sound Dump","Date: "..os.date("%Y-%m-%d %H:%M:%S"),"",string.rep("-",50),""} local cnt=0
	for _,svc in ipairs({game:GetService("ReplicatedStorage"),game:GetService("StarterGui"),game:GetService("Workspace"),_lp:FindFirstChild("PlayerGui")}) do
		if svc then
			for _,d in ipairs(svc:GetDescendants()) do
				if d:IsA("Sound") then
					cnt=cnt+1
					local path=d:GetFullName():gsub("%.","/")
					table.insert(ls,string.format("%-30s  id=%-40s  vol=%s  loop=%s",d.Name,tostring(d.SoundId),tostring(d.Volume),tostring(d.Looped)))
					table.insert(ls,"  path: "..path) table.insert(ls,"")
				end
			end
		end
	end
	table.insert(ls,string.rep("-",50)) table.insert(ls,"Total: "..cnt)
	writefile(_rt.."/Misc/Sounds/sounds.txt",table.concat(ls,"\n"))
	_lm("Sounds: "..cnt.." saved","success")
end

---@return nil
local function _san()
	_ef(_rt.."/Misc/Animations")
	local ls={"Animation Dump","Date: "..os.date("%Y-%m-%d %H:%M:%S"),"",string.rep("-",50),""} local cnt=0
	for _,svc in ipairs({game:GetService("ReplicatedStorage"),game:GetService("StarterPlayer"),game:GetService("Workspace")}) do
		if svc then
			for _,d in ipairs(svc:GetDescendants()) do
				if d:IsA("Animation") then
					cnt=cnt+1
					local path=d:GetFullName():gsub("%.","/")
					table.insert(ls,string.format("[Animation] %-30s  id=%s",d.Name,tostring(d.AnimationId)))
					table.insert(ls,"  path: "..path) table.insert(ls,"")
				end
			end
		end
	end
	local char=_lp.Character
	if char then
		local anim=char:FindFirstChildOfClass("Humanoid") and char:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator")
		if anim then
			table.insert(ls,"-- PLAYING --")
			for _,t in ipairs(anim:GetPlayingAnimationTracks()) do
				table.insert(ls,"  "..t.Name.." speed="..tostring(t.Speed).." weight="..tostring(t.WeightCurrent))
			end
		end
	end
	table.insert(ls,string.rep("-",50)) table.insert(ls,"Total: "..cnt)
	writefile(_rt.."/Misc/Animations/animations.txt",table.concat(ls,"\n"))
	_lm("Animations: "..cnt.." saved","success")
end

---@return nil
local function _sbi()
	_ef(_rt.."/Misc/Bindables")
	local ls={"Bindables Dump","Date: "..os.date("%Y-%m-%d %H:%M:%S"),"",string.rep("-",50),""} local cnt=0
	for _,svc in ipairs({game:GetService("ReplicatedStorage"),game:GetService("ReplicatedFirst"),game:GetService("StarterGui"),game:GetService("StarterPlayer")}) do
		if svc then
			for _,d in ipairs(svc:GetDescendants()) do
				if d:IsA("BindableEvent") or d:IsA("BindableFunction") then
					cnt=cnt+1
					local path=d:GetFullName():gsub("%.","/")
					table.insert(ls,string.format("%-18s %s","["..d.ClassName.."]",path))
				end
			end
		end
	end
	table.insert(ls,"") table.insert(ls,string.rep("-",50)) table.insert(ls,"Total: "..cnt)
	writefile(_rt.."/Misc/Bindables/bindables.txt",table.concat(ls,"\n"))
	_lm("Bindables: "..cnt.." saved","success")
end

local _ir2=false

_rbn.MouseButton1Click:Connect(function()
	if _ir2 then return end
	if not writefile or not makefolder or not isfolder then _lm("executor missing writefile/makefolder/isfolder","error") return end
	_ir2=true _rbn.Text="running..." _rbn.BackgroundColor3=_c.sf2 _rbn.TextColor3=_c.tx2 _sl.Text="running"
	_es2={total=0,warn=0,err=0,nil_found=0,ui=0,scripts=0} _sp(5)
	task.spawn(function()
		_lm("vault started — game: ".._gn.." [".._sid.."]","info")
		_ef("Vault") _ef(_rt) _ef(_rt.."/UI") _ef(_rt.."/Scripts") _ef(_rt.."/Data") _ef(_rt.."/Misc")
		local sel={}
		for _,e in ipairs(_svs) do if _cfg[e.id] then table.insert(sel,e) end end
		local step=#sel>0 and (80/#sel) or 0 local prog=5
		for _,e in ipairs(_svs) do
			if _cfg[e.id] then
				prog=prog+step _sp(math.floor(prog)) task.wait(0.05)
				pcall(function()
					local svc=e.svc local snm=e.nm local hu,hs=false,false
					for _,c in ipairs(svc:GetDescendants()) do
						if c:IsA("GuiObject") or c:IsA("LayerCollector") then hu=true end
						if c:IsA("LocalScript") or c:IsA("ModuleScript") then hs=true end
						if hu and hs then break end
					end
					if hu then
						_ef(_rt.."/UI/"..snm)
						for _,c in ipairs(svc:GetChildren()) do
							if _ir(c) and not(c:IsA("LocalScript") or c:IsA("ModuleScript")) then
								_vc=0 local res=_sui(c,nil,0)
								if res~="" then
									writefile(_rt.."/UI/"..snm.."/"..(_sn(c.Name))..".lua","UI: "..c:GetFullName().."\n\n"..res)
									_es2.ui=_es2.ui+1 _lm("UI: "..c:GetFullName(),"success")
								end
							end
						end
					end
					if hs then _ef(_rt.."/Scripts/"..snm) _ssr(svc,_rt.."/Scripts/"..snm) end
					if _cfg.rem then _scr(svc,snm) end
				end)
			end
		end
		if _cfg.rem then pcall(_frf) end
		if _cfg.ws then pcall(_sw2) end
		if _cfg.pd then pcall(_spd) end
		if _cfg.li then pcall(_sli) end
		if _cfg.sn then pcall(_ssn) end
		if _cfg.an then pcall(_san) end
		if _cfg.bi then pcall(_sbi) end
		if _cfg.nil_ then
			_lm("nil scan — filters: ["..table.concat(_nf,", ").."]","nil")
			task.wait(0.05) pcall(_sni)
		end
		local sum={
			"Vault — Session Summary","-------------------------->",
			"Game:     ".._gn,"Session:  ".._sid,"Date:     "..os.date("%Y-%m-%d %H:%M:%S"),"",
			"Results:","  UI files:      ".._es2.ui,"  Scripts:       ".._es2.scripts,
			"  Nil instances: ".._es2.nil_found,"  Warnings:      ".._es2.warn,"  Errors:        ".._es2.err,"",
			"Folder Structure:","  Vault/","  └─ ".._gn.."_".._sid.."/",
			"     ├─ UI/","     │  └─ <service>/  *.lua","     ├─ Scripts/","     │  └─ <service>/  *.lua",
			"     ├─ Data/","     │  └─ PlayerData/  PlayerData.txt  PlayerData.json",
			"     ├─ Misc/","     │  ├─ Remotes/     remotes.txt",
			"     │  ├─ NilInstances/nil_instances.txt","     │  │  └─ <name>/<children>/  *.lua",
			"     │  ├─ Workspace/   workspace_map.txt","     │  ├─ Lighting/    lighting.txt",
			"     │  ├─ Sounds/      sounds.txt","     │  ├─ Animations/  animations.txt",
			"     │  └─ Bindables/   bindables.txt","     └─ README.txt",
		}
		writefile(_rt.."/README.txt",table.concat(sum,"\n"))
		_sp(100) task.wait(0.3)
		_lm("vault complete — >".._rt.."/","success")
		_sl.Text="done" _rbn.Text="run vault" _rbn.BackgroundColor3=_c.bb _rbn.TextColor3=_c.bt _ir2=false
		task.wait(3) _sp(0) _sl.Text="idle"
	end)
end)
