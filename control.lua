-- ----------------------------
-- requires
-- ----------------------------
require("scripts.common.choose_quality")

----------------------------
-- マップ生成時の巣とワームを置換
-- ----------------------------
script.on_event(defines.events.on_chunk_generated, function(event)
	local spawners = event.surface.find_entities_filtered{area = event.area, name = {"biter-spawner", "spitter-spawner", "gleba-spawner-small", "gleba-spawner"}}
	for _, spawner in pairs(spawners) do
		-- 品質処理
		replace_common(spawner)
	end

	local worms = event.surface.find_entities_filtered{area = event.area, type = "turret", name = {"small-worm-turret", "medium-worm-turret", "big-worm-turret", "behemoth-worm-turret"}}
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
		entity.name == "biter-spawner" or 
		entity.name == "gleba-spawner" or 
		entity.name == "gleba-spawner-corpse" or
		entity.name == "gleba-spawner-corpse-small"
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
	
	if(old_entity.type == "turret" 
		and (
			old_entity.quality ~= "legendary"
			and old_entity.quality ~= "epic"
			and old_entity.quality ~= "rare"
			and old_entity.quality ~= "uncommon"
			)
		) then
		-- ユニットの再配置 ワーム(ワームは破壊なし)
		local result = place_warm(old_entity, strquality)
		-- 設置後に破壊
		if result == "success" then
			old_entity.destroy()
		end

	else
		-- ワーム以外は破壊
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

	-- debug
	-- game.print(name.." quality = ".. strquality)

end


-- ----------------------------
-- ユニットの再配置 ワーム(初期ワームは破壊)
-- ----------------------------
function place_warm(old_entity, strquality)

	local name = old_entity.name
	local surface = old_entity.surface
	
	local min_distance = 3
	local max_distance = 5
	-- 設置可能座標を左上から探索
    for dx = -max_distance, max_distance do
	    for dy = -max_distance, max_distance do
	    	local distance = dx*dx + dy*dy
	    	if distance >= min_distance*min_distance and distance <= max_distance*max_distance then
	    		local spawn_position = {x = old_entity.position.x + dx, y = old_entity.position.y + dy}
				if surface.can_place_entity{name = name, position = spawn_position} then
					local new_entity = surface.create_entity{
						name = name,
						position = spawn_position,
						force = old_entity.force,
						quality = strquality
					}
					return "success"
				end
	    	end
    	end
    end
	
	return "failed"
	
end
