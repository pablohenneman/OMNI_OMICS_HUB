---
stepsCompleted: [1, 2, 3, 4, 7, 8, 9, 10]
inputDocuments:
  - docs/analysis/product-brief-OMNI_OMICS_HUB-2025-12-23.md
  - docs/ux-design-specification.md
  - docs/analysis/brainstorm-project.md
  - docs/project-context.md
  - docs/excalidraw-diagrams/theme.json
  - docs/excalidraw-diagrams/V1_End_to_end.excalidraw
documentCounts:
  briefs: 1
  research: 0
  brainstorming: 1
  projectDocs: 4
workflowType: 'prd'
lastStep: 11
project_name: 'OMNI_OMICS_HUB'
user_name: 'Pablo'
date: '2025-12-26T14:22:50'
---

# Product Requirements Document - OMNI_OMICS_HUB

**Author:** Pablo
**Date:** 2025-12-26T14:22:50

## Executive Summary

OMNI_OMICS_HUB is a greenfield, desktop-first web app that guides non-experts through omics data import and preprocessing to reach an analysis-ready dataset with explicit checkpoints, provenance, and reproducible state transitions. The V1 focus is proteomics LFQ, with a clear path to future downstream analysis and multi-omics expansion.

### What Makes This Special

A stepwise, gated workflow that delivers confidence and reproducibility for non-experts: explicit commit points, transparent provenance, and a UX designed to prevent setup errors while preserving extensibility for advanced users.

## Project Classification

**Technical Type:** web_app
**Domain:** scientific
**Complexity:** medium
**Project Context:** Greenfield - new project

Classification signals: web app / dashboard UX, Shiny + bslib, scientific/omics data workflows, reproducibility and analysis readiness focus.

## Success Criteria

### User Success

- Users can configure and preprocess a proteomics dataset end-to-end (Steps 0-4 + preprocessing) without getting stuck, confused, or needing external tools.
- Each step explains what is required, why it matters, and what happens next.
- A sensible default path exists; advanced options stay hidden until explicitly opened.
- The UI always shows exactly one primary next action (Apply, Continue, Run, Save).
- Locked steps clearly explain why they are locked and how to unlock them.
- Errors are actionable: what is wrong, why it matters, and what to change.
- Users receive immediate feedback after every meaningful action:
  - data previews after import
  - mapping coverage and ID quality summaries
  - QC plots during preprocessing (distributions, PCA/UMAP)
- Progress indicators make step status obvious (completed, active, pending).
- Warnings are explicit but non-blocking when safe; critical issues block progression with clear guidance.
- Users reach an explicit success state: Preprocessed and Saved Dataset labeled as analysis-ready.
- Reopening a workspace restores the exact same state, parameters, and results.

### Business Success

**3-month success**
- You (and 1-2 friendly users) repeatedly use it for real datasets.
- Manual LFQ setup outside the tool is no longer needed.
- No rewrites of core workflow are required (only UX tuning).

**12-month success**
- A core facility or lab adopts it as the default preprocessing entry point.
- Multiple datasets per project become routine.
- V2 analysis modules feel like a natural extension, not a retrofit.

### Technical Success

- The application faithfully implements the workflows, rules, and behaviors in the brainstorm, UX spec, and PRD with no undocumented deviations.
- Step structure, gating logic, and state transitions match the written specifications.
- UI behavior (Apply/Run semantics, error handling, validation timing) follows UX rules exactly.
- No hidden shortcuts, silent mutations, or undocumented behavior exist.
- Every state change requires explicit user intent and is recorded.
- Reopening a project or workspace restores the exact step, parameters, and dataset state.
- Analysis-ready datasets are reproducible from raw input plus saved configuration and preprocessing parameters.
- Typical V1 datasets process without crashes or data loss.
- Downstream steps invalidate predictably when upstream changes occur.
- Behavior is consistent across repeated use.

### Measurable Outcomes

- End-to-end completion of Steps 0-4 + preprocessing without external tools.
- Explicit "Preprocessed and Saved Dataset" state reached and persisted.
- Deterministic restoration of state after reopen (step, params, dataset state).
- Zero undocumented deviations from workflow and UX specifications in V1.

## web_app Specific Requirements

### Project-Type Overview

OMNI_OMICS_HUB is a single-page web application (Shiny) with internal navigation for Project -> Workspace -> Steps. It prioritizes resume-at-exact-step behavior with persistent state.

### Technical Architecture Considerations

- Single Shiny SPA with internal routing/step state.
- Desktop-first layout; mobile browsers are not targeted for active analysis.
- UI should support immediate validation feedback and progress indicators for running steps.
- No real-time collaboration; "real-time" behavior is local UI responsiveness only.

