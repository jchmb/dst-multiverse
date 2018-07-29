require("stategraphs/commonstates")

local actionhandlers = {}

local events = 
{
	-- EventHandler("lightningstrike", function(inst) 
	--     if not inst.EggHatched then
	--         inst.sg:GoToState("crack")
	--     end
	-- end),
}

local function ReleaseDoydoy(inst)
	print("ReleaseDoydoy")
	local doydoy = SpawnPrefab("doydoy")
	doydoy.Transform:SetPosition(inst:GetPosition():Get())
	doydoy.sg:GoToState("hatch")
	inst.components.herd:AddMember(doydoy)
end

local function Hatch(inst)
	print("Hatch")
	inst.EggHatched = true
	inst:DoTaskInTime(0.1, ReleaseDoydoy)
end

local states =
{   
	State{
		name = "land",
		tags = {"busy", "egg"},

		onenter = function(inst)
			inst.AnimState:PlayAnimation("lay")
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/egg_bounce")
		end,

		timeline = {},

		events = {
			EventHandler("animover", function(inst) inst.sg:GoToState("idle_full") end)
		},
	},

	State{  
		name = "idle_full",
		tags = {"idle", "egg"},
		
		onenter = function(inst)
			local function doeffect(inst)
				local fx = SpawnPrefab("moose_nest_fx")
				fx.entity:SetParent(inst.entity)
				fx.Transform:SetPosition(0,0.1,0)
				if inst.fx_task then
					inst.fx_task:Cancel()
					inst.fx_task = nil
				end
				inst.fx_task = inst:DoTaskInTime(math.random() * 10, doeffect)
			end
			doeffect(inst)
			if not inst.components.workable then
				inst:MakeWorkable(true)
			end

			inst.AnimState:PlayAnimation("idle")
		end,

		onexit = function(inst)
			if inst.fx_task then
				inst.fx_task:Cancel()
				inst.fx_task = nil
			end

		end,   
	},

	State{        
		name = "idle_empty",
		tags = {"idle"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("nest")
			inst:MakeWorkable(false)        
		end,        
	},

	State{
		name = "hit",
		tags = {"busy", "egg"},

		onenter = function(inst)
			inst.AnimState:PlayAnimation("hit")
			local fx = SpawnPrefab("moose_nest_fx")
			fx.entity:SetParent(inst.entity)
			fx.Transform:SetPosition(0,0.1,0)
			fx.AnimState:PlayAnimation("hit")
		end,

		events = {
			EventHandler("animover", function(inst) inst.sg:GoToState("idle_full") end)
		},
	},

	State{
		name = "crack",
		tags = {"busy", "egg"},

		onenter = function(inst)
			inst.AnimState:PlayAnimation("crack")
		end,

		timeline = 
		{
			TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/egg_crack") end)
		},

		events = {
			EventHandler("animover", function(inst) inst.sg:GoToState("hatch") end)
		},
	},

	State{
		name = "hatch",
		tags = {"busy", "egg"},

		onenter = function(inst)
			inst.AnimState:PlayAnimation("hatch")
		end,

		timeline = 
		{
			TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/egg_bounce") end),
			TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/egg_bounce") end),
			TimeEvent(50*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/egg_bounce") end),
			TimeEvent(60*FRAMES, function(inst) 
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/egg_burst") 
			end),
			TimeEvent(60*FRAMES, function(inst) Hatch(inst) end)
		},

		events = {
			EventHandler("animover", function(inst) inst.sg:GoToState("idle_empty") end)
		},
	},
}
	
return StateGraph("doydoyegg", states, events, "land", actionhandlers)
