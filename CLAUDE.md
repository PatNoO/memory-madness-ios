# CLAUDE.md — MemoryMadness iOS
AI-Assisted Development Workflow

> This document defines how Claude Code should work in this repository.
> Claude Code works interactively with the developer — changes are reviewed in real time before committing.

---

# Project Overview

**MemoryMadness** is a themed memory card matching game for iPhone and iPad.

**Core gameplay:** Flip cards to find matching pairs. All matches found = level complete.

**Themes:**
- Halloween (`card1`–`card9`)
- Christmas (`xmas1`–`xmas9`)
- Easter (`easter1`–`easter9`)
- St. Patrick's Day (`stpday1`–`stpday9`)

Each theme has 9 unique card images. A game board shows pairs of each card (18 cards = 9 pairs).

**Target platforms:** iPhone + iPad (iOS 15.0+)
**Developer:** Patrik Noordh
**Bundle ID:** `com.example.memorymadness`

---

# Tech Stack

| Layer | Technology |
|---|---|
| Language | Swift (latest) |
| UI Framework | SwiftUI |
| Architecture | MVVM |
| IDE | Xcode |
| Assets | Assets.xcassets |
| Version control | GitHub |
| Package manager | Swift Package Manager (SPM) |

No backend, no database, no network calls — this is a local, offline game.

---

# Folder Structure

```
MemoryMadness-IOS/
├── MemoryMadness_IOSApp.swift   ← App entry point (@main)
├── ContentView.swift            ← Root view / navigation
├── Models/
│   ├── Card.swift               ← Card model (id, imageName, isFlipped, isMatched)
│   ├── Theme.swift              ← Theme enum (halloween, christmas, easter, stpatrick)
│   └── GameState.swift          ← Game state model
├── ViewModels/
│   └── GameViewModel.swift      ← Game logic (shuffle, flip, match, reset)
├── Views/
│   ├── GameBoardView.swift      ← Card grid layout
│   ├── MemoryCardView.swift     ← Individual card (front/back, flip animation)
│   ├── ThemePickerView.swift    ← Theme selection screen
│   └── ResultView.swift         ← Win screen / level complete
├── Extensions/
│   └── Color+Theme.swift        ← Theme color definitions
├── Utilities/
│   └── SoundManager.swift       ← Optional sound effects
└── Assets.xcassets/
    └── (card images per theme)
```

---

# Architecture Rules (STRICT)

## Pattern: MVVM

```
View (SwiftUI)
  → observes @StateObject / @ObservedObject ViewModel
  → calls ViewModel methods on user action
  → never contains game logic

ViewModel (ObservableObject)
  → owns all game state via @Published properties
  → contains all game logic (shuffle, flip, match detection)
  → never imports SwiftUI (use Foundation only)

Model
  → plain Swift structs/enums
  → Identifiable, Equatable, Codable where appropriate
```

## Rules
- Views are SwiftUI only — no UIKit unless unavoidable
- ViewModels are `ObservableObject` with `@Published` properties
- No game logic in Views — delegate to ViewModel
- No force-unwraps (`!`) without a comment explaining why it is safe
- No `any` or untyped collections — use concrete types
- No hardcoded strings for card image names — use the `Theme` enum
- Card image names must match `Assets.xcassets` exactly (case-sensitive)
- All new types go in their correct folder (Models / ViewModels / Views / Extensions / Utilities)
- `@StateObject` in the owning view, `@ObservedObject` when passed down

---

# How Claude Code Works Here

- Read existing code before making changes
- Show developer what will change before significant edits
- Ask for clarification when task is ambiguous
- Keep scope tight — only implement what is discussed
- Use mock / placeholder data with `// TODO:` when feature is incomplete
- Never add Swift packages (SPM) without explaining why and getting approval
- Never push or open PRs without explicit developer instruction
- Never take destructive actions without confirmation

---

# Branch Naming

```
feature/short-description
fix/short-description
```

Examples:
- `feature/card-flip-animation`
- `feature/theme-picker`
- `fix/match-detection-crash`

**Never commit directly to `main`.**

---

# Commit Rules

All commits must start with `[claude]`.

**First commit on branch:**
```
[claude] feat: Title Case Description
```

**Subsequent commits:**
```
[claude] [<type>] imperative description
```

Types: `feat` `fix` `style` `refactor` `chore` `docs` `perf` `test`

Rules:
- Imperative tense always
- Under 72 characters
- Never `git add .` or `git add -A` — stage specific files by name
- Never `--no-verify`

Use `/git-commit` for the full workflow.

---

# Pull Request Rules

Target branch is always `main`.

Use `/git-ship` to run the full ship workflow (build → commit → push → PR).

## PR Title
```
[claude] Title Case Summary of Feature
```

## PR Body Template (REQUIRED)

```markdown
## Summary
<One or two sentences describing what was built and why.>

### What Was Changed
1. **Models** — <item or "Not touched">
2. **ViewModels** — <item or "Not touched">
3. **Views** — <item or "Not touched">
4. **Extensions / Utilities** — <item or "Not touched">
5. **Assets** — <item or "Not touched">

### Acceptance Criteria Coverage
- [ ] <criterion 1>
- [ ] <criterion 2>

### Manual Test Steps
1. Build and run on iPhone simulator
2. <Step 2>
3. <Step 3>

### Notes / Tradeoffs
- <Placeholder data? TODO markers? New SPM packages? Breaking changes?>
```

---

# Validation Command

```bash
xcodebuild -project MemoryMadness-IOS.xcodeproj \
  -scheme MemoryMadness-IOS \
  -destination 'generic/platform=iOS Simulator' \
  build
```

Build must succeed with no errors before committing. Warnings are acceptable.

---

# Claude Code Restrictions

Must NOT:
- Add SPM packages without developer approval
- Use UIKit when SwiftUI can do the job
- Put game logic inside Views
- Force-push without explicit confirmation
- Push or open PRs without explicit developer instruction
- Take destructive git actions without confirmation

---

# Pre-Merge Checklist

- [ ] `xcodebuild` passes with no errors
- [ ] MVVM split is correct — no logic in Views
- [ ] No force-unwraps without justification
- [ ] Card image names match `Assets.xcassets` exactly
- [ ] No hardcoded card name strings — use `Theme` enum
- [ ] iPhone and iPad layouts checked in simulator
- [ ] No new SPM packages added without approval
- [ ] Commits follow `[claude]` format
- [ ] PR template filled out

---

# Key Game Rules — Never Violate

1. A card can only be flipped if it is not already matched
2. Only two cards can be face-up at a time — third flip must wait
3. Match detection is by `imageName`, not by card `id`
4. A matched pair stays face-up for the rest of the game
5. Shuffle is always random — never a fixed order
6. Theme selection resets the board completely
