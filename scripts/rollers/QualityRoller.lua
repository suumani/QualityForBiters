-- __BiterShield2__/scripts/rollers/QualityRoller.lua
-- ------------------------------------------------------------
-- 責務:
--   enemy evolution factor (evo) と乱数 r に基づき、
--   base window の「段数（steps）」を決定する。
--
-- 定義:
--   0 = normal
--   1 = uncommon
--   2 = rare
--   3 = epic
--   4 = legendary
--
-- 重要:
--   - 本モジュールは base window（0..4）の抽選のみを行う。
--   - legendary 以降の拡張（窓ずらし / 追加品質追従）は Replacer 側の責務。
-- ------------------------------------------------------------

local QualityRoller = {}

function QualityRoller.choose_quality(evo, r)
  -- evo: [0,1], r: [0,1)
  if evo < 0.1 then
    if r < 0.01 then
      return 2 -- rare
    elseif r < 0.1 then
      return 1 -- uncommon
    end

  elseif evo < 0.2 then
    if r < 0.05 then
      return 2 -- rare
    elseif r < 0.2 then
      return 1 -- uncommon
    end

  elseif evo < 0.3 then
    if r < 0.1 then
      return 2 -- rare
    elseif r < 0.3 then
      return 1 -- uncommon
    end

  elseif evo < 0.4 then
    if r < 0.01 then
      return 3 -- epic
    elseif r < 0.16 then
      return 2 -- rare
    elseif r < 0.4 then
      return 1 -- uncommon
    end

  elseif evo < 0.5 then
    if r < 0.05 then
      return 3 -- epic
    elseif r < 0.25 then
      return 2 -- rare
    elseif r < 0.5 then
      return 1 -- uncommon
    end

  elseif evo < 0.6 then
    if r < 0.10 then
      return 3 -- epic
    elseif r < 0.3 then
      return 2 -- rare
    elseif r < 0.6 then
      return 1 -- uncommon
    end

  elseif evo < 0.7 then
    if r < 0.01 then
      return 4 -- legendary
    elseif r < 0.16 then
      return 3 -- epic
    elseif r < 0.41 then
      return 2 -- rare
    elseif r < 0.7 then
      return 1 -- uncommon
    end

  elseif evo < 0.8 then
    if r < 0.05 then
      return 4 -- legendary
    elseif r < 0.25 then
      return 3 -- epic
    elseif r < 0.55 then
      return 2 -- rare
    elseif r < 0.8 then
      return 1 -- uncommon
    end

  elseif evo < 0.9 then
    if r < 0.1 then
      return 4 -- legendary
    elseif r < 0.35 then
      return 3 -- epic
    elseif r < 0.65 then
      return 2 -- rare
    elseif r < 0.9 then
      return 1 -- uncommon
    end

  elseif evo < 0.95 then
    if r < 0.2 then
      return 4 -- legendary
    elseif r < 0.5 then
      return 3 -- epic
    elseif r < 0.75 then
      return 2 -- rare
    elseif r < 0.95 then
      return 1 -- uncommon
    end

  elseif evo < 0.98 then
    if r < 0.34 then
      return 4 -- legendary
    elseif r < 0.64 then
      return 3 -- epic
    elseif r < 0.84 then
      return 2 -- rare
    elseif r < 0.99 then
      return 1 -- uncommon
    end

  else
    if r < 0.5 then
      return 4 -- legendary
    elseif r < 0.85 then
      return 3 -- epic
    elseif r < 0.95 then
      return 2 -- rare
    else
      return 1 -- uncommon
    end
  end

  return 0 -- normal
end

return QualityRoller