-- �����z�u���[���Ƒ��ɑΉ�

-- ----------------------------
-- �}�b�v�������̑��ƃ��[����u��
-- ----------------------------
script.on_event(defines.events.on_chunk_generated, function(event)
	local spawners = event.surface.find_entities_filtered{area = event.area, name = {"biter-spawner", "spitter-spawner", "gleba-spawner-small", "gleba-spawner"}}
	for _, spawner in pairs(spawners) do
		-- �i������
		replace_common(spawner)
	end

	local worms = event.surface.find_entities_filtered{area = event.area, type = "turret", name = {"small-worm-turret", "medium-worm-turret", "big-worm-turret", "behemoth-worm-turret"}}
	for _, worm in pairs(worms) do
		-- �i������
		replace_common(worm)
	end
end)

-- ----------------------------
-- �V�K�X�|�[���C�x���g�ɂ�
-- ----------------------------
script.on_event(defines.events.on_entity_spawned, function(event)
	-- �i������
	replace_common(event.entity)
end)

-- ----------------------------
-- �i������
-- ----------------------------
function replace_common(entity)
	-- �o�C�^�[�A���[���A�o�C�^�[�̑��̒u��
	if (entity.type == "unit" or entity.type == "spider-unit" or entity.type == "turret" or entity.name == "biter-spawner") and entity.force.name == "enemy" then
		
		-- �i���x�̎擾
		local evolution_factor = game.forces["enemy"].get_evolution_factor(entity.surface)
		
		-- �i���̌���
		local quality = choose_quality(evolution_factor)
		
		-- ���j�b�g�̍Ĕz�u
		if(quality ~= "normal") then
			replace_with_high_quality(entity, quality)
		end
	end
end


-- ----------------------------
-- ���j�b�g�̍Ĕz�u ���[���͒ǉ��z�u(�񓯊������L���b�`�s��)
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
		-- ���j�b�g�̍Ĕz�u ���[��(���[���͔j��Ȃ�)
		place_warm(old_entity, strquality)
	else
		-- ���[���ȊO�͔j��
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
-- ���j�b�g�̍Ĕz�u ���[��(���[���͔j��Ȃ�)
-- ----------------------------
function place_warm(old_entity, strquality)

	local name = old_entity.name
	local surface = old_entity.surface
	
	local min_distance = 3
	local max_distance = 5
	-- �ݒu�\���W�����ォ��T��
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



-- �i���̌���
function choose_quality(evolution_factor)
	-- �ύX�Ȃ����normal
	local quality = "normal"
	local r = math.random()
	
	if evolution_factor < 0.1 then
		if r < 0.01 then
			-- ���A1��
			return "rare"
		elseif r < 0.1 then
			-- �A���R����9��
			return "uncommon"
		end
		
	elseif evolution_factor < 0.2 then
		if r < 0.05 then
			-- ���A5��
			return "rare"
		elseif r < 0.2 then
			-- �A���R����15��
			return "uncommon"
		end
	
	elseif evolution_factor < 0.3 then
		if r < 0.1 then
			-- ���A10��
			return "rare"
		elseif r < 0.3 then
			-- �A���R����20��
			return "uncommon"
		end
	
	elseif evolution_factor < 0.4 then
		if r < 0.01 then
			-- �G�s�b�N1��
			return "epic"
		elseif r < 0.16 then
			-- ���A15��
			return "rare"
		elseif r < 0.4 then
			-- �A���R����24��
			return "uncommon"
		end
	
	elseif evolution_factor < 0.5 then
		if r < 0.05 then
			-- �G�s�b�N5��
			return "epic"
		elseif r < 0.25 then
			-- ���A20��
			return "rare"
		elseif r < 0.5 then
			-- �A���R����25��
			return "uncommon"
		end
	
	elseif evolution_factor < 0.6 then
		if r < 0.10 then
			-- �G�s�b�N10��
			return "epic"
		elseif r < 0.3 then
			-- ���A20��
			return "rare"
		elseif r < 0.6 then
			-- �A���R����30��
			return "uncommon"
		end
	
	elseif evolution_factor < 0.7 then
		if r < 0.01 then
			-- ���W�F���h
			return "legendary"
		elseif r < 0.16 then
			-- �G�s�b�N15��
			return "epic"
		elseif r < 0.41 then
			-- ���A25��
			return "rare"
		elseif r < 0.7 then
			-- �A���R����29��
			return "uncommon"
		end
	
	elseif evolution_factor < 0.8 then
		if r < 0.05 then
			-- ���W�F���h5%
			return "legendary"
		elseif r < 0.25 then
			-- �G�s�b�N20��
			return "epic"
		elseif r < 0.55 then
			-- ���A30��
			return "rare"
		elseif r < 0.8 then
			-- �A���R����25��
			return "uncommon"
		end
	
	elseif evolution_factor < 0.9 then
		if r < 0.1 then
			-- ���W�F���h10%
			return "legendary"
		elseif r < 0.35 then
			-- �G�s�b�N25��
			return "epic"
		elseif r < 0.65 then
			-- ���A30��
			return "rare"
		elseif r < 0.9 then
			-- �A���R����25��
			return "uncommon"
		end
	
	elseif evolution_factor < 0.95 then
		if r < 0.2 then
			-- ���W�F���h20%
			return "legendary"
		elseif r < 0.5 then
			-- �G�s�b�N30��
			return "epic"
		elseif r < 0.75 then
			-- ���A25��
			return "rare"
		elseif r < 0.95 then
			-- �A���R����20��
			return "uncommon"
		end
	
	elseif evolution_factor < 0.98 then
		if r < 0.34 then
			-- ���W�F���h34%
			return "legendary"
		elseif r < 0.64 then
			-- �G�s�b�N30��
			return "epic"
		elseif r < 0.84 then
			-- ���A20��
			return "rare"
		elseif r < 0.99 then
			-- �A���R����15��
			return "uncommon"
		end
	
	else
		if r < 0.5 then
			-- ���W�F���h50%
			return "legendary"
		elseif r < 0.85 then
			-- �G�s�b�N35��
			return "epic"
		elseif r < 0.95 then
			-- ���A10��
			return "rare"
		else
			-- �A���R����5��
			return "uncommon"
		end
	
	end
	return "normal"
end