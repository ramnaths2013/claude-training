---
project: IT PMO Board
register: product
aesthetic_direction: organic / natural (wabi-sabi)
color_strategy: restrained
design_system: bespoke   # CLAUDE.md forbids frameworks and external resources; vanilla CSS custom properties only
design_variance: 6
motion_intensity: 2
visual_density: 6
---

# IT PMO Board: locked design language

Every screen must read as the same product if placed side by side.

## Design Read
Quiet, weathered and honest. A working board that feels like a well-used workshop table: calm ground, soft edges, one ink-blue voice. The bet is that restraint and slight imperfection read as trust for a banking PMO.

## Aesthetic direction and why it passes the tests
Wabi-sabi, filed under "organic / natural". The user asked for it by name, so two normally banned tells are used on purpose and justified here:
- **Light neutral ground.** The anti-slop list bans cream/sand/beige. The ground here is lime-plaster grey with a faint green cast (hue 113, chroma 0.009), clearly cooler than the `#F4F1EA` family, and tokens avoid the banned names (`--paper`, `--cream`, `--sand`, `--linen`).
- **A serif display face.** Justified by the Japanese mincho tradition, not by "creative brief means serif". It is used only for the wordmark, column titles and card titles.

Counterfactual test: a generic corporate kanban would be white cards on a blue header with a gradient. This is not that. Colour is almost absent, structure comes from space (ma), and the one memorable move is the ensō count (see Signature).

## Wabi-sabi principles mapped to the UI
| principle | what it means here |
|---|---|
| wabi (rustic simplicity) | no gradients, no shadows beyond one soft contact shadow, no glass |
| sabi (patina) | a faint paper grain on the ground, slightly uneven card corners |
| fukinsei (asymmetry) | card corner radii differ per corner (see Scales); header is left-weighted with generous empty right |
| kanso (simplicity) | one accent, three text tones, no decorative icons |
| ma (negative space) | gaps between columns are space, not boxes; columns have no border or fill |
| shibui (understated) | priority and state are carried by text first, colour second |

## Signature
**The open ensō.** Each column's task count sits inside an incomplete brushed circle (an inline SVG arc, about 300 degrees, stroke slightly thicker at the start). The gap in the ring is deliberate, the Japanese ideal of an imperfect, unfinished circle. The ring sweeps a little further as the column holds a larger share of all tasks (minimum 40 percent, maximum 92 percent so it never closes). The same ensō, smaller and unfilled, is the filter "clear" mark. Nothing else on the page is decorative.

## Inspiration
No reference links were given. DNA is taken from general wabi-sabi craft: lime plaster, sumi ink, indigo dye (aizome), kintsugi restraint. Rejected: tatami grids, cherry blossoms, red suns, brush-script fonts and any "Japanese-themed" clip art, all of which read as costume.

## Color (locked)
Neutrals are tinted toward the plaster green-yellow hue. 60-30-10 by weight: 60 ground and surfaces, 30 ink text, 10 indigo accent plus semantic.

| role | OKLCH | hex | use | contrast |
|------|-------|-----|-----|----------|
| ground (`--ground`) | oklch(0.92 0.009 113) | #E4E5DE | page background | base |
| surface (`--surface`) | oklch(0.95 0.008 114) | #EEEFE9 | header band, filter bar, modal ground | base |
| card (`--card`) | oklch(0.97 0.005 106) | #F6F6F2 | task cards, modal panel | base |
| line (`--line`) | oklch(0.84 0.012 117) | #C9CBC2 | hairlines, input borders | decorative only |
| text (`--sumi`) | oklch(0.27 0.010 261) | #23262B | body and titles | 11.97 on ground, 14.01 on card |
| muted (`--muted`) | oklch(0.45 0.011 258) | #52565C | secondary text, labels | 5.82 on ground, 6.81 on card |
| subtle (`--subtle`) | oklch(0.54 0.011 258) | #6A6E74 | counters, hints (never essential info) | 4.73 on card |
| accent (`--ai`, exactly one) | oklch(0.40 0.073 254) | #2B4A6F | primary button, links, focus ring, Medium priority | 7.16 on ground, 8.38 on card; 8.38 for #F6F6F2 text on it |
| danger (`--shu`) | oklch(0.50 0.152 29) | #A8362A | Critical, Overdue, delete confirm, errors | 6.01 on card, 5.13 on ground |
| warning (`--kaki`) | oklch(0.48 0.096 70) | #7F5210 | High priority text | 6.22 on card |
| warning edge (`--kaki-edge`) | oklch(0.63 0.126 70) | #B97A1E | High priority left edge only | 3.30 on card (UI edge, passes 3:1) |
| success (`--matsu`) | oklch(0.46 0.064 154) | #3A6348 | Done column mark, success toast | 6.34 on card |
| low (`--nezumi`) | oklch(0.59 0.010 258) | #7A7E84 | Low priority left edge | 3.77 on card |

Indigo keeps the original "corporate blue only" brief intact. Colour is never the only signal: every priority has a text pill, Overdue has a text badge.

## Type (locked)
No web fonts (CLAUDE.md). All faces are local system stacks, so `system-ui` is deliberately never first.

| role | family stack | use | notes |
|------|--------------|-----|-------|
| display (`--font-display`) | "Hiragino Mincho ProN", "Yu Mincho", "Noto Serif JP", "Iowan Old Style", "Palatino Linotype", Georgia, serif | wordmark, column titles, card titles, modal title | weight 500, tracking 0.02em, sentence case |
| body (`--font-body`) | "Hiragino Sans", "Yu Gothic UI", "Noto Sans JP", "Avenir Next", "Segoe UI", sans-serif | everything else | 14px, line-height 1.55, measure under 70ch |
| utility (`--font-mono`) | ui-monospace, "SF Mono", "Cascadia Mono", Consolas, monospace | task IDs, counters | 12px, tracking 0.04em |

Pairing axis: serif plus humanist sans, contrast in stroke and rhythm.
Scale (px): 11 (labels, uppercase with 0.08em tracking), 12, 14 (body), 16 (card title), 20 (column title), 26 (wordmark). Nothing else.

## Scales (locked)
- **spacing:** 4, 8, 12, 16, 24, 40, 64. Column gap is 40 on desktop (ma). Card inner padding 16.
- **radius:** `--r-1: 2px`, `--r-2: 6px`, `--r-3: 10px`. Cards use an uneven pair, `2px 6px 3px 8px`, the only asymmetry on the page. Controls use 2px. Pills use 999px.
- **elevation:** one value only, `0 1px 0 var(--line), 0 6px 14px -10px rgba(35,38,43,.35)`. No other shadows. Modal backdrop is flat `rgba(35,38,43,.45)`.
- **texture:** one inline SVG `feTurbulence` grain at 4 percent opacity on `body` as a data URI. No image files.
- **motion:** durations 120ms (hover, focus), 300ms (drop highlight, toast), 500ms (ensō sweep on load, once). Easing `cubic-bezier(.3,.7,.2,1)`. No bounce, no elastic. Everything honours `prefers-reduced-motion: reduce` by dropping to 0ms.
- **icon family:** none. Text and Unicode only (`×`, `▸`, `+`). The ensō is the only drawn mark.

## Voice
Plain, calm, short. No exclamation marks, no buzzwords, no em-dashes in visible text. Action vocabulary stays consistent: Add task, Added; Move, Moved; Delete, Deleted. Empty column text: "Nothing here yet." Errors say what to fix: "Choose a due date that is today or later."
