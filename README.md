# SwiftAppTemplate

A polished SwiftUI iOS app template designed to be cloned as the starting point
for new apps. It ships with a small design system, reusable components, fluid
animations, haptics, light/dark support, a sensible feature-folder structure,
and the production scaffolding most apps need (networking, dependency
injection, error handling, logging, analytics seam, persistence, tests, CI, and
a privacy manifest).

## Build from a product brief

This template is meant to be handed to **Claude Code**: clone it, open it on a
Mac, fill in [`docs/PRODUCT_BRIEF.md`](docs/PRODUCT_BRIEF.md), then ask Claude to
*"Build the app described in `docs/PRODUCT_BRIEF.md`."* See
[`CLAUDE.md`](CLAUDE.md) for the architecture, conventions, and the
step-by-step recipe Claude follows when adding features.

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
├─ App/                 App entry, root view, AppEnvironment (DI + app state)
├─ Core/                Non-UI infrastructure
│  ├─ Configuration/    AppConfiguration (environment, base URL, version)
│  ├─ Networking/       APIClient protocol, Endpoint, Live + Mock clients
│  ├─ Persistence/      FileStore (Codable cache)
│  ├─ Analytics/        AnalyticsClient seam + Console/Noop impls
│  ├─ Logging/          AppLog (os.Logger categories)
│  ├─ Errors/           AppError + ErrorCenter + .errorAlert modifier
│  └─ Services/         AppServices dependency container
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
└─ Resources/           Asset catalog + app icon, PrivacyInfo, Localizable.xcstrings
SwiftAppTemplateTests/  Unit tests (XCTest, @testable import)
```

## Production scaffolding

| Concern | Where |
| --- | --- |
| **Networking** | `Core/Networking` — depend on the `APIClient` protocol; `LiveAPIClient` for production, `MockAPIClient` for previews/tests. |
| **Dependency injection** | `Core/Services/AppServices` built once and injected via `AppEnvironment`. |
| **Errors** | Map to `AppError`, present with `ErrorCenter.present(_:)` + the global `.errorAlert`. |
| **Logging** | `AppLog` categories over `os.Logger`. |
| **Analytics** | Vendor-neutral `AnalyticsClient` seam (`ConsoleAnalytics` default). |
| **Persistence** | `FileStore` Codable cache; `@AppStorage` for preferences. |
| **Config** | `AppConfiguration` reads env / base URL / version from Info.plist. |
| **App Store** | `PrivacyInfo.xcprivacy` manifest + `Localizable.xcstrings` String Catalog. |
| **Tests & CI** | `SwiftAppTemplateTests` target + `.github/workflows/ci.yml` (build + test on macOS). |

## Conventions

- **State** uses the Observation framework (`@Observable`) and `@AppStorage`
  for persisted preferences.
- **Animations** favor SwiftUI's modern presets (`.smooth`, `.spring`,
  `.bouncy`) and scroll transitions for tasteful, performant motion.
- **Surfaces** use system colors so the UI adapts to light and dark mode, while
  brand accents stay vivid in both.

## Tooling

The repo includes a project-scoped `.mcp.json` that registers
[XcodeBuildMCP](https://github.com/cameroncooke/XcodeBuildMCP). When you open
the project in Claude Code on a Mac, it offers an MCP server that can build,
run, test, and drive simulators for this app via `npx`. It requires macOS and
Node, and has no effect on other platforms.

## License

See [LICENSE](LICENSE).
