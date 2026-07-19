-- Pure validation for character identity and allowed draft-to-active transitions.
local CharacterPolicy = {}

local function trim(value)
    return value:match('^%s*(.-)%s*$')
end

function CharacterPolicy.is_uuid(value)
    return type(value) == 'string'
        and value:match(
                '^[0-9a-fA-F]+%-[0-9a-fA-F]+%-[0-9a-fA-F]+%-[0-9a-fA-F]+%-[0-9a-fA-F]+$'
            )
            ~= nil
end

function CharacterPolicy.normalize_name(value)
    if type(value) ~= 'string' then
        return nil
    end
    local normalized = trim(value):gsub('%s+', ' ')
    if
        #normalized < 2
        or #normalized > 48
        or not normalized:match("^[A-Za-z][A-Za-z '%-]*[A-Za-z]$")
    then
        return nil
    end
    return normalized
end

function CharacterPolicy.parse_birth_date(value)
    if type(value) ~= 'string' then
        return nil
    end
    local year, month, day = value:match('^(%d%d%d%d)%-(%d%d)%-(%d%d)$')
    year, month, day = tonumber(year), tonumber(month), tonumber(day)
    if not year or month < 1 or month > 12 or day < 1 or day > 31 then
        return nil
    end
    local timestamp = os.time({ year = year, month = month, day = day, hour = 12 })
    local resolved = os.date('*t', timestamp)
    if resolved.year ~= year or resolved.month ~= month or resolved.day ~= day then
        return nil
    end
    return { value = value, timestamp = timestamp }
end

function CharacterPolicy.age_on(birth_timestamp, now_timestamp)
    local birth = os.date('*t', birth_timestamp)
    local current = os.date('*t', now_timestamp)
    local age = current.year - birth.year
    if
        current.month < birth.month or (current.month == birth.month and current.day < birth.day)
    then
        age = age - 1
    end
    return age
end

function CharacterPolicy.validate_draft(payload, settings, now_timestamp)
    if type(payload) ~= 'table' then
        return nil, 'VALIDATION_ERROR'
    end
    local allowed = {
        first_name = true,
        last_name = true,
        date_of_birth = true,
        background_code = true,
        request_id = true,
        operation_uuid = true,
        contract_version = true,
    }
    for key in pairs(payload) do
        if not allowed[key] then
            return nil, 'VALIDATION_ERROR'
        end
    end
    if
        payload.contract_version ~= 1
        or not CharacterPolicy.is_uuid(payload.operation_uuid)
        or type(payload.request_id) ~= 'string'
        or #payload.request_id < 1
        or #payload.request_id > 64
        or type(payload.background_code) ~= 'string'
        or not payload.background_code:match('^[a-z][a-z0-9_]*$')
    then
        return nil, 'VALIDATION_ERROR'
    end
    local first_name = CharacterPolicy.normalize_name(payload.first_name)
    local last_name = CharacterPolicy.normalize_name(payload.last_name)
    local birth = CharacterPolicy.parse_birth_date(payload.date_of_birth)
    if not first_name or not last_name or not birth then
        return nil, 'VALIDATION_ERROR'
    end
    local age = CharacterPolicy.age_on(birth.timestamp, now_timestamp or os.time())
    if age < settings.minimum_age or age > settings.maximum_age then
        return nil, 'VALIDATION_ERROR'
    end
    return {
        first_name = first_name,
        last_name = last_name,
        date_of_birth = birth.value,
        background_code = payload.background_code,
        request_id = payload.request_id,
        operation_uuid = payload.operation_uuid,
        contract_version = 1,
    }
end

function CharacterPolicy.validate_activation(payload)
    if type(payload) ~= 'table' then
        return nil, 'VALIDATION_ERROR'
    end
    local allowed =
        { character_uuid = true, request_id = true, operation_uuid = true, contract_version = true }
    for key in pairs(payload) do
        if not allowed[key] then
            return nil, 'VALIDATION_ERROR'
        end
    end
    if
        payload.contract_version ~= 1
        or not CharacterPolicy.is_uuid(payload.character_uuid)
        or not CharacterPolicy.is_uuid(payload.operation_uuid)
        or type(payload.request_id) ~= 'string'
        or #payload.request_id < 1
        or #payload.request_id > 64
    then
        return nil, 'VALIDATION_ERROR'
    end
    return payload
end

local function valid_request(payload, allowed, version)
    if type(payload) ~= 'table' then
        return false
    end
    for key in pairs(payload) do
        if not allowed[key] then
            return false
        end
    end
    return payload.contract_version == version
        and CharacterPolicy.is_uuid(payload.operation_uuid)
        and type(payload.request_id) == 'string'
        and #payload.request_id >= 1
        and #payload.request_id <= 64
end

function CharacterPolicy.validate_selection(payload)
    local allowed = {
        character_uuid = true,
        request_id = true,
        operation_uuid = true,
        contract_version = true,
    }
    if
        not valid_request(payload, allowed, 1)
        or not CharacterPolicy.is_uuid(payload.character_uuid)
    then
        return nil, 'VALIDATION_ERROR'
    end
    return payload
end

local function integer_between(value, minimum, maximum)
    return type(value) == 'number' and value % 1 == 0 and value >= minimum and value <= maximum
end

function CharacterPolicy.validate_appearance(payload)
    local allowed = {
        model = true,
        shape_first = true,
        shape_second = true,
        shape_mix = true,
        skin_mix = true,
        face_features = true,
        hair_style = true,
        hair_texture = true,
        hair_color = true,
        hair_highlight = true,
        eye_color = true,
        outfit_code = true,
        request_id = true,
        operation_uuid = true,
        contract_version = true,
    }
    if not valid_request(payload, allowed, 1) then
        return nil, 'VALIDATION_ERROR'
    end
    if
        (payload.model ~= 'mp_m_freemode_01' and payload.model ~= 'mp_f_freemode_01')
        or not integer_between(payload.shape_first, 0, 45)
        or not integer_between(payload.shape_second, 0, 45)
        or not integer_between(payload.shape_mix, 0, 100)
        or not integer_between(payload.skin_mix, 0, 100)
        or not integer_between(payload.hair_style, 0, 76)
        or not integer_between(payload.hair_texture, 0, 10)
        or not integer_between(payload.hair_color, 0, 63)
        or not integer_between(payload.hair_highlight, 0, 63)
        or not integer_between(payload.eye_color, 0, 31)
        or payload.outfit_code ~= 'starter_casual'
        or type(payload.face_features) ~= 'table'
        or #payload.face_features ~= 20
    then
        return nil, 'VALIDATION_ERROR'
    end
    for key, value in pairs(payload.face_features) do
        if not integer_between(key, 1, 20) or not integer_between(value, -100, 100) then
            return nil, 'VALIDATION_ERROR'
        end
    end
    return payload
end

function CharacterPolicy.validate_spawn_ack(payload)
    if type(payload) ~= 'table' then
        return nil, 'VALIDATION_ERROR'
    end
    for key in pairs(payload) do
        if key ~= 'spawn_uuid' then
            return nil, 'VALIDATION_ERROR'
        end
    end
    if not CharacterPolicy.is_uuid(payload.spawn_uuid) then
        return nil, 'VALIDATION_ERROR'
    end
    return payload
end

return CharacterPolicy
