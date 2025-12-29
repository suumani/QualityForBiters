-- settings.lua
local Catalog = require("scripts.defines.qfb_catalog")

local PACK_ORDER = {
  { key = "default",        title = "Default Mob" },
  { key = "space_age",      title = "SpaceAge" },
  { key = "Cold_biters",    title = "Frost Biters" },
  { key = "Explosive_biters",title = "Explosive Biters" },
  { key = "Toxic_biters",   title = "Toxic Biters" },
  { key = "ArmouredBiters", title = "Armoured Biters" },
  { key = "Big-Monsters",   title = "Big Monsters" },
}

local function is_pack_available(pack_key, pack)
  if pack_key == "space_age" then
    return mods["space-age"] ~= nil
  end
  if pack.mod_name then
    return mods[pack.mod_name] ~= nil
  end
  return true
end

local function pack_disabled_reason_key(pack_key, pack)
  if pack_key == "space_age" then
    return {"qfb.reason.space_age_disabled"}
  end
  if pack.mod_name then
    return {"qfb.reason.mod_disabled", pack.mod_name}
  end
  return {"qfb.reason.unknown"}
end

data:extend({
  {
    type = "bool-setting",
    name = "qfb-00-header",
    setting_type = "runtime-global",
    default_value = true,
    order = "qfb-00[header]",
    localised_name = {"qfb.ui.header_title_simple"},
    localised_description = {"qfb.ui.header_desc_simple"},
  }
})

for i, entry in ipairs(PACK_ORDER) do
  local pack_key = entry.key
  local pack = Catalog.packs[pack_key]
  if pack then
    local available = is_pack_available(pack_key, pack)
    local suffix = available and "" or "（invalid）"

    data:extend({
      {
        type = "bool-setting",
        name = "qfb-pack-" .. pack_key,
        setting_type = "runtime-global",
        default_value = true, -- ON=置換 / OFF=除外
        order = string.format("qfb-%02d[pack-%s]", i, pack_key),
        localised_name = {"", entry.title, " ", suffix},
        localised_description = available
          and {"qfb.ui.pack_desc"}
          or {"qfb.ui.pack_desc_disabled", pack_disabled_reason_key(pack_key, pack)},
      }
    })
  end
end