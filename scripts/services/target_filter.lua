-- __QuickFlipBiter__/scripts/domain/target_filter.lua
-- ------------------------------------------------------------
-- Responsibility:
--   Determine whether an enemy entity is a valid QFB target.
--
--   - Build an exclusion set from qfb_catalog packs.
--   - Respect runtime mod settings (qfb-pack-*).
--   - Respect mod availability (script.active_mods).
--   - Cache the exclusion name set in module memory.
--
--   This module cache is NOT persisted in storage because
--   the data is fully reconstructible from catalog + settings.
-- ------------------------------------------------------------

local Catalog = require("scripts.defines.qfb_catalog")

local M = {}

-- module-local cache (non-persistent)
local excluded_name_set = nil

local function get_setting_value(name)
  local s = settings.global[name]
  -- 設定が無い場合は ON 扱い（＝除外しない／未知は置換）
  if s == nil then return true end
  return s.value == true
end

local function is_pack_available(pack_key, pack)
  if pack_key == "space_age" then
    return script.active_mods["space-age"] ~= nil
  end

  if pack.mod_name then
    return script.active_mods[pack.mod_name] ~= nil
  end

  return true
end

local function push_names(set, names)
  for _, n in ipairs(names) do
    set[n] = true
  end
end

local function build_excluded_set()
  local excluded = {}

  for pack_key, pack in pairs(Catalog.packs) do
    local available = is_pack_available(pack_key, pack)
    local pack_on = get_setting_value("qfb-pack-" .. pack_key)

    if available and (not pack_on) then
      -- packがOFF => pack内の全namesを除外
      for _, item in ipairs(pack.items) do
        push_names(excluded, item.names)
      end
    end
  end

  return excluded
end

function M.rebuild_cache()
  excluded_name_set = build_excluded_set()
end

function M.ensure_cache()
  if excluded_name_set == nil then
    M.rebuild_cache()
  end
end

function M.is_target_enemy(entity)
  M.ensure_cache()
  return excluded_name_set[entity.name] ~= true
end

return M