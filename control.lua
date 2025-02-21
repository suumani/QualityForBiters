-- ----------------------------
-- requires
-- ----------------------------
require("scripts.common.choose_quality")


script.on_init(function()
end)

----------------------------
-- マップ生成時の巣とワームを置換
-- ----------------------------
script.on_event(defines.events.on_chunk_generated, function(event)

	local spawners = nil
	spawners = event.surface.find_entities_filtered{area = event.area, force = "enemy", type = "unit-spawner"}

	for _, spawner in pairs(spawners) do
		-- 品質処理
		replace_common(spawner)
	end

	local worms = event.surface.find_entities_filtered{area = event.area, force = "enemy", type = "turret"}
	for _, worm in pairs(worms) do
		-- 品質処理
		replace_common(worm)
	end
end)

-- ----------------------------
-- 新規スポーンイベントにて
-- ----------------------------
script.on_event(defines.events.on_entity_spawned, function(event)
	-- 品質処理
	replace_common(event.entity)
end)

-- ----------------------------
-- 品質処理
-- ----------------------------
function replace_common(entity)
	-- バイター、ワーム、バイターの巣の置換
	if (
		entity.type == "unit" or 
		entity.type == "spider-unit" or 
		entity.type == "turret" or 
		entity.type == "unit-spawner"
	) and entity.force.name == "enemy" then
		
		-- 進化度の取得
		local evolution_factor = game.forces["enemy"].get_evolution_factor(entity.surface)
		
		-- 品質の決定
		local quality = choose_quality(evolution_factor)
		
		-- ユニットの再配置
		if(quality ~= "normal") then
			replace_with_high_quality(entity, quality)
		end
	end
end


-- ----------------------------
-- ユニットの再配置 ワームは追加配置(非同期処理キャッチ不可)
-- ----------------------------
function replace_with_high_quality(old_entity, strquality)
	
	local name = old_entity.name
	local surface = old_entity.surface
	local position = old_entity.position
	local force = old_entity.force
	old_entity.destroy()
	local new_entity = surface.create_entity{
		name = name,
		position = position,
		force = force,
		quality = strquality
	}

end

