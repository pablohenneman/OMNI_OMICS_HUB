---
stepsCompleted: [1, 2, 3]
inputDocuments:
  - docs/prd.md
  - docs/architecture.md
  - docs/ux-design-specification.md
---

# OMNI_OMICS_HUB - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for OMNI_OMICS_HUB, decomposing the requirements from the PRD, UX Design if it exists, and Architecture requirements into implementable stories.

## Requirements Inventory

### Functional Requirements

FR1: OmicsDataset data model representing assays, rowData, colData, dataset properties, and preprocessing metadata.
FR2: Explicit raw input storage, detachment, and reconstruction rules with visible state.
FR3: OmicsProject as project-level root object mapped to disk with a manifest.
FR4: Central DatabaseManager with deterministic, reproducible feature mapping and provenance.
FR5: OmicsWorkspace as authoritative unit of work with full lifecycle APIs; usable outside UI.
FR6: Registry mapping dataset properties to enabled capabilities.
FR7: Explicit state machine with predictable invalidation and explicit transitions.
FR8: Provenance recording for all state-changing actions with replayability.
FR9: Structured logging (user/dev) independent of provenance.
FR10: Project creation/open/delete/list with explicit confirmation for destructive actions.
FR11: Workspace creation/open/delete/import/export with project registration.
FR12: Dataset properties config with gating and invalidation tied to registry outputs.
FR13: CSV/TSV/XLSX import with NA detection, preview, and explicit commit.
FR14: Column assignment to Expression/RowData/Ignore with validation and conflict resolution.
FR15: Feature ID configuration with delimiter, dedupe, ID type/species, mapping quality, and provenance.
FR16: Guided colData configuration with validation, identity selection, and persistence.
FR17: Computation only via explicit Apply/Run actions; validation gates execution.
FR18: Filtering with explicit masks, QC guidance, and downstream invalidation.
FR19: Normalization with log handling, NA preservation, and diagnostics.
FR20: Imputation + scaling with tracked masks and RNG seeds + diagnostics.
FR21: Variable features + PCA/UMAP/t-SNE with persisted parameters/outputs.
FR22: Navigation, gating, and step states with exact resume behavior.
FR23: Actionable validation, errors, and warnings before Apply/Run.
FR24: Persist/restore workspace state, dataset state, and provenance exactly.
FR25: Export/import full workspaces with required artifacts for reuse.
FR26: Explicit "Preprocessed & Saved" checkpoint gating downstream analyses.
FR27: Extension point for registering future analyses and storing typed results, without implementing analyses in V1.
FR28: UI is a consumer of domain logic; core logic usable without UI.
FR29: Split workspace layout (config left / plots right) with stepper tabs for Steps 0-4 + preprocessing and a persistent two-row progress module on the workspace dashboard.
FR30: Step states (locked/ready/dirty/running/completed) are visual; locked states explain unblock path; exactly one primary next action is visible at all times.
FR31: Column mapping uses a tri-panel model (RowData | Ignore | Expression) with drag/drop, multi-select, search, bulk select, numeric validation, and explicit conflict resolution.
FR32: Sample Metadata Builder supports delimiter-aware suggestions, unassigned list visibility, overlap prevention, irregular sample handling, combined traits, and active identity selection.
FR33: Import/Parsing UI enforces NA token scanning + re-parse if none found; reports parsed vs token-normalized missingness distinctly; preview required before commit.
FR34: Preprocessing feedback includes density/boxplot toggles, imputation heatmap, variable-feature rank plot, and PCA/UMAP/t-SNE view toggles.
FR35: Apply commits a single step; "Save Preprocessed Data" freezes state and unlocks downstream; dirty vs saved messaging is explicit and persistent.
FR36: Run/Provenance status strip and log visibility in-app with user/dev levels.
FR37: Workspace export bundles internal DB artifacts referenced by the workspace for portability.
FR38: Adopt the UX design system tokens (colors, typography, spacing) and panel/stepper layout patterns defined in the UX specification.
FR39: Provide a global "Advanced" toggle and per-panel "See more" controls to keep advanced options hidden by default.

### Non-Functional Requirements

