<p align="center">
  <img src="Useful Information/PolePosition.png" width="800">
  <img src="Useful Information/PolePositionII.png" width="800">
</p>

<h1 align="center">Pole Position FPGA Core</h1>

<p align="center">
  Arcade hardware implementation for MiSTer FPGA
</p>

---

## Overview

FPGA implementation of **Pole Position (1982)** and **Pole Position II (1983)**, originally developed and released by Namco.

This core targets MiSTer FPGA and aims for accurate gameplay behavior, video timing, and sound reproduction.

---

## Game Information

| Field        | Value |
|--------------|--------|
| Title        | Pole Position |
| Year         | 1982 |
| Developer    | Namco |
| Genre        | Driving |
| Players      | 1–2 alternating |

---

## Controls

Default MiSTer gamepad mapping:

| Input | Action |
|-------|--------|
| D-Pad / Joystick | Steering |
| A | Accelerate |
| B | Brake |
| X | Gear |
| Y | Service Mode |
| Select | Insert Coin |
| Start | 1 Player Start |
| Right Shoulder | 2 Player Start |
| Left Shoulder | Pause |

---

## Features

- Arcade-accurate CPU timing
- Namco 5xxx custom MCUs implemented
- Sprite scaling and road rendering
- High score saving support
- MiSTer-compatible .mra provided
- Verified ROM definitions with checksums

---

## ROM Requirements

ROM files are **not included**.

To use this arcade core, you must provide legally obtained ROM files.

To simplify setup:

- `.mra` files are provided in the **Releases** section.
- The `.mra` specifies all required ROM files along with checksums.
- The ROM `.zip` filename corresponds to the naming convention used by the MAME project.

For setup instructions and environment configuration, refer to:

MiSTer Arcade ROM guide:  
https://github.com/MiSTer-devel/Main_MiSTer/wiki/Arcade-Roms

---

## Installation

1. Copy the core `.rbf` file to your MiSTer `/_Arcade/cores` folder.
2. Copy the `.mra` file to your MiSTer `/_Arcade` folder.
3. Place the appropriate ROM `.zip` files in your `/games/mame` directory.
4. Launch the core from the MiSTer Arcade menu.

---

## Legal Notice

This project contains **no copyrighted game data**.

Users are responsible for obtaining and using ROM files in accordance with applicable laws.

Do not request ROM files in issues or discussions.

---

## Credits

FPGA core development: RodimusFVC  
Original arcade game © Namco (1982)

---
