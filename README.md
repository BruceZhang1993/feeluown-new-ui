# FeelUOwn New UI (WIP)

## Prerequisite

- Python >=3.11 (PySide6 dependency)
- FeelUOwn[webserver]
- Qt6
  - Base (qt6-base)
  - QtWebSockets (qt6-websockets)
  - QtSvg (qt6-svg)
- Qt6.Qt5Compat (qt6-5compat)

## How to run

```shell
# Run FeelUOwn first
fuo -v -nw
# ...In another shell
poetry install
poetry run feeluown-gui
```

## Features

- [x] Basic layout design
- [ ] Player bar
  - [x] GUI
    - [x] Blur effect (Cover)
    - [x] Transitions/Animations (Progress bar/Volume control)
  - [ ] Status sync
    - [x] Play/Resume
    - [x] Metadata (need cover)
    - [x] Position/Duration/Progress bar
    - [ ] Volume
  - [ ] Live lyrics
    - [x] In app
    - [ ] OSD
  - [ ] Controls
    - [x] Play/Resume
    - [ ] Volume
    - [ ] Shuffle/Repeat
    - [ ] Next/Prev
    - [ ] Seek
