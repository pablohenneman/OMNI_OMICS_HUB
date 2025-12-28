---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
inputDocuments:
  - docs/prd.md
  - docs/ux-design-specification.md
  - docs/project-context.md
  - docs/analysis/brainstorm-project.md
hasProjectContext: true
projectContextPath: docs/project-context.md
workflowType: 'architecture'
lastStep: 8
project_name: 'OMNI_OMICS_HUB'
user_name: 'Pablo'
date: '2025-12-27T10:47:54'
---
status: 'complete'
completedAt: '2025-12-27T16:00:52'


# Architecture Decision Document

_This document builds collaboratively through step-by-step discovery. Sections are appended as we work through each architectural decision together._

## Project Context Analysis

### Requirements Overview

**Functional Requirements:**
- Guided, step-gated configuration (Steps 0-4) and preprocessing flow with explicit Apply/Run/Save checkpoints and strict invalidation.
- Explicit workspace state model tracking phase (configuration vs preprocessing), current step/substep, and step status (locked/ready/dirty/running/completed) for UI gating and resume behavior.
- OmicsProject/OmicsWorkspace/OmicsDataset object model with strict ownership and persistence to disk.
- Clear authority boundaries: OmicsWorkspace owns workflow state; OmicsDataset owns data/metadata/preprocessing outputs; UI state is derived and non-authoritative.
- Deterministic state restoration, provenance capture, and replayable workflow state.
- Feature mapping via DB Manager with coverage scoring, deterministic duplicate handling, and mapping summaries.
- Rich domain-specific UI components (tri-panel mapping, sample metadata builder, QC plots, step state indicators).
- Workspace-scoped navigation and progress: persistent left navigation and step/progress indicator tied to workspace state, enforcing gating and resume-at-exact-step behavior.
- Workspace import/export as self-contained bundles (data + config + provenance + internal DB artifacts).
- Headless core logic: dataset manipulation, preprocessing, mapping, invalidation callable without UI for deterministic testing.

**Non-Functional Requirements:**
- Local-first, privacy-by-design, no cloud sync.
- Reproducibility and determinism (seeded stochastic steps, replayable provenance).
- Reliability: crash-safe commit points (only completed Apply/Run/Save are durable); no silent data loss; explicit confirmations for destructive actions.
- Recovery: on restart, restore last committed state and step, never intermediate state.
- Accessibility: WCAG AA for core UI.
- Performance: interactive UI feedback; synchronous V1 execution.
- Maintainability: core domain logic usable outside UI.
- Versioning: workspace schema, dataset schema, provenance format, and internal DB artifacts versioned; reproducibility scoped to matching inputs, parameters, RNG seeds, and versions.

**Scale & Complexity:**
- Primary domain: desktop-first Shiny web app with heavy client interaction + data pipeline.
- Complexity level: medium.
- Estimated architectural components: ~7-9 (UI shell, workflow/state engine, domain model, persistence, provenance/logging, DB manager, preprocessing engine, import/export).

### UX Specification Clarifications

- Persistent workspace left navigation is always visible within a workspace (dashboard, configuration, preprocessing, results) and reflects state (locked/active/completed) with gating.
- Selecting Configuration/Preprocessing routes to the active step if incomplete, or the latest completed step if finished.
- A reusable step/progress indicator shows configuration and preprocessing status with step-level states; it is always visible, can be collapsed on the workspace dashboard after completion, and remains fully visible on configuration/preprocessing screens.
- The left nav and step/progress indicator are informational/guiding only and derive entirely from the authoritative workspace state model.
- UI theming must implement the UX design system tokens (colors, typography, spacing) defined in the UX specification.
- Advanced options are hidden by default via a global "Advanced" toggle and per-panel "See more" controls.
- Terminology: OmicsWorkspace is canonical; OmicsAnalysis is legacy and reserved for downstream analysis modules.

### Technical Constraints & Dependencies

