require("stategraphs/commonstates")

local actionhandlers =
{
	ActionHandler(ACTIONS.GOHOME, "gohome"),
}


local events=
{
	CommonHandlers.OnStep(),
	CommonHandlers.OnLocomote(true,true),
	CommonHandlers.OnSleep(),
	CommonHandlers.OnFreeze(),
	-- CommonHandlers.OnAttack(),
	-- CommonHandlers.OnAttacked(true),
	-- CommonHandlers.OnDeath(),
	-- EventHandler("doaction",
	-- 	function(inst, data)
	-- 		if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
	-- 			if data.action == ACTIONS.CHOP then
	-- 				inst.sg:GoToState("chop", data.target)
	-- 			end
	-- 		end
	-- 	end),

}

local states=
{
	State{
		name= "idle",
		tags = {"idle"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle_loop", true)
		end,

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
		},
	},
	State{
		name = "talk",
		tags = {"talk"},

		onenter = function(inst)
			inst.Physics:Stop()
			local number = math.random(2)
			inst.AnimState:PlayAnimation("talk" .. tostring(number))
			inst.talked = true
			inst:DoTaskInTime(10, function() inst.talked = false end)
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
		}
	},
	State{
		name= "invisibleaction",	-- Placeholder for when we learn how to work with Spriter
		tags = {"busy"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle_loop")
		end,

		timeline=
		{

			TimeEvent(7*FRAMES, function(inst) inst:PerformBufferedAction() end ),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
		},
	},
	State {
		name = "frozen",
		tags = {"busy"},

		onenter = function(inst)
			inst.AnimState:PlayAnimation("frozen")
			inst.Physics:Stop()
		end,
	},

	State{
		name = "death",
		tags = {"busy"},

		onenter = function(inst)
			--inst.SoundEmitter:PlaySound("dontstarve/pig/grunt")
			inst.AnimState:PlayAnimation("death")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/death")
			inst.Physics:Stop()
			RemovePhysicsColliders(inst)
			inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
		end,

	},

	State{
		name = "abandon",
		tags = {"busy"},

		onenter = function(inst, leader)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle")
			inst:FacePoint(Vector3(leader.Transform:GetWorldPosition()))
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
		},
	},

	State{
		name = "attack",
		tags = {"attack", "busy"},

		onenter = function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/eat_beaver")
			--inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
			inst.components.combat:StartAttack()
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("atk")
		end,

		timeline=
		{
			TimeEvent(13*FRAMES, function(inst)
				inst.components.combat:DoAttack()
				--inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/attack")
				inst.sg:RemoveStateTag("attack")
				inst.sg:RemoveStateTag("busy")
			end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "chop",
		tags = {"chopping"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("atk")
			--inst.AnimState:PushAnimation("atk", false)
			inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
		end,

		timeline=
		{

			TimeEvent(7*FRAMES, function(inst) inst:PerformBufferedAction() end ),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "eat",
		tags = {"busy"},

		onenter = function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/eat_beaver")
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("eat")
		end,

		timeline=
		{
			TimeEvent(10*FRAMES, function(inst) inst:PerformBufferedAction() end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
		},
	},
	State{
		name = "hit",
		tags = {"busy"},

		onenter = function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/hurt")
			inst.AnimState:PlayAnimation("hit")
			inst.Physics:Stop()
		end,

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
		},
	},
}

CommonStates.AddWalkStates(states,
{
	walktimeline = {
		TimeEvent(0*FRAMES, PlayFootstep ),
		TimeEvent(12*FRAMES, PlayFootstep ),
	},
},
{
	startwalk = "walk_pre",
	walk = "walk_loop",
	stopwalk = "walk_pst",
})
CommonStates.AddRunStates(states,
{
	runtimeline = {
		TimeEvent(0*FRAMES, PlayFootstep ),
		TimeEvent(10*FRAMES, PlayFootstep ),
	},
},
{
	startwalk = "run_pre",
	walk = "run_loop",
	stopwalk = "run_pst",
})

local function idleonanimover(inst)
    if inst.AnimState:AnimDone() then
        inst.sg:GoToState("idle")
    end
end

local function sleeponanimover(inst)
    if inst.AnimState:AnimDone() then
        inst.sg:GoToState("sleeping")
    end
end

local function onwakeup(inst)
    inst.sg:GoToState("wake")
end

local function onentersleeping(inst)
    inst.AnimState:PlayAnimation("sleep_loop")
end

table.insert(states, State
    {
        name = "sleep",
        tags = { "busy", "sleeping" },

        onenter = function(inst)
            if inst.components.locomotor ~= nil then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("dozy")
            -- if fns ~= nil and fns.onsleep ~= nil then
            --     fns.onsleep(inst)
            -- end
        end,

        timeline = nil,

        events =
        {
            EventHandler("animover", sleeponanimover),
            EventHandler("onwakeup", onwakeup),
        },
    })

    table.insert(states, State
    {
        name = "sleeping",
        tags = { "busy", "sleeping" },

        onenter = onentersleeping,

        timeline = nil,

        events =
        {
            EventHandler("animover", sleeponanimover),
            EventHandler("onwakeup", onwakeup),
        },
    })

    table.insert(states, State
    {
        name = "wake",
        tags = { "busy", "waking" },

        onenter = function(inst)
            if inst.components.locomotor ~= nil then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("wakeup")
            if inst.components.sleeper ~= nil and inst.components.sleeper:IsAsleep() then
                inst.components.sleeper:WakeUp()
            end
            -- if fns ~= nil and fns.onwake ~= nil then
            --     fns.onwake(inst)
            -- end
        end,

        timeline = nil,

        events =
        {
            EventHandler("animover", idleonanimover),
        },
    })

CommonStates.AddIdle(states, "funnyidle")
CommonStates.AddFrozenStates(states)

CommonStates.AddSimpleActionState(states,"pickup", "pig_pickup", 10*FRAMES, {"busy"})

CommonStates.AddSimpleActionState(states, "gohome", "pig_pickup", 4*FRAMES, {"busy"})


return StateGraph("bumsy", states, events, "idle", actionhandlers)