NFR1: Interactive UI actions respond within 200 ms; Apply/Run shows running state within 100 ms; preprocessing steps complete in 5-15 seconds; plots render within 2 seconds for reference workload.
NFR2: System never freezes silently; heavy operations show progress and size-aware plotting; performance degradation is explained to the user.
NFR3: No silent data loss; crash-safe commits; failures preserve last valid state; destructive actions require explicit confirmation.
NFR4: WCAG AA compliance for core UI elements; desktop-first usage; color is never the sole indicator of state.
NFR5: Local-first privacy with no cloud sync or telemetry; exports are fully portable; auth/multi-user security out of scope for V1.
NFR6: Reproducibility and determinism: record RNG seeds for stochastic steps and enable provenance replay to reproduce outputs exactly.

### Additional Requirements

- Starter template: golem-based Shiny app scaffold with bslib theming and renv for reproducible environments.
- Local-first storage with project/workspace manifests; export/import bundles are self-contained and include internal DB artifacts.
- Crash-safe Apply/Run/Save commits via atomic writes; state recorded only after durable persistence.
- Version all workspace schema, dataset schema, and provenance formats for replay compatibility.
- UI state is derived only; core domain logic must be callable headless (no UI dependency).
- Separation of provenance (replayable) from logs (diagnostic only).
- Registry-driven capability gating by dataset properties.
- No implicit background recomputation; all mutations require explicit Apply/Run/Save.
- Deterministic invalidation when upstream steps change; restore last committed state on restart.
- Shiny SPA with internal routing; desktop-first layout.
- Breakpoints at 1280px and 768px; <768px read-only/warned mode for active analysis.
- Persistent workspace left navigation and stepper progress indicator tied to authoritative workspace state.
- Split workspace layout (config left, plots right) and advanced options hidden by default.
- Actionable validation, errors, and warnings; one primary action visible at all times.
- QC and feedback panels (density/boxplots, PCA/UMAP/t-SNE, imputation heatmap) tightly coupled to step parameters.

### FR Coverage Map

FR1: Epic 2 - Deterministic core domain model for reliable workflows
FR2: Epic 2 - Raw input state and reconstruction rules for reproducibility
FR3: Epic 1 - Project container and manifest
FR4: Epic 2 - Deterministic mapping authority
FR5: Epic 2 - Authoritative workspace for reliable execution
FR6: Epic 2 - Registry capability gating for consistent behavior
FR7: Epic 2 - State machine and invalidation for predictable outcomes
FR8: Epic 2 - Provenance recording and replayability
FR9: Epic 2 - Logs separated from provenance for reproducibility
FR10: Epic 1 - Project lifecycle management
FR11: Epic 1 - Workspace lifecycle management
FR12: Epic 3 - Step 0 dataset properties configuration
FR13: Epic 3 - Step 1 import with preview and commit
FR14: Epic 3 - Step 2 column assignment and validation
FR15: Epic 3 - Step 3 feature ID configuration and mapping
FR16: Epic 3 - Step 4 colData configuration
FR17: Epic 2 - Explicit Apply/Run/Save execution invariant
FR18: Epic 4 - Filtering with QC and invalidation
FR19: Epic 4 - Normalization with diagnostics
FR20: Epic 4 - Imputation/scaling with RNG tracking
FR21: Epic 4 - Variable features and dimensionality reduction
FR22: Epic 2 - Predictable resume and gating behavior
FR23: Epic 2 - Actionable validation and errors before Apply/Run
FR24: Epic 1 - Persist/restore workspace state and data
FR25: Epic 5 - Export/import full workspaces
FR26: Epic 4 - Preprocessed & Saved checkpoint
FR27: Epic 6 - Future analysis extension interface
FR28: Epic 2 - Headless core logic for deterministic workflows
FR29: Epic 3 - Split layout and stepper for configuration
FR30: Epic 3 - Step state visibility and single primary action
FR31: Epic 3 - Tri-panel column mapping UX
FR32: Epic 3 - Sample metadata builder UX rules
FR33: Epic 3 - Import/Parsing UI NA scanning and preview
FR34: Epic 4 - Preprocessing feedback plots
FR35: Epic 4 - Apply/Save semantics for preprocessing
FR36: Epic 2 - Run/provenance status strip and log visibility
FR37: Epic 5 - Workspace export bundles internal DB artifacts
FR38: Epic 3 - Design system tokens and layout patterns
FR39: Epic 3 - Advanced toggle and per-panel expansion controls