- Stack direction: Shiny + golem + bslib; ggplot2/ComplexHeatmap; optional plotly.
- Explicit Apply/Run/Save semantics; no implicit mutations or background recomputation in V1.
- Stepwise gating, resume-at-exact-step behavior; single-page app routing.
- Local-only storage with project folder manifest; export/import as portable bundles.
- Registry-driven capability gating by dataset properties.
- DB Manager handles feature mapping (type/species) and exposes deterministic mapping APIs.
- Explicit V1 non-goals: no branching/parallel workflows, no concurrent workspace editing.

### Cross-Cutting Concerns Identified

- Provenance vs logging separation: provenance is deterministic and replayable; logs are non-deterministic diagnostics/timing.
- Each state-changing action produces exactly one provenance entry and may emit zero+ log messages.
- Deterministic invalidation and restore of workflow state when upstream changes occur.
- Strict separation between UI parameters and dataset state; core logic callable without UI.
- Configured vs active dataset boundary: configured dataset is reproducible from raw input; active dataset is mutated by preprocessing with reconstruction paths preserved.
- Data privacy and offline constraints shaping storage, import/export, and execution.

## Starter Template Evaluation

### Primary Technology Domain

Desktop-first Shiny web application in R, with a package-structured architecture (golem) and bslib-based UI.

### Starter Options Considered

**Selected: golem**
Canonical Shiny app framework; aligns with modular architecture, clean UI/server separation, and long-term maintainability. No alternatives required at this stage.

### Selected Starter: golem

**Rationale for Selection:**
- Matches documented technical direction (golem as canonical scaffold).
- Supports modular UI/server design needed for step-gated workflow and reusable domain logic.
- Integrates cleanly with bslib theming and Shiny module patterns.

**Initialization Command:**

```bash
R -q -e "golem::create_golem('OMNI_OMICS_HUB', open = FALSE)"
R -q -e "renv::init()"
```

Note: `renv::init()` may be deferred until initial dependency selection is confirmed, to avoid churn if the scaffold changes.

**Architectural Decisions Provided by Starter:**

**Language & Runtime:**
- R + Shiny runtime; golem package structure with modules and app entrypoint.

**Styling Solution:**
- bslib for Bootstrap 5 theming; bsicons for iconography.

**Build Tooling:**
- golem scaffolding for modules, utils, and deployment wiring.
- renv as the single source of truth for reproducible environments.

**Testing Framework:**
- testthat as mandatory headless-domain coverage.
- shinytest2 reserved for a small set of deterministic UI workflows (gated/skippable).

**Code Organization:**
- App structured as an R package; modules split by workflow steps and UI panels.
- Core domain logic in headless functions/services to enable deterministic tests and reuse.

**Development Experience:**
- Local-first development; hostable later (no hard-coded paths).
- reactable as default tables; DT as a targeted escape hatch for high-interaction editing (e.g., Sample Metadata Builder).

**Preprocessing Adapters (Seurat-inspired):**
- Where Seurat behaviors are adopted (variable features, PCA/UMAP), prefer a thin adapter layer that maps OmicsDataset ? Seurat-like inputs/outputs.
- If direct reuse is impractical, selectively reimplement required logic with clear provenance and deterministic behavior.

**Dependency Sourcing Notes:**
- Verified versions (informational only; authoritative pinning is via `renv.lock`, not this document).
- CRAN: shiny 1.12.1, golem 0.5.1, bslib 0.9.0, bsicons 0.1.2, htmltools 0.5.9, reactable 0.4.5, DT 0.34.0, shinyWidgets 0.9.0, waiter 0.2.5.1, shinycssloaders 1.1.0, ggplot2 4.0.1, plotly 4.11.0, Seurat 5.4.0, future 1.68.0, promises 1.5.0, testthat 3.3.1, shinytest2 0.4.1, renv 1.1.5
- Bioconductor (release 3.22): ComplexHeatmap 2.26.0, InteractiveComplexHeatmap 1.18.0, vsn 3.78.0
- DEP2: expected to be sourced from GitHub (Bioc-devel–adjacent); exact source and version must be confirmed and pinned via renv.

**Dependency Evolution Policy:**
- Preprocessing methods expand post-V1; renv dependencies grow incrementally as capabilities are added.
- `renv.lock` evolves intentionally; additions should be explicit, minimal, and recorded (package versions captured in provenance where relevant).
- During V1, renv changes occur only on request/approval, not implicitly as a side effect of experimentation.

**Distribution Direction (V1):**
- Local-first distribution via repo clone/zip + one-click launcher that runs `renv::restore()` on first run.
- `install_github()` supported for developers but not the user-facing path.

## Core Architectural Decisions

### Decision Priority Analysis

**Critical Decisions (Block Implementation):**
- Authoritative ownership boundaries: OmicsProject owns project registry and DB Manager; OmicsWorkspace owns workflow state and UI params; OmicsDataset owns data, metadata, and preprocessing outputs.
- Persistence boundaries: project is a folder on disk with manifest; each workspace has its own subfolder; workspace object is persisted for durable resume.
- Configured vs active dataset boundary: configured dataset is reproducible from raw input; active dataset is mutated by preprocessing with reconstruction paths preserved.
- V1 persistence baseline: workspace and dataset state are serialized using R-native persistence (RDS/RDA) for the workspace object, with raw inputs and large artifacts stored in workspace subfolders and referenced by the workspace manifest.
- Write-safety rule: Apply/Run/Save commits are crash-safe via atomic replace (write to temp in the same workspace directory, then rename) and step completion is recorded only after the new persisted state and provenance are durably written.

**Important Decisions (Shape Architecture):**
- Crash-safe commit points: only completed Apply/Run/Save actions are durable; partial execution never corrupts last valid state.
- Recovery policy: on restart, restore last committed state and step, never an intermediate state.

**Deferred Decisions (Post-MVP):**
- Alternative storage formats for large assays (beyond R-native serialization) and lazy-loading strategies.
- Cache eviction and persistence tuning for large datasets.

### Data Architecture

**Authoritative Data/Model Ownership (Policy):**
- OmicsProject is the authoritative registry of workspaces and owns the DB Manager for feature mapping.
- OmicsWorkspace is the authoritative owner of workflow state and step progression, including UI parameters needed for exact resume.
- OmicsDataset is the authoritative owner of assays, rowData, colData, dataset properties, and preprocessing outputs.
- UI state is derived only; it never becomes a source of truth.

**Persistence Boundaries (Policy):**
- Project state persists to a project folder on disk with a project-level manifest that indexes workspaces and project metadata.
- Each workspace persists to its own subfolder with a workspace-level manifest (workspace metadata, paths, schema versions); exports are bundled at the workspace level.
- App-level state maintains a lightweight local registry of recently opened project paths for UI convenience; this registry is not authoritative, is safe to lose, and stores only paths/metadata needed to populate “recent projects” with graceful handling of moved or missing paths.
- Raw inputs may be detached from memory but remain on disk for reconstruction.
- Workspace persistence baseline (V1): serialize the OmicsWorkspace object (including OmicsDataset + UI params + workflow state) to R-native format; store raw inputs and non-memory artifacts in workspace subfolders referenced by the workspace manifest. The configured dataset does not need to persist as a fully materialized object and may be reconstructed from raw input and provenance when needed.
- Export/import baseline (V1): export bundles the workspace object plus required on-disk artifacts (raw data, provenance, internal DB artifacts) into a portable package; import creates a new workspace subfolder and restores from the bundle.
- Compatibility marker (V1): persisted workspaces and exports include explicit workspace schema and provenance schema versions to define open/replay compatibility.

**Caching Strategy (Policy):**
- V1 favors in-memory operation for active datasets; configured datasets may be retained in cache for reconfiguration.
- Reconstruction from raw inputs and provenance is the fallback if configured data is evicted or removed.
- Memory usage is monitored with user-facing warnings at high utilization; no implicit background eviction or recomputation.

**Open Decisions:**
- Criteria for retaining vs evicting configured datasets from memory.
- Storage format for large assays beyond R-native serialization and whether lazy-loading is needed.

## Implementation Patterns & Consistency Rules

### Pattern Categories Defined

**Critical Conflict Points Identified:**
- Workflow state vs dataset state ownership and naming
- Provenance vs logging structure
- Workspace/project folder structure
- Step/phase naming and UI state enums
- Serialization paths and artifact naming

