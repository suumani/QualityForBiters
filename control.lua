-- 初期配置ワームと巣に対応

-- ----------------------------
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
	if (entity.type == "unit" or entity.type == "spider-unit" or entity.type == "turret" or entity.name == "biter-spawner") and entity.force.name == "enemy" then
		
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
		place_warm(old_entity, strquality)
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
-- ユニットの再配置 ワーム(ワームは破壊なし)
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



-- 品質の決定
function choose_quality(evolution_factor)
	-- 変更なければnormal
	local quality = "normal"
	local r = math.random()
	
	if evolution_factor < 0.1 then
		if r < 0.01 then
			-- レア1％
			return "rare"
		elseif r < 0.1 then
			-- アンコモン9％
			return "uncommon"
		end
		
	elseif evolution_factor < 0.2 then
		if r < 0.05 then
			-- レア5％
			return "rare"
		elseif r < 0.2 then
			-- アンコモン15％
			return "uncommon"
		end
	
	elseif evolution_factor < 0.3 then
		if r < 0.1 then
			-- レア10％
			return "rare"
		elseif r < 0.3 then
			-- アンコモン20％
			return "uncommon"
		end
	
	elseif evolution_factor < 0.4 then
		if r < 0.01 then
			-- エピック1％
			return "epic"
		elseif r < 0.16 then
			-- レア15％
			return "rare"
		elseif r < 0.4 then
			-- アンコモン24％
			return "uncommon"
		end
	
	elseif evolution_factor < 0.5 then
		if r < 0.05 then
			-- エピック5％
			return "epic"
		elseif r < 0.25 then
			-- レア20％
			return "rare"
		elseif r < 0.5 then
			-- アンコモン25％
			return "uncommon"
		end
	
	elseif evolution_factor < 0.6 then
		if r < 0.10 then
			-- エピック10％
			return "epic"
		elseif r < 0.3 then
			-- レア20％
			return "rare"
		elseif r < 0.6 then
			-- アンコモン30％
			return "uncommon"
		end
	
	elseif evolution_factor < 0.7 then
		if r < 0.01 then
			-- レジェンド
			return "legendary"
		elseif r < 0.16 then
			-- エピック15％
			return "epic"
		elseif r < 0.41 then
			-- レア25％
			return "rare"
		elseif r < 0.7 then
			-- アンコモン29％
			return "uncommon"
		end
	
	elseif evolution_factor < 0.8 then
		if r < 0.05 then
			-- レジェンド5%
			return "legendary"
		elseif r < 0.25 then
			-- エピック20％
			return "epic"
		elseif r < 0.55 then
			-- レア30％
			return "rare"
		elseif r < 0.8 then
			-- アンコモン25％
			return "uncommon"
		end
	
	elseif evolution_factor < 0.9 then
		if r < 0.1 then
			-- レジェンド10%
			return "legendary"
		elseif r < 0.35 then
			-- エピック25％
			return "epic"
		elseif r < 0.65 then
			-- レア30％
			return "rare"
		elseif r < 0.9 then
			-- アンコモン25％
			return "uncommon"
		end
	
	elseif evolution_factor < 0.95 then
		if r < 0.2 then
			-- レジェンド20%
			return "legendary"
		elseif r < 0.5 then
			-- エピック30％
			return "epic"
		elseif r < 0.75 then
			-- レア25％
			return "rare"
		elseif r < 0.95 then
			-- アンコモン20％
			return "uncommon"
		end
	
	elseif evolution_factor < 0.98 then
		if r < 0.34 then
			-- レジェンド34%
			return "legendary"
		elseif r < 0.64 then
			-- エピック30％
			return "epic"
		elseif r < 0.84 then
			-- レア20％
			return "rare"
		elseif r < 0.99 then
			-- アンコモン15％
			return "uncommon"
		end
	
	else
		if r < 0.5 then
			-- レジェンド50%
			return "legendary"
		elseif r < 0.85 then
			-- エピック35％
			return "epic"
		elseif r < 0.95 then
			-- レア10％
			return "rare"
		else
			-- アンコモン5％
			return "uncommon"
		end
	
	end
	return "normal"
end