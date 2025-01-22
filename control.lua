-- ----------------------------
-- requires
-- ----------------------------
require("scripts.common.choose_quality")

----------------------------
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
		local result = place_warm(old_entity, strquality)
		-- �ݒu��ɔj��
		if result == "success" then
			old_entity.destroy()
		end

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
-- ���j�b�g�̍Ĕz�u ���[��(�������[���͔j��)
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
