-- __BiterShield2__/scripts/defines/qfb_catalog.lua
--[[
責務:
- 設定項目を生成するための「敵名カタログ」を提供する。
- 実行時フィルタの「対象名セット構築」もこのカタログを参照する。
- パターンは使わない。内部名を列挙する。
]]

local Catalog = {}

Catalog.packs = {
  default = {
    title = "Default",
    items = {
      { key = "biter",   label = "Biter",   names = { "small-biter", "medium-biter", "big-biter", "behemoth-biter" } },
      { key = "spitter", label = "Spitter", names = { "small-spitter", "medium-spitter", "big-spitter", "behemoth-spitter" } },
      { key = "worm",    label = "Worm",    names = { "small-worm-turret", "medium-worm-turret", "big-worm-turret", "behemoth-worm-turret" } },
      { key = "spawner", label = "Spawner", names = { "biter-spawner", "spitter-spawner" } },
    }
  },

  space_age = {
    title = "Space Age",
    items = {
      -- ここはあなたの列挙で埋める（例は空）
      { key = "wriggler", label = "Wriggler", names = { "small-wriggler-pentapod", "medium-wriggler-pentapod", "big-wriggler-pentapod"} },
      { key = "strafer",  label = "Strafer",  names = { "small-strafer-pentapod", "medium-strafer-pentapod", "big-strafer-pentapod"} },
      { key = "stomper",  label = "Stomper",  names = { "small-stomper-pentapod", "medium-stomper-pentapod", "big-stomper-pentapod"} },
      { key = "nest",     label = "Nest",     names = { "gleba-spawner-small", "gleba-spawner"} },
    }
  },

  Cold_biters = {
    title = "Cold_biters",
    mod_name = "Cold_biters", -- ある時だけ設定表示
    items = {
      {
        key = "cold-biter", label = "cold-biter", names = 
        {
          "small-cold-biter", "medium-cold-biter", "big-cold-biter", "behemoth-cold-biter", "leviathan-cold-biter" 
        }
      },

      {
        key = "boss-frost-biter", label = "boss-frost-biter", names = { 
          "maf-boss-frost-biter-1", "maf-boss-frost-biter-2", "maf-boss-frost-biter-3", "maf-boss-frost-biter-4", "maf-boss-frost-biter-5",
          "maf-boss-frost-biter-6", "maf-boss-frost-biter-7", "maf-boss-frost-biter-8", "maf-boss-frost-biter-9", "maf-boss-frost-biter-10",
        }
      },
      
      {
        key = "cold-spitter", label = "cold-spitter", names = 
        {
          "small-cold-spitter", "medium-cold-spitter", "big-cold-spitter", "behemoth-cold-spitter", "leviathan-cold-spitter" 
        }
      },

      {
        key = "boss-frost-spitter", label = "boss-frost-spitter", names = { 
          "maf-boss-frost-spitter-1", "maf-boss-frost-spitter-2", "maf-boss-frost-spitter-3", "maf-boss-frost-spitter-4", "maf-boss-frost-spitter-5",
          "maf-boss-frost-spitter-6", "maf-boss-frost-spitter-7", "maf-boss-frost-spitter-8", "maf-boss-frost-spitter-9", "maf-boss-frost-spitter-10",
        }
      },

      {
        key = "cold-worm", label = "cold-worm", names = 
        {
          "small-cold-worm-turret", "medium-cold-worm-turret", "big-cold-worm-turret", "behemoth-cold-worm-turret", "leviathan-cold-worm-turret", "mother-cold-worm-turret"
        }
      },
    }
  },

  Explosive_biters = {
    title = "Explosive_biters",
    mod_name = "Explosive_biters",
    items = {
      {
        key = "explosive-biter", label = "explosive-biter", names = 
        {
          "small-explosive-biter", "medium-explosive-biter", "big-explosive-biter", "behemoth-explosive-biter", "leviathan-explosive-biter" 
        }
      },

      {
        key = "boss-explosive-biter", label = "boss-explosive-biter", names = { 
          "maf-boss-explosive-biter-1", "maf-boss-explosive-biter-2", "maf-boss-explosive-biter-3", "maf-boss-explosive-biter-4", "maf-boss-explosive-biter-5",
          "maf-boss-explosive-biter-6", "maf-boss-explosive-biter-7", "maf-boss-explosive-biter-8", "maf-boss-explosive-biter-9", "maf-boss-explosive-biter-10",
        }
      },
      
      {
        key = "explosive-spitter", label = "explosive-spitter", names = 
        {
          "small-explosive-spitter", "medium-explosive-spitter", "big-explosive-spitter", "behemoth-explosive-spitter", "leviathan-explosive-spitter" 
        }
      },

      {
        key = "boss-explosive-spitter", label = "boss-explosive-spitter", names = { 
          "maf-boss-explosive-spitter-1", "maf-boss-explosive-spitter-2", "maf-boss-explosive-spitter-3", "maf-boss-explosive-spitter-4", "maf-boss-explosive-spitter-5",
          "maf-boss-explosive-spitter-6", "maf-boss-explosive-spitter-7", "maf-boss-explosive-spitter-8", "maf-boss-explosive-spitter-9", "maf-boss-explosive-spitter-10",
        }
      },

      {
        key = "explosive-worm", label = "explosive-worm", names = 
        {
          "small-explosive-worm-turret", "medium-explosive-worm-turret", "big-explosive-worm-turret", "behemoth-explosive-worm-turret", "leviathan-explosive-worm-turret", "mother-explosive-worm-turret"
        }
      },
    }
  },

  Toxic_biters = {
    title = "Toxic_biters",
    mod_name = "Toxic_biters",
    items = {
      {
        key = "toxic-biter", label = "toxic-biter", names = 
        {
          "small-toxic-biter", "medium-toxic-biter", "big-toxic-biter", "behemoth-toxic-biter", "leviathan-toxic-biter" 
        }
      },

      {
        key = "boss-toxic-biter", label = "boss-toxic-biter", names = { 
          "maf-boss-toxic-biter-1", "maf-boss-toxic-biter-2", "maf-boss-toxic-biter-3", "maf-boss-toxic-biter-4", "maf-boss-toxic-biter-5",
          "maf-boss-toxic-biter-6", "maf-boss-toxic-biter-7", "maf-boss-toxic-biter-8", "maf-boss-toxic-biter-9", "maf-boss-toxic-biter-10",
        }
      },
      
      {
        key = "toxic-spitter", label = "toxic-spitter", names = 
        {
          "small-toxic-spitter", "medium-toxic-spitter", "big-toxic-spitter", "behemoth-toxic-spitter", "leviathan-toxic-spitter" 
        }
      },

      {
        key = "boss-toxic-spitter", label = "boss-toxic-spitter", names = { 
          "maf-boss-toxic-spitter-1", "maf-boss-toxic-spitter-2", "maf-boss-toxic-spitter-3", "maf-boss-toxic-spitter-4", "maf-boss-toxic-spitter-5",
          "maf-boss-toxic-spitter-6", "maf-boss-toxic-spitter-7", "maf-boss-toxic-spitter-8", "maf-boss-toxic-spitter-9", "maf-boss-toxic-spitter-10",
        }
      },

      {
        key = "toxic-worm", label = "toxic-worm", names = 
        {
          "small-toxic-worm-turret", "medium-toxic-worm-turret", "big-toxic-worm-turret", "behemoth-toxic-worm-turret", "leviathan-toxic-worm-turret", "mother-toxic-worm-turret"
        }
      },
    }
  },

  ArmouredBiters = {
    title = "ArmouredBiters",
    mod_name = "ArmouredBiters",
    items = {
      { 
        key = "armoured-biter", label = "armoured-biter", names = 
        {
          "small-armoured-biter", "medium-armoured-biter", "big-armoured-biter", "behemoth-armoured-biter", "leviathan-armoured-biter"
        } 
      },

    }
  },

  ["Big-Monsters"] = {
    title = "Big-Monsters",
    mod_name = "Big-Monsters",
    items = {
      { key = "giant-fire-spitter", label = "giant spitter", names = {
        "maf-giant-fire-spitter1", "maf-giant-fire-spitter2", "maf-giant-fire-spitter3", "maf-giant-fire-spitter4", "maf-giant-fire-spitter5",
        "maf-giant-acid-spitter1", "maf-giant-acid-spitter2", "maf-giant-acid-spitter3", "maf-giant-acid-spitter4", "maf-giant-acid-spitter5", } },
      { key = "giant-biter", label = "giant biter", names = { 
        "biterzilla11", "biterzilla12", "biterzilla13", "biterzilla14", "biterzilla15", 
        "biterzilla21", "biterzilla22", "biterzilla23", "biterzilla24", "biterzilla25", 
        "biterzilla31", "biterzilla32", "biterzilla33", "biterzilla34", "biterzilla35", 
        "bm-motherbiterzilla1", "bm-motherbiterzilla2", "bm-motherbiterzilla3", "bm-motherbiterzilla4", "bm-motherbiterzilla5", 
      } },
      { key = "bm-spidertron", label = "spidertron", names = { 
        "bm-spidertron_1","bm-spidertron_2","bm-spidertron_3","bm-spidertron_4","bm-spidertron_5",
      } },
    }
  },
}

return Catalog