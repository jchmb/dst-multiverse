local Trader = TraderManager("TRADING_BUNNYMAN")

Trader:Add(
    "carrot",
    {
        coin1 = 5,
    },
	"Buy 10 Carrots.",
    "images/inventoryimages.xml",
    "carrot.tex",
    10,
    true,
    true
)

Trader:Add(
    "pufftree_nut",
    {
        coin1 = 1,
    },
	"Buy 1 Puff Nut.",
    "images/inventoryimages/pufftree_nut.xml",
    "pufftree_nut.tex",
    1,
    true,
    true
)

Trader:Add(
    "wheat",
    {
        coin1 = 3,
    },
	"Buy 5 Wheat.",
    "images/inventoryimages.xml",
    "quagmire_wheat.tex",
    5,
    true,
    true
)

Trader:Add(
    "bunnyhat",
    {
        coin1 = 5,
    },
	"Pretend that you are a bunny!",
    "images/inventoryimages/bunnyhat.xml",
    "bunnyhat.tex",
    1,
    true,
    true
)
