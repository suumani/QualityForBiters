-- control.lua
local Replacer = require("scripts.replacer")
local DRand = require("scripts.util.DeterministicRandom")
local TargetFilter = require("scripts.services.target_filter")

local function rebuild_filter_cache()
  TargetFilter.rebuild_cache()
end

script.on_init(function()
  DRand.init(1025025)
  rebuild_filter_cache()
end)

script.on_configuration_changed(function()
  DRand.init(1025025)
  rebuild_filter_cache()
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(e)
  if e and e.setting and string.sub(e.setting, 1, 4) == "qfb-" then
    rebuild_filter_cache()
  end
end)

-- マップ生成時の巣とワームを置換
script.on_event(defines.events.on_chunk_generated, function(event)
  Replacer.on_chunk_generated(event)
end)

-- 新規スポーンイベントにて
script.on_event(defines.events.on_entity_spawned, function(event)
  Replacer.on_entity_spawned(event)
end)