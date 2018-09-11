--- ============================ HEADER ============================
-- HeroLib
local HL = HeroLib;
local Cache = HeroCache;
local Unit = HL.Unit;
local Player = Unit.Player;
local Pet = Unit.Pet;
local Target = Unit.Target;
local Spell = HL.Spell;
local Item = HL.Item;
local SpellMeleeRange = HL.Enum.SpellMeleeRange
-- HeroRotation
local HR = HeroRotation;
-- Spells
local SpellBlood = Spell.DeathKnight.Blood;
local SpellFrost = Spell.DeathKnight.Frost;
local SpellUnholy = Spell.DeathKnight.Unholy;
-- Lua

--- ============================ CONTENT ============================
local function DeathStrikeHeal(Spell)
  local should_heal = (Settings.General.SoloMode and Player:HealthPercentage() < Settings.DeathKnight.Commons.UseDeathStrikeHP) and true or false;
  if should_heal then
    if Spell == SpellFrost.GlacialAdvance or Spell == SpellFrost.FrostStrike or Spell == SpellUnholy.DeathCoil or Spell == SpellUnholy.Epidemic then
      return true;
    end
  else
    if Spell == SpellFrost.DeathStrike or Spell == SpellUnholy.DeathStrike then
      return true;
    end
  end
end

-- Blood, ID: 250

-- Frost, ID: 251
local FrostSpellIsCastableP
FrostSpellIsCastableP = HL.AddCoreOverride("Spell.IsCastableP",
  function(self, Range, AoESpell, ThisUnit, BypassRecovery, Offset)
    -- keep runic power for healing if you are in solomode and at low health
    if DeathStrikeHeal(self) then
      return false;
    end
    -- Check for ranges
    if Settings.DeathKnight.Commons.InRange then
      if self == SpellFrost.HowlingBlast then
        Range = 30;
        AoESpell = true;
      elseif self == SpellFrost.Obliterate then
        Range = "Melee";
      elseif self == SpellFrost.ChainsOfIce then
        Range = 30;
      end
    end

    return FrostSpellIsCastableP(self, Range, AoESpell, ThisUnit, BypassRecovery, Offset);
  end, 251);

local FrostSpellIsReadyP
FrostSpellIsReadyP = HL.AddCoreOverride("Spell.IsReadyP",
  function(self, Range, AoESpell, ThisUnit)
    -- keep runic power for healing if you are in solomode and at low health
    if DeathStrikeHeal(self) then
      return false;
    end
    -- Check for ranges
    if Settings.DeathKnight.Commons.InRange then
      if self == SpellFrost.FrostStrike then
        Range = 13;
      elseif self == SpellFrost.DeathStrike then
        Range = "Melee";
      end
    end

    return FrostSpellIsReadyP(self, Range, AoESpell, ThisUnit);
  end, 251);

-- Unholy, ID: 252
local UnholySpellIsCastableP
UnholySpellIsCastableP = HL.AddCoreOverride("Spell.IsCastableP",
  function(self, Range, AoESpell, ThisUnit, BypassRecovery, Offset)
    -- keep runic power for healing if you are in solomode and at low health
    if DeathStrikeHeal(self) then
      return false;
    end
    -- Check for ranges
    if Settings.DeathKnight.Commons.InRange then
      if self == SpellUnholy.Outbreak then
        Range = 30;
      elseif self == SpellUnholy.Obliterate then
        Range = "Melee";
      elseif self == SpellUnholy.ScourgeStrike then
        Range = "Melee";
      elseif self == SpellUnholy.ClawingShadows then
        Range = "Melee";
      elseif self == SpellUnholy.FesteringStrike then
        Range = "Melee";
      elseif self == SpellUnholy.SoulReaper then
        Range = "Melee";
      elseif self == SpellUnholy.Apocalypse then
        Range = "Melee";
      end
    end

    return UnholySpellIsCastableP(self, Range, AoESpell, ThisUnit, BypassRecovery, Offset);
  end, 252);

local UnholySpellIsReadyP
UnholySpellIsReadyP = HL.AddCoreOverride("Spell.IsReadyP",
  function(self, Range, AoESpell, ThisUnit)
    -- keep runic power for healing if you are in solomode and at low health
    if DeathStrikeHeal(self) then
      return false;
    end
    -- Check for ranges
    if Settings.DeathKnight.Commons.InRange then
      if self == SpellUnholy.DeathCoil then
        Range = 30;
      elseif self == SpellUnholy.Epidemic then
        Range = 30;
        AoESpell = true
      elseif self == SpellUnholy.DeathStrike then
        Range = "Melee";
      end
    end

    return UnholySpellIsReadyP(self, Range, AoESpell, ThisUnit);
  end, 252);
