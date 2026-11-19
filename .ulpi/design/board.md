# Board redesign spec (binds to DESIGN.md)

Every screen must read as the same product if placed side by side.
Re-read `.ulpi/design/DESIGN.md` first. Any value outside it is a defect.

## Scope
Visual and layout redesign of `index.html` only. Behaviour, state model, function names and the DOM hooks listed below do not change.

### Hooks that must be preserved (JS depends on them)
IDs: `summary`, `f-project`, `f-assignee`, `f-priority`, `f-clear`, `filter-note`, `board`, `open-add`, `modal`, `close-add`, `cancel-add`, `task-form`, `t-title`, `t-desc`, `t-project`, `t-category`, `t-assignee`, `t-priority`, `t-due`, `t-status`, `t-*-err`, `t-title-count`, `t-desc-count`, `submit-btn`, `toast-region`.
Classes and data attributes emitted by `renderBoard()` / `renderCard()`: `.column[data-status]`, `.column-head`, `.badge`, `.dropzone`, `.empty`, `.card[data-id]`, `.card.p-critical|p-high|p-medium|p-low`, `.dragging`, `.drag-over`, `.pill`, `.tag`, `.overdue`, `.move-select[data-id]`, `.del-btn`, `.confirm .yes`, `[data-action=delete-ask|delete-yes|delete-no]`, `.toast`, `.toast.warn`.
The JS may be edited only where needed to emit the ensō SVG inside the count badge and to add ARIA text. `escapeHtml()` stays on every user string.

## Primary flow
1. Open board: header, summary, filters, four columns with seeded cards.
2. Triage: filter by project, assignee text or priority. A note appears: "Showing 3 of 8 tasks."
3. Move work: drag a card to another column, or use the Move control. Both call `moveTask()`.
4. Add work: "Add task" opens the dialog, validate inline, submit, card appears at once, toast confirms, email status follows in a second toast.
5. Remove work: the "×" turns into "Delete? Yes / No" inside the card.

## States
| element | loading | empty | partial | success | error |
|---|---|---|---|---|---|
| column | n/a (in-memory) | dashed hairline box, "Nothing here yet." | filtered subset, ensō reflects visible share | n/a | n/a |
| filtered board | n/a | all columns empty plus the filter note reads "Showing 0 of 8 tasks. Clear filters to see everything." | note shows counts | n/a | n/a |
| card | n/a | n/a | description clamped to 2 lines | n/a | n/a |
| drag | source card at 45 percent opacity | n/a | hovered column gets drop highlight (see Column) | card lands, 300ms settle | drop on non-column: no change |
| add form | submit button reads "Sending…" and is disabled | all fields blank, Medium and Backlog preselected | counters live (n / 80, n / 500) | modal closes, toast "Added UOB-ITPM-0009 to Backlog" | inline error under field, `aria-invalid`, focus to first invalid field |
| notification | button "Sending…" | n/a | n/a | silent | warn toast "Card added locally. Email notification failed." |

Edge cases: refresh resets to the seed data and the header note says so; opening the dialog sets the date `min` to today; Esc closes the dialog unless sending; a long title wraps (never clips); long assignee names wrap; delete confirm is cancelled when another card is moved; offline fetch fails into the warn toast and the board stays intact.

## Layout (desktop first, stacks under 768px)
- Page: ground background with grain. Max content width 1320px, centered, 40px side padding (16px on phones).
- Header band (surface): wordmark left ("IT PMO" in display face with a thin 1px underline brushed to 60 percent width, then "Project board" in muted 12px). The empty space on the right holds only the "Add task" button and the demo note beneath it, right aligned. Asymmetry is intentional.
- Summary: one quiet line of inline stats, not tiles: `8 tasks · 2 Backlog · 2 In Progress · 2 Blocked · 2 Done · 2 Overdue`, numbers in mono, Overdue in shu with its label. Keep the `ul#summary` with `li` items, separated by a mid-dot via CSS.
- Filters: one hairline-bounded row on surface, labels above fields in 11px uppercase muted, fields with 2px radius and a bottom-weighted 1px line. "Clear" is a text button with the small ensō mark.
- Board: four columns, flex, 40px gap, no column fill or border. Each column has a top hairline in `--line`, a 20px display title, a 12px muted hint line, and the ensō count at the right of the title row. Column identity is carried by the title and hint, not by colour bars.
- Drop highlight on `.column.drag-over`: the top hairline becomes 2px `--ai`, and the column ground becomes `--surface`. No glow.
- Card: `--card` fill, uneven radius, elevation token, 3px left edge by priority (Critical shu, High kaki-edge, Medium ai, Low nezumi). Order inside: top row (mono ID left, pills right), title (display 16px), description (muted 12px, 2-line clamp), meta as a definition list (Project, Assignee, Due), category tag as plain text with a hairline underline, actions row.
- Priority pill: text label in the matching text colour on a transparent background with a 1px border of the same colour. Overdue badge: "Overdue" in shu, 1px shu border, placed before the priority pill.
- Actions row: Move select left (2px radius, `Move ▸` placeholder), "×" right. Confirm state: "Delete?" then "Yes" (shu filled, light text) and "No" (outlined).
- Modal: flat backdrop, panel on `--card`, display-face title, two-column form on desktop, one column on phone, labels above inputs, errors in shu 12px under the field with `role` text, primary button "Add task" in `--ai`, secondary "Cancel" outlined.
- Toast: bottom right, `--sumi` fill with light text for success (left 3px matsu), `--card` fill with kaki text and kaki edge for warning. Region keeps `aria-live="polite"`.