## Epic List

### Epic 1: Project & Workspace Lifecycle
Users can create/open/delete projects and workspaces with durable persistence, establishing containers for all workflow activity.
**FRs covered:** FR3, FR10, FR11, FR24

### Epic 2: Reliable, Reproducible Workflows
Users can trust workflow outcomes through deterministic state, explicit Apply/Run/Save, and predictable resume/gating behavior.
**FRs covered:** FR1, FR2, FR4, FR5, FR6, FR7, FR8, FR9, FR17, FR22, FR23, FR28, FR36

### Epic 3: Configuration Workflow (Steps 0-4)
Users can configure datasets through Steps 0-4 with step-specific validations and commit at the configured dataset boundary.
**FRs covered:** FR12, FR13, FR14, FR15, FR16, FR29, FR30, FR31, FR32, FR33, FR38, FR39

### Epic 4: Preprocessing Workflow
Users can run preprocessing steps with QC feedback and reach the explicit Preprocessed & Saved checkpoint.
**FRs covered:** FR18, FR19, FR20, FR21, FR26, FR34, FR35

### Epic 5: Portability
Users can export/import complete workspaces for portability and reuse.
**FRs covered:** FR25, FR37

### Epic 6: Analysis Extension Interface
Users can add future analysis modules without destabilizing the core workflow, ensuring analysts and labs can extend the platform safely post-V1.
**FRs covered:** FR27

<!-- Repeat for each epic in epics_list (N = 1, 2, 3...) -->

## Epic 1: Project & Workspace Lifecycle

Users can create/open/delete projects and workspaces with durable persistence, establishing containers for all workflow activity.

<!-- Repeat for each story (M = 1, 2, 3...) within epic N -->

### Story 1.1: Set Up Initial Project from Golem Starter Template

As a platform builder,
I want to initialize the project using the golem starter template,
So that the application starts from the approved scaffold and conventions.

**FRs:** FR3

**Acceptance Criteria:**

**Given** the project is initialized from the documented starter template
**When** the scaffold is created
**Then** the golem project structure is generated with the agreed package name
**And** the initialization steps are captured so they can be repeated deterministically
**And** if scaffold creation fails, the error is surfaced with actionable guidance and no partial project state is recorded

<!-- End story repeat -->

### Story 1.2: Create and Open Project with Manifest

As a workspace owner,
I want to create and open a project folder with a project manifest,
So that all workspaces and data have a durable, authoritative container.

**FRs:** FR3, FR10

**Acceptance Criteria:**

**Given** I provide a project name and folder location
**When** I create a new project
**Then** a project folder is created with a manifest file that records project metadata and schema version
**And** the project is registered as the active project in the app session

**Given** an existing project folder with a valid manifest
**When** I open the project
**Then** the project loads with its recorded metadata and workspace registry
**And** any missing or invalid manifest blocks open with an actionable error

<!-- End story repeat -->

### Story 1.3: Delete Project with Explicit Confirmation

As a workspace owner,
I want to delete a project only after explicit confirmation,
So that I avoid accidental data loss.

**FRs:** FR10

**Acceptance Criteria:**

**Given** I am viewing a project
**When** I choose the delete action
**Then** I am required to confirm the deletion explicitly before any files are removed
**And** the confirmation clearly states that all workspaces and data in the project will be deleted

**Given** I confirm the deletion
**When** the deletion completes
**Then** the project folder is removed and the app no longer lists it as available
**And** a success message confirms the project was deleted

<!-- End story repeat -->

### Story 1.4: Create, Open, and Delete Workspaces

As a workspace owner,
I want to create, open, and delete workspaces within a project,
So that I can manage multiple datasets and workflows.

**FRs:** FR11

**Acceptance Criteria:**

