# SwiftAppTemplate

A polished SwiftUI iOS app template designed to be cloned as the starting point
for new apps. It ships with a small design system, reusable components, fluid
animations, haptics, light/dark support, and a sensible feature-folder
structure.

## Requirements

- **Xcode 16 or later** (the project uses Xcode's synchronized file-system
  groups, so new files added to the `SwiftAppTemplate/` folder are picked up
  automatically — no need to edit the project file).
- **iOS 17.0+** deployment target.

## Getting started

1. Open `SwiftAppTemplate.xcodeproj` in Xcode.
2. Select the `SwiftAppTemplate` scheme and an iOS 17+ simulator.
3. Press **Run** (`⌘R`).

To make it your own:

- Rename the product and bundle identifier in the target's **Build Settings**
  (`PRODUCT_BUNDLE_IDENTIFIER` is `com.example.SwiftAppTemplate`).
- Tweak the palette in `DesignSystem/Color+Theme.swift` and the spacing/radius
  tokens in `DesignSystem/Theme.swift` to re-skin the entire app.
- Replace the `FeedItem` sample model and `HomeViewModel` loading logic with
  your real data.

## What's inside

| Area | Highlights |
| --- | --- |
| **Onboarding** | Paged welcome flow with an animated aurora background, springy page entrances, animated SF Symbols, and a custom page indicator. |
| **Custom tab bar** | A floating, pill-shaped tab bar where the selected tab expands with a `matchedGeometryEffect` spring animation. |
| **Home** | Greeting header, an animated gradient hero card, skeleton/shimmer loading state, pull-to-refresh, and feed rows that animate in with scroll transitions. |
| **Explore** | A two-column grid with scale + blur scroll transitions. |
| **Detail** | Animated header symbol and content that eases in on appear. |
| **Settings** | Live appearance switching (System/Light/Dark), haptics & notifications toggles, and a "Reset Onboarding" action — all persisted with `@AppStorage`. |

## Project structure

```
SwiftAppTemplate/
├─ App/                 App entry, root view, shared environment state
├─ DesignSystem/        Theme tokens, color palette
│  └─ Components/       Reusable views (buttons, cards, shimmer, pills, background)
├─ Navigation/          Custom tab bar + tab definitions
├─ Features/
│  ├─ Onboarding/
│  ├─ Home/             View, view model, and model
│  ├─ Explore/
│  ├─ Detail/
│  └─ Settings/
├─ Support/             Helpers (haptics)
└─ Resources/           Asset catalog (accent color, app icon slot)
```

## Conventions

- **State** uses the Observation framework (`@Observable`) and `@AppStorage`
  for persisted preferences.
- **Animations** favor SwiftUI's modern presets (`.smooth`, `.spring`,
  `.bouncy`) and scroll transitions for tasteful, performant motion.
- **Surfaces** use system colors so the UI adapts to light and dark mode, while
  brand accents stay vivid in both.

## License

See [LICENSE](LICENSE).