## Components
| component | purpose | variants | states | interaction | a11y |
|---|---|---|---|---|---|
| Wordmark | brand | one | n/a | none | `aria-label="IT PMO"` |
| Summary line | live counts | overdue emphasised | zero counts stay visible | none | list semantics kept |
| Filter field | narrow cards | select, text | default, focus, filled | updates on change or input | label for every control, visible focus |
| Ensō count | column count mark | per column, clear mark | sweep on first load, redraw on re-render | none | the number is real text inside the SVG (`<text>`), plus `aria-label="3 tasks"` on the badge |
| Column | status container | four statuses | default, drag-over, empty | drop target | `<section aria-labelledby>`, heading is the title |
| Card | one task | four priorities, overdue, confirming | default, dragging, confirming, focus | drag, Move select, delete confirm | `draggable`, Move select labelled with task ID, delete button labelled, confirm group labelled |
| Priority pill | priority as text | four | static | none | text carries meaning |
| Move select | keyboard alternative to drag | per card | default, focus | `change` calls `moveTask()` | native select, 44px minimum hit height on touch |
| Dialog | add task | none | open, sending, error | Esc, backdrop click, focus trap | `role="dialog"`, `aria-modal`, focus returns to opener |
| Toast | feedback | success, warn | enter 300ms, exit after 3.5 or 6 seconds | none | `aria-live="polite"` |

Focus ring: 2px solid `--ai` with 2px offset on every focusable element, always visible on keyboard focus (`:focus-visible`).
Touch targets: on viewports under 768px, buttons, selects and the delete control are at least 44px tall.

## Accessibility
Contrast ratios are listed in DESIGN.md and all pass AA (lowest text pair 4.73, lowest UI edge 3.30 against the 3:1 UI requirement). Full keyboard path: Add task, dialog fields in order, submit, Esc; filters; each card's Move select then delete button; confirm Yes/No. Motion is limited to the one-time ensō sweep, the 300ms drop highlight and toast entry, all disabled by `prefers-reduced-motion`. Screen readers hear counts through the badge label and filter results through `aria-live` on `#filter-note`.

## Pre-Flight (run on this spec)
Identity lock: 0 off-system values, one accent, one radius scale, no icon family, one type pairing. Done.
Anti-slop: 0 banned fonts as primary, 0 color clichés (ground is plaster grey-green, justified in DESIGN.md), 0 three-card rows, 0 nested cards, 0 buzzwords, 0 fake names, 0 em-dashes in visible copy. Signature present. Done.
State and flow coverage: table above. Done.
Accessibility: ratios listed, focus, motion and ARIA specified. Done.
Layout craft: header band, hairline filter row, open columns, modal give four families. Done.
Cognitive load: 1 primary action (Add task), 3 filters, form of 8 fields grouped in pairs (limit is about 4 per group, so the dialog groups them as: what (title, description), where (project, category), who and when (assignee, due date), status (priority, status)). Done.

Scored self-critique (0 to 4): distinctiveness 3, hierarchy and focus 3, consistency 4, accessibility 3, state coverage 3, copy 3, restraint 4, motion motivation 3. Total 26 of 32. No axis at or below 2. Change made at the gate: the first draft coloured column top bars per status; removed because it competed with priority colour and broke restraint.

## Build handoff
Target: a general-purpose engineering agent working on a static single file (neither the Next.js nor the Vite agent fits, as CLAUDE.md forbids frameworks).
design_system: bespoke, vanilla CSS custom properties defined once on `:root`.
Instruction: Implement exactly this spec. Do NOT redesign. Keep all behaviour and hooks listed above.
Acceptance criteria:
1. `index.html` is still one file with inline `<style>` and `<script>`, no external resources, no storage APIs, no `!important`.
2. All tokens in DESIGN.md exist as custom properties and every colour, radius and spacing value in the CSS comes from them.
3. The ensō count renders in each column header and the clear-filter mark, with the real number as text.
4. Seeded board shows 8 cards, drag and drop and Move select both work, delete confirm works, filters work, form validation and toasts work (re-run the Playwright smoke test from CLAUDE.md).
5. Under 768px the columns stack, targets are at least 44px, no horizontal page scroll.
6. Keyboard focus is visible everywhere; `prefers-reduced-motion` removes the sweep and transitions.
7. No em-dashes in visible copy; copy matches the Voice section.
8. Screenshots at 1280px and 400px widths are taken and checked against this spec.
