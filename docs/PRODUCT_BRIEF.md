# Product Brief

> Fill this in, then tell Claude Code: **"Build the app described in
> `docs/PRODUCT_BRIEF.md`."** Delete the prompts in italics as you go. The more
> concrete you are, the less Claude has to guess.

## 1. One-liner

_What is the app, in a sentence? "A ___ that helps ___ do ___."_

## 2. Audience & problem

_Who is it for, and what pain does it remove?_

## 3. Platforms

- Target: iOS 17+ (change if needed)
- Orientation / devices: _iPhone only? iPad too?_

## 4. Core screens

_List the main screens and what each one shows / does. Map these onto folders
under `Features/`._

| Screen | Purpose | Key elements |
| --- | --- | --- |
| _Home_ | _…_ | _…_ |
| _Detail_ | _…_ | _…_ |
| _…_ | _…_ | _…_ |

## 5. Data model

_What are the main entities and their fields? (These become `Decodable` models.)_

```
Example:
Recipe { id, title, imageURL, minutes, ingredients[], steps[] }
```

## 6. Backend / integrations

- API base URL: _e.g. https://api.myapp.com_
- Auth: _none / token / OAuth / sign in with Apple_
- Third-party SDKs: _analytics, payments, push, …_
- _Or: "no backend yet — use `MockAPIClient` with sample data."_

## 7. Branding

- App name: _…_
- Accent / palette: _hex values, or "keep the indigo→violet→pink default"_
- Tone: _playful / minimal / professional / …_

## 8. Must-haves vs. later

- **v1 must-have:** _…_
- **Nice-to-have / later:** _…_

## 9. Anything else

_Edge cases, offline behavior, accessibility needs, inspirations / references._
