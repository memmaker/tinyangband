# TinyAngband 1.0.1: handover

## Source and changes

- Base: **TinyAngband 1.0.1**
- Original source: https://github.com/iks3/tinyangband/tree/d221733 (iks3/tinyangband, commit d221733)
- Our changes: https://github.com/memmaker/tinyangband/compare/d221733...master (memmaker/tinyangband)
- Prompt line (`RvipWM.prompt`, RVIP 5.9): `js_next_event(inkey_flag && character_generated)` in `src/main-web.c`;
  the page tracks term 0 row 0 (`row0` in `text`/`wipe`/`clear`) and sends it on
  `fresh(0)`.
