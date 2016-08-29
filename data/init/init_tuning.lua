local day_time = 60 * 8
local total_day_time = day_time
local wilson_attack = 34

TUNING.PALMTREE_GROW_TIME =
{
	{base=1.5*day_time, random=0.5*day_time},   --short
	{base=3*day_time, random=1*day_time},   --normal
	{base=3*day_time, random=1*day_time},   --tall
	{base=5*day_time, random=0.5*day_time},   --old
}

TUNING.PALMTREE_CHOPS_SMALL = 5
TUNING.PALMTREE_CHOPS_NORMAL = 10
TUNING.PALMTREE_CHOPS_TALL = 15

TUNING.PALMTREE_COCONUT_CHANCE = 0.1

TUNING.COCONUT_GROWTIME = {base=0.75*day_time, random=0.25*day_time}

TUNING.BAMBOO_HACKS = 6
TUNING.BAMBOO_REGROW_TIME = total_day_time*4
TUNING.BAMBOO_WINDBLOWN_SPEED = 0.2
TUNING.BAMBOO_WINDBLOWN_FALL_CHANCE = 0.1

TUNING.OBSIDIANTOOLFACTOR = 2.5
TUNING.OBSIDIANTOOL_WORK = 2.5

TUNING.MACHETE_DAMAGE = wilson_attack* .88
TUNING.MACHETE_USES = 100