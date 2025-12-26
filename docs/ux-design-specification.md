---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
inputDocuments:
  - docs/analysis/product-brief-OMNI_OMICS_HUB-2025-12-23.md
  - docs/project-context.md
  - docs/analysis/brainstorm-project.md
  - User_Notes/preprocessing_guidelines.md
  - User_Notes/step_00_dataset_properties_bmad.md
  - User_Notes/step_04_sample_data_colData_configuration.md
  - User_Notes/steps_01_to_03_import_and_rowdata_flow.mdworkflowType: 'ux-design'
lastStep: 14
project_name: 'OMNI_OMICS_HUB'
user_name: 'Pablo'
date: '2025-12-23'
---
# UX Design Specification OMNI_OMICS_HUB

**Author:** Pablo
**Date:** 2025-12-23

---

<!-- UX design content will be appended sequentially through collaborative workflow steps -->
## Executive Summary

### Project Vision

OMNI_OMICS_HUB is a guided, stepwise omics configuration and preprocessing platform (proteomics-first in V1) that reduces analysis paralysis by providing a clear, minimal-input path from raw data to an analysis-ready dataset (OmicsWorkspace). The UX prioritizes confidence, reproducibility, and explicit checkpoints over flexible but confusing workflows.
Terminology note: OmicsWorkspace is the canonical top-level container; OmicsAnalysis is a legacy synonym for the same object. Use "analysis" only for downstream analysis modules.

### Target Users

- Bench scientists and non-omics collaborators who need a guided, error-resistant workflow.
- Core facility staff who run repeatable preprocessing pipelines and share results.
- PIs/supervisors who want clean, trustworthy outputs.
- The platform builder/analyst who needs debuggability and modularity.

### Key Design Challenges

- Preventing "how do I start?" confusion while handling complex data structures.
- Supporting both novices and experts without overwhelming either group.
- Making configuration steps feel guided and reversible, with clear progress gates.

### Design Opportunities

- A minimal-input "happy path" with advanced options tucked under an "Advanced" mode.
- Clear step gating, progress cues, and guardrails that build user confidence.
- Panel/tab-centric flows that mirror the mental model of the configuration steps.
## Core User Experience

### Defining Experience

The core experience is a guided "get started" flow: Home -> Projects -> Workspace -> Resume at the exact step with saved parameters. Users should always know where they are in the workflow and be able to continue without reconfiguration.

### Platform Strategy

Desktop-first (laptop/PC) web app, optimized for mouse/keyboard and typical office workflows. No offline requirements noted.

### Effortless Interactions

- One-click "Get Started" from Home to Projects.
- Fast project creation (name + folder selection).
- Clear recent projects list with safe open/delete actions.
- Workspace creation/import should be straightforward.
- Reopening a workspace resumes the exact step with all parameters intact.
- Workspace export is self-contained (data, configuration, preprocessing state, provenance, referenced internal databases); import always creates a new workspace.

### Critical Success Moments

- Creating/opening a project without confusion.
- Selecting/creating an OmicsWorkspace and quickly being able to import , configure and preprocess a data
- Seeing feedback on thresholds and parameters set + concise instructions so user does not feel lost

### Experience Principles

- **Guided progression:** show users exactly where to go next.
- **State continuity:** never lose configuration or progress.
- **Low cognitive load:** minimal required input, advanced options tucked away.
- **Safe confidence:** explicit checkpoints and predictable behavior.
## Desired Emotional Response

### Primary Emotional Goals

- Confidence in actions and outcomes.
- Transparency about what each action does and its effects.

### Emotional Journey Mapping

- **Discovery:** Calm and guided, no analysis paralysis.
- **Core Usage:** In control, with clear next steps and progress.
- **Errors/Recovery:** Informed and supported, with actionable guidance.
- **Return Use:** Trust that state and settings are preserved.

### Micro-Emotions

- Confidence over confusion.
- Trust over skepticism.
- Calm over panic.

### Design Implications

- Make every step explainable (why it matters, what it changes).
- Provide explicit checkpoints and status signals.
- Error states must explain what failed and what to reconfigure.

### Emotional Design Principles

- **Clarity first:** explain before asking.
- **Actionable feedback:** every error includes next steps.
- **Predictable state:** users always know where they are and what's saved.
## UX Pattern Analysis & Inspiration

### Inspiring Products Analysis

**Perseus**
- Strength: hands-on, direct manipulation of data for filtering, missingness inspection, PCA, clustering, and DE.
- UX wins: exploratory "look-and-decide" flow with immediate visual feedback; low barrier for non-coders.
- Limits: session-based workflows and weaker reproducibility for repeated analyses.

