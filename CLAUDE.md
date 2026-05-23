# CLAUDE.md

Guidance for Claude Code (and humans) working in this repository.

## What this is

**SwiftAppTemplate** is a polished, production-shaped SwiftUI iOS starter. Clone
it, open it on a Mac, hand Claude Code a product brief, and build your app on
top of the scaffolding that's already here. The template intentionally ships a
small but complete example app (Onboarding → Tab bar → Home/Explore/Detail →
Settings) so there is a real, working pattern to copy for every new feature.

## The product-brief workflow

1. Copy `docs/PRODUCT_BRIEF.md` and fill it in (what the app is, who it's for,
   the core screens, the data, the integrations).
2. Open the project in Xcode and start Claude Code in this directory.
3. Tell Claude: *"Build the app described in `docs/PRODUCT_BRIEF.md`."*
4. Claude should: confirm the feature list, then implement features one folder
   at a time under `Features/`, reusing the design system and the service
   layer, and keeping the example screens until they're replaced.

When building from a brief, **prefer extending the existing patterns over
introducing new ones.** The value of this template is consistency.

## Requirements

- **Xcode 16+** (the project uses file-system synchronized groups, so new files
  added under `SwiftAppTemplate/` are picked up automatically — no `.pbxproj`
  editing needed).
- **iOS 17.0+** deployment target.

## Build / run / test

The project includes a `.mcp.json` that registers
[XcodeBuildMCP](https://github.com/cameroncooke/XcodeBuildMCP). On a Mac, prefer
those MCP tools to drive builds and the simulator. The equivalent CLI:

```bash
# Build for a simulator
xcodebuild build -scheme SwiftAppTemplate \
  -destination 'platform=iOS Simulator,name=iPhone 16'

# Run the unit tests
xcodebuild test -scheme SwiftAppTemplate \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

Always build (or run tests) after a change before reporting it done.

## Architecture

- **UI:** SwiftUI, one folder per feature under `Features/`.
- **State:** the Observation framework (`@Observable` view models), `@AppStorage`
  for persisted preferences. View models own state and call into services.
- **Dependencies:** constructed once in `AppServices` and injected through
  `AppEnvironment` in the SwiftUI environment. Features read services from the
  environment; they never construct `URLSession`, analytics, etc. directly.
- **Networking:** features depend on the `APIClient` protocol. `LiveAPIClient`
  talks to the network; `MockAPIClient` powers previews and tests.
- **Errors:** map failures to `AppError`, then `ErrorCenter.present(_:)` to
  surface them through the global `.errorAlert`.

### Directory map

```
SwiftAppTemplate/
├─ App/                 Entry point, RootView, AppEnvironment (DI + app state)
├─ Core/                Non-UI infrastructure
│  ├─ Configuration/    AppConfiguration (env, base URL, version)
│  ├─ Networking/       APIClient, Endpoint, Live + Mock clients
│  ├─ Persistence/      FileStore (Codable cache)
│  ├─ Analytics/        AnalyticsClient seam + Console/Noop impls
│  ├─ Logging/          AppLog (os.Logger categories)
│  ├─ Errors/           AppError + ErrorCenter + .errorAlert
│  └─ Services/         AppServices dependency container
├─ DesignSystem/        Theme tokens, palette, reusable Components/
├─ Navigation/          Custom floating tab bar + AppTab
├─ Features/            One folder per feature (View + ViewModel + Model)
├─ Support/             Small helpers (Haptics)
└─ Resources/           Assets, App icon, PrivacyInfo, Localizable.xcstrings
SwiftAppTemplateTests/  Unit tests (XCTest, @testable import)
```

## How to add a feature (recipe)

1. Create `Features/<Name>/`.
2. Add a model (`struct <Name>Item: Identifiable, Decodable`).
3. Add a view model:
   ```swift
   @Observable
   final class <Name>ViewModel {
       private(set) var phase: LoadPhase = .loading
       private let api: APIClient
       init(api: APIClient) { self.api = api }
       func load() async { /* call api.send(...), set phase */ }
   }
   ```
4. Add a `View` that reads `@Environment(AppEnvironment.self)`, builds the view
   model with `environment.services.api`, and renders loading / empty / error /
   loaded states (see `Features/Home` for the reference implementation).
5. If it's a top-level destination, add a case to `AppTab` and wire it into
   `Navigation/MainTabView`.
6. Add tests under `SwiftAppTemplateTests/`.

## Conventions

- **Reuse the design system.** Use `Theme.Spacing`/`Theme.Radius`, `Palette`,
  and the components in `DesignSystem/Components/` (GlassCard, PrimaryButton,
  Shimmer, TagPill, AuroraBackground). Re-skin by editing tokens, not call sites.
- **Animations should be tasteful.** Favor `.smooth`, `.spring`, `.bouncy`,
  scroll transitions, and `matchedGeometryEffect`. Drive animation off state.
- **Use system colors for surfaces** (`Color(.systemGroupedBackground)`, etc.)
  so light/dark mode work for free; keep brand accents from `Palette`.
- **Every async view has four states:** loading, empty, error, loaded.
- **Provide `#Preview`s** and inject preview dependencies with
  `AppServices.preview()` / `AppEnvironment(services: .preview())`.
- **Strings** go through the String Catalog (`Localizable.xcstrings`).
- **Logging:** `AppLog.<category>`. Never `print`.

## Things to keep in mind

- Don't edit `project.pbxproj` to add source files — synchronized groups handle
  it. Only touch the project file to add a new target.
- Keep `PrivacyInfo.xcprivacy` accurate as you add SDKs / data collection.
- Rename the bundle identifier (`com.example.SwiftAppTemplate`) before shipping.
