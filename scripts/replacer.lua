local QualityRoller = require("__Manis_lib__/scripts/rollers/QualityRoller")
local DRand = require("scripts.util.DeterministicRandom")
local TargetFilter = require("scripts.services.target_filter")

--- Replacer
--- 責務: 対象エンティティ（敵ユニット/巣/ワーム等）の品質判定と置換を行う。
local Replacer = {}

local function replace_with_high_quality(old_entity, quality)
  -- 重要: old_entity は valid 前提
  local surface = old_entity.surface
  local params = {
    name     = old_entity.name,
    position = old_entity.position,
    force    = old_entity.force,
    quality  = quality
  }

  old_entity.destroy()

  -- 生成失敗する可能性はある（衝突等）。nil が返ることがあるので受けておく。
  return surface.create_entity(params)
end

local function process_entity(entity)
  if not TargetFilter.is_target_enemy(entity) then return end

  -- enemy evolution（surface依存）
  local evo = game.forces.enemy.get_evolution_factor(entity.surface)

  local quality = QualityRoller.choose_quality(evo, DRand.random())
  if quality and quality ~= "normal" then
    replace_with_high_quality(entity, quality)
  end
end

function Replacer.on_chunk_generated(event)
  local surface = event.surface

  local spawners = surface.find_entities_filtered{
    area  = event.area,
    force = "enemy",
    type  = "unit-spawner"
  }
  for _, e in pairs(spawners) do
    process_entity(e)
  end

  local worms = surface.find_entities_filtered{
    area  = event.area,
    force = "enemy",
    type  = "turret"
  }
  for _, e in pairs(worms) do
    process_entity(e)
  end
end

function Replacer.on_entity_spawned(event)
  process_entity(event.entity)
end

return Replacer