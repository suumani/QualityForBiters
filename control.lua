-- ------------------------------------------------------------
-- 責務:
--   QFB Mod のイベント境界を管理する。
--
--   - Mod 初期化時に DeterministicRandom を初期化する
--   - TargetFilter のキャッシュを構築する
--   - runtime mod setting 変更時にフィルタキャッシュを更新する
--   - マップ生成時の敵エンティティを Replacer に委譲する
--   - 新規スポーン敵エンティティを Replacer に委譲する
--
-- 設計方針:
--   本ファイルはイベント境界のみを担当し、
--   実際の処理ロジックは各サービスクラスに委譲する。
--
--   on_chunk_generated / on_entity_spawned は高頻度イベントのため
--   pcall 等の例外ラップは行わず、処理コストを最優先とする。
-- ------------------------------------------------------------
local Replacer = require("scripts.replacer")
local DRand = require("scripts.util.DeterministicRandom")
local TargetFilter = require("scripts.services.target_filter")

local function rebuild_filter_cache()
  TargetFilter.rebuild_cache()
end

script.on_init(function()
  DRand.init()
  rebuild_filter_cache()
end)

script.on_configuration_changed(function()
  DRand.init()
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