### browser_matrix

- Primary browsers: Chrome, Edge, Firefox (desktop).
- Secondary: Safari (desktop).
- Mobile: not supported for active analysis; show warning/limited mode under 768px.

### responsive_design

- Desktop-first layout with breakpoints at 1280px and 768px.
- >=1280px: full layout (left-nav + split workspace).
- 768-1279px: collapsed nav + stacked panels.
- <768px: read-only / limited mode with warning.

### performance_targets

- UI feedback must feel immediate for validations and previews.
- Step runs show clear progress states; no background queues in V1.

### seo_strategy

- No SEO requirements; app-style workflow tool, not a marketing site.

### accessibility_level

- WCAG AA for core UI elements (navigation, buttons, forms, focus states, contrast).

### Implementation Considerations

- Preserve explicit Apply/Continue/Run/Save semantics.
- Avoid implicit state changes; all mutations require explicit user action.
- Ensure state restoration is deterministic across sessions.

## Product Scope

### MVP - Minimum Viable Product

- Full, guided configuration flow (Steps 0-4) with gating and explicit Apply/Continue semantics.
- Preprocessing flow with QC feedback and explicit Save Preprocessed Data checkpoint.
- Provenance capture for all state-changing actions.
- Restore exact workflow state, parameters, and dataset on reopen.
- Clear progress indicators, locked-step explanations, and actionable errors.

### Growth Features (Post-MVP)

- Expanded UX polish and tuning informed by real user feedback.
- Broader dataset and project handling (multiple datasets per project as a routine workflow).
- Preparation for downstream analysis modules.

### Vision (Future)

- V2 analysis modules that extend naturally from the preprocessing foundation.
- Wider adoption across core facilities and labs as a standard entry point.

## User Journeys

**Journey 1: Elena Rossi (Bench Scientist) - From Raw File to Analysis-Ready Confidence**
Elena has a proteomics LFQ file from her core facility and needs to get to analysis-ready data without derailing her week. She opens OMNI_OMICS_HUB, creates a project, and starts a new workspace. The stepwise flow keeps her calm: Step 0 explains the required dataset properties, Step 1 walks her through import with a clear preview, and she understands missingness because the app tells her exactly what was parsed and why.

As she assigns columns, she first selects the gene name column, but the mapping feedback notifies her that the protein ID column will yield higher coverage. She switches to protein IDs and proceeds with better mapping confidence. The system warns about ambiguous IDs without blocking her unnecessarily. Each step has one clear action: Apply or Continue. When she reaches preprocessing, QC plots give her confidence that normalization and imputation are behaving. She saves the dataset and sees a visible "Preprocessed and Saved" state. The relief is immediate: she didn't have to open any external tools or guess her way through the workflow. When she returns the next day, the workspace resumes exactly where she left off.

**Journey 2: Diego Alvarez (Non-Omics Collaborator) - The Novice Stress Test**
Diego received an LFQ export but has never configured omics data before. He's nervous about breaking something. OMNI_OMICS_HUB starts with simple, plain-language guidance and a default path with advanced options hidden. At every step, the UI tells him what is required, why it matters, and what happens next. When he hits a validation error, it explains the fix in plain terms and shows him how to proceed.

He sees a locked preprocessing step and the UI clearly explains it is locked until configuration is complete. He follows the single visible next action and reaches a saved, analysis-ready dataset. The moment he sees the explicit "Preprocessed and Saved" state is his success moment: he finally feels confident that he did it correctly without needing to ask for help.

**Journey 3: Priya Nair (Core Facility Analyst) - Repeatable at Scale**
Priya processes multiple client datasets per week. She needs speed and consistency. She opens OMNI_OMICS_HUB, creates a new workspace, and the structured flow lets her repeat the same configuration pattern quickly. Mapping coverage and ID quality summaries help her decide fast, and preprocessing QC plots surface issues early without extra tooling.

She appreciates that every state change is explicit and recorded, so troubleshooting client questions is straightforward. She also imports a basic omics analysis, reimports the dataframe, and the system automatically re-runs preprocessing with the saved parameters. When she reopens any workspace, the system restores the exact step and parameters, which saves time and reduces errors. Her success moment is realizing she can standardize preprocessing without losing provenance or needing to reinvent the process for every dataset.

**Journey 4: Sam Chen (Builder/Analyst) - Fidelity and Debuggability**
Sam is building the platform and needs the implementation to match the written specs precisely. He uses OMNI_OMICS_HUB as both a user and a debugger: every step is explicit, Apply/Run semantics are consistent, and invalidations are predictable when upstream changes occur. The system's provenance records make it clear which parameters produced which outputs.

