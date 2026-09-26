# TinyAngband 1.0.1: handover

## Source and changes

- Base: **TinyAngband 1.0.1**
- Original source: https://github.com/iks3/tinyangband/tree/d221733 (iks3/tinyangband, commit d221733)
- Our changes: https://github.com/memmaker/tinyangband/compare/d221733...master (memmaker/tinyangband)
- Prompt line (RVIP step 5 / W4, 2026-09-26): the live message row is shown in a
  box over the map by `RvipWM.prompt` (rvip-wm.js). A key hides it only while
  the game waits for a command, so a question stays up until answered.
  Here: `js_next_event(inkey_flag && character_generated)` in `src/main-web.c`;
  the page tracks term 0 row 0 (`row0` in `text`/`wipe`/`clear`) and sends it on
  `fresh(0)`.