**Given** an open project
**When** I create a new workspace
**Then** a workspace folder and manifest are created and registered in the project manifest
**And** the workspace appears in the project's workspace list

**Given** an existing workspace in a project
**When** I open the workspace
**Then** the workspace loads from its manifest and becomes the active workspace
**And** missing or invalid workspace manifests block open with an actionable error

**Given** an existing workspace
**When** I choose to delete it
**Then** I must explicitly confirm deletion before any files are removed
**And** the workspace is removed from the project manifest and no longer listed after deletion
**And** if deletion fails mid-operation, the workspace remains listed with an actionable error and no partial deletion is recorded

<!-- End story repeat -->

### Story 1.5: Persist and Restore Last Committed Workspace State

As a workspace owner,
I want the last committed workspace state to be durably persisted and restored,
So that I can recover reliably after a crash or restart.

**FRs:** FR24

**Acceptance Criteria:**

**Given** a workspace completes an Apply/Run/Save commit
**When** the workspace is persisted
**Then** the workspace object, manifests, and required artifacts are written durably to disk
**And** only the last committed state is recorded as recoverable
**And** if persistence fails, the last committed state remains intact and a clear error is surfaced

**Given** I reopen a workspace after a crash or restart
**When** the workspace loads
**Then** the last committed state is restored from disk
**And** if persistence artifacts are missing or corrupted, the load is blocked with an actionable error

<!-- End story repeat -->

### Story 1.6: Configure Development Environment

As a platform builder,
I want a documented and repeatable development environment setup,
So that contributors can build and run the app consistently.

**FRs:** FR3

**Acceptance Criteria:**

**Given** a new contributor clones the repository
**When** they follow the documented setup steps
**Then** dependencies are installed and the app runs locally with no manual fixes
**And** the setup instructions cover R, renv, and required system libraries
**And** setup failures provide actionable guidance

<!-- End story repeat -->

### Story 1.7: Initialize CI Pipeline for Core Checks

As a platform builder,
I want a basic CI pipeline for core checks,
So that regressions are caught early and builds are consistent.

**FRs:** FR3

**Acceptance Criteria:**

**Given** a pull request is opened
**When** CI runs
**Then** unit tests and lint/check steps execute successfully or fail with actionable output
**And** CI uses a pinned R version and restores dependencies deterministically
**And** CI failures do not block local development unless required checks fail

<!-- End story repeat -->

## Epic 2: Reliable, Reproducible Workflows

Users can trust workflow outcomes through deterministic state, explicit Apply/Run/Save, and predictable resume/gating behavior.

### Story 2.1: Establish Authoritative Domain Ownership and Invariants

As a platform builder,
I want OmicsProject, OmicsWorkspace, and OmicsDataset to be the authoritative owners of their respective data and invariants,
So that all workflow behavior is grounded in a consistent, testable core.

**FRs:** FR1, FR4, FR5

**Acceptance Criteria:**

**Given** an OmicsProject, OmicsWorkspace, and OmicsDataset are created
**When** their ownership boundaries are defined
**Then** OmicsProject owns project metadata and the workspace registry
**And** OmicsProject owns the DatabaseManager for deterministic feature mapping
**And** OmicsWorkspace owns workflow state and UI parameters required for deterministic resume
**And** OmicsDataset owns assays, rowData, colData, dataset properties, and preprocessing outputs

<!-- End story repeat -->

### Story 2.2: Define Raw Input Storage and Reconstruction Rules

As a platform builder,
I want explicit raw input storage, detachment, and reconstruction rules,
So that configured datasets are reproducible and state transitions are transparent.

**FRs:** FR2

**Acceptance Criteria:**

**Given** raw inputs are imported into a workspace
**When** they are stored and referenced
**Then** raw inputs persist on disk with stable references for reconstruction
**And** the workspace records a visible state indicating raw inputs are detached or attached

**Given** a configured dataset needs reconstruction
**When** reconstruction is triggered
**Then** the system rebuilds the configured dataset deterministically from raw inputs and recorded parameters
**And** if required raw inputs are missing or unreadable, reconstruction fails with an actionable error and no state is mutated