When a dataset behaves unexpectedly, Sam can reproduce it by replaying the saved configuration and preprocessing parameters. The workflow never mutates silently, and every decision is discoverable in logs and state. The breakthrough for Sam is confidence: the product behaves deterministically and matches the UX and workflow contracts.

### Journey Requirements Summary

These journeys reveal the following capability requirements:
- Guided, stepwise flow with explicit Apply/Continue/Run/Save actions
- Clear, actionable validation and error messaging at every step
- Locked-step explanations with unblock guidance
- Data previews, mapping summaries, and QC feedback tightly coupled to each step
- Explicit success state: "Preprocessed and Saved Dataset"
- Deterministic state restoration on reopen (step, parameters, dataset state)
- Provenance and logging for all state changes
- Predictable invalidation rules when upstream steps change

## Project Scoping & Phased Development

### MVP Strategy & Philosophy

**MVP Approach:** Experience MVP focused on spec fidelity and calm, guided workflow.
**Resource Requirements:** Medium, tightly constrained scope emphasizing correctness over breadth.

### MVP Feature Set (Phase 1)

**Core User Journeys Supported:**
- Bench Scientist
- Non-Omics Collaborator
- Core Facility Analyst
- Builder/Analyst

**Must-Have Capabilities:**
- Strict step gating across Steps 0-4 + preprocessing
- Explicit Apply/Run/Continue/Save semantics
- Visible provenance and state-change logs
- Predictable invalidation of downstream steps on upstream changes
- Resume exactly where you left off (step, parameters, dataset state)
- Calm UX with one clear next action at all times

### Post-MVP Features

**Phase 2 (Post-MVP):**
- Canonical downstream analyses for proteomics + RNA-seq
- DE, WGCNA, ORA, FGSEA, GSVA, and a limited set of related methods
- Expanded normalization and imputation options
- No new workflow steps, gating logic, or state transitions

**Phase 3 (Expansion):**
- Additional omics layers beyond proteomics/RNA-seq
- Multi-omics integration and cross-dataset workflows
- AI-assisted guidance deferred to late Phase 3 or beyond

### Risk Mitigation Strategy

**Technical Risks:** specification drift or hidden behavior; tight UI-backend coupling.
**Mitigation:** treat PRD/UX/brainstorm as contracts; enforce Apply/Run semantics; prohibit silent mutations; keep OmicsWorkspace logic callable outside the UI.

**Market Risks:** users default to Perseus or custom scripts.
**Mitigation:** differentiate on calm UX, clarity, and reproducibility; optimize for "did not get stuck" as the primary value signal.

**Resource Risks:** scope creep before MVP stability.
**Mitigation:** freeze scope; defer anything not required for V1 journeys or Phase 2 canonical analyses.

## Functional Requirements

### Foundational Domain & Infrastructure (Implement First)

- FR-1: OmicsDataset data model representing assays, rowData, colData, dataset properties, and preprocessing metadata.
- FR-2: Explicit raw input storage, detachment, and reconstruction rules with visible state.
- FR-3: OmicsProject as project-level root object mapped to disk with a manifest.
- FR-4: Central DatabaseManager with deterministic, reproducible feature mapping and provenance.
- FR-5: OmicsWorkspace as authoritative unit of work with full lifecycle APIs; usable outside UI.
- FR-6: Registry mapping dataset properties to enabled capabilities.
- FR-7: Explicit state machine with predictable invalidation and explicit transitions.
- FR-8: Provenance recording for all state-changing actions with replayability.
- FR-9: Structured logging (user/dev) independent of provenance.

### Project & Workspace Lifecycle

- FR-10: Project creation/open/delete/list with explicit confirmation for destructive actions.
- FR-11: Workspace creation/open/delete/import/export with project registration.

### Dataset Configuration Workflow (Steps 0-4)

- FR-12: Dataset properties config with gating and invalidation tied to registry outputs.
- FR-13: CSV/TSV/XLSX import with NA detection, preview, and explicit commit.
- FR-14: Column assignment to Expression/RowData/Ignore with validation and conflict resolution.
- FR-15: Feature ID configuration with delimiter, dedupe, ID type/species, mapping quality, and provenance.
- FR-16: Guided colData configuration with validation, identity selection, and persistence.

### Execution & Preprocessing Workflow

- FR-17: Computation only via explicit Apply/Run actions; validation gates execution.
- FR-18: Filtering with explicit masks, QC guidance, and downstream invalidation.
- FR-19: Normalization with log handling, NA preservation, and diagnostics.
- FR-20: Imputation + scaling with tracked masks and RNG seeds + diagnostics.
- FR-21: Variable features + PCA/UMAP/t-SNE with persisted parameters/outputs.

