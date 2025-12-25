local Replacer = require("scripts.replacer")

script.on_init(function()
end)

-- マップ生成時の巣とワームを置換
script.on_event(defines.events.on_chunk_generated, function(event)
  Replacer.on_chunk_generated(event)
end)

-- 新規スポーンイベントにて
script.on_event(defines.events.on_entity_spawned, function(event)
  Replacer.on_entity_spawned(event)
end)