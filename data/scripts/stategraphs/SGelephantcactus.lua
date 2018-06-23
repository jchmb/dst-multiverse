require("stategraphs/commonstates")

local events=
{
	EventHandler("death", function(inst) inst.sg:GoToState("death") end),
	EventHandler("doattack", function(inst)
		if not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
			inst.sg:GoToState("attack_pre")
		end
	end),

	-- CommonHandlers.OnDeath(),

	EventHandler("attacked", function(inst)
		if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then
			inst.sg:GoToState("hit")
		end
	end),

	EventHandler("growspike", function(inst)
		if not inst.components.health:IsDead() then
			inst.sg:GoToState("grow_spike")
		end
	end)
}

local states=
{
	State{
		name = "idle",
		tags = {"idle", "canrotate"},
		onenter = function(inst)
			if inst.has_spike then
				inst.AnimState:PlayAnimation("idle_spike")
			else
				inst.AnimState:PlayAnimation("idle")
			end
		end,
		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "death",
		tags = {"busy"},

		onenter = function(inst)
			inst.AnimState:PlayAnimation("death")
			-- inst.AnimState:PushAnimation("idle_dead")
			inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
		end,

		timeline =
		{
			TimeEvent(0*FRAMES, function(inst) --inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/volcano_cactus/death")
			end),
		},

		events=
		{
			EventHandler("animover", function(inst)
				local active = SpawnPrefab("elephantcactus_stump")
				if active then
					active.Transform:SetPosition(inst.Transform:GetWorldPosition())
					inst:Remove()
				end
			end),
		},
	},

	State{
		name = "hit",
		tags = {"hit"},

		onenter = function(inst)
			if inst.AnimState:IsCurrentAnimation("idle_spike") then
				inst.AnimState:PlayAnimation("hit_spike")
			else
				inst.AnimState:PlayAnimation("hit")
			end
		end,

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State
	{
		name = "attack_pre",
		tags = {"attack", "canrotate"},
		onenter = function(inst)
			inst.AnimState:PlayAnimation("attack_pre")
		end,

		timeline =
		{
			TimeEvent(8*FRAMES, function(inst)
				-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/volcano_cactus/attack_pre")
			end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("attack") end),
		},
	},

	State
	{
		name = "attack",
		tags = {"attack", "canrotate"},

		onenter = function(inst)
			inst.AnimState:PlayAnimation("attack")
			-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/volcano_cactus/attack")
		end,

		timeline=
		{
			TimeEvent(2*FRAMES, function(inst)
				if inst.components.combat then
					inst.components.combat:StartAttack()
					inst.components.combat:DoAttack()
					inst.has_spike = false
					inst.components.timer:StartTimer("SPIKE", TUNING.ELEPHANTCACTUS_REGROW_PERIOD)
				end
			end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State
	{
		name = "grow_spike",
		tags = {"busy"},
		onenter = function(inst)
			inst.AnimState:PlayAnimation("grow_spike")
		end,

		timeline =
		{
			-- TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/volcano_cactus/grow_pre") end),
			-- TimeEvent(28*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/volcano_cactus/grow_spike") end),
		},

		events=
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},

	State
	{
		name = "dead_to_empty",
		tags = {"busy"},
		onenter = function(inst)
			-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/volcano_cactus/dead_to_empty")
			inst.AnimState:PlayAnimation("dead_to_empty")
		end,

		events=
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("grow_spike")
			end),
		},
	},
}

return StateGraph("elephantcactus", states, events, "idle")
