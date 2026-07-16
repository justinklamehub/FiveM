-- Verifies English identity input and age/status rules without FiveM.
local Policy = dofile('resources/[cnr]/cnr_characters/shared/character_policy.lua')
local settings = { minimum_age = 18, maximum_age = 85 }
local now = os.time({ year = 2026, month = 7, day = 16, hour = 12 })

local function payload()
    return {
        first_name = 'Alex',
        last_name = "O'Connor",
        date_of_birth = '1995-05-20',
        background_code = 'local',
        request_id = 'request-1',
        operation_uuid = '0190b7a0-2000-7000-8000-000000000001',
        contract_version = 1,
    }
end

local function appearance_payload()
    return {
        model = 'mp_m_freemode_01',
        shape_first = 0,
        shape_second = 21,
        shape_mix = 50,
        skin_mix = 50,
        face_features = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
        hair_style = 0,
        hair_texture = 0,
        hair_color = 0,
        hair_highlight = 0,
        eye_color = 0,
        outfit_code = 'starter_casual',
        request_id = 'appearance-1',
        operation_uuid = '0190b7a0-2000-7000-8000-000000000003',
        contract_version = 1,
    }
end

describe('character policy', function()
    it('normalizes a valid identity and accepts realistic duplicate names', function()
        local result = Policy.validate_draft(payload(), settings, now)
        assert.are.equal('Alex', result.first_name)
        assert.are.equal("O'Connor", result.last_name)
    end)
    it(
        'rejects underage, impossible dates, unsafe names, and unexpected authority fields',
        function()
            local value = payload()
            value.date_of_birth = '2010-01-01'
            assert.are.equal(
                'VALIDATION_ERROR',
                select(2, Policy.validate_draft(value, settings, now))
            )
            value = payload()
            value.date_of_birth = '1995-02-31'
            assert.are.equal(
                'VALIDATION_ERROR',
                select(2, Policy.validate_draft(value, settings, now))
            )
            value = payload()
            value.first_name = '<script>'
            assert.are.equal(
                'VALIDATION_ERROR',
                select(2, Policy.validate_draft(value, settings, now))
            )
            value = payload()
            value.account_uuid = value.operation_uuid
            assert.are.equal(
                'VALIDATION_ERROR',
                select(2, Policy.validate_draft(value, settings, now))
            )
        end
    )
    it('requires narrow versioned activation input', function()
        assert.is_table(Policy.validate_activation({
            character_uuid = '0190b7a0-2000-7000-8000-000000000001',
            request_id = 'request-2',
            operation_uuid = '0190b7a0-2000-7000-8000-000000000002',
            contract_version = 1,
        }))
    end)
    it(
        'requires narrow versioned character selection without session or spawn authority',
        function()
            local selection = {
                character_uuid = '0190b7a0-2000-7000-8000-000000000001',
                request_id = 'selection-1',
                operation_uuid = '0190b7a0-2000-7000-8000-000000000002',
                contract_version = 1,
            }
            assert.is_table(Policy.validate_selection(selection))
            selection.session_uuid = selection.operation_uuid
            assert.are.equal('VALIDATION_ERROR', select(2, Policy.validate_selection(selection)))
        end
    )
    it('accepts curated appearance and rejects invalid ranges or authority fields', function()
        assert.is_table(Policy.validate_appearance(appearance_payload()))
        local value = appearance_payload()
        value.face_features[20] = 101
        assert.are.equal('VALIDATION_ERROR', select(2, Policy.validate_appearance(value)))
        value = appearance_payload()
        value.model = 'a_m_m_business_01'
        assert.are.equal('VALIDATION_ERROR', select(2, Policy.validate_appearance(value)))
        value = appearance_payload()
        value.character_uuid = value.operation_uuid
        assert.are.equal('VALIDATION_ERROR', select(2, Policy.validate_appearance(value)))
    end)
end)
