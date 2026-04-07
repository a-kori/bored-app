# Anastasiia Korzhylova's Intro Course App

Welcome to your project repository! To pass the intro course, you will build a unique iOS app using SwiftUI. There are no limitations on the app's functionality — be as creative as you like. Your app must, however, satisfy the **quality attributes & external constraints** specified in the course materials.

## Local Development

For your Intro Course App, you will use XcodeGen to manage your Xcode Project.

**What is XcodeGen?** XcodeGen is a tool that automatically generates Xcode project files from a simple configuration file. Instead of manually managing complex Xcode project settings, you define your project structure in the provided `project.yml` file, and XcodeGen creates the `.xcodeproj` file for you. This makes it easier to manage your Xcode project under version control (git), and resolve any merge conflicts that arise.

**Why do we need this?** When you clone this repository, you won't find a ready-to-use `.xcodeproj` file, which you can directly open with Xcode. Instead, you'll find a `project.yml` configuration file that describes how the Xcode project should be set up. You need to generate the actual Xcode project file before you can open and work on the app in Xcode.

1. Install tools (if you don't have [Homebrew](https://brew.sh), install it first)
    ```bash
    brew install xcodegen swiftlint
    ```
2. Generate .xcodeproj
    ```bash
    xcodegen generate
    ```

    After running this command, you'll see a new `.xcodeproj` file appear in your project folder. You can then double-click this file to open your project in Xcode.

Since the `xcodegen generate` command must be run when the project is cloned and whenever changes affect the project structure, you can enable Git hooks to run the command automatically after merges and pulls.

Run the following command to point `git` to the hooks:
```bash
git config core.hooksPath .githooks
```

## Submission Procedure

1. **Personal Repository**
   You have been given a personal repository on GitLab to work on your app.

2. **Issue-Based Development**

    * Follow the issue-based development process from the Git Basics and Software Engineering sessions.
    * **Every code change must start with a GitLab issue.** Do not write code without a corresponding issue.
    * Inside the issue, click the dropdown arrow next to **Create merge request** and select **Create branch**. Confirm that **Source branch = `main`** and let GitLab generate the feature-branch name so the branch stays linked to the issue.
    * After GitLab creates the branch, sync your local repo and check out that branch:

     ```bash
     git fetch origin
     git checkout <branch-name>
     ```

3. **Merge Requests (MRs)**

   * For each completed issue / task, open an **MR targeting `main`** (source: your feature branch → target: `main`).
   * Prefix your MR title with `Draft:` (e.g. `Draft: #5: Add persistence layer`). While in Draft status, fill out the MR description and complete your work. Only **mark the MR as ready** when it is fully complete and ready for review.
   * Add your tutor as a reviewer and collaborate on requested changes. Respond to feedback promptly.
   * When the MR is ready, **let your tutor know** (in person or via Slack) — don't just wait silently.
   * Keep MRs focused and small where possible; ensure CI/build checks are green.
   * **Do not commit directly to `main`.** Use MRs only.
   * It is **your responsibility to press "Merge"** once the MR is approved.

**Deadline:** **2026-04-17 18:00**

**All MRs must be merged into `main` by the deadline.** The version on `main` at the deadline is considered your final submission. Your app must satisfy all required **quality attributes & external constraints**. During the first four days there are intermediate deadlines for software engineering artifacts to help you stay on track.

---

## Project Documentation

This README serves as your primary documentation. **Fill out each section carefully** — vague or generic content will not be accepted. Each section below contains guidance in blockquotes (>) with examples. **Replace all blockquotes with your own content.**

### Short Self Introduction

Hi all! I'm Anastasiia, a Master's Informatics student in 3rd semester. I'm also a DevOps Engineer with 3 years of development experience, but have never worked with Swift or iOS before. One fun fact about me is that I speak 5 languages fluently: Ukrainian and Russian as a native speaker, as well as English, German and Polish. And I'm currently on my way to mastering Spanish. Looking forward to this course!

### Problem Statement (max. 500 words)

> TODO: Add your problem statement here.

### Requirements

#### Functional Requirements (User Stories)

> TODO: List the user stories that your app fulfills. These should be added to the GitLab product backlog as issues. Discuss and refine them with your tutor.

- As a [user], I want to [action] so that [goal].

**Example** (for an Expense Tracking App): As a [student], I want to [see all my monthly transactions] so that [I can make better financial decisions].

#### Quality Attributes & External Constraints

> TODO: For **each** required quality attribute or constraint listed below, replace the placeholder with a **specific** description of how **your app** addresses it. You must name the **exact files, views, frameworks, or services** you used — generic statements like "followed Apple guidelines" or "used native components" are not sufficient.

Each subsection below must include:
1. **What you did** — the specific implementation (name the view, file, framework, or service)
2. **Where to find it** — a link to the file or a screenshot
3. **Any follow-up work** — what you would improve with more time

---

##### Human Interface Guidelines (HIG)

> TODO: Describe **specific** HIG decisions you made. Do not write "I followed Apple's HIG."
>
> **Good example:**
> - Navigation uses `NavigationStack` with a tab bar (`TabView`) for the three main sections (Expenses, Budget, Settings) — see `MainTabView.swift`
> - All icons are SF Symbols (`chart.bar.fill`, `gearshape`) to match iOS conventions
> - Touch targets are at least 44×44pt; spacing follows 8pt grid — see `ExpenseRowView.swift`
> - Destructive actions (delete expense) use `.destructive` role with a confirmation dialog — see `ExpenseDetailView.swift`
>
> **Bad example** (do not do this):
> - "I followed Apple's Human Interface Guidelines to make the app intuitive and visually consistent with iOS design."

##### Dark Mode

> TODO: Explain how your app supports dark mode. Name the specific approach.
>
> **Good example:**
> - All colors use semantic system colors (`Color.primary`, `Color(.systemBackground)`) — no hardcoded hex values
> - Custom accent color defined in `Assets.xcassets/AccentColor` with light/dark variants
> - Verified in Simulator by toggling Appearance in Settings — screenshot below:
>   ![Dark mode screenshot](screenshots/dark_mode.png)
>
> **Bad example:** "My app supports dark mode."

##### Persistence

> TODO: Explain what data your app persists and how.
>
> **Good example:**
> - User expenses are stored using SwiftData with a `@Model` class `Expense` in `Models/Expense.swift`
> - The model container is injected at the app root in `ExpenseTrackerApp.swift`
> - Data survives app restarts — verified by adding an expense, force-quitting, and relaunching

##### Responsiveness

> TODO: Explain how your app stays responsive during long-running operations.
>
> **Good example:**
> - Network requests to the exchange-rate API use `async/await` in `ExchangeRateService.swift` so the UI never freezes
> - A `ProgressView` is shown while loading data — see `DashboardView.swift:42`

##### Error Handling

> TODO: Explain how your app handles errors.
>
> **Good example:**
> - Network errors are caught in `ExchangeRateService.swift` and surfaced to the user via an `.alert` modifier in `DashboardView.swift`
> - If the API is unreachable, the app shows cached data with a banner "Showing offline data" — see `OfflineBanner.swift`

##### Logging

> TODO: Explain how your app uses logging.
>
> **Good example:**
> - Using `os.Logger` with a subsystem matching my bundle identifier (e.g., `de.tum.cit.ase.ios26.ExpenseTracker`) and categories per feature (e.g., `Logger(subsystem:category:)` for "Networking", "Persistence")
> - Key events logged: API call start/success/failure in `ExchangeRateService.swift`, SwiftData save errors in `Expense.swift`

##### Responsible AI Usage

> TODO: List the AI tools you used and describe on a high level how you used them. Generic statements like "I used AI to help with coding" are not acceptable.
>
> For each tool, tell us: **what tool and model**, **what you used it for**, and **how you made sure the output was correct**.
>
> Common tools: Xcode Coding Intelligence, Claude Code (Opus 4.6), GitHub Copilot, Cursor, ChatGPT (GPT-5.4), Windsurf
>
> **Good example:**
> - **Xcode Coding Intelligence (Claude):** Used for code completion and generating SwiftUI views. Reviewed all suggestions before accepting — caught a few cases where it used deprecated modifiers.
> - **Claude Code (Opus 4.6):** Used to scaffold the networking layer and debug SwiftData issues. Always reviewed the generated code and tested manually in the Simulator.
> - **GitHub Copilot:** Used for code generation and refactoring suggestions. Reviewed all changes before accepting — rejected suggestions that didn't follow the project's architecture.
>
> **Bad example** (do not do this):
> - "I used ChatGPT to support the design and coding process. All outputs were carefully reviewed."

---

#### Glossary (Abbott's Analysis)

> TODO: Define key terms and concepts used in your project. Clarify domain-specific language or abbreviations.

| Term | Definition |
| ---- | ---------- |
| *example:* Transaction | A record of money moving out of an account in exchange for a product or service. |
| ... | ... |

#### Analysis Object Model

> TODO: Add an analysis object model diagram showing relationships between key entities in your app.

* **Instructions:** Create with [Apollon](https://apollon.aet.cit.tum.de) or the [Apollon VS Code extension](https://marketplace.visualstudio.com/items?itemName=aet-tum.apollon-extension), export as a **PNG or JPEG** and insert it directly (no links, **no SVG**).

<!-- Replace the path below with the actual path to your exported AOM image -->
![Analysis Object Model](diagrams/aom.png)

### Architecture

#### Subsystem Decomposition

> TODO: Break down your app into its main subsystems (e.g., UI layer, networking, data/persistence, domain/logic, feature modules). Describe responsibilities, main data flows, and key dependencies. Include a diagram.

* **Instructions:** Create a UML component diagram with [Apollon](https://apollon.aet.cit.tum.de) or the [Apollon VS Code extension](https://marketplace.visualstudio.com/items?itemName=aet-tum.apollon-extension), export as a **PNG or JPEG** (not SVG) and insert it below.

<!-- Replace the path below with the actual path to your exported subsystem decomposition image -->
![Subsystem Decomposition](diagrams/subsystem_decomposition.png)

* Subsystem A — responsibilities, key types, inbound/outbound data
* Subsystem B — ...
* ...

---

*Replace all TODOs and keep this document current. It is both your planning guide and part of your final deliverable.*
