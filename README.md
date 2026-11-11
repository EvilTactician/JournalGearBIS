# Journal: Gear

> [!WARNING]
> **Early alpha (version 0.1.5-alpha).** Journal: Gear is in active development and isn't ready for a
> live realm or a proper playthrough yet. Expect missing pieces, rough edges and lists that change between
> versions. Only **Rogue** and **Priest** have hand-picked lists so far; every other class runs on stat
> weights alone. The full version (1.0) is coming soon.

A World of Warcraft 3.3.5a addon that adds a **Gear** tab to the
[Journal](https://github.com/buildthehomelab/wow-mod-forever-journal) (mod-forever-journal), for realms
running [mod-individual-progression](https://github.com/Grimfeather/mod-individual-progression).

It tells you which gear to aim for, so you never have to look it up. For your spec, every slot shows up to
three steps from what you're wearing:

- **Now**: what you can get now. Where there is one, an easy item comes first (a quest reward, a crafted
  piece, or a dungeon drop that comes often), then the best you can get.
- **Next**: the one upgrade that opens next, such as the next raid at your progression stage.
- **BiS**: the slot's best in slot in Classic.

Once you have the best you can get, the slot says **Best you can get now**, and if nothing in Classic beats
what you're wearing, it says **Best in Slot until The Burning Crusade**.

## On your gear list: Roll Need

Anywhere in the game, an item's tooltip says **On your gear list: Roll Need** when it's a clear upgrade
for your spec: in a loot window, a Need or Greed roll, a chat link, a vendor or the auction house. That
includes items the list doesn't show as a step, so a good drop is never missed, and raid tokens (tier
tokens, Head of Onyxia), which also say what to exchange them for. The line doesn't show for items you
own (worn or in your bags), for anything no better than what you have, or before level 55.

At the top, **Where to go next** names the five-player dungeon with the most upgrades for you right now, a
second choice, and the raid (or larger group instance, such as Upper Blackrock Spire) with the most. Each
line says what it is and how many players it takes, and how many of its upgrades are on your list. They're
weighted by how big the upgrades are and how often they drop, with the items your list shows counting
most.

Every step shows where it comes from, how likely it is to drop (*about 1 in 5 runs*), and whether that's
**Easy**, **Medium** or **Hard**. A quest that's part of a chain says so and names the quest it starts
with. Clicking a step:

- **A drop** opens that boss's loot in the Journal.
- **A dungeon or raid quest** opens that instance's quests in the Journal, chain and all.
- **Any other quest** marks where its chain starts on your map, and says so in chat. A chain your class
  trainer (or several quest givers) starts has nothing to mark: the step says who to talk to instead.

Each step's tooltip says which of these a click does. Shift-click links the item; Ctrl-click tries it on.

Open it with `/gear` (or `/bis`), or from the Journal's tabs (next to Progression).

## Screenshots

Screenshots are coming soon.

## What each step shows

| Status | Meaning |
| --- | --- |
| **Now** | You can get it now. |
| **Next** | The upgrade that opens next. |
| **BiS** | The slot's best in slot: Best in Slot until The Burning Crusade. |
| Equipped | You're wearing it. |
| **+N%** | How much better than what you have it is, for your spec. |
| new | You have nothing in that slot yet. |
| In your bags: wear it | You already own it. |
| Opens with *raid* (Stage *N*) / Opens at Stage *N* | Your progression stage keeps it locked until that stage. |
| Available at level *N* | You, or its quest, need a higher level. |
| Easy / Medium / Hard | How easy it is to get: quest rewards are easy; drops go by how often they drop. |

A slot's header shows what you wear there and how many upgrades you can get now, **Best you can get now**
when the rest are locked, or **Best in Slot until The Burning Crusade** when nothing beats it.

**Rings and trinkets** come in twos and are mostly unique, so their header shows both you wear, and their
list can have up to five steps: two you can get now, the one that opens next, and the two best in slot.
They're compared with the weaker of the two you wear, so an upgrade over either counts.

## Which list you see

The list follows your **active talents**: the tree you've put the most points in picks the spec, and the
weapons that go with it (a Combat rogue gets swords and maces, Assassination and Subtlety get daggers).
With no talent points spent yet, the list asks you to assign them and shows a typical list for your
class meanwhile (Combat for a rogue). The menu at the top right only appears when there's a choice to make: with **dual spec** it shows your
other talents' list, compared with what you're wearing now (probably your active spec's gear), and a
druid can pick Feral (bear) instead of Feral (cat).

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
towards, each step marked *Available at level N*. From 55 it compares with what you're wearing, and
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
  part of that raid. Rewards behind world bosses, the Darkmoon Faire or battlegrounds are left out.
- **Item stats**, including the *Equip:* lines (attack power, crit, hit, spell power and the rest), come
  from the item table and the client's Spell.dbc.
- **Stat weights** for every spec are in `Profiles.lua`.
- **Hand-picked items** in `Curated.lua` win their raid or dungeon step over the stat-weighted pick. In
  this alpha they cover **Rogue** (swords and maces, and daggers) and **Priest** (Holy and Discipline, and
  Shadow).

## Versions

| Version | What's in it |
| --- | --- |
| 0.1.0-alpha | Classic lists for every spec; hand-picked items for Rogue and Priest. |
| 0.1.1-alpha | Get / Next / BiS steps, a preview below level 55, quest chains and levels, clearer clicks. |
| 0.1.2-alpha | Quest chains for your faction, raid tiers on locked steps, your gear shown in the preview. |
| 0.1.3-alpha | Stages instead of tiers, "Available at level N" in the preview, tidier source lines. |
| 0.1.4-alpha | "On your gear list: Roll Need" on item tooltips everywhere, Now / Next / BiS labels. |
| **0.1.5-alpha** (now) | Two rings and trinkets, clearer dungeon advice, no-talents note, tooltip line last. |
| 0.x alphas | Hand-picked lists for the other classes, and fixes from playtesting. |
| **1.0.0** | The full Classic version: every class's lists worked out. |
| later updates | The Burning Crusade lists, then Wrath of the Lich King. |

## Requirements

- **[mod-forever-journal](https://github.com/buildthehomelab/wow-mod-forever-journal)**: the Journal
  addon on your client and the module on the realm. The tab gets your progression stage, each raid's
  stage on your realm, and the boss pages it opens from it. It also works with
  [EvilTactician's fork](https://github.com/EvilTactician/wow-mod-forever-journal), which has extra
  bugfixes.
- **[mod-individual-progression](https://github.com/Grimfeather/mod-individual-progression)** on the
  realm. Without it, every raid counts as open.

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
- **`Data.lua`**: generated from the realm's database; don't edit it by hand. Regenerate it with the
  tools below.

## Regenerating the data (tools)

`tools/` builds `Data.lua`, `Profiles.lua` and `Curated.lua` from AzerothCore's world database and
mod-individual-progression's SQL. If you regenerate, edit `profiles.py` and `curated.py` there rather than
the Lua copies. You need Python 3 and:

- the `data/sql/base/db_world` folder of [azerothcore-wotlk](https://github.com/azerothcore/azerothcore-wotlk)
  (set `GEARBIS_AC` to it)
- the `data/sql/world/base` folder of mod-individual-progression (`GEARBIS_MOD`)
- `Spell.dbc`: `python3 tools/rangezip.py Spell.dbc` fetches just that file from AzerothCore's
  client-data release

```
python3 tools/rangezip.py Spell.dbc
python3 tools/sqlload.py     # a few minutes: loads the tables and applies the module's changes
python3 tools/extract.py     # where every item comes from
python3 tools/gen.py         # writes the Lua files into JournalGearBIS/
```

## Things to know

- **Stat weights are rules of thumb.** Hand-picked items fix the cases weights get wrong (set bonuses,
  procs). For classes without hand-picked items yet, the list is a good stat-for-stat path rather than a
  theorycrafted one.
- **Crafted items** aren't in the world database, so only hand-picked ones show up (Devilsaur, Truefaith
  Vestments, Hide of the Wild).
- **Random-enchant items** you wear ("of the Monkey") are read from their tooltip, in English.
- **Bank items** aren't checked, only your bags.
- **Realm settings** aren't visible to an addon, such as `AllowEarlyDungeonSet2`. The lists assume
  mod-individual-progression's defaults.
- **Journal updates:** the tab uses the Journal's widgets and data functions, so a large Journal update
  may need a matching update here.

## Credits

- [mod-forever-journal](https://github.com/buildthehomelab/wow-mod-forever-journal), the Journal this
  tab lives in.
- [mod-individual-progression](https://github.com/Grimfeather/mod-individual-progression), the
  progression stages and the Classic item and loot changes.
- [AzerothCore](https://www.azerothcore.org/) for the world database the item sources come from.
