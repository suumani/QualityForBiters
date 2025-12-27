-- target_filter.lua
local Catalog = require("scripts.defines.qfb_catalog")
local M = {}

local function get_setting_value(name)
  local s = settings.global[name]
  -- 設定が無い場合は ON 扱い（＝除外しない／未知は置換）
  if s == nil then return true end
  return s.value == true
end

local function is_pack_available(pack_key, pack)
  -- runtime では mods ではなく script.active_mods
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
  storage.qfb_excluded_name_set = build_excluded_set()
  storage.qfb_excluded_name_set_version = (storage.qfb_excluded_name_set_version or 0) + 1
end

function M.ensure_cache()
  if storage.qfb_excluded_name_set == nil then
    M.rebuild_cache()
  end
end

function M.is_target_enemy(entity)
  -- ここはあなたの方針（握り潰さない）に合わせてガード無しでOK
  M.ensure_cache()
  return storage.qfb_excluded_name_set[entity.name] ~= true
end

return M