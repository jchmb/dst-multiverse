require("stategraphs/commonstates")

local function SpawnMoveFx(inst, offset)
	local pos = inst:GetPosition()
	local angle = inst.Transform:GetRotation()*DEGREES
	local vec = Vector3(math.cos(angle), 0, -math.sin(angle))
	local perp = Vector3(-vec.z, 0, vec.x)
	local scale = 0.4

	local rand_offset = Vector3(math.random(-1, 1) * 0.2, 0, math.random(-1, 1) * 0.2)

	-- TODO
	-- SpawnPrefab("dragoon_charge_fx").Transform:SetPosition((pos + (perp * offset * scale) + rand_offset):Get())
end

local function SpawnFireFx(inst)
	local pos = inst:GetPosition()
	local rand_offset = Vector3(math.random(-1, 1) * 0.2, 0, math.random(-1, 1) * 0.2)
	SpawnPrefab("dragoonfire").Transform:SetPosition((pos + rand_offset):Get())
end


local actionhandlers =
{
	ActionHandler(ACTIONS.EAT, "eat"),
	-- ActionHandler(ACTIONS.LAVASPIT, "spit"), TODO
	ActionHandler(ACTIONS.GOHOME, "gohome"),
}

local events=
{
	EventHandler("attacked",
		function(inst)
			if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then
				inst.sg:GoToState("hit")
			end
		end),

	EventHandler("death",
		function(inst)
			inst.sg:GoToState("death")
		end),

	EventHandler("doattack",
		function(inst, data)
			if not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
				inst.sg:GoToState("attack", data.target)
			end
		end),

	EventHandler("locomote",
		function(inst)
			if not inst.sg:HasStateTag("idle") and not inst.sg:HasStateTag("moving") then return end

			if not inst.components.locomotor:WantsToMoveForward() then
				if not inst.sg:HasStateTag("idle") then
					inst.sg:GoToState("idle")
				end
			elseif inst.components.locomotor:WantsToRun() then
				if not inst.sg:HasStateTag("running") then
					inst.sg:GoToState("charge_pre")
				end
			else
				if not inst.sg:HasStateTag("walking") then
					inst.sg:GoToState("walk")
				end
			end
		end),

	CommonHandlers.OnSleep(),
	CommonHandlers.OnFreeze(),
}

local states=
{

	State{
		name = "idle",
		tags = {"idle", "canrotate"},
		onenter = function(inst, playanim)
			-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/dragoon/idle")
			inst.Physics:Stop()
			if playanim then
				inst.AnimState:PlayAnimation(playanim)
				inst.AnimState:PushAnimation("idle_loop", true)
			else
				inst.AnimState:PlayAnimation("idle_loop", true)
			end
			inst.sg:SetTimeout(2*math.random()+.5)
		end,

	},


	State{
		name = "attack",
		tags = {"attack", "busy"},

		onenter = function(inst, target)
			inst.sg.statemem.target = target
			inst.Physics:Stop()
			inst.components.combat:StartAttack()
			inst.AnimState:PlayAnimation("atk")
			-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/dragoon/attack")
		end,

		timeline=
		{

			--.inst:ForceFacePoint(self.target:GetPosition())

			TimeEvent(8*FRAMES, function(inst)
				if inst.components.combat.target then
					inst:ForceFacePoint(inst.components.combat.target:GetPosition())
				end
			end),

			TimeEvent(15*FRAMES, function(inst)
				inst.components.combat:DoAttack(inst.sg.statemem.target)
				if inst.components.combat.target then
					inst:ForceFacePoint(inst.components.combat.target:GetPosition())
				end
				-- TODO: -- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/dragoon/attack_strike")
			end),

			TimeEvent(20*FRAMES, function(inst)
				if inst.components.combat.target then
					inst:ForceFacePoint(inst.components.combat.target:GetPosition())
				end
			end),

			TimeEvent(27*FRAMES, function(inst)
				if inst.components.combat.target then
					inst:ForceFacePoint(inst.components.combat.target:GetPosition())
				end
			end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "spit",
		tags = {"busy"},

		onenter = function(inst)
			-- print("snake spit")
			if ((inst.target ~= inst and not inst.target:HasTag("fire")) or inst.target == inst) and not (inst.recently_frozen) then
				if inst.components.locomotor then
					inst.components.locomotor:StopMoving()
				end
				inst.AnimState:PlayAnimation("spit")
				-- inst.vomitfx = SpawnPrefab("vomitfire_fx")
				-- inst.vomitfx.Transform:SetPosition(inst.Transform:GetWorldPosition())
				-- inst.vomitfx.Transform:SetRotation(inst.Transform:GetRotation())

				-- TODO
				-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/dragoon/hork")
			else
				-- print("no spit")
				inst:ClearBufferedAction()
				inst.sg:GoToState("idle")
			end
		end,

		onexit = function(inst)
			-- print("spit onexit")
			if inst.last_target and inst.last_target ~= inst then
				inst.num_targets_vomited = inst.last_target.components.stackable and inst.num_targets_vomited + inst.last_target.components.stackable:StackSize() or inst.num_targets_vomited + 1
				inst.last_target_spit_time = GetTime()
			end
			--inst.Transform:SetFourFaced()
			if inst.vomitfx then
				inst.vomitfx:Remove()
			end
			inst.vomitfx = nil
		end,

		events=
		{
			EventHandler("animqueueover", function(inst)
				-- print("spit animqueueover")
				inst.sg:GoToState("idle")
			end),
		},

		timeline=
		{
			TimeEvent(37*FRAMES, function(inst)
				-- print("spit timeline")
				-- print("vomitfire_fx spawned")
				-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/dragoon/spit")
				inst:PerformBufferedAction()
				inst.last_target = inst.target
				inst.target = nil
				inst.spit_interval = math.random(20,30)
				inst.last_spit_time = GetTime()
			end),

			TimeEvent(39*FRAMES, function(inst)
				-- print("spit timeline")
				-- print("vomitfire_fx spawned")
				-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/dragoon/fireball")
			end),
		},
	},

	State{
		name = "hit",
		tags = {"busy", "hit"},

		onenter = function(inst, cb)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("hit")
			-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/dragoon/hit")
		end,

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	-- State{
	-- 	name = "taunt",
	-- 	tags = {"busy"},

	-- 	onenter = function(inst, cb)
	-- 		inst.Physics:Stop()
	-- 		inst.AnimState:PlayAnimation("taunt")
	-- 		-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/dragoon/taunt")
	-- 	end,

	-- 	events=
	-- 	{
	-- 		EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
	-- 	},
	-- },

	State{
		name = "death",
		tags = {"busy"},

		onenter = function(inst)
			-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/dragoon/death")
			inst.AnimState:PlayAnimation("death")
			inst.Physics:Stop()
			RemovePhysicsColliders(inst)
			inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
		end,

	},

	State{
		name = "walk",
		tags = {"moving", "canrotate", "walking"},

		onenter = function(inst)
			inst.AnimState:PlayAnimation("walk_pre")
			inst.AnimState:PushAnimation("walk_loop", true)
			inst.components.locomotor:WalkForward()
			--inst.sg:SetTimeout(2*math.random()+.5)
		end,

		onupdate= function(inst)
			if not inst.components.locomotor:WantsToMoveForward() then
				inst.sg:GoToState("idle", "walk_pst")
			end
		end,

		timeline = {
			--TimeEvent(0, function(inst) -- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/snake/taunt") end),
			TimeEvent(0*FRAMES, PlayFootstep ),
			TimeEvent(4*FRAMES, PlayFootstep ),
		},
	},

	State{
		name = "charge_pre",
		tags = {"canrotate", "busy"},

		onenter = function(inst)
			inst.Physics:Stop()

			inst.AnimState:PlayAnimation("charge_pre")
			--inst.sg:SetTimeout(2*math.random()+.5)
		end,

		onupdate= function(inst)
			if not inst.components.locomotor:WantsToMoveForward() then
				inst.sg:GoToState("idle", "charge_pst")
			end
		end,

		events = {
            EventHandler("animover", function(inst)
            	inst:DoTaskInTime(1, function(inst)
            		if inst.sg:HasStateTag("charging") then
            			inst.sg:GoToState("idle", "charge_pst")
            		end
            	end)
            	inst.sg:GoToState("charge")
            end),
        }
	},

	State{
		name = "charge",
		tags = {"moving", "running", "charging"},

		onenter = function(inst)
			inst.AnimState:PlayAnimation("charge_loop")
			inst.components.locomotor:RunForward()

			-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/dragoon/charge")

			inst.sg.statemem.fire_timer = 5*FRAMES
			inst.sg.statemem.fire_time = 5*FRAMES

			inst.sg.statemem.move_timer = 2*FRAMES
			inst.sg.statemem.move_time = 2*FRAMES

			inst.sg.statemem.offset = 1
		end,

		onupdate= function(inst, dt)
			inst.sg.statemem.move_timer = inst.sg.statemem.move_timer - dt
			inst.sg.statemem.fire_timer = inst.sg.statemem.fire_timer - dt

			if inst.sg.statemem.move_timer <= 0 then
				inst.sg.statemem.move_timer = inst.sg.statemem.move_time
				SpawnMoveFx(inst, inst.sg.statemem.offset)
				inst.sg.statemem.offset = inst.sg.statemem.offset * -1
			end

			if inst.sg.statemem.fire_timer <= 0 then
				inst.sg.statemem.fire_timer = inst.sg.statemem.fire_time
				SpawnFireFx(inst)
			end

			if not inst.components.locomotor:WantsToMoveForward() then
				inst.sg:GoToState("idle", "charge_pst")
			end
		end,

		timeline =
		{
			-- TimeEvent(0*FRAMES, SpawnMoveFx),
			-- TimeEvent(4*FRAMES, SpawnMoveFx),
			-- TimeEvent(8*FRAMES, SpawnMoveFx),
		},

		events = {
            EventHandler("animover", function(inst) inst.sg:GoToState("charge") end),
        }
	},
}

CommonStates.AddSleepStates(states,
{
	sleeptimeline = {
		TimeEvent(
			30*FRAMES,
			function(inst)
				-- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/dragoon/sleep")
			end
		),
	},
})

CommonStates.AddFrozenStates(states)

CommonStates.AddSimpleActionState(states, "gohome", "hit", 1*FRAMES, {"busy"})

return StateGraph("dragoon", states, events, "idle", actionhandlers)
