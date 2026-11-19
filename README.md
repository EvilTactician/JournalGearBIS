# Journal: Gear 0.2.8

> [!WARNING]
> **Early alpha (version 0.2.8-alpha).** Journal: Gear is in active development and isn't ready for a
> live realm or a proper playthrough yet. Expect missing pieces, rough edges and lists that change between
> versions. Only **Rogue**, **Priest** and **Druid** have hand-picked lists so far; every other class runs on stat
> weights alone. The full version (1.0) is coming soon.

<div align="center">

![Interface Version](https://img.shields.io/badge/Interface-30300-blue)
![WoW Version](https://img.shields.io/badge/WoW-3.3.5a-orange)
[![Version](https://img.shields.io/badge/Version-0.2.8-green)](https://github.com/EvilTactician/JournalGearBIS)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

**A World of Warcraft 3.3.5a addon that adds a Gear tab to [mod-forever-journal](https://github.com/EvilTactician/wow-mod-forever-journal), for realms
running [mod-individual-progression](https://github.com/Grimfeather/mod-individual-progression).**

</div>

It tells you which gear to aim for, so you never have to look it up. For your spec, every slot shows up to
three steps from what you're wearing:

- **Now**: what you can get now. Where there is one, an easy item comes first (a quest reward, a crafted
  piece, or a dungeon drop that comes often), then the best you can get.
- **Next**: the one upgrade that opens next, such as the next raid at your progression stage.
- **BiS**: the slot's best in slot in Classic.

Once you have the best you can get, the slot says **Best you can get now**, and if nothing in Classic beats
what you're wearing, it says **Best in Slot until The Burning Crusade**.

## Enchants, glyphs and consumables

- **Enchants:** next to what you wear in a slot, a small icon shows the best enchant for it. Its frame is
  **green** when you have it, **yellow** when a better one is there to get, **red** when there's no
  enchant and one is worth putting on, and **grey** when only a locked one beats what you have. Its tooltip
  says what's on it now, the best you can get and exactly how: the enchanter's recipe and where it comes
  from, an arcanum's quest, a reputation and standing, the stage that opens it. When the best needs a raid,
  it also names the best you can get **before raids**, and when the best opens later, the **next** step on
  the way (Lesser Arcanum of Voracity at level 50 before Death's Embrace).
- **Stat caps** count: past the hit cap (and expertise and armor penetration caps), more of that stat is
  worth nothing, so an enchant that gives it loses out.
- **Glyphs:** at the bottom of the list, the three major and three minor glyphs for your spec, best first:
  the best you can use, never the same glyph twice. The ones you have count whichever socket they're in;
  a missing one says which weaker glyph of yours to swap out. A slot you haven't opened yet says **Requires level N** in red.
  Glyphs that need a talent you don't have give way to the next, with a note naming the talent. During
  Classic, Inscription stops at 300, so glyphs that need more open at a later stage.
- **Recommended consumables:** a row of icons at the top: the potions, elixirs, food, poisons and oils for
  your spec. Hover one for how to get it now (and, for poisons, which hand it goes on). Elixirs say which
  others they don't stack with: one battle and one guardian elixir at a time, and a flask counts as both. If you're an
  engineer, an Engineering icon at the end lists the explosives only engineers can use.
- **Profession gear:** gear only a profession can wear, such as Engineering goggles, only shows when you
  have the profession at the skill it needs, and only when it's clearly better than what you can get
  otherwise: it's often costly and hard to make.

Glyphs and consumables are hand-picked, so for now they're there for **Rogue**, **Priest** and **Druid**.

- **Talent builds (with DragonUI):** a book icon at the end of the title saves a level 80 talent build for
  your spec to DragonUI's talent builds, named "GearBIS: …" so you can tell where it came from. There you
  can follow it as a plan; below level 80, spend your points along it as far as they go. The builds are
  the first ones Warcraft Tavern's Wrath guides list for each spec (Combat and Balance picked by hand from
  its calculator), checked against the realm's own talent trees. Clicking again doesn't make a duplicate, but a copy you've renamed or changed is left alone, and
  the next click saves a fresh one. The icon only shows with a DragonUI that lets other addons save builds.

## On your gear list: Roll Need

Anywhere in the game, an item's tooltip says **On your gear list: Roll Need** when it's a clear upgrade
for your spec: in a loot window, a Need or Greed roll, a chat link, a vendor or the auction house. That
includes items the list doesn't show as a step, so a good drop is never missed, and raid tokens (tier
tokens, Head of Onyxia), which also say what to exchange them for. The line doesn't show for items you
own (worn or in your bags), for anything no better than what you have, or before level 55.

At the top, **Where to go next** names the two dungeons with the most upgrades for you right now, two more
that are also good, and the raid with the most (Upper Blackrock Spire counts as a raid). Each says how many
upgrades it has and how many of them are on your list; hover over one to see the items, or click it to open
it in the Journal. Dungeon names are blue and raid names purple, here and on every source line. They're
weighted by how big the upgrades are and how often they drop, with the items your list shows counting most
(hand-picked ones a little more), and an empty slot measured against the best you can get now.

Every step shows where it comes from, how likely it is to drop (*about 1 in 5 runs*), and whether that's
**Easy**, **Medium** or **Hard**. A quest that's part of a chain says so and names the quest it starts
with. Clicking a step:

- **A drop** opens that boss's loot in the Journal.
- **A quest** opens it in the Journal's Quests tab, with its chain.
- If the Quests tab doesn't list it, **a dungeon or raid quest** opens that instance's quests instead,
  and **any other quest** marks where its chain starts on your map, and says so in chat. A chain your
  class trainer (or several quest givers) starts has nothing to mark: the step says who to talk to.

Each step's tooltip says which of these a click does. Shift-click links the item; Ctrl-click tries it on.

Open it with `/gear` (or `/bis`), or from the Journal's tabs (next to Progression).

## Screenshots

Screenshots are coming soon.

## What each step shows

| Status | Meaning |
| --- | --- |
| **Now** | You can get it now. |
| **Next** | The upgrade that opens next. |
| **Soon** | It's open at your stage, but you're not the level for it yet. |
| **BiS** | The slot's best in slot: Best in Slot until The Burning Crusade. |
| Equipped | You're wearing it. |
| **+N%** | How much better than what you have it is, for your spec. |
| new | You have nothing in that slot yet. |
| In your bags: wear it | You already own it. |
| Opens with *raid* (Stage *N*) / Opens at Stage *N* | Your progression stage keeps it locked until that stage. |
| Requires level *N* | You, or its quest, need a higher level. |
| Easy / Medium / Hard | How easy it is to get: quest rewards are easy; drops go by how often they drop. |

A slot's header shows what you wear there and how many upgrades you can get now, **Best you can get now**
when the rest are locked, or **Best in Slot until The Burning Crusade** when nothing beats it.

**Rings and trinkets** come in twos and are mostly unique, so their header shows both you wear, and their
list can have up to five steps: two you can get now, the one that opens next, and the two best in slot.
They're compared with the weaker of the two you wear, so an upgrade over either counts.

## Which list you see

The list follows your **active talents**: the tree you've put the most points in picks the spec, and the
weapons that go with it (a Combat rogue gets swords and maces, Assassination and Subtlety get daggers),
leaning toward the right speed for each hand (a slow main hand and quick off hand for Combat, a quick
off-hand dagger for the others).
With no talent points spent yet, the list asks you to assign them and shows a typical list for your
class meanwhile (Combat for a rogue).

**Other lists:** the spec in the title ("Classic gear: **Combat** ▾ Rogue") is a button. Click it for any
of your class's lists, with the one your talents pick marked; with **dual spec** it also offers your other
talents' list, compared with what you're wearing now (probably your active spec's gear). Feral druids get
Feral (cat) and Feral (bear) as two lists; one with the Natural Reaction talent gets the bear list by
default, since only tanks take it. The list you picked stays picked until you pick another.

**Weapons that suit the role:** a melee or tank list never offers a caster's weapon (intellect and spell
power with no fighting stats), however much damage it does. The weapon row says **Two-hand** when the list
only has two-handers, which is why there's no off-hand row then, and the ranged row says
**Relic** or **Wand** for the classes that use those. When a caster's main hand mixes the two, each step
says whether it's a two-hander or a one-hander that goes with an off-hand, the off-hand row says it's
"With a one-hander only", and a two-hander as best in slot (Atiesh) comes with the best one-hander too, so
the off-hand row keeps going until you have the staff. The better of the two in the end (the two-hander, or
the one-hander with the best off-hand) says "the better choice". The list follows what you wear: with a one-hander on, the
off-hand row stays even when the only upgrade left is a two-hander; with the two-hander on, it goes.

**Feral weapons:** in Cat and Bear Form a weapon's damage doesn't count, but the realm turns any weapon's
damage past 54.8 per second into feral attack power (14 for each point above it). Only two-handers get
there, so a feral druid's list shows two-handed weapons only, with no off-hand.

Steps are compared with what you **wear and carry** in your bags. Quest chains are the ones your faction
starts.

## Expansions

Each list covers levelling through its expansion and that expansion's level cap.

| Your level | List |
| --- | --- |
| up to 60 | Classic (this version) |
| 61 to 70 | The Burning Crusade (a later update) |
| 71 to 80 | Wrath of the Lich King (a later update) |

Reaching 61 means you've moved on to Outland (mod-individual-progression keeps you at 60 until then), so
Classic gear stops being the goal. Anyone still after Classic gear is at 60 and sees the Classic list.

You can open the list at any level. Below level 55 (65, 75 for the later lists) it's a **preview**: the
list as it will be at the level cap, at your progression stage, so you can see what you're working
towards, each step you're not the level for marked **Soon** and *Requires level N*. From 55 it compares with what you're wearing, and
suggests dungeons near your level.

In Classic, your progression stage decides which raids are open: Molten Core from the start, then Onyxia
(stage 1), Blackwing Lair (2), Zul'Gurub (3), Ahn'Qiraj (4) and Naxxramas (6). When the Journal gives a
different stage for a raid on your realm, the tab uses the realm's.

## How the lists are made

**Hybrid**: hand-picked best-in-slot items, filled in by stat weights from your realm's own data.

- **Where items come from** was worked out from the realm's world database: AzerothCore's tables with
  mod-individual-progression's Classic item and loot changes applied. That covers boss and chest loot
  (with drop chances, all of an instance's bosses counted together), quest rewards and vendors. Quest
  rewards follow the module's stage gating (Dungeon Set 2 opens at stage 3, the Scourge Invasion at 6, and
  so on). Rewards for raid tokens, such as the tier 2.5 and 3 sets and Head of Onyxia's rewards, count as
  part of that raid. Rewards behind world bosses, the Darkmoon Faire or battlegrounds are left out, and so is
  anything only a world event brings (the Darkmoon Faire's vendors, the Scourge Invasion's bosses).
- **Odd ways to get things** count too: bosses the realm summons rather than spawns (Gyth, and the six that
  take turns in Blackrock Depths' Ring of Law, each counted as a sixth of a chance), quests that need
  something skinned (Breastplate of Bloodthirst, which only shows for skinners, counting skill from gear
  like Finkle's Skinner), and, for hand-picked items
  with no other way to get them, random world drops (Idol of the Moon), marked Easy, Medium or Hard by how
  many kills they take.
- **Things to know** before you go are on the source line and in the tooltip: bosses you have to summon
  (Lord Valthalak's Brazier of Beckoning, say), ones that take turns (the Ring of Law, Zul'Gurub's Edge of
  Madness), gear whose use effect only works so many times, and the odd item that needs explaining
  (Breastplate of Bloodthirst's Skinning 310). The data build names any summoned boss without a note.
- **Item stats**, including the *Equip:* lines (attack power, crit, hit, spell power and the rest), come
  from the item table and the client's Spell.dbc.
- **Stat weights** for every spec are in `Profiles.lua`.
- **Hand-picked items** in `Curated.lua` win their raid or dungeon step over the stat-weighted pick. In
  this alpha they cover **Rogue** (swords and maces, and daggers), **Priest** (Holy and Discipline, and
  Shadow) and **Druid** (Balance, Feral cat, Feral bear and Restoration).

## Versions

| Version | What's in it |
| --- | --- |
| 0.1.0 to 0.1.8-alpha | Classic lists for every spec, hand-picked items for Rogue and Priest; Now, Soon, Next and BiS steps; a preview below level 55; Where to go next; "On your gear list: Roll Need" on item tooltips; quests open in the Journal. |
| 0.1.9 to 0.1.13-alpha | Enchants for what you wear (with a pre-raid step), glyphs and consumables for Rogue and Priest, stat caps, Engineering gear. |
| 0.1.14 to 0.1.19-alpha | Rogue and Priest lists re-checked against current Classic guides and the realm. |
| 0.2.0-alpha | Rogue and Priest finished: weapon speeds, spec poisons, which elixirs stack, glyph swaps, and a way up from dungeons through Upper Blackrock Spire to the big raids. |
| 0.2.1 to **0.2.8-alpha** (now) | Druid: hand-picked lists, glyphs and consumables for Balance, Feral (cat and bear) and Restoration; feral attack power from weapons; world drops, Ring of Law bosses and skinning quests; level 80 talent builds saved to DragonUI. |
| 0.3.0-alpha | Druid finished. |
| 0.4.0-alpha and on | One more class's hand-picked lists in each version. |
| **1.0.0** | The full Classic version: every class's lists worked out. |
| later updates | The Burning Crusade lists, then Wrath of the Lich King. |

## Requirements

- **[mod-forever-journal](https://github.com/EvilTactician/wow-mod-forever-journal)** (my fork): the Journal addon on your client and the module on the realm. This fork is
  required: the tab builds on hooks only it has, such as opening a quest in the Quests tab. The tab gets
  your progression stage, each raid's stage on your realm, and the boss and quest pages it opens from it.
- **[mod-individual-progression](https://github.com/Grimfeather/mod-individual-progression)** on the
  realm. Without it, every raid counts as open.
- **[DragonUI](https://github.com/EvilTactician/wow-addon-DragonUI)** (my fork), recommended: the tab is
  built and tested with it. It may well work without, but if something looks out of place, that's why.
  Saving talent builds needs it.

Nothing needs installing on the server beyond those two modules.

## Installation

**[Download the latest version](https://github.com/EvilTactician/JournalGearBIS/archive/refs/heads/main.zip)**

1. Open the downloaded `JournalGearBIS-main.zip`. Inside is a folder called `JournalGearBIS-main`, and
   inside that is the `JournalGearBIS` folder: that's the one you need. The outer folders are just
   GitHub's packaging, and `tools` is only for regenerating the data.
2. Copy that inner `JournalGearBIS` folder into `World of Warcraft\Interface\AddOns`. It must keep that
   exact name, so `Interface\AddOns\JournalGearBIS\JournalGearBIS.toc` is where the files end up, not
   inside a `JournalGearBIS-main` folder.
3. Make sure **Journal** is installed and enabled.
4. Restart the game. A `/reload` isn't enough the first time, because the game only finds new addons
   when it starts.

## Customising

- **`Curated.lua`**: the hand-picked items for each spec. Add an item ID to a spec's list and it wins its
  step. `{ 11815, 45 }` also gives an item whose strength is a proc or use effect (Hand of Justice) a
  value, in the spec's own units.
- **`Profiles.lua`**: what each stat is worth to each spec, and which weapons it uses.
- **`Data.lua`** and **`Extras.lua`**: generated from the realm's database; don't edit them by hand.
  Regenerate them with the tools below. Glyphs, consumables and proc enchants' values are hand-picked in
  `tools/curated.py`.

## Regenerating the data (tools)

`tools/` builds `Data.lua`, `Extras.lua`, `Profiles.lua` and `Curated.lua` from AzerothCore's world database and
mod-individual-progression's SQL. If you regenerate, edit `profiles.py` and `curated.py` there rather than
the Lua copies. You need Python 3 and:

- the `data/sql/base/db_world` folder of [azerothcore-wotlk](https://github.com/azerothcore/azerothcore-wotlk)
  (set `GEARBIS_AC` to it)
- the `data/sql/world/base` folder of mod-individual-progression (`GEARBIS_MOD`)
- these DBC files: `python3 tools/rangezip.py <file>` fetches just that file from AzerothCore's
  client-data release

```
for f in Spell AreaTable SpellItemEnchantment SkillLineAbility GlyphProperties; do python3 tools/rangezip.py $f.dbc; done
python3 tools/sqlload.py     # a few minutes: loads the tables and applies the module's changes
python3 tools/extract.py     # where every item comes from
python3 tools/gen.py         # writes the Lua files into JournalGearBIS/
```

## Things to know

- **Stat weights are rules of thumb.** Hand-picked items fix the cases weights get wrong (set bonuses,
  procs). For classes without hand-picked items yet, the list is a good stat-for-stat path rather than a
  theorycrafted one.
- **Crafted gear** comes from hand-picked items (Devilsaur, Truefaith Vestments, Hide of the Wild) and
  profession gear (Engineering goggles); other crafted gear isn't on the lists yet. Crafted gear that binds
  on pickup (Truefaith Vestments, Robe of the Void) only shows for a crafter of that profession.
- **Consumables found only in the open world** (Winterfall Firewater) have a note in place of a source:
  only instance drops, quests, vendors and crafting are worked out.
- **Random-enchant items** you wear ("of the Monkey") are read from their tooltip, in English.
- **Bank items** aren't checked, only your bags.
- **Realm settings** aren't visible to an addon, such as `AllowEarlyDungeonSet2`. The lists assume
  mod-individual-progression's defaults.
- **Journal updates:** the tab uses the Journal's widgets and data functions, so a large Journal update
  may need a matching update here.

## Credits

- [mod-individual-progression](https://github.com/Grimfeather/mod-individual-progression), the
  progression stages and the Classic item and loot changes.
- [AzerothCore](https://www.azerothcore.org/) for the world database the item sources come from.
