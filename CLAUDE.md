# CLAUDE.md

## Project
Single-page IT PMO Kanban board for a fictitious bank's internal IT PMO. Demo/training tool only.
- Everything lives in one file: `index.html` (markup, `<style>`, `<script>`).
- Theme: Star Trek style (full roleplay), an unofficial LCARS-inspired homage. Internal status and priority values stay `Backlog/In Progress/Blocked/Done` and `Critical/High/Medium/Low`; only the display labels change (`COLUMN_LABELS`, `PRIORITY_LABELS`). No official logos, insignia or fonts. Design tokens and the ratio table live in `.ulpi/design/DESIGN.md`.
- Do not use real UOB logos, trademarks or imitations of official systems. Use the neutral "IT PMO" text wordmark and the corporate-blue palette. Task IDs keep the `UOB-ITPM-####` format.

## Hard constraints
- Vanilla HTML/CSS/JS only. No frameworks, libraries, build step, bundler or npm.
- Must work by double-clicking the file (`file://`), no server.
- No external resources: no CDN scripts, web fonts or image files. Use the system font stack and inline SVG or Unicode glyphs.
- No persistence: no `localStorage`, `sessionStorage`, IndexedDB or cookies. Board state lives in `state.tasks` and resets to the seed data on refresh. The UI says so.
- Only network call: FormSubmit AJAX endpoint (`FORMSUBMIT_ENDPOINT`, config constant at the top of the script). A failed call must never break the board. Never send the user's email address anywhere else.

## IT assistant chatbot
- Bottom-right avatar opens a text chat. Clicking it speaks "I am your IT assistant, how can I help you?" with the browser's Web Speech API (`speechSynthesis`, no external service).
- RAG is in-browser only: BM25-style retrieval over live `state.tasks` plus a demo FAQ, replies quoted from retrieved passages. No LLM, no backend, chat lives in `state.chat` (memory only).
- Hook: `.claude/hooks/check-index.sh` (registered in `.claude/settings.json`, PostToolUse on Write/Edit/MultiEdit) checks `index.html` after every edit: greeting present, `speechSynthesis` used, no storage APIs or `!important`, no external resources, `fetch` only for FormSubmit. Exit code 2 means fix the listed problems.

## IT meeting popup
- After the visitor has been on the page for 10 seconds (`NOTICE_DELAY_MS = 10000`), an in-page `role="alertdialog"` shows once per page load: IT meeting next Wednesday, 10:00 am, Room 888 (the date is computed from today). Never a native `alert()`. It waits if the add-task dialog is open. No storage, so a refresh shows it again.
- Hook: `.claude/hooks/check-meeting-notice.sh` (registered in `.claude/settings.json` next to the other guard) checks the 10 second delay, Wednesday, 10:00 am, Room 888, the alertdialog role and that no native `alert(` call exists.

## Code conventions
- `state = { tasks: [], filters: {} }` is the single source of truth. Re-render from state; only `renderBoard()` and the functions it calls write card/column/summary HTML.
- Keep small named functions: `renderBoard`, `renderCard`, `addTask`, `moveTask`, `deleteTask`, `applyFilters`, `showToast`, `notifyNewTask`.
- Escape every user-supplied string with `escapeHtml()` before putting it into HTML.
- CSS: colours and spacing come from `:root` custom properties; no `!important`; visible `:focus-visible` rings.
- Accessibility: semantic HTML, `<label for>` on every input, `aria-label` on icon-only buttons, `aria-live="polite"` toast region, never colour alone as a signal.
- Validation errors appear inline; never use `alert()` or `confirm()`.
- Comment each major section.

## Verifying changes
Open `index.html` in headless Chromium (Playwright is pre-installed) and check: 8 seeded cards, drag-and-drop and the Move ▸ select, filters, inline delete confirm, form validation, add-task flow and toasts, and the layout stacking below 768px. Then grep the file for `localStorage|sessionStorage|indexedDB|cookie|!important`; there should be no matches.

## Git
Develop on branch `claude/eager-babbage-ayuea1`. Do not open a pull request unless asked.