### Naming Patterns

**Domain Object Naming:**
- S4 classes: `OmicsProject`, `OmicsWorkspace`, `OmicsDataset`, `DatabaseManager`
- Workflow phases: `configuration`, `preprocessing`
- Step states: `locked`, `ready`, `dirty`, `running`, `completed` (canonical)
- Step/substep IDs: `{phase}.{step_order}.{short_name}` (e.g., `configuration.01.import`, `preprocessing.03.imputation`)

**Function & Variable Naming (R):**
- Functions: `snake_case` (e.g., `apply_preprocessing_step`)
- Variables: `snake_case` (e.g., `workspace_state`)
- Constants/enums: `UPPER_SNAKE_CASE` where needed (e.g., `STEP_LOCKED`)

**File & Module Naming:**
- R files: `snake_case.R` with responsibility prefixes (e.g., `domain_omics_project.R`, `persistence_path_resolver.R`, `services_project_service.R`, `state_app_session_state.R`)
- `R/` subfolders are not used for code because R does not auto-source them; only root-level files are guaranteed to load
- Shiny module code lives in root `R/` as `mod_*` files (e.g., `mod_project_dashboard_ui.R`); optional `R/modules/` is assets-only and may be omitted

### Structure Patterns

**Project Organization (golem):**
- `R/` root contains domain, state, persistence, provenance, services, and utils code using prefixed filenames
- `R/modules/` is optional and assets-only; no module code lives under `R/` subfolders
- `inst/` for static assets and templates
- `tests/` for testthat, with headless domain logic first

**Persistence Artifacts:**
- Workspace folder contains a workspace manifest, persisted workspace object, and subfolders for raw input and artifacts
- Export bundles mirror workspace folder contents (portable, self-contained)
- All file paths are resolved via project/workspace path resolvers (no hard-coded or CWD-relative paths)

### Format Patterns

**Provenance Records:**
- Single provenance entry per state-changing action
- Required minimum fields: `action_id`, `step_id`, `timestamp`, `parameters`, `inputs`, `outputs`, `rng_seed`, `schema_version`, `package_versions`
- Optional fields: `status` (success/failure), `error_summary` (on failure), `duration_ms`, `artifact_refs`
- `inputs`/`outputs` are references or summaries, not full object dumps
- Provenance is authoritative for replay; must be immutable once committed

**Logs:**
- Logs are non-authoritative diagnostics
- Required fields: `timestamp`, `level`, `message`, `context`, `duration_ms` (if applicable)
- Logs never used for replay or state reconstruction

### Communication Patterns

**State Updates:**
- All state changes occur through explicit Apply/Run/Save actions
- UI triggers validation only; computation requires explicit action
- Step completion is recorded only after state + provenance are durably written
- Preprocessing may mutate only the active dataset; the configured dataset is never modified except via reconstruction

**Error Handling:**
- User-facing errors: actionable, step-specific, non-technical phrasing
- System errors: include error ID and are logged at dev level
- Execution-time errors after Apply/Run are treated as system errors even if data-driven
- No silent failures or implicit state changes

### Process Patterns

**Validation Timing:**
- Validate on change/blur; block Apply/Run if invalid
- Summarize blocking issues at the step level

**Loading & Progress:**
- Show explicit running state for Apply/Run actions
- No background queues in V1

### Enforcement Guidelines

**All AI Agents MUST:**
- Use the canonical step/state names and ownership boundaries defined in Step 4
- Write provenance for every state-changing action and keep it immutable post-commit
- Keep UI state derived only; no UI-only persistence
- Resolve all file paths via project/workspace path resolvers (no hard-coded or CWD-relative paths)

**Pattern Enforcement:**
- Architectural PRDs and tests should reject deviations
- Any new pattern requires an explicit update to this section
- Deviations are allowed only if documented and this section is updated accordingly

### Pattern Examples

**Good Examples:**
- `apply_preprocessing_step()` writes provenance, then commits workspace state
- `workspace_state$step_status["step_2"] <- "completed"` only after commit succeeds

**Anti-Patterns:**
- Updating UI step status before persistence completes
- Writing logs without a corresponding provenance entry for a state change
- Creating new step names not in the canonical set

