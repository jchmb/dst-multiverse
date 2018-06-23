require("stategraphs/commonstates")


local actionhandlers =
{
	ActionHandler(ACTIONS.ATTACK, "fireattack"),
}

local events=
{
	CommonHandlers.OnStep(),
	CommonHandlers.OnSleep(),
	CommonHandlers.OnLocomote(false,true),
	EventHandler("attacked", function(inst)
		if inst.components.health and not inst.components.health:IsDead() then
			inst.sg:GoToState("hit")
			inst.SoundEmitter:PlaySound(inst.sounds.hurt)
		end
	end),
	EventHandler("death", function(inst) inst.sg:GoToState("death") end),

	EventHandler("doattack", function(inst, data)
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
            inst.sg:GoToState("fireattack", data.target)
        end
    end),
}

local states=
{
	State{
		name = "idle",
		tags = {"idle", "canrotate"},

		onenter = function(inst, pushanim)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle_loop")
		end,

		timeline=
		{
			TimeEvent( 2*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(19*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			-- TimeEvent(22*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bounce) end),
			TimeEvent(27*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
   },


	State{
		name = "death",
		tags = {"busy"},

		onenter = function(inst)
			inst.components.container:Close()
			inst.components.container:DropEverything()
			inst.SoundEmitter:PlaySound(inst.sounds.death)
			inst.AnimState:PlayAnimation("death")
			inst.Physics:Stop()
			RemovePhysicsColliders(inst)
		end,

		timeline=
		{
			TimeEvent( 6*FRAMES, function(inst)
				if inst.PackimState == "FAT" then
					inst.SoundEmitter:PlaySound(inst.sounds.fat_death_spin)
				end
			end),
		},
	},


	State{
		name = "open",
		tags = {"busy", "open"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.components.sleeper:WakeUp()
			inst.AnimState:PlayAnimation("open")
		end,

		timeline=
		{
			TimeEvent( 0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.open) end),
			TimeEvent( 2*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("open_idle") end ),
		},
	},

	State{
		name = "open_idle",
		tags = {"busy", "open"},

		onenter = function(inst)
			inst.AnimState:PlayAnimation("idle_loop_open")

			if not inst.sg.mem.pant_ducking or inst.sg:InNewState() then
				inst.sg.mem.pant_ducking = 1
			end

		end,

		timeline=
		{
			TimeEvent( 3*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(19*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			-- TimeEvent(24*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bounce) end),
			TimeEvent(27*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("open_idle") end ),
		},
	},

	State{
		name = "close",
		tags = {""},

		onenter = function(inst)
			inst.AnimState:PlayAnimation("closed")
		end,

		events=
		{
			EventHandler("animover",
				function(inst)
					local packimstate = inst.PackimState
					if inst.tryeat(inst) then --Do I contain anything I want to eat?
						if packimstate == inst.PackimState then
							inst.sg:GoToState("swallow")
						else
							-- transforming
							inst.sg:GoToState("transform", true)
						end
					elseif inst.checkfiretransform(inst) then
						inst.sg:GoToState("transform", true)
					else


						inst.sg:GoToState("idle")
					end
				end ),
		},

		timeline=
		{
			TimeEvent( 0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.close) end),
			TimeEvent( 5*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		},
	},


	State{
		name = "swallow",
		tags = {"busy"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.components.sleeper:WakeUp()
			inst.AnimState:PlayAnimation("swallow")
		end,

		events=
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end ),
		},

		timeline=
		{
			TimeEvent( 0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.swallow) end),
			TimeEvent( 2*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			-- TimeEvent( 8*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bounce) end),
			TimeEvent( 9*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(28*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(36*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		},
	},

	State{
		name = "transform",
		tags = {"busy"},

		onenter = function(inst, swallowed)
			inst.Physics:Stop()
			inst.components.sleeper:WakeUp()
			if swallowed then
				inst.SoundEmitter:PlaySound(inst.sounds.swallow)
				inst.AnimState:PlayAnimation("swallow", false)
			else
				inst.sg:GoToState("transform_stage2")
			end
		end,

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("transform_stage2") end),
		},
	},

	State{
		name = "transform_stage2",
		tags = {"busy"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.components.sleeper:WakeUp()
			inst.AnimState:PlayAnimation("transform", false) -- 30 fr
			inst.AnimState:PushAnimation("transform_pst", false)
			inst.SoundEmitter:PlaySound(inst.sounds.transform)
			inst.SoundEmitter:PlaySound(inst.sounds.trasnform_stretch)
		end,

		events=
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
		},

		timeline =
		{
			TimeEvent(30*FRAMES, function(inst)
				if inst.PackimState == "NORMAL" then
					inst.AnimState:SetBuild("packim_build")
					-- local fx = SpawnPrefab("feathers_packim")
					-- fx.Transform:SetPosition(inst:GetPosition():Get())
				elseif inst.PackimState == "FAT" then
					inst.AnimState:SetBuild("packim_fat_build")
					-- local fx = SpawnPrefab("feathers_packim_fat")
					-- fx.Transform:SetPosition(inst:GetPosition():Get())
				elseif inst.PackimState == "FIRE" then
					inst.AnimState:SetBuild("packim_fire_build")
					-- local fx = SpawnPrefab("feathers_packim_fire")
					-- fx.Transform:SetPosition(inst:GetPosition():Get())
				end

				-- inst.SoundEmitter:PlaySound(inst.sounds.transform_pop)
			end)
		},

	},

	State{
		name = "fireattack",
		tags = {"attack", "busy", "canrotate", "throwing"},

		onenter = function(inst)
			if not inst.last_fire_time or (inst.fire_interval and (GetTime() - inst.last_fire_time) > inst.fire_interval) then
				if inst.components.locomotor then
					inst.components.locomotor:StopMoving()
				end
				inst.AnimState:PlayAnimation("fireball")
			else
				inst:ClearBufferedAction()
                inst.sg:GoToState("idle")
			end
		end,

		-- 751
		timeline =
		{
			TimeEvent( 2*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			-- TimeEvent( 3*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bounce) end),
			TimeEvent( 6*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(14*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(21*FRAMES, function(inst)
				inst.components.combat:DoAttack()
				inst.fire_interval = math.random(TUNING.PACKIM_FIRE_DELAY_MIN, TUNING.PACKIM_FIRE_DELAY_MAX)
                inst.last_fire_time = GetTime()
			end),
			TimeEvent(22*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(30*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			-- TimeEvent(31*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bounce) end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "hit",
		tags = {"busy"},

		onenter = function(inst)
			if inst.components.locomotor then
				inst.components.locomotor:StopMoving()
			end
			inst.AnimState:PlayAnimation("hit")
		end,

		timeline =
		{
			TimeEvent( 6*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},
}

CommonStates.AddWalkStates(states,
{
	starttimeline =
	{
		TimeEvent( 2*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
	},
	walktimeline =
	{
		TimeEvent( 0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bounce) end),
		TimeEvent( 3*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(18*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bounce) end),
		TimeEvent(19*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(27*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
	},
	endtimeline =
	{
		TimeEvent( 0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bounce) end),
		TimeEvent( 2*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent( 6*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
	},
})

CommonStates.AddSleepStates(states,
{
	starttimeline =
	{
		TimeEvent( 2*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(17*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(32*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
	},
	sleeptimeline =
	{
		TimeEvent( 1*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(13*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(29*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(45*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		-- TimeEvent(61*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(34*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.sleep) end),
	},
	waketimeline =
	{
		TimeEvent( 1*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(13*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(22*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bounce) end),
		TimeEvent(23*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(26*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(34*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
	},
})

return StateGraph("packim", states, events, "idle", actionhandlers)
