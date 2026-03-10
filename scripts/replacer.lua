-- __BiterShield2__/scripts/replacer.lua
-- ------------------------------------------------------------
-- 責務:
--   対象となる敵エンティティ（巣・ワームなど）に対して品質ロールを行い、
--   必要に応じて品質付きエンティティへ置換する。
--
-- 基本ロジック:
--   QualityRoller.choose_quality(evo, r) により base_steps (0..4) を取得する。
--     0 = normal
--     1 = uncommon
--     2 = rare
--     3 = epic
--     4 = legendary
--
-- 拡張機能 (QFB_MoreQualities):
--   Mod "QFB_MoreQualities" が有効な場合、
--   legendary 以上の品質拡張（window shift）を適用する。
--
--   final_steps = base_steps + unlock_steps
--
--   unlock_steps はプレイヤー研究レベルから取得する。
--     技術: qfb-biter-quality-shift (無限研究)
--     unlock_steps = tech.level - 1
--
-- 実装方針:
--   - 乱数は DeterministicRandom を使用し、同期乱数とする。
--   - 品質チェーンは prototypes.quality を使用して
--     normal -> next -> next ... の順で解決する。
--   - 品質チェーンは一度だけ構築しキャッシュする。
--   - create_entity に渡す品質は QualityID（prototype.name）とする。
-- ------------------------------------------------------------

local QualityRoller = require("scripts.rollers.QualityRoller")
local DRand = require("scripts.util.DeterministicRandom")
local TargetFilter = require("scripts.services.target_filter")

local Replacer = {}

-- ------------------------------------------------------------
-- Extension constants
-- ------------------------------------------------------------
local EXT_MOD_NAME = "QFB_MoreQualities"
local SHIFT_TECH_NAME = "qfb-biter-quality-shift"

-- ------------------------------------------------------------
-- Cached quality chain
-- ------------------------------------------------------------
local _cached_quality_chain = nil

local function clamp(v, lo, hi)
  if v < lo then return lo end
  if v > hi then return hi end
  return v
end

local function get_unlock_steps_player()
  if not script.active_mods[EXT_MOD_NAME] then
    return 0
  end

  local f = game.forces.player
  if not f then return 0 end

  local t = f.technologies[SHIFT_TECH_NAME]
  if not t then
    return 0
  end

  -- Infinite tech:
  -- level starts at 1 (even before researched), so shift steps = level - 1.
  local lvl = tonumber(t.level) or 1
  if lvl < 1 then lvl = 1 end

  return lvl - 1
end

local function build_quality_chain_uncached()
  -- Build a list of quality ids following:
  --   normal -> next -> next -> ...
  -- Stops on nil, loop, or hard cap.
  local chain = {}
  local seen = {}

  if not prototypes or not prototypes.quality then
    return { "normal", "uncommon", "rare", "epic", "legendary" }
  end

  local q = prototypes.quality["normal"]
  if not q then
    return { "normal", "uncommon", "rare", "epic", "legendary" }
  end

  local limit = 512
  for _ = 1, limit do
    if not q then break end
    if seen[q.name] then break end
    seen[q.name] = true
    chain[#chain + 1] = q.name
    q = q.next
  end

  return chain
end

local function get_quality_chain()
  if _cached_quality_chain then
    return _cached_quality_chain
  end

  local chain = build_quality_chain_uncached()
  if type(chain) ~= "table" or #chain <= 0 then
    chain = { "normal", "uncommon", "rare", "epic", "legendary" }
  end

  _cached_quality_chain = chain
  return _cached_quality_chain
end

local function replace_with_quality(old_entity, quality_id)
  -- Important: old_entity is assumed valid at call site.
  local surface = old_entity.surface
  local params = {
    name     = old_entity.name,
    position = old_entity.position,
    force    = old_entity.force,
    quality  = quality_id
  }

  -- 設計意図：削除を優先し、create_entityの安全性を確保
  old_entity.destroy()

  -- 生成失敗時のnil返却を許容（例外のreplace失敗より処理速度優先）
  return surface.create_entity(params)
end

local function compute_final_quality_id(evo, r)
  -- base_steps: 0..4
  local base_steps = tonumber(QualityRoller.choose_quality(evo, r)) or 0
  if base_steps < 0 then base_steps = 0 end

  local unlock_steps = get_unlock_steps_player()
  local final_steps = base_steps + unlock_steps

  if final_steps <= 0 then
    return "normal"
  end

  local chain = get_quality_chain()
  -- Lua 1-based index
  local idx = clamp(final_steps + 1, 1, #chain)
  return chain[idx]
end

local function process_entity(entity)
  if not (entity and entity.valid) then return end
  if not TargetFilter.is_target_enemy(entity) then return end

  -- enemy evolution factor (surface dependent)
  local evo = game.forces.enemy.get_evolution_factor(entity.surface)

  local quality_id = compute_final_quality_id(evo, DRand.random())
  if quality_id and quality_id ~= "normal" then
    replace_with_quality(entity, quality_id)
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