# 🎭 IMPOSTA?

<p align="center">
  <img src="assets/logo.png" alt="IMPOSTA Logo" width="200"/>
</p>

A premium, modern social deduction word game built with Flutter. Gather your friends, find the imposter, or bluff your way to victory!

---

## 🎮 Game Rules
1. **The Secret Reveal**: Every player is secretly shown a card.
   - **Innocents** receive the secret civilian word (e.g., `Sinigang`).
   - **Imposters** receive a subtle descriptive hint (e.g., `Sour` or `Tamarind`) instead of the exact word.
2. **The Sequence**: Players take turns giving **one-word clues** related to their secret.
   - *Innocents* try to signal each other without making the word too obvious to the imposter.
   - *Imposters* must listen carefully to gather info, blend in, and fake their clues!
3. **Discussion & Vote**: After the clue rotations, the group discusses and votes on who they think is the **Imposter**.
4. **Win Conditions**:
   - **Innocents win** if they identify and eliminate all imposters.
   - **Imposters win** if they survive undetected, or if they correctly guess the innocent secret word after being caught!

---

## ✨ Features
- **Curated Multi-Hint Word Bank**: Diverse, high-quality word pairs across categories:
  - 🏠 Everyday Objects (with local Pinoy flavor like *Suklay*, *Balde*)
  - 🦸 Famous People & World Class Icons (like *Jose Rizal*, *Vice Ganda*, *BINI*, *Elon Musk*)
  - 🍕 Foods & Drinks (like *Sinigang*, *Adobo*, *Kwek-kwek*, *Halo-halo*)
  - 🌍 Places (like *Boracay*, *Mayon Volcano*, *Banaue Rice Terraces*)
  - 🎬 Movies & Shows
  - 💻 Tech & Brands (like *Jollibee*, *SM*)
  - 🐾 Animals
  - 👔 Professions & Jobs
- **Smooth Animations**: High-fidelity haptic feedback, 3D card-flip interaction, and elegant animated UI elements.
- **Game Customization**: Customize player count, timer mode, clue rotations, and opt to give imposters hints.

---

## 🚀 How to Run & Build

### Development
1. Clone the repository:
   ```bash
   git clone https://github.com/NiksyD/imposta.git
   cd imposta
   ```
2. Install packages:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

### Build APK (Android)
To build a runnable release APK:
```bash
flutter build apk --release
```
The compiled APK will be located at:
`build/app/outputs/flutter-apk/app-release.apk`
