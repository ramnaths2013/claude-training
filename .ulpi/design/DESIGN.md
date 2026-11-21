---
project: IT PMO Mission Board
register: product
aesthetic_direction: retro-futuristic (LCARS-inspired console, unofficial Star Trek homage)
color_strategy: committed
design_system: bespoke   # CLAUDE.md forbids frameworks and external resources; vanilla CSS custom properties only
design_variance: 6
motion_intensity: 2
visual_density: 6
---

# IT PMO Mission Board: locked design language

Every screen must read as the same product if placed side by side.
This replaces the earlier wabi-sabi identity (still in git history, commit `72ce052`).

## Design Read
A bridge console for a bank's IT team: dark, calm, rounded, with coloured bars doing the structural work. The bet is that a playful theme still reads as a serious tool when contrast, labels and behaviour stay plain.

## Legal and IP stance
Unofficial fan-style homage. Original shapes, colours and wording only. No logos, Starfleet delta or other insignia, screenshots or official fonts. Generic vocabulary (stardate, red alert, subspace). The page footer and README carry a not-affiliated disclaimer.

## Signature
The **column header bar**: a coloured bar with a large rounded left cap, the column title and hint in dark ink, and a dark capsule on the right holding the real count plus a thin meter of the column's share of visible missions. The meter is decorative; the number is the signal.

## Color (locked, dark theme)
Contrast ratios computed against the surface they sit on (WCAG 2.x). All text pairs pass AA.
| role | hex | use | contrast |
|---|---|---|---|
| ground `--ground` | #090A12 | page | base |
| panel `--panel` | #12142A | cards, dialogs | base |
| panel-2 `--panel-2` | #1B1E3C | inputs, chips, bot messages | base |
| line `--line` | #2A2E55 | hairlines (decorative) | 1.4 |
| edge `--edge` | #6C70A8 | control borders | 3.48 on panel-2 |
| text `--text` | #ECEAFF | body | 16.7 ground, 15.3 panel, 13.7 panel-2 |
| muted `--muted` | #B0ADCF | secondary text | 9.1 ground, 8.4 panel, 7.5 panel-2 |
| subtle `--subtle` | #8E8BB0 | counters, placeholders | 5.6 panel |
| ink `--ink` | #0A0A14 | text on bars | 9.5 orange, 9.1 lavender, 8.4 periwinkle, 12.5 tan, 7.1 red |
| orange `--orange` (the one action colour) | #FF9C42 | primary button, Adrift column | 8.7 on panel |
| lavender / periwinkle / tan | #C9A0E8 / #8EA4FF / #E9C9A0 | other columns, labels | 8.4 / 7.7 / 11.5 on panel |
| red / yellow / violet | #FF6B6B / #FFC93C / #A39BC4 | Red Alert, Yellow Alert, Routine, Overdue | 6.5 / 11.8 / 6.9 on panel |
| mint `--mint` | #6FD6B8 | success toast edge | 10.3 on panel |
Priority colour is never the only signal: every card shows the alert level as text.

## Type (locked)
Local stacks only (no web fonts).
| role | stack | use |
|---|---|---|
| display | "Avenir Next Condensed", "Arial Narrow", "Roboto Condensed", "Helvetica Neue", Arial, sans-serif | wordmark, column and dialog titles, labels, pills; uppercase with 0.1 to 0.24em tracking |
| body | "Avenir Next", "Segoe UI", "Helvetica Neue", Arial, sans-serif | everything else, 14px, line-height 1.55 |
| utility | ui-monospace, "SF Mono", "Cascadia Mono", Consolas, monospace | task IDs, counts, stardate |
Scale (px): 11, 12, 14, 15, 16, 20, 34.

## Scales (locked)
- spacing 4, 8, 12, 16, 24, 40, 64
- radius 4, 10, 28 (cap), 999 (pill); card radius `4px 16px 16px 4px`
- no shadows; separation by borders and colour
- motion 120 / 300 / 500ms, easing `cubic-bezier(.3,.7,.2,1)`, no bounce; header bars sweep in once on load; everything is disabled under `prefers-reduced-motion`
- texture: sparse inline SVG star dots on the ground, no image file
- icon family: none beyond the cute droid avatar (round dark head, periwinkle visor, blink) and a small circular-arrow mark on Clear filters

## Voice (full roleplay, plain underneath)
Ship-log tone, short sentences, no em-dashes in visible copy. Internal values never change; labels do.
| internal | shown as |
|---|---|
| Backlog / In Progress / Blocked / Done | Awaiting Orders / Underway / Adrift / Mission Complete |
| Critical / High / Medium / Low | Red Alert / Yellow Alert / Standard / Routine |
Other terms: mission (task), officer (assignee), alert level (priority), stardate (`YYYY.DDD`), Ship's computer (chatbot), Incoming transmission (meeting popup), subspace relay (email). Kept literally for clarity: "Delete? Yes / No", "Overdue", "Room 888", the spoken greeting "I am your IT assistant, how can I help you?".
