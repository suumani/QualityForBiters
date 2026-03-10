-- __QuickFlipBiter__/scripts/domain/target_filter.lua
-- ------------------------------------------------------------
-- 責務:
--   エンティティが QFB の置換対象となる敵かどうかを判定する。
--
--   - qfb_catalog に定義された pack 情報を参照し、
--     除外対象となる entity.name の集合を構築する。
--   - runtime mod setting (qfb-pack-*) を参照し、
--     pack が OFF の場合はその pack に含まれる name を除外する。
--   - script.active_mods を参照し、対象 Mod が存在する pack のみ考慮する。
--   - 除外 name 集合は module 内キャッシュとして保持する。
--
-- 設計方針:
--   この除外集合は catalog と settings から常に再構築可能な情報であるため、
--   storage には保存せず module-local キャッシュとして保持する。
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