<!-- End story repeat -->

### Story 2.3: Enforce Headless Core Logic and Derived UI State

As a platform builder,
I want core workflow logic usable without the UI and UI state derived only from authoritative data,
So that the system is testable and avoids UI-driven state drift.

**FRs:** FR28

**Acceptance Criteria:**

**Given** any UI component or service requests state
**When** it reads domain data
**Then** UI state is derived only and never becomes a source of truth
**And** headless core logic can operate without UI dependencies

<!-- End story repeat -->

### Story 2.4: Define Workflow State Machine and Invalidation Rules

As a platform builder,
I want a canonical workflow state machine with deterministic invalidation rules,
So that workflow progression is predictable and reproducible.

**FRs:** FR6, FR7

**Acceptance Criteria:**

**Given** a workspace workflow state model
**When** step states are defined
**Then** canonical step states include locked, ready, dirty, running, and completed
**And** workflow phases and step identifiers follow the agreed naming conventions
**And** registry-derived capabilities gate which steps are available

**Given** an upstream step's committed state changes
**When** invalidation rules apply
**Then** all dependent downstream steps transition to the correct invalidated state
**And** the invalidation outcome is deterministic and reproducible in headless execution
**And** invalidation affects only downstream step status and outputs while preserving the last committed state on disk until the next successful commit
**And** if invalidation rules are undefined for a step, the action fails with a clear error and no status changes are committed

<!-- End story repeat -->

### Story 2.5: Enforce Global Apply/Run/Save Execution Semantics

As a platform builder,
I want all computation and state mutation to occur only via explicit Apply/Run/Save actions,
So that execution is intentional, deterministic, and testable.

**FRs:** FR17, FR23

**Acceptance Criteria:**

**Given** a user modifies parameters or inputs
**When** no Apply/Run/Save action is triggered
**Then** no computation or state mutation occurs

**Given** an Apply/Run/Save action is triggered
**When** validation passes
**Then** the system executes the action and records a single authoritative state change
**And** the action is marked completed only after provenance is written and persistence commit succeeds

**Given** validation fails
**When** Apply/Run/Save is attempted
**Then** execution is blocked and no state change is committed
**And** if persistence or provenance writing fails after execution, the system restores the last committed state and surfaces an actionable error

<!-- End story repeat -->

### Story 2.6: Record Provenance for Every State Change

As a platform builder,
I want every state-changing action to write immutable provenance,
So that workflow replay and reproducibility are guaranteed.

**FRs:** FR8

**Acceptance Criteria:**

**Given** an Apply/Run/Save action completes
**When** provenance is written
**Then** a single provenance entry is created with action ID, step ID, parameters, inputs, outputs, RNG seed, schema version, and package versions
**And** the provenance entry is immutable once committed

**Given** a state change fails
**When** provenance is attempted
**Then** the failure is recorded with status and error summary
**And** no partial or duplicate provenance entries are created
**And** the last committed workspace state remains intact and unmodified
**And** if provenance storage is unavailable, the action is marked failed and no commit is recorded

<!-- End story repeat -->

### Story 2.7: Emit Non-Authoritative Logs Separate from Provenance

As a platform builder,
I want diagnostic logs to be recorded separately from provenance,
So that debugging is possible without affecting reproducibility.

**FRs:** FR9

**Acceptance Criteria:**

**Given** a state-changing action occurs
**When** logs are written
**Then** logs include timestamp, level, message, and context
**And** logs are explicitly non-authoritative and never used for state reconstruction
**And** if log writing fails, the action continues and surfaces a non-blocking warning

**Given** a user-facing error occurs
**When** it is recorded
**Then** the log includes an error ID and diagnostic details
**And** the error log does not alter provenance or committed state

<!-- End story repeat -->

### Story 2.8: Derive Resume Behavior from Workflow State

As a platform builder,
I want resume behavior to be derived from the authoritative workflow state,
So that the UI reflects the true system state without introducing new sources of truth.

**FRs:** FR22

**Acceptance Criteria:**