## Project Structure & Boundaries

### Complete Project Directory Structure

```
OMNI_OMICS_HUB/
|-- DESCRIPTION
|-- NAMESPACE
|-- README.md
|-- renv.lock
|-- renv/
|-- .Rbuildignore
|-- .gitignore
|-- R/
|   |-- app_ui.R
|   |-- app_server.R
|   |-- domain_omics_project.R
|   |-- domain_omics_workspace.R
|   |-- domain_omics_dataset.R
|   |-- domain_db_manager.R
|   |-- domain_registry.R
|   |-- state_workflow_state.R
|   |-- state_step_status.R
|   |-- state_validation_rules.R
|   |-- state_invalidation_rules.R
|   |-- persistence_path_resolver.R
|   |-- persistence_project_manifest.R
|   |-- persistence_workspace_manifest.R
|   |-- persistence_workspace_store.R
|   |-- persistence_export_import.R
|   |-- provenance_provenance_writer.R
|   |-- provenance_provenance_schema.R
|   |-- services_import_service.R
|   |-- services_mapping_service.R
|   |-- services_preprocessing_service.R
|   |-- services_registry_service.R
|   |-- mod_workspace_nav_ui.R
|   |-- mod_workspace_nav_server.R
|   |-- mod_workspace_stepper_ui.R
|   |-- mod_workspace_stepper_server.R
|   |-- mod_project_dashboard_ui.R
|   |-- mod_project_dashboard_server.R
|   |-- mod_workspace_dashboard_ui.R
|   |-- mod_workspace_dashboard_server.R
|   |-- mod_configuration_step_*.R
|   |-- mod_preprocessing_step_*.R
|   |-- modules/ (optional assets only)
|   |-- utils_config_defaults.R
|   |-- utils_ui_helpers.R
|   |-- utils_error_helpers.R
|   `-- utils_logging.R
|-- inst/
|   |-- assets/
|   |   |-- icons/
|   |   `-- images/
|   `-- config/
|       |-- theme.json
|       |-- defaults.json
|       `-- registry_defaults.yaml
|-- tests/
|   |-- testthat/
|   |   |-- test-domain-omics_project.R
|   |   |-- test-domain-omics_workspace.R
|   |   |-- test-domain-omics_dataset.R
|   |   |-- test-state-workflow.R
|   |   |-- test-provenance.R
|   |   `-- test-persistence.R
|   `-- shinytest2/
|       `-- test-e2e-core-flow.R
`-- man/
```

### Architectural Boundaries

**Modules Boundary:**
- Shiny module code lives in root `R/` as `mod_*` files; no module code under `R/` subfolders. Optional `R/modules/` is assets-only.
- `workspace_nav` and `workspace_stepper` are reusable workspace-scoped modules driven by the authoritative workspace state model.

**Domain Boundary:**
- `R/` root files prefixed `domain_` define the authoritative objects and invariants (OmicsProject/Workspace/Dataset).

**State Boundary:**
- `R/` root files prefixed `state_` own workflow state, step status, validation rules, and invalidation rules (kept distinct).

**Persistence Boundary:**
- `R/` root files prefixed `persistence_` own all file path resolution, manifests, storage, and export/import.

**Provenance Boundary:**
- `R/` root files prefixed `provenance_` own provenance schema and writes; immutable after commit.

**Service Boundary:**
- `R/` root files prefixed `services_` orchestrate domain + state + persistence for actions (import, mapping, preprocessing).

**Utility Boundary:**
- `R/` root files prefixed `utils_` hold cross-cutting helpers (logging, UI helpers, error helpers).

### Requirements to Structure Mapping

**Feature/Epic Mapping:**
- Project/Workspace lifecycle: `R/domain_*.R`, `R/services_*.R`, `R/mod_project_dashboard_*`, `R/mod_workspace_dashboard_*`
- Workspace navigation + progress: `R/mod_workspace_nav_*`, `R/mod_workspace_stepper_*`, `R/state_*.R`
- Configuration Steps 0?4: `R/mod_configuration_step_*`, `R/state_*.R`, `R/services_import_service.R`
- Preprocessing flow: `R/mod_preprocessing_step_*`, `R/services_preprocessing_service.R`
- Feature mapping & DB Manager: `R/domain_db_manager.R`, `R/services_mapping_service.R`
- Provenance/logging: `R/provenance_*.R`, `R/utils_logging.R`

