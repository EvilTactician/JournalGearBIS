# Journal: Gear

> [!WARNING]
> **Early alpha (version 0.1.0-alpha).** Journal: Gear is in active development and isn't ready for a
> live realm or a proper playthrough yet. Expect missing pieces, rough edges and lists that change between
> versions. Only **Rogue** and **Priest** have hand-picked lists so far; every other class runs on stat
> weights alone. The full version (1.0) is coming soon.

A World of Warcraft 3.3.5a addon that adds a **Gear** tab to the
[Journal](https://github.com/buildthehomelab/wow-mod-forever-journal) (mod-forever-journal), for realms
running [mod-individual-progression](https://github.com/Grimfeather/mod-individual-progression).

It tells you which gear to aim for, so you never have to look it up. For your spec, every slot shows a
short path from what you're wearing to the best item there is:

- **An easy item first** where there is one: a quest reward, a crafted piece, or a dungeon drop that comes
  often.
- **The best from dungeons** (pre-raid best in slot).
- **Each raid's best** as the raids open to you.

Only steps you can get **now** are listed. When that leaves fewer than three, the next locked one is added,
so you can see what's coming. Once you have the best you can get, the slot says so, and if nothing in
Classic beats what you're wearing, it says **Best in slot until The Burning Crusade**.

At the top, **Where to go next** names the dungeon with the most upgrades for you right now, a second
choice, and the raid with the most. Each is weighted by how big the upgrades are and how often they drop.

Every step shows where it comes from, how likely it is to drop (*about 1 in 5 runs*), and whether that's
**Easy**, **Medium** or **Hard**. Click a step to open that boss's loot in the Journal (for a quest, the
quest giver on your map). Shift-click links the item; Ctrl-click tries it on.

Open it with `/gear` (or `/bis`), or from the Journal's tabs (next to Progression).

## Screenshots

Screenshots are coming soon.

## What each step shows

| Status | Meaning |
| --- | --- |
| **+N%** | How much better than what you have it is, for your spec. |
| new | You have nothing in that slot yet. |
| In your bags: wear it | You already own it. |
| **Next** | Locked for now, shown so you know what comes after the steps you can take. |
| Opens with *raid* | Your progression stage keeps that raid closed. |
| Needs level *N* | You can't wear it yet. |
| (BiS pick) | A hand-picked best-in-slot item for your spec, rather than a stat-weighted pick. |
| Easy / Medium / Hard | How easy it is to get: quest rewards are easy; drops go by how often they drop. |

A slot's header shows what you wear there and how many upgrades you can get now, **Best you can get now**
when the rest are locked, or **Best in slot until The Burning Crusade** when nothing beats it. Rings and
trinkets are compared with the weaker of the two you wear.

## Which list you see

The list follows your **active talents**: the tree you've put the most points in picks the spec. A rogue's
list follows the weapon in their main hand (daggers, or swords and maces). With **dual spec**, the menu at
the top right shows your other talents' list too; that one is compared with what you're wearing now,
which is probably your active spec's gear. You can also pick any role your class has, such as Feral (bear)
instead of Feral (cat).

Steps are compared with what you **wear and carry** in your bags.

## Expansions

Each list covers levelling through its expansion and that expansion's level cap.

| Your level | List |
| --- | --- |
| up to 60 | Classic (this version) |
| 61 to 70 | The Burning Crusade (a later update) |
| 71 to 80 | Wrath of the Lich King (a later update) |

Reaching 61 means you've moved on to Outland (mod-individual-progression keeps you at 60 until then), so
Classic gear stops being the goal. Anyone still after Classic gear is at 60 and sees the Classic list.

You can open the list at any level. While levelling, it lists what you can wear now from level 45 or so,
with locked items shown as *Needs level N*, and suggests dungeons near your level.

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
| **0.1.0-alpha** (now) | Classic lists for every spec; hand-picked items for Rogue and Priest. |
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
