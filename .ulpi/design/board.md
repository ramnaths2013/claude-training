# Board spec (binds to DESIGN.md)

Every screen must read as the same product if placed side by side.

## Layout
- Header: segmented colour bars with rounded end caps (swept in once), wordmark "IT PMO / Mission board", stardate, "+ New mission" button, simulation note, summary capsules (missions, four statuses, overdue).
- Filter row: Project, Officer (free text), Alert level, Clear filters, live count note.
- Board: four columns with the header-bar signature. 4 across on desktop, 2 per row under 1024px, stacked under 768px. Each column body has a thick left rail in the column colour.
- Cards: dark panel, 6px left edge by alert level, ID (mono), Overdue badge, alert pill (text), title, 2-line brief, Project, Officer, Due (date and stardate), category tag, Move select, delete with inline "Delete? Yes / No" (the action row wraps so the confirm never overflows the card).
- Dialogs: "Log new mission" (orange head) and "Incoming transmission" (periwinkle head, role `alertdialog`, 10 second timer, next Wednesday 10:00 am, Room 888, once per page load, waits for the mission dialog to close).
- Ship's computer: droid avatar bottom right; lavender-headed chat panel; speaks the greeting on open; BM25-style retrieval over live missions and a demo library.
- Footer: closing bars and the not-affiliated disclaimer.

## Hooks that must be preserved
IDs and classes used by the JS and the tests: `summary`, `stardate`, `f-project`, `f-assignee`, `f-priority`, `f-clear`, `filter-note`, `board`, `open-add`, `modal`, `task-form`, `t-*`, `submit-btn`, `notice*`, `chat*`, `toast-region`, `.column[data-status]`, `.badge`, `.dropzone`, `.card[data-id]`, `.p-critical|p-high|p-medium|p-low`, `.pill`, `.tag`, `.overdue`, `.move-select`, `.del-btn`, `.confirm .yes`, `[data-action]`, `.toast`.

## States
Empty column: "No missions here yet." Filtered to zero: "Showing 0 of N missions. Clear filters to see everything." Dragging: card at 45 percent, target column header brightens and its body gets a dashed outline. Sending: button reads "Sending…". Email failure: warn toast "Mission logged locally. Subspace relay (email) failed." Errors appear inline under fields with `aria-invalid`. No voice support: note in the chat panel.

## Accessibility
Contrast table in DESIGN.md. Visible 3px focus ring on every control. Full keyboard path (Move select instead of drag, dialogs trap focus, Esc closes). Touch targets 44px on phones. Counts have text and `aria-label`. `prefers-reduced-motion` removes all animation.