**Given** a workspace loads with a persisted workflow state
**When** the application initializes
**Then** the active step and gating status are derived from the workflow state model
**And** resume behavior always reflects the last committed state
**And** if workflow state is missing or corrupt, loading is blocked with an actionable error

<!-- End story repeat -->

### Story 2.9: Render Step State and Status Strip Without Mutating State

As a platform builder,
I want step states and run/provenance status to render from authoritative workflow state,
So that UI indicators are reliable and do not introduce state mutations.

**FRs:** FR36

**Acceptance Criteria:**

**Given** a step is locked, ready, dirty, running, or completed
**When** the UI renders navigation or step controls
**Then** the UI reflects those states without mutating them
**And** any changes to step state occur only through Apply/Run/Save transitions

**Given** a run/provenance status strip is displayed
**When** it renders status and logs
**Then** it reflects authoritative state and logs without mutating them
**And** if logs are unavailable, the UI shows a clear placeholder without blocking workflow actions

<!-- End story repeat -->

## Epic 3: Configuration Workflow (Steps 0-4)

Users can configure datasets through Steps 0-4 with step-specific validations and commit at the configured dataset boundary.

### Story 3.1: Configure Dataset Properties (Step 0)

As a workspace owner,
I want to configure dataset properties with explicit validation and commit,
So that the system can gate subsequent steps based on the dataset's declared characteristics.

**FRs:** FR12, FR29, FR30

**Acceptance Criteria:**

**Given** a new workspace in configuration Step 0
**When** I enter dataset properties and pass validation
**Then** I can Apply to commit the dataset properties for the workspace
**And** the committed properties are persisted and available for downstream gating
**And** the configuration view uses the standard split layout and stepper with a single primary action

**Given** dataset properties are invalid or incomplete
**When** I attempt to Apply
**Then** the Apply action is blocked with actionable validation errors
**And** no dataset property changes are committed

<!-- End story repeat -->

### Story 3.2: Import Data with Preview and NA Detection (Step 1)

As a workspace owner,
I want to import CSV/TSV/XLSX data with preview and NA token scanning,
So that I can confirm parsing before committing the dataset.

**FRs:** FR13, FR33

**Acceptance Criteria:**

**Given** I select a data file for import
**When** the file is parsed
**Then** the system scans for NA tokens and reports parsed vs token-normalized missingness
**And** a data preview is shown before I can commit

**Given** the preview is shown and validation passes
**When** I Apply the import
**Then** the imported data is committed as the configured dataset input
**And** the import parameters are persisted with the workspace

**Given** validation fails
**When** I attempt to Apply
**Then** the Apply action is blocked with actionable errors
**And** no data is committed

<!-- End story repeat -->

### Story 3.3: Assign Columns to Expression/RowData/Ignore (Step 2)

As a workspace owner,
I want to assign columns to Expression, RowData, or Ignore with validation,
So that the dataset structure is correct before mapping and preprocessing.

**FRs:** FR14, FR31

**Acceptance Criteria:**

**Given** imported data with visible columns
**When** I assign columns to Expression, RowData, or Ignore
**Then** the system validates numeric requirements for Expression columns
**And** conflicts or invalid assignments are surfaced with actionable errors

**Given** the assignments are valid
**When** I Apply the configuration
**Then** column assignments are committed to the workspace configuration
**And** the assigned structure is persisted for downstream steps

<!-- End story repeat -->

### Story 3.4: Configure Feature IDs and Mapping (Step 3)

As a workspace owner,
I want to configure feature ID parsing and mapping with quality feedback,
So that identifiers are reliable for downstream analysis.

**FRs:** FR15

**Acceptance Criteria:**

**Given** row identifiers are available
**When** I configure delimiter, deduplication, ID type, and species
**Then** the system applies deterministic parsing and mapping rules
**And** mapping coverage and ID quality summaries are shown before commit

**Given** configuration is valid
**When** I Apply the feature ID configuration
**Then** the mapping results and metadata are committed to the workspace
**And** mapping parameters and provenance are persisted

**Given** mapping fails due to invalid identifiers or missing reference data
**When** I attempt to Apply the feature ID configuration
**Then** the action is blocked with actionable errors
**And** no mapping results are committed

<!-- End story repeat -->