**Cross-Cutting Concerns:**
- Deterministic state restore: `R/state_*.R`, `R/persistence_*.R`, `R/provenance_*.R`
- Apply/Run/Save commit boundaries: `R/state_*.R`, `R/provenance_*.R`, `R/persistence_*.R`
- Registry-driven capabilities: `R/domain_registry.R`, `R/services_registry_service.R`

### Integration Points

**Internal Communication:**
- Modules call services; services coordinate domain + state + persistence.
- Preprocessing services may mutate only the active dataset; configured datasets are never modified and may be reconstructed.
- Path resolver is the only source of file paths (no module/service ad-hoc paths).

**External Integrations:**
- Bioconductor/CRAN package adapters remain inside services or domain adapters; no module dependency.

**Data Flow:**
- Modules ? services ? domain/state ? persistence/provenance for commits.
- Modules read computed summaries via services (no direct domain mutation).

### File Organization Patterns

**Configuration Files:**
- `inst/config/` holds declarative defaults and theme assets only.

**Source Organization:**
- `R/` root contains responsibility-prefixed files; subfolders under `R/` are not used for code (R does not auto-source them).

**Test Organization:**
- `tests/testthat/` for deterministic, headless domain tests.
- `tests/shinytest2/` for a small number of canonical UI flows.

**Asset Organization:**
- `inst/assets/` for icons/images only.

### Development Workflow Integration

**Development Server Structure:**
- `app_ui.R`/`app_server.R` are the entry points, wiring modules by phase and dashboard.

**Build Process Structure:**
- Package build uses `R/` for code and `inst/` for assets/configs.

**Deployment Structure:**
- Local-first; path resolver anchors all persistence to project/workspace directories.

## Architecture Validation Results

### Coherence Validation ?

**Decision Compatibility:**
- Technology choices (Shiny + golem + bslib + renv) are consistent with the UX and workflow requirements.
- Persistence, provenance, and state boundaries align with local-first constraints and deterministic replay.

**Pattern Consistency:**
- Implementation patterns reinforce ownership boundaries, step state, and commit rules.
- Naming conventions and module boundaries are consistent with golem and Shiny modules.

**Structure Alignment:**
- Project structure supports all defined boundaries (domain/state/persistence/provenance/modules).
- Workspace nav and stepper are explicitly represented as reusable modules.

### Requirements Coverage Validation ?

**Functional Requirements Coverage:**
- Step-gated configuration/preprocessing, state restoration, provenance, DB Manager, and workspace import/export are all covered architecturally.
- Workspace-scoped navigation and progress indicators are captured in UX and structure.

**Non-Functional Requirements Coverage:**
- Local-first, reproducibility, crash-safe commits, and WCAG AA are explicitly addressed.

### Implementation Readiness Validation ?

**Decision Completeness:**
- Critical decisions are documented with V1 baselines and explicit policies.
- Open decisions are identified and isolated to non-blocking optimization topics.

**Structure Completeness:**
- Complete directory structure and boundary mapping is provided.
- Integration points and internal data flow are clear.

**Pattern Completeness:**
- Naming, persistence, provenance, and error handling patterns are specified.

### Gap Analysis Results

**Critical Gaps:** None identified.

**Important Gaps:**
- DEP2 source/version must be confirmed and pinned via `renv.lock`; treat as analysis-scoped unless required earlier.
- Cache retention/eviction remains intentionally undefined in V1; default to explicit user control and warnings (no implicit eviction).

**Nice-to-Have Gaps:**
- Optional cleanup of project-tree rendering artifacts (encoding of tree glyphs).
- Post-V1 decisions on alternative storage formats and lazy-loading.

### Validation Issues Addressed

- None required for coherence or coverage; acknowledged items are non-blocking.

### Architecture Completeness Checklist