**OmicsPlayground**
- Strength: polished exploration dashboards after preprocessing is complete.
- UX wins: modular analysis panels (DE, enrichment, clustering, WGCNA) with consistent controls; easy switching between contrasts and visualizations; works for beginners and experts.
- Limits: assumes preprocessing elsewhere; limited raw data manipulation.

### Transferable UX Patterns

- **Direct data manipulation with immediate visual feedback** (from Perseus) for filtering/missingness checks in preprocessing.
- **Modular panel layout with consistent controls** (from OmicsPlayground) for analysis screens and future extensions.
- **Fast toggling between settings and views** to reduce cognitive load and encourage exploration.

### Anti-Patterns to Avoid

- Session-only workflows without reproducible checkpoints (Perseus limitation).
- Tooling that assumes preprocessing is done elsewhere (OmicsPlayground gap).
- Hidden state changes that make results feel untrustworthy.

### Design Inspiration Strategy

**Adopt**
- Direct, visual preprocessing controls with instant feedback.
- Consistent panel controls across modules.

**Adapt**
- Perseus's interactive feel but wrap it with explicit checkpoints and provenance.
- OmicsPlayground's dashboard modularity but bring preprocessing upstream.

**Avoid**
- Non-reproducible, session-only flows.
- UI designs that detach preprocessing from the core workflow.
## Design System Foundation

### 1.1 Design System Choice

Themeable system using bslib as the primary design foundation.

### Rationale for Selection

- Balanced speed and customization for a small team.
- bslib aligns with the Shiny/golem stack and provides consistent, accessible defaults.
- Supports a calm, guided UI without heavy custom build effort.

### Implementation Approach

- Use bslib themes to define typography, color, spacing, and component styles.
- Standardize layout and navigation patterns across panels/tabs.
- Keep advanced controls behind consistent "Advanced" panels.

### Customization Strategy

- Start with a clean base theme and adjust tokens (colors, fonts, spacing).
- Define reusable UI patterns for steps, gating, and error states.
- Extend only when necessary; prioritize consistency.
## 2. Core User Experience

### 2.1 Defining Experience

Configure and preprocess omics data in ~10 minutes without getting stuck, using a guided, stepwise flow from project setup to a saved preprocessed dataset.

### 2.2 User Mental Model

Users expect a "wizard-like" sequence with clear steps, each explaining what's happening and why. They want quick validation, visible progress, and reassurance that the platform is doing the right thing.

### 2.3 Success Criteria

- Complete Steps 0-4 + preprocessing within ~10 minutes for a typical dataset.
- No dead-ends; clear next step after every action.
- Errors are explained with specific fixes.
- Users can resume at the exact step with saved parameters.
Data limits are soft guardrails (warnings only) and do not block execution in V1.

### 2.4 Novel UX Patterns

The core flow uses established patterns (wizard + step gating) with a stronger emphasis on reproducibility and explicit checkpoints. The novelty is in combining interactive, visual data inspection with a strict provenance trail.

### 2.5 Experience Mechanics

**Initiation:** User selects or creates a project, then creates/opens a workspace.
**Interaction:** Step-by-step panels guide dataset properties -> import -> mapping -> rowData -> sample metadata -> preprocessing.
**Feedback:** Live previews, validation messages, and plot-based diagnostics at each step (e.g., missingness summaries, density/boxplots, PCA/UMAP views, clustering/QC plots) to make progress and data quality visible. Missingness reporting separates parsed NA vs token-normalized NA, and separates expression data vs rowData.
**Completion:** "Save Preprocessed Data" confirms a stable, analysis-ready dataset and unlocks downstream analysis.
Apply commits a single step’s parameters and outputs; Save Preprocessed Data is a distinct freeze.
V1 execution is synchronous with minimal running indicators; async queues/background processing are post-V1 only.
## Visual Design Foundation

### Color System

Use the provided palette as the core system:

- **Primary:** #21271f, #323b2f, #424e3f, #53624f
- **Accent/Action:** #6e8b74, #819b87, #95ab9a, #a9bbad
- **Neutrals:** #f7f8f6 (app background), #ffffff (panel), #c0cabe (border)
- **Text:** #1f2721 (primary), #5e7764 (muted)
- **Status:** success #6b8e6d, info #7f9e81, warning #adbaaa, error #9a5a5a

Semantic mapping:
- Primary actions use  ccent_500
- Panels use g_panel with order
- App background uses g_app
- Status colors used for alerts, badges, and validation feedback

### Typography System

- **Tone:** professional, modern, calm
- **Primary font:** TBD (suggest IBM Plex Sans or Source Sans 3)
- **Hierarchy:** clear, readable headings + compact label styles for forms and tables
- **Body size:** 14-16px with comfortable line height (~1.45-1.6)

### Spacing & Layout Foundation

- **Base spacing:** 8px system (8/16/24/32/48)
- **Layout:** spacious and calm; avoid dense tables unless in advanced views
- **Panels:** generous padding with clear section dividers
- **Progress:** step headers and status banners aligned to the same grid

### Accessibility Considerations

- Maintain sufficient contrast between text and backgrounds
- Avoid low-contrast status colors for critical warnings
- Ensure focus states and error messages are visibly distinct
## Design Direction Decision

### Design Directions Explored

We reviewed six mockup directions. The strongest elements were:
- A: stepper-based guidance
- C: split workspace (configuration + live plot feedback)
- E: carded layout with advanced sections

### Chosen Direction

A hybrid: **Tabbed Stepper + Split Workspace + Collapsible Advanced Cards**.

### Design Rationale

- Tabs with step names reduce analysis paralysis and make progress explicit.
- Split workspace keeps configuration and feedback visible together.
- Advanced sections stay hidden by default but are always discoverable.

### Implementation Approach

- Top stepper/tabs for Steps 0-4 and preprocessing.
- Left column: configuration panels with cards; right column: plots/preview.
- Global "Advanced" toggle for power users.
- Per-panel "See more" controls for granular expansion.
## User Journey Flows

### End-to-End Setup & Preprocessing

**Journey Goal:** Create a project and workspace, configure data, complete preprocessing, and reach a saved preprocessed dataset.

`mermaid
flowchart TD
  A[Launch app] --> B[Landing Page: Open / Create Project]
  B --> C[OmicsProject Dashboard: Open / Import / Create OmicsWorkspace]
  C --> D[OmicsWorkspace Dashboard: Config/preprocess navigation and progress panel]
  D --> F[Config/preproc. screen:] 
  F --> G[Tab Workspace Properties + Import Data: apply&continue]
  H --> I[Tab Column & feature Mapping: apply&continue]
  I --> K[Tab Sample Metadata builde: apply&continuer]
  K --> L[Tab Sample and feature Filtering: apply&continue]
  L --> M1[Tab Normalization: apply&continue]  
  M1 -> M2[Tab  Imputation / Scaling: apply&continue]
  M2 --> N[Preprocessing: Variable Features + Dimensionality Reduction: save]
  N --> P[Downstream Analysis (post-V1)]
`

**Entry Points:** Home -> Projects; Project Dashboard -> Create Workspace
**Success State:** Preprocessed data saved; workspace can be resumed at last step
Steps 0–4 are canonical even when UI panels are merged; Continue advances step state, not panel layout. Step 0 + Step 1 share a panel; Step 2 + Step 3 share a panel (may be split later).

### Journey Patterns

- **Left-nav with grouped sections:** Import -> (Configuration, Preprocessing) for clear progression.
- **Step gating:** Users cannot skip required steps; each step explains "why this matters."
- **Resume state:** Reopen workspace at exact last step with saved parameters.
- **Progress feedback:** Plots/preview on the right, configuration on the left.

### Flow Optimization Principles

- Minimize steps to value: users reach preprocessing quickly.
- Always show next action and completion criteria.
- Keep advanced options tucked away (global + per-panel).
- Errors must be actionable with clear fixes.
## Component Strategy

### Design System Components

Use bslib + standard patterns for layout and navigation:

- **Project Picker** (recent projects + create new)
- **Workspace Selector** (create/import/resume)
- **Left Navigation** (Import -> Configuration -> Preprocessing -> Analyses [post-V1])
- **Split Workspace Layout** (config left, plots right)
- **Advanced Toggle** (global + per-panel "see more")

### Custom Components

These encode omics semantics, state gating, provenance, and async behavior (post-V1):

**Stepper Tabs (Steps 0-4 + Preprocessing)**
Purpose: guided, gated progression
States: inactive / ready / dirty / running / completed
Logic: invalidation propagation across downstream steps

**Column Mapping Tri-Panel (Expression | RowData | Ignore)**
Drag/drop + multi-select, adapter presets, validation overlays
Numeric coercion + live head preview
Core differentiator vs. existing tools
Feature IDs: first occurrence may map; duplicates are suffixed (.1/.2) and are not mapped; internal DB duplicates resolve by deterministic first match.

**Sample Metadata Builder**
Delimiter-aware suggestions; one value at a time
Unassigned list always visible
Overlap prevention + live preview