### UX Behavior as Functional Contract

- FR-22: Navigation, gating, and step states with exact resume behavior.
- FR-23: Actionable validation, errors, and warnings before Apply/Run.

### Persistence, Export & Analysis Readiness

- FR-24: Persist/restore workspace state, dataset state, and provenance exactly.
- FR-25: Export/import full workspaces with required artifacts for reuse.
- FR-26: Explicit "Preprocessed & Saved" checkpoint gating downstream analyses.

### Forward-Declared (Phase-Aware) Requirements

- FR-27: The system SHALL provide an extension point for registering future analyses and storing typed results, without implementing analyses in V1.
- FR-28: UI is a consumer of domain logic; core logic usable without UI.

### UX-Spec Compliance Addendum (Must Hold in V1)

- FR-29: Provide split workspace layout (config left / plots right) with stepper tabs for Steps 0-4 + preprocessing and a persistent two-row progress module on the workspace dashboard.
- FR-30: Expose step states (locked/ready/dirty/running/completed) visually; locked states explain unblock path; exactly one primary next action is visible at all times.
- FR-31: Column mapping uses a tri-panel model (RowData | Ignore | Expression) with drag/drop, multi-select, search, bulk select, numeric validation, and explicit conflict resolution.
- FR-32: Sample Metadata Builder supports delimiter-aware suggestions, unassigned list visibility, overlap prevention, irregular sample handling, combined traits, and active identity selection.
- FR-33: Import/Parsing UI enforces NA token scanning + re-parse if none found; reports parsed vs token-normalized missingness distinctly; preview required before commit.
- FR-34: Preprocessing feedback includes density/boxplot toggles, imputation heatmap, variable-feature rank plot, and PCA/UMAP/t-SNE view toggles.
- FR-35: Apply commits a single step; "Save Preprocessed Data" freezes state and unlocks downstream; dirty vs saved messaging is explicit and persistent.
- FR-36: Provide Run/Provenance status strip and log visibility in-app with user/dev levels.
- FR-37: Workspace export bundles internal DB artifacts referenced by the workspace for portability.

## Non-Functional Requirements

### Performance

**Reference workload (V1 baseline):**
- Typical LFQ proteomics dataset (~5-10k features x 4-200 samples)
- Plots up to a few thousand points/lines
- No full-resolution mega-heatmaps by default

**Targets for reference workload:**
- Interactive UI actions (navigation, form edits, previews) respond within 200 ms.
- Apply/Run actions show a running/loading state within 100 ms.
- Typical preprocessing steps (filtering, normalization, imputation, PCA) complete within 5-15 seconds.
- Plot rendering completes within 2 seconds after computation finishes.

**Graceful degradation (all workloads):**
- System never freezes silently; heavy operations surface running/progress state.
- For larger datasets, the system provides explicit progress indicators, avoids blocking unrelated UI when feasible, offers size-aware plotting (downsampling/aggregation/summary), and requires explicit user intent for expensive plots.
- Performance degradation is explained to the user (e.g., "rendering simplified due to dataset size").

### Reliability

- Silent data loss is unacceptable.
- Workspace state is recoverable after UI crash, R session restart, or forced reload if last Apply/Save completed successfully.
- Partial or failed executions leave last valid state intact, surface a clear error, and do not corrupt workspace files or provenance.
- Destructive actions (delete, overwrite, invalidate saved state) require explicit confirmation.

### Accessibility

- WCAG AA compliance required for core UI elements: navigation, buttons, forms, validation/error messaging, focus states.
- Desktop-first usage only; mobile interaction limited to read-only or warning states.
- Color is never the sole indicator of state (errors, warnings, locked steps).

### Security & Privacy (Data Protection)

- V1 is strictly local-first: no cloud sync, no remote execution.
- All data remains on the user's machine unless explicitly exported.
- No telemetry or external data collection beyond optional local logs.
- Exported workspaces are fully portable and do not rely on external paths, undeclared databases, or hidden runtime dependencies.
- Authentication/authorization/multi-user security is out of scope for V1.

### Scalability

- V1 targets single-user, single-project active usage.
- Multiple workspaces per project are supported; only one workspace active at a time.
- No concurrency guarantees for multiple users or parallel sessions.
- Architecture should not preclude future async execution, background jobs, or multi-user expansion.

### Reproducibility & Determinism

- Preprocessing outputs are reproducible given identical raw input, parameters, database versions, and RNG seeds.
- All stochastic steps (imputation, UMAP, t-SNE) record RNG seeds and default to deterministic behavior.
- Replaying provenance reproduces dataset state, preprocessing results, and step ordering exactly.
- Logging verbosity and UI state do not affect computational results.