### Story 3.5: Configure Sample Metadata (colData) (Step 4)

As a workspace owner,
I want to configure sample metadata with validation and identity selection,
So that downstream preprocessing uses reliable sample annotations.

**FRs:** FR16, FR32

**Acceptance Criteria:**

**Given** imported data and assigned columns
**When** I configure colData fields and identities
**Then** the system validates assignments and prevents overlaps or invalid formats
**And** unassigned samples remain visible for correction

**Given** the configuration is valid
**When** I Apply the colData configuration
**Then** sample metadata is committed to the workspace configuration
**And** the configuration is persisted for downstream steps

<!-- End story repeat -->

### Story 3.6: Apply UX Design System Tokens and Layout Patterns

As a workspace owner,
I want the configuration workflow to use the defined UX design system and layout patterns,
So that the interface is consistent, calm, and aligned to the UX specification.

**FRs:** FR38

**Acceptance Criteria:**

**Given** the configuration workflow UI is rendered
**When** panels, steppers, and navigation elements display
**Then** colors, typography, and spacing follow the UX design system tokens
**And** the split layout and stepper patterns match the UX specification

**Given** the design system tokens are updated
**When** the UI reloads
**Then** the updated tokens are reflected consistently across configuration surfaces

**Given** required design tokens are missing or invalid
**When** the configuration workflow renders
**Then** the UI falls back to safe defaults
**And** a non-blocking warning is logged for remediation

<!-- End story repeat -->

### Story 3.7: Provide Advanced Controls Expansion

As a workspace owner,
I want advanced options hidden by default with a clear way to reveal them,
So that I can focus on the happy path unless I need deeper controls.

**FRs:** FR39

**Acceptance Criteria:**

**Given** a configuration panel includes advanced options
**When** the panel loads
**Then** advanced options are hidden by default
**And** a global "Advanced" toggle is available to reveal advanced options

**Given** I want to expand a specific panel
**When** I select a per-panel "See more" control
**Then** only that panel's advanced options expand without affecting other panels

**Given** advanced options fail to load for a panel
**When** I attempt to expand that panel
**Then** the expansion is blocked with a clear error
**And** the rest of the workflow remains usable

<!-- End story repeat -->

## Epic 4: Preprocessing Workflow

Users can run preprocessing steps with QC feedback and reach the explicit Preprocessed & Saved checkpoint.

### Story 4.1: Filter Data with QC Guidance (Preprocessing Step 1)

As a workspace owner,
I want to apply filtering with QC guidance,
So that I can remove low-quality data before normalization.

**FRs:** FR18, FR34

**Acceptance Criteria:**

**Given** a configured dataset is ready for preprocessing
**When** I set filtering parameters and preview QC feedback
**Then** the system shows relevant QC summaries before I commit

**Given** filtering parameters are valid
**When** I Run the filtering step
**Then** filtered outputs are committed as the active dataset state
**And** the configured dataset remains unchanged
**And** downstream steps are marked dirty or invalidated as required

**Given** filtering validation fails
**When** I attempt to Run
**Then** the action is blocked with actionable errors
**And** no filtering outputs are committed

<!-- End story repeat -->

### Story 4.2: Normalize Data with Diagnostics (Preprocessing Step 2)

As a workspace owner,
I want to normalize the active dataset with diagnostic feedback,
So that values are comparable across samples.

**FRs:** FR19, FR34

**Acceptance Criteria:**

**Given** filtered data is available
**When** I configure normalization parameters
**Then** the system shows diagnostic summaries (e.g., distributions) before I commit

**Given** normalization parameters are valid
**When** I Run normalization
**Then** normalized outputs are committed to the active dataset
**And** the configured dataset remains unchanged
**And** downstream steps are marked dirty or invalidated as required

**Given** normalization validation fails
**When** I attempt to Run
**Then** the action is blocked with actionable errors
**And** no normalization outputs are committed

<!-- End story repeat -->

### Story 4.3: Impute and Scale Data with Tracked RNG (Preprocessing Step 3)

As a workspace owner,
I want to impute missing values and scale data with tracked RNG seeds,
So that preprocessing is reproducible and traceable.