**Preprocessing Queue Panel** (post-V1)
Ordered steps with async execution, per-step status, and resume/retry semantics. V1 uses synchronous execution with brief running indicators only.

**Checkpoint Banner ("Save Preprocessed Data")**
Explicit state freeze and gating of downstream analyses
Clear dirty vs saved messaging

**Plot Feedback Panel (QC-first)**
Density/boxplots/PCA/UMAP
Tight coupling to step params
Consistent action bar + render toggle

**Run / Provenance Status Strip**
Chips: state_id, last run, warnings, annotation coverage
Click-through to logs
Logs record parameters, start/end time, and duration for each step; User logs show outcomes/warnings/failures, Dev logs include parameter diffs and load/compute timings.

### Component Implementation Strategy

- Build custom components around bslib tokens for consistent theming.
- All custom components must expose state + provenance in UI.
- Validation and error messages must be explicit and actionable.

### Implementation Roadmap

**Phase 1 - Core Workflow**
- Stepper Tabs
- Column Mapping Tri-Panel
- Sample Metadata Builder
- Checkpoint Banner

**Phase 2 - Trust & Feedback**
- Plot Feedback Panel
- Run / Provenance Status Strip
- Validation Summary Panel (aggregate blockers)

**Phase 3 - Async & History** (post_v1)
- Preprocessing Queue Panel
- Global Run Status Bar
- Run History / Variant Selector
- Empty-State Components
## UX Consistency Patterns

### Feedback Patterns

- User-input errors and warnings validate immediately (change/blur).
- Feedback appears inline at field or step level.
- Errors must explain: **what failed -> why -> what to change -> what happens next**.
- Warnings are non-blocking and explicitly state the user may proceed.
- Success messages indicate meaningful state changes; checkpoint success does not auto-dismiss.
- Info messages are explanatory only and never indicate system state.
- Modals are reserved for destructive/irreversible actions requiring explicit consent.
Error taxonomy: Validation errors are user-fixable and block Apply/Continue; System errors are unexpected and logged with an error ID.

### Apply / Run Action Rule

- Any computation or state mutation requires explicit Apply / Run.
- No calculations are triggered automatically by form changes.
- Validation must pass before Apply is enabled.
- Post-Apply errors are treated as critical/system errors and surfaced distinctly.

### Empty, Locked, and Loading States

- Locked steps/panels appear light-gray and unavailable.
- Clicking a locked element explains why it's locked and how to unlock it.
- True empty states should be rare due to step gating.
- Panels appear empty only while a calculation is running.
- Loading states must say what is running (step/process), not just a spinner.
- Use a consistent loading placeholder (logo + status text).

### Navigation Patterns

- Left navigation is module-level only.
- Stepper navigation is exclusive to intake + preprocessing workflows.
- Tabs group closely related topics within a module.
- Workflow order is system-enforced; users cannot reorder steps.
- Disabled/locked nav elements explain why they're unavailable.
- Stepper reflects state: inactive / ready / dirty / running / completed.

### Button Hierarchy

- One primary action per surface.
- Primary actions advance workflow (Apply, Run, Save).
- Destructive actions are never primary.
- V1 actions show brief running state (Apply -> Running... -> Completed) without background queues.
- Icon-only buttons allowed only in action bars with tooltips.

### Form Patterns & Validation

- No errors shown on initial render.
- Validation triggers on change/blur.
- Field-level errors before global summaries.
- Invalid forms disable Apply/Run.
- Validation summaries appear only when blocking progression.

### Search & Filter Patterns (Light Lock)

- Search and filtering are non-destructive and reversible.
- Active filters are always visible.
- Detailed patterns can be defined later.
## Responsive Design & Accessibility

### Responsive Strategy

- **Desktop-first** design for laptop/desktop use only.
- Prioritize precision and information density over small-screen usability.
- Mobile is not a target platform for active analysis.

### Breakpoint Strategy

- **>=1280px:** full supported layout (left-nav + split workspace).
- **768-1279px:** graceful fallback (collapsed nav, stacked panels).
- **<768px:** read-only / unsupported for active analysis.

### Accessibility Strategy

- Target **WCAG AA** for core UI elements only:
  - Navigation, buttons, forms, focus states, contrast.

### Testing Strategy

- Desktop browsers: Chrome, Firefox, Edge (primary), Safari (secondary).
- Tablet-size resizing to validate fallback layout.
- Keyboard-only navigation for core UI flows.
- Color contrast checks for all core actions and states.

### Implementation Guidelines

- Desktop-first layout with CSS breakpoints at 1280px and 768px.
- Disable or warn for active analysis on screens <768px.
- Maintain visible focus states and AA contrast for primary interactions.
