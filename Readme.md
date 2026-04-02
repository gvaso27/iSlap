# 👋 iSlap

> *The app that rewards bad behaviour.*

---

## What is it?

iSlap is an iOS app that plays a **random sexy sound** every time you slap your phone.
That's it. That's the whole app. No apologies.

Slap the back. Get a moan.
Slap again. Get another one.
You won't stop. Nobody ever does.

---

## Features

- 👋 **Slap detection** — accelerometer-powered, tuned to feel satisfyingly physical
- 🔊 **60 handpicked sounds** — each one more scandalous than the last
- 🔒 **Works on locked screen** — because inspiration strikes at inconvenient times
- 📳 **Heavy haptic feedback** — the phone hits back
- 💥 **Ripple animation** — visual satisfaction to go with the audio
- 🎲 **Fully random** — you never know what you're gonna get

---

## How to use

1. Hold phone
2. Slap it
3. 😳

---

## Tech Stack

| What | How |
|---|---|
| UI | SwiftUI |
| Slap detection | CoreMotion — accelerometer spike at 2.5G threshold |
| Audio | AVFoundation `AVAudioPlayer` |
| Background audio | Background Modes — *Audio, AirPlay & Picture in Picture* |
| Haptics | `UIImpactFeedbackGenerator(.heavy)` |

---

## Project Structure

```
iSlap/
├── iSlapApp.swift        # App entry point
├── ContentView.swift     # UI + animations
├── SoundManager.swift    # Sound list + AVAudioPlayer playback
├── SlapDetector.swift    # CoreMotion accelerometer slap detection
└── audio/
    ├── 00.mp3
    ├── 01.mp3
    ├── ...
    └── 59.mp3            # 60 sounds of pure chaos
```

---

## Sensitivity Tuning

Not feeling it? Too sensitive? Adjust `slapThreshold` in `SlapDetector.swift`:

| Value | Vibe |
|---|---|
| `2.0` | light tap — very eager |
| `2.5` | firm slap — the default, as god intended |
| `3.5` | full commitment — no half measures |

---

## Requirements

- iOS 16+
- A real iPhone — the Simulator does not have feelings and cannot be slapped
- No shame whatsoever

---

## Disclaimer

We are not responsible for:
- What people on the subway think you are doing
- Noise complaints
- Broken phones
- Broken relationships
- The sounds themselves

---

*iSlap — putting the 🍑 in application.*