**FRs:** FR20

**Acceptance Criteria:**

**Given** normalized data is available
**When** I configure imputation and scaling parameters
**Then** the system previews diagnostic feedback relevant to the chosen methods

**Given** parameters are valid
**When** I Run imputation and scaling
**Then** outputs are committed to the active dataset with recorded RNG seeds
**And** the imputation mask and RNG seed are persisted as provenance metadata
**And** the configured dataset remains unchanged
**And** downstream steps are marked dirty or invalidated as required

**Given** validation fails
**When** I attempt to Run
**Then** the action is blocked with actionable errors
**And** no imputation/scaling outputs are committed

<!-- End story repeat -->

### Story 4.4: Compute Variable Features and Dimensionality Reduction (Preprocessing Step 4)

As a workspace owner,
I want to compute variable features and dimensionality reduction outputs with persisted parameters,
So that QC and downstream analysis are based on consistent preprocessing.

**FRs:** FR21, FR34

**Acceptance Criteria:**

**Given** imputed and scaled data is available
**When** I configure variable features and PCA/UMAP/t-SNE parameters
**Then** the system previews relevant diagnostic plots before I commit

**Given** parameters are valid
**When** I Run the step
**Then** variable feature selections and DR outputs are committed to the active dataset
**And** the parameters and RNG seeds are persisted as provenance metadata
**And** the configured dataset remains unchanged

**Given** validation fails
**When** I attempt to Run
**Then** the action is blocked with actionable errors
**And** no outputs are committed

<!-- End story repeat -->

### Story 4.5: Save Preprocessed Dataset Checkpoint

As a workspace owner,
I want to explicitly save the preprocessed dataset,
So that the analysis-ready state is frozen and downstream analyses are unlocked.

**FRs:** FR26, FR35

**Acceptance Criteria:**

**Given** preprocessing outputs are available
**When** I choose "Save Preprocessed Data"
**Then** the system commits a preprocessed & saved checkpoint for the active dataset
**And** downstream analysis steps are unlocked only after this checkpoint

**Given** the checkpoint is saved
**When** I reopen the workspace
**Then** the analysis-ready state is available as the last committed preprocessing result
**And** any subsequent preprocessing changes require a new save to restore the checkpoint

**Given** the checkpoint save fails during persistence
**When** I attempt to save preprocessed data
**Then** the previous committed state remains intact
**And** an actionable error is displayed with retry guidance

<!-- End story repeat -->

## Epic 5: Portability

Users can export/import complete workspaces for portability and reuse.

### Story 5.1: Export and Import Full Workspaces as Portable Bundles

As a workspace owner,
I want to export and import complete workspaces as portable bundles,
So that I can share or move projects without losing reproducibility.

**FRs:** FR25, FR37

**Acceptance Criteria:**

**Given** an existing workspace
**When** I export it
**Then** the export bundle includes the workspace object, manifests, provenance, raw inputs, and internal DB artifacts
**And** the bundle is self-contained with no external path dependencies

**Given** an export bundle
**When** I import it
**Then** a new workspace is created from the bundle
**And** the workspace loads with the same committed state and provenance as the source
**And** if the bundle is missing required artifacts or is corrupt, import fails with an actionable error and no workspace is created

<!-- End story repeat -->

<!-- End story repeat -->

## Epic 6: Analysis Extension Interface

Users can add future analysis modules without destabilizing the core workflow, ensuring analysts and labs can extend the platform safely post-V1.

### Story 6.1: Define Analysis Extension Interface (V1)

As a platform builder,
I want a defined interface for registering future analyses and storing typed results,
So that post-V1 analysis modules can plug in without reworking the core.

**FRs:** FR27

**Acceptance Criteria:**

**Given** the V1 core is in place
**When** an analysis extension is registered
**Then** the system accepts a typed result definition and registration metadata
**And** no analysis execution is required or implemented in V1

**Given** an analysis extension registration
**When** results are stored
**Then** they are persisted using the same schema/versioning and provenance conventions as the core
**And** the extension interface does not alter the committed preprocessing state

<!-- End story repeat -->
