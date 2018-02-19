local mod	= DBM:NewMod("3 Drakes", "DBM-BWL", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 168 $"):sub(12, -3))
mod:SetCreatureID(11981, 11983, 14601)
mod:RegisterCombat("combat")
mod:AddBoolOption("SetIconOnBombTarget", true)

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_REMOVED",
	"SPELL_AURA_APPLIED_DOSE"
)
--Flamegor

local warnWingBuffetFlamegor	= mod:NewCastAnnounce(23339)
local warnWingBuffetFiremaw		= mod:NewCastAnnounce(23339)
local warnWingBuffetEbonroc		= mod:NewCastAnnounce(23339)
local timerWingBuffetFlamegor	= mod:NewNextTimer(31, 23339)
local timerWingBuffetFiremaw	= mod:NewNextTimer(31, 23339)
local timerWingBuffetEbonroc	= mod:NewNextTimer(31, 23339)
local warnShadowFlameFlamegor	= mod:NewCastAnnounce(22539)
local warnShadowFlameFiremaw	= mod:NewCastAnnounce(22539)
local warnShadowFlameEbonroc	= mod:NewCastAnnounce(22539)
local timerShadowFlameFlamegor	= mod:NewCastTimer(2, 22539)
local timerShadowFlameFiremaw	= mod:NewCastTimer(2, 22539)
local timerShadowFlameEbonroc	= mod:NewCastTimer(2, 22539)
local warnEnrageFlamegor		= mod:NewSpellAnnounce(23342)
local timerEnrageNextFlamegor 	= mod:NewNextTimer(10, 23342)
local warnFlameBuffet			= mod:NewSpellAnnounce(23341)
local timerFlameBuffetCD 		= mod:NewCDTimer(10, 23341)
local specwarnImmolate		= mod:NewSpecialWarningYou(100348)
local timerImmolate			= mod:NewTargetTimer(15, 100348)
local timerBlastwave		= mod:NewTargetTimer(3, 100349)
local warnImmolate			= mod:NewTargetAnnounce(100348)


function mod:OnCombatStart(delay)
	timerWingBuffetFlamegor:Start(-delay)
	timerWingBuffetFiremaw:Start(-delay)
	timerWingBuffetEbonroc:Start(-delay)
end


function mod:SPELL_CAST_START(args)
	if args:IsSpellID(23339) and self:IsInCombat()  then		--wing buffet Flamegore Warning and Timer
		warnWingBuffetFlamegor:Show()
		timerWingBuffetFlamegor:Start()
	elseif args:IsSpellID(22539) and self:IsInCombat()  then	--Shadowflame Flamegore Warning and Timer
		timerShadowFlameFlamegor:Start()
		warnShadowFlameFlamegor:Show()
	elseif args:IsSpellID(23339) and self:IsInCombat() then	--wing buffet Firemaw Warning and Timer
		warnWingBuffetFiremaw:Show()
		timerWingBuffetFiremaw:Start()
	elseif args:IsSpellID(22539) and self:IsInCombat()  then	--Shadowflame Firemaw Warning and Timer
		timerShadowFlameFiremaw:Start()
		warnShadowFlameFiremaw:Show()
	elseif args:IsSpellID(23339) and self:IsInCombat() then	--wing buffet Ebonroc Warning and Timer
		warnWingBuffetEbonroc:Show()
		timerWingBuffetEbonroc:Start()
	elseif args:IsSpellID(22539) and self:IsInCombat()  then	--Shadowflame Ebonroc Warning and Timer
		timerShadowFlameEbonroc:Start()
		warnShadowFlameEbonroc:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(23342)  then		--Flamegore Enrage Warning and Timer
		warnEnrageFlamegor:Show()
		timerEnrageNextFlamegor:Start()
	elseif args:IsSpellID(23341)  then	--Firemaws Buffet Warning and Timer
		warnFlameBuffet:Show()
		timerFlameBuffetCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(23340) then 		--Shadow of Ebonroc Debuff Timer
		warnShadowEbonroc:Show(args.destName)
		timerShadowEbonroc:Start(args.destName)
	elseif args:IsSpellID(100348) then					--Immolate applied show warning and
		timerImmolate:Start(args.destName)				--start timer
		timerBlastwave:Start(args.destName)
		warnImmolate:Show(args.destName)
		if self.Options.SetIconOnBombTarget then		--IF option is set Skull is set on Immolate owner.
			self:SetIcon(args.destName, 8, 8)
			end
		if args:IsPlayer() then
			specwarnImmolate:Show()						--DBM Warning on Player with Immolate 
			DBM.RangeCheck:Show(10)
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)				--Blastwave every 3 Sec resets the Blastwave Timer
	if args:IsSpellID(100349) then
		timerBlastwave:Start(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(23340) then 		-- IF Ebonroc casts his Debuff
		timerShadowEbonroc:Cancel(args.destName)
	elseif args:IsSpellID(100348) then 					-- IF immolate is removed hide Rangecheck
		if args:IsPlayer() then
			DBM.RangeCheck:Hide()
		end
	end
end
