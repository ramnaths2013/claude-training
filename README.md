# IT PMO Kanban Board

[![CI](https://github.com/ramnaths2013/claude-training/actions/workflows/ci.yml/badge.svg)](https://github.com/ramnaths2013/claude-training/actions/workflows/ci.yml)
[![Pages](https://github.com/ramnaths2013/claude-training/actions/workflows/pages.yml/badge.svg)](https://github.com/ramnaths2013/claude-training/actions/workflows/pages.yml)

A single-page, Star Trek themed Kanban board for a fictitious bank's internal IT PMO. **Demo / training tool only.**

**Live demo:** https://ramnaths2013.github.io/claude-training/

## Features
- Drag-and-drop cards between columns, plus a **Move ▸** select for keyboard use
- Filters, inline delete confirmation (no `alert()`/`confirm()`)
- Add-task form with inline validation and toast notifications
- Responsive layout that stacks below 768px
- IT assistant chatbot (bottom right): click the avatar to hear a voice greeting, then ask about board tasks or IT help; answers are retrieved in the browser from the live board and a demo FAQ
- After 10 seconds on the page, a reminder dialog announces the IT meeting (next Wednesday, 10:00 am, Room 888)
- 8 seeded tasks using the `UOB-ITPM-####` ID format

## Run it
Double-click `index.html`. No build step, server or install needed.

## Constraints
- Vanilla HTML/CSS/JS in one file, no frameworks or external resources
- No persistence: board state resets to the seed data on refresh
- The only network call is the optional FormSubmit new-task notification; a failure never breaks the board

## Disclaimer
The visual theme is an unofficial fan-style homage. It is not affiliated with or endorsed by the owners of Star Trek, and uses no official logos, insignia or fonts.
The bank is fictitious. This project uses a neutral "IT PMO" wordmark and no real UOB logos or trademarks.
