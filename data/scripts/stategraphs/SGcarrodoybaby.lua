require("stategraphs/commonstates")

local actionhandlers = 
{
	ActionHandler(ACTIONS.EAT, "eat_loop"),
	ActionHandler(ACTIONS.PICKUP, "action"),
	ActionHandler(ACTIONS.HARVEST, "action"),
	ActionHandler(ACTIONS.PICK, "action"),
}

local events=
{
	CommonHandlers.OnSleep(),
	CommonHandlers.OnFreeze(),
	CommonHandlers.OnAttacked(),
	CommonHandlers.OnDeath(),
	CommonHandlers.OnLocomote(false,true),
}

local function ShouldStopSpin(inst)
	return inst:GetDistanceSqToInst(GetPlayer()) > 100 or math.random() > 0.9
end

local function LightningStrike(inst)
	local rad = math.random(0,3)
	local angle = math.random() * 2 * PI
	local offset = Vector3(rad * math.cos(angle), 0, -rad * math.sin(angle))

	local pos = inst:GetPosition() + offset

	GetWorld().components.seasonmanager:DoLightningStrike(pos)

	GetSeasonManager():StartPrecip()
end

local states=
{   

	State{
		
		name = "idle",
		tags = {"idle", "canrotate"},
		onenter = function(inst, playanim)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle")
			if inst.sounds.idle then
				inst.SoundEmitter:PlaySound(inst.sounds.idle)
			end
		end,        
	  
		events=
		{
			EventHandler("animover", function(inst) 
				inst.sg:GoToState("idle") 
			end),
		},
	},

	State{
		name = "action",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("eat", false)
			inst.sg:SetTimeout(math.random()*2+1)
		end,
		
		timeline=
		{
			-- TimeEvent(7*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/eat") end),
			
			TimeEvent(10*FRAMES, function(inst)
				inst:PerformBufferedAction()
				inst.sg:RemoveStateTag("busy")
				inst.brain:ForceUpdate()
				inst.sg:AddStateTag("wantstoeat")
			end),
		},

		events =
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end)
		},

		ontimeout = function(inst)
			inst.sg:GoToState("idle") 
		end,
	},

	State{
		name = "eat_loop",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("eat", false)
		end,

		events =
		{
			EventHandler("animqueueover", function(inst) 
				inst:PerformBufferedAction()  
				inst.sg:GoToState("idle") 
			end)
		},

		timeline = 
		{
			TimeEvent( 1*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.eat_pre) end),
			TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.swallow) end),
		},
	},

	State{
		name = "hatch",
		tags = {"busy"},
		
		onenter = function(inst)
			local angle = math.random()*2*PI
			local speed = GetRandomWithVariance(3, 2)
			inst.Physics:SetMotorVel(speed*math.cos(angle), 0, speed*math.sin(angle))
			inst.AnimState:PlayAnimation("hatch")
			inst.SoundEmitter:PlaySound(inst.sounds.hatch)

		end,

		timeline =
		{
			TimeEvent(20*FRAMES, function(inst) inst.Physics:SetMotorVel(0,0,0) end),
		},
		
		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},
}

CommonStates.AddFrozenStates(states)
CommonStates.AddWalkStates(states, {
	walktimeline = 
	{ 
		TimeEvent(0*FRAMES, function(inst) 
			if inst:HasTag("baby") then
				-- PlayFootstep(inst)
				-- inst.components.locomotor:WalkForward()
			end
		end),
		TimeEvent(1*FRAMES, function(inst)
			if inst:HasTag("baby") then
				-- inst.components.locomotor:RunForward()
				inst.SoundEmitter:PlaySound(inst.sounds.jump)
			end
		end),
	}
}, nil, true)
CommonStates.AddCombatStates(states,
{
	attacktimeline = 
	{
		TimeEvent(20*FRAMES, function(inst)
			inst.components.combat:DoAttack(inst.sg.statemem.target, nil, nil, "electric")
		end),
		-- TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/attack") end),
		TimeEvent(22*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
	},

	deathtimeline = 
	{
		TimeEvent(FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.death) end)
	},
})
CommonStates.AddSleepStates(states, 
{
	starttimeline =
	{
		-- TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/yawn") end)
	},
	sleeptimeline = 
	{
		-- TimeEvent(25*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/sleep") end)
	},
	waketimeline =
	{
		-- TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/hatch") end)
	}
})
	
return StateGraph("doydoybaby", states, events, "idle", actionhandlers)