**? Requirements Analysis**
- [x] Project context analyzed
- [x] Scale and complexity assessed
- [x] Technical constraints identified
- [x] Cross-cutting concerns mapped

**? Architectural Decisions**
- [x] Critical decisions documented
- [x] Technology stack specified
- [x] Persistence/provenance policies defined
- [x] UX-driven navigation/progress captured

**? Implementation Patterns**
- [x] Naming conventions established
- [x] Structure patterns defined
- [x] Communication patterns specified
- [x] Process patterns documented

**? Project Structure**
- [x] Complete directory structure defined
- [x] Component boundaries established
- [x] Integration points mapped
- [x] Requirements-to-structure mapping complete

### Architecture Readiness Assessment

**Overall Status:** READY FOR IMPLEMENTATION

**Confidence Level:** High (with a few non-blocking follow-ups)

**Key Strengths:**
- Strong alignment across PRD, UX, and architecture
- Clear ownership and persistence boundaries
- Explicit state/provenance contract for deterministic behavior

**Areas for Future Enhancement:**
- DEP2 sourcing/version pin
- Cache retention/eviction policy (if needed)
- Optional storage/lazy-loading strategy

### Implementation Handoff

**AI Agent Guidelines:**
- Follow all architectural decisions exactly as documented
- Use implementation patterns consistently across all components
- Respect project structure and boundaries
- Refer to this document for all architectural questions

**First Implementation Priority:**
- Initialize golem scaffold and confirm dependency sources prior to `renv.lock` pinning
```

## Architecture Completion Summary

### Workflow Completion

**Architecture Decision Workflow:** COMPLETED
**Total Steps Completed:** 8
**Date Completed:** 2025-12-27
**Document Location:** docs/architecture.md

### Final Architecture Deliverables

**Complete Architecture Document**

- All architectural decisions documented with specific versions
- Implementation patterns ensuring AI agent consistency
- Complete project structure with all files and directories
- Requirements to architecture mapping
- Validation confirming coherence and completeness

**Implementation Ready Foundation**

- 9 architectural decisions made
- 6 implementation patterns defined
- 9 architectural components specified
- 10 requirements fully supported

**AI Agent Implementation Guide**

- Technology stack with verified versions
- Consistency rules that prevent implementation conflicts
- Project structure with clear boundaries
- Integration patterns and communication standards

### Implementation Handoff

**For AI Agents:**
This architecture document is your complete guide for implementing OMNI_OMICS_HUB. Follow all decisions, patterns, and structures exactly as documented.

**First Implementation Priority:**
- Initialize golem scaffold and confirm dependency sources prior to `renv.lock` pinning

**Development Sequence:**

1. Initialize project using documented starter template
2. Set up development environment per architecture
3. Implement core architectural foundations
4. Build features following established patterns
5. Maintain consistency with documented rules

### Quality Assurance Checklist

**Architecture Coherence**

- [x] All decisions work together without conflicts
- [x] Technology choices are compatible
- [x] Patterns support the architectural decisions
- [x] Structure aligns with all choices

**Requirements Coverage**

- [x] All functional requirements are supported
- [x] All non-functional requirements are addressed
- [x] Cross-cutting concerns are handled
- [x] Integration points are defined

**Implementation Readiness**

- [x] Decisions are specific and actionable
- [x] Patterns prevent agent conflicts
- [x] Structure is complete and unambiguous
- [x] Examples are provided for clarity

### Project Success Factors

**Clear Decision Framework**
Every technology choice was made collaboratively with clear rationale, ensuring all stakeholders understand the architectural direction.

**Consistency Guarantee**
Implementation patterns and rules ensure that multiple AI agents will produce compatible, consistent code that works together seamlessly.

**Complete Coverage**
All project requirements are architecturally supported, with clear mapping from business needs to technical implementation.

**Solid Foundation**
The chosen starter template and architectural patterns provide a production-ready foundation following current best practices.

---

**Architecture Status:** READY FOR IMPLEMENTATION

**Next Phase:** Begin implementation using the architectural decisions and patterns documented herein.

**Document Maintenance:** Update this architecture when major technical decisions are made during implementation.


