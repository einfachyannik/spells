local Spell = {}
Spell.Learntime = 1
Spell.Description = [[
    Friert die Leute im 
    Umkreis ein und 
    Hält sie für mehr 
    als 1 Sekunde fest 
]]
Spell.FlyEffect = "hpw_grenadio_main"
Spell.ImpactEffect = "hpw_expulso_impact_warp"
Spell.ApplyDelay = 0.7
Spell.AccuracyDecreaseVal = 0.5
Spell.ForceDelay = 0
Spell.Category = { HpwRewrite.CategoryNames.DestrExp, HpwRewrite.CategoryNames.Special }
Spell.NodeOffset = Vector (-1354, -180, 0)
ForceAnim = { ACT_VM_PRIMARYATTACK_5 }

function Spell:OnSpellSpawned(wand,spell)
    wand:PlayCastSound()
end

function Spell:Draw(spell)
    self:DrawGlow(spell)
end

function Spell:OnFire(wand)
    local pos = wand:GetSpellSpawnPosition()

    wand:PlayCastSound()

    local spellentity = ents.Create("fstar_sfire")
    spellentity:SetPos(pos)
    spellentity:SetOwner(self.Owner)

    local dir = (self.Owner:GetEyeTrace().HitPos - pos):GetNormalized()
    wand:ApplyAccuracyPenalty(dir)

    spellentity:SetAngles(self.Owner:GetAngles())
    spellentity:Spawn()

    local phys = spellentity:GetPhysicsObject ()
    if not phys:IsValid() then SafeRemoveEntity(spellentity) return end

    phys:ApplyForceCenter(dir * phys:GetMass() * 5000)
    phys:ApplyForceOffset(Vector(0, 0, -phys:GetMass() * 0.15), spellentity:GetPos() + spellentity:GetForward() * 200)
    phys:AddAngleVelocity(Vector(0, 50, 0))
    sound.Play("npc/vort/attack_shoot.wav", pos, 100, math.random(90, 110)) 

    
end

HpwRewrite:AddSpell("Lux Custus", Spell)