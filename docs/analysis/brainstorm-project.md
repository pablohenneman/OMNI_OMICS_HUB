# Brainstorm: OMNI_OMICS_HUB (V1)

## Problem Statement
Omics analysis is hard to configure and easy to misstep. The project guides users through configuring and preprocessing omics data into a structured, analysis-ready form. The current focus is proteomics LFQ data. Downstream analysis configuration and visualization are acknowledged but not part of the current scope.
Terminology note: OmicsWorkspace is the canonical top-level container; OmicsAnalysis is a legacy synonym for the same object. Use "analysis" only for downstream analysis modules.

## Project & Workspace Management (OmicsProject)
Source: `User_Notes/user_notes_correct_course_and_epics_bundle.md`
- Home screen: app opens on HOME with short project description and a "Get Started" CTA that routes to Projects.
- Home screen: add a log level dropdown (dev = all logs, user = only major step completions).
- Projects are required before any workspace can be created or opened.
- Project lifecycle: create/open/delete/unlink; local-only with explicit confirmation on destructive actions.
- A project is a folder on disk with a manifest; it is the authoritative index of workspaces.
- Project output includes a manifest and workspace folders.
- Example structure:
  - projectfolder/config.json (project settings in project object)
  - projectfolder/<workspace-id>/ (one folder per omics workspace)
  - projectfolder/ExportedAnalyses/ (portable exports by name + date)
- Single active project; workspaces are independent and each workspace owns one dataset.
- Workspace lifecycle: create/delete/import; portable imports are converted to workspace state and registered.
- App-level registry tracks recent projects; missing/moved projects handled gracefully.
- Cache representation: an in-memory S4 OmicsProject object that centralizes paths and project metadata.
- Navigation gating: no project open shows only Home/Projects; workspace panels unlock only after a project + workspace exist.
- Baseline V1 goal for projects: manage workspace contents (datasets living in the project); extended features can be added later.
- Logging/provenance:
  - log UI parameter changes, provenance saves, and process completion times (duration).
  - OmicsProject owns multiple OmicsWorkspaces; each OmicsWorkspace owns exactly one OmicsDataset.
  - Each step records parameters, start time, end time, and total duration.
  - Logging levels: User (step outcomes, warnings, failures) and Dev (parameter diffs, sub-step timings, load/compute events).
 
## Project vs Workspace Dashboards (Navigation)
- Project dashboard is project-level only: overview table of OmicsWorkspaces (datasets) with key properties.
- Project dashboard includes Create OmicsWorkspace and select existing workspace.
- Selecting/creating an OmicsWorkspace opens the OmicsWorkspace dashboard (workspace-level).
- OmicsWorkspace dashboard shows dataset info/stats + sub-analyses (future) and provides a CTA to open Import/Config/Preprocess at current step.
- Left nav for Import/Config/Preprocess is only shown inside the import/config workspace, not on the project dashboard.

## OmicsWorkspace Navigation (Left Nav)
- OmicsWorkspace screens use a persistent left nav with top-level sections: Home, Data, Results.
- Results is locked in V1.
- Data expands into two grouped subsections:
  - Configuration: Steps 0–4
  - Preprocessing: Filtering, Normalization, Imputation/Scaling, Dimensionality Reduction
- Each step shows a state (locked/ready/dirty/completed).
- Navigation changes the visible workspace only; computation runs only via Apply/Run.

## App Screen Hierarchy & OmicsWorkspace (V1)
- Three primary screen levels: Landing Page, Project Dashboard, OmicsWorkspace Level.
- OmicsWorkspace level centers on a single config/preprocessing workspace with a persistent two-row progress bar:
  - Row 1: Configuration (Steps 0–4)
  - Row 2: Preprocessing (Filtering -> DR)
  - Each step shows state (completed/active/locked).
- The progress module is persistent and reused in the OmicsWorkspace dashboard as a status card.
- OmicsWorkspace Dashboard behavior:
  - Newly created workspace: status/to-do card dominates.
  - As config completes: add summary cards (workspace name, omics layer, bulk vs single-cell, sample count, feature count).
  - Top half: global workspace properties + status; bottom half: Results placeholder (post-V1).
- Clicking steps switches to the full workspace (replaces dashboard).
- Shared workspace layout rules:
  - Left panel: parameters/controls; advanced in collapsible section.
  - Validation/warnings above action area.
  - Bottom-left: explicit Apply/Continue buttons.
  - Validation errors are user-fixable and block Apply/Continue; system errors are unexpected and logged with an error ID.
  - Right panel: feedback (tables, plots, interactive builders).
  - Some steps may temporarily use more horizontal space.
- Navigation never triggers computation; execution requires explicit user action.
Merged panels: Step 0 + Step 1 share a single panel; Step 2 + Step 3 share a single panel (may be split in the future). Continue advances step state, not panel layout.

## OmicsWorkspace Object
Sources:
- `User_Notes/user_notes_correct_course_and_epics_bundle.md`
- `User_Notes/omn_omics_backend_high_level_design_takeaways.md`
- An omics workspace lives inside a project and is represented in cache as an S4 object.
- The omics workspace object has three main slots: (can later expanded to more when extra features are added)
  - OmicsDataset (dataset slot, focus for V1 configuration and preprocessing)
  - UI params (for opening a workspace later and having the same configuration, in user interface) (also included in V1)
  - Analysis Results object (results slot, planned but not implemented in V1)
- The dataset slot contains the full dataset, metadata, and preprocessing state; workflow gating and UI params are handled by the omics workspace object.
- Raw data presence state is tracked in the OmicsDataset and surfaced at the workspace level.
- Additional workspace-level slots can be added later to support these management concerns.
- The workspace object is the primary in-memory object used by the UI while a workspace is open.
- On disk, each workspace lives in its own project subfolder and stores:
  - an `omicsworkspace.rda` file for the workspace object
  - subfolders for files not kept in memory (raw data, exported figures, and later analysis outputs)
- Raw data state is explicit and must never change silently (embedded, detached, missing).
- Export is handled at the workspace level: exporting bundles the workspace object plus any on-disk data (raw data and other non-cached artifacts) by loading them into the dataset for portability.
- Workspace export is self-contained: data, configuration, preprocessing state, provenance, and any internal databases referenced by the workspace.
- Import always creates a new workspace subfolder with required on-disk folders and data.
- Export folder name: `ExportedAnalyses` (project-level).

## OmicsDataset
Sources:
- `User_Notes/backend_preprocessing_design.md`
- `User_Notes/preprocessing_guidelines.md`
- `User_Notes/steps_01_to_03_import_and_rowdata_flow.md`
- `User_Notes/step_04_sample_data_colData_configuration.md`
- In this project, OmicsDataset represents the complete dataset, including data, metadata, and preprocessing state.
- The OmicsDataset stores assays, rowData, colData, dataset properties, and preprocessing/provenance details.

- Raw input slot
  - full input (raw data) non-configured (only used, during export of a workspace or in the first step of data parsing)
  - Preview df (first 10 rows of raw input df
- Assays:
  - raw: non-log transformed raw assay (post-filtering applied via masks)
  - normalized: derived from raw (log transform + optional normalization method)
  - imputed normalized: normalized assay after imputation
  - scaled: scaled version of the normalized/imputed assay
- rowData:
  - user-defined rowData
  - rowData_internal from feature mapping (same nrow)
  - row filtering applies to all rowData tables
  - later analysis feature annotations can be added as additional rowData tables
- colData:
  - sample metadata configured in Step 4
- colData_meta:
  - metadata about colData columns (group ordering, colors, column-level settings)
- properties:
  - list of property name/value pairs
  - properties come from user config and derived checks (e.g., data flags)
  - enforced property names list is configurable and can evolve over time
  - preprocessing steps and parameters are stored as provenance entries



## Properties and Registry System
- Use a flexible properties list and a registry to determine available options. (registry: contains options, each linked to [param:name = value pairs] that all need to be present in a property list for the option to be returned)
- Input: properties + registry; output: list of available options with descriptions.
- Requirements are checked by property name and value matches.
- Reuse this system for:
  - preprocessing step availability (e.g., bulk vs single-cell)
  - analysis availability
  - database selection

## DB Manager Object
Source: `User_Notes/internal_feature_annotation_db_mvp.md`
- A DB Manager object is a slot on the OmicsProject object and owns all database setup and access.
- Responsibilities: list database types and contents, create/download databases, and serve access by type + properties.
- If a requested DB type is missing, the DB Manager downloads/builds it; if present, it loads and returns the data quickly.
- Modular design: DB manager can host per-type subclasses, each exposing specialized methods (e.g., mapping IDs).
- V1 database type: `feature_mapping`.
- For `feature_mapping`, resolve by properties (omics_layer = proteomics or transcriptomics) and species to return mapping tables.
- Omics workspaces request DB access by type (e.g., `feature_mapping`) through the DB Manager.
- Required functions from the feature mapping spec:
  - Score candidate ID columns (mapping coverage, multi-mapping rate, unmapped count).
  - Map ID vectors to canonical IDs with deterministic one-to-many handling.
  - Attach default labels (gene_symbol) when available.
  - Report mapping provenance (release, build date, mapping stats, policy).
  - map_features parameters:
    - ids: unique feature ID vector
    - dedupe: make unique with suffixes .1, .2, ...
    - id_delim: split delimiter for multi-ID entries (default ";", allow NULL, "_", ",", "|")
    - id_type: uniprot, ensembl, gene_symbol, protein_name (database column choice)
    - species: human or mouse
  - map_features outputs:
    - internal_id (Ensembl ID for V1; configurable later)
    - label (default gene_symbol; unmapped uses "Unmapped_<input_id>")
    - mapped flag (boolean)
    - multi_mapping flag (boolean; true if input matches multiple DB entries, but map to first)
  - map_features_summary:
    - input: map_features result
    - output: counts and percentages mapped, multi-mapped count, and missing-label count
  - optimize_feature_mapping:
    - input: ID vectors (vector or matrix; if matrix, run per column) plus candidate parameter options
    - behavior: run map_features across all parameter combinations and aggregate summaries
    - output: summary table with one row per parameter combination, scored by mapped count



# Data Import (configuration + preprocessing):
- loading of an omics workspace or creating a new omics workspace (starts by filling and configuring the OmicsDataset)
- Linear flow: track configuration steps (step0, step1, step2, ..., complete). If a user changes an earlier step, re-run downstream steps (initially re-run everything downstream to the current point). Do the same for preprocessing.
Steps 0–4 are canonical even when UI panels are merged; Continue advances step state, not panel layout.

## Data Configuration contract: 
User uploads data and configures dataset properties, expression vs rowData columns, and sample metadata from sample names. At the end, an unfiltered configured dataset is returned (Configuration = "complete"): properties, rowData (user + internal), raw assay, colData (sample + col metadata).
Other dataframes, such as the input dataframe, can be removed from cache but must be available on disk in the workspace raw folder for later re-configuration.
### Tab 1: 
Dataset Properties (step 0)
Source: `User_Notes/step_00_dataset_properties_bmad.md`
- Required properties (V1): workspace_name (unique within project), modality (bulk/single_cell), data_type (fixed to LFQ proteomics).
- Optional context: acquisition_mode, sample_origin, project_description.
- No data upload here; this step only sets dataset context.
- Explicit completion gating before import; downstream panels locked until completed.
- Properties remain editable; changing later shows a warning about downstream impact.

Import & Parsing (Step 1)
Sources:
- `User_Notes/steps_01_to_03_import_and_rowdata_flow.md`
- `User_Notes/user_notes_correct_course_and_epics_bundle.md`
- Upload CSV/TSV/XLSX, parse into a raw table, and show a preview.
- Summary cards show filename, shape (nrow/ncol), missingness + NA tokens, parse config (delimiter/header or sheet), and adapter preset detection (if available).
- Preview table truncates long values; hover reveals full cell content.
- Continue only when parsed result exists and nrow/ncol > 0; warn if no NA tokens detected and require explicit confirmation.
- NA detection: first parse and check for NA/NULL/Inf (coerce to NA). If none found, scan for default NA tokens ("NA", "", "NULL") and re-parse.
- Defaults: header = TRUE (shown as dropdown but locked in V1), delimiter auto-detect; advanced settings allow manual override and custom NA tokens.
- Commit point on Continue: store parsed data, a stable preview snapshot, parse settings, and mark Step 1 completed (Property: Configuration = "step1").
- Missingness reporting separates parsed NA vs token-normalized NA, and separates expression data vs rowData; mixed cases must be surfaced with no silent conversion.

### Tab 2: Column Mapping & RowData (Steps 2-3)
Sources:
- `User_Notes/steps_01_to_03_import_and_rowdata_flow.md`
- `User_Notes/internal_feature_annotation_db_mvp.md`
- `User_Notes/user_notes_correct_course_and_epics_bundle.md`
Column mapping
- Assign each parsed column to exactly one role: Expression, RowData, or Ignore.
- Three-field layout: left = RowData, middle = Ignore, right = Expression.
- Default preset: all columns start in the middle. (ColumnMappingPreset = "custom") (for now keep custom only option in V1)
- Presets for known search engine formats use hard-coded rowData columns and regex for intensity columns. (POST V1)
- Auto-detection tries to match known formats; if none, fall back to default.(POST V1)
- UI supports drag and drop, multi-select, and search; show counts per role and truncate long names with hover.
- Search bar filters across all three fields; results can be selected in bulk and dragged.
- One-click select all for the current filter results.
- Long lists must be scrollable (single-cell scale or long names).
- Advanced helper: IncludeColumnsThatContain(<pattern>) for RowData or Expression.
- Regex conflicts put overlapping columns back to Ignore with a warning border; user must resolve manually.
- Expression columns must be numeric; non-numeric selections are blocked with warnings.
- Presets/auto-detection can prefill roles; manual override always allowed.
- Conflicts (columns matched by multiple rules) are surfaced and must be resolved before Continue.
RowData configuration:
- RowData preview is shown for selected columns; optional upload/join allowed with row count validation.
- Feature ID configuration:
  - select primary ID column and delimiter (;, by default) for multi-ID entries (protein groups in proteomics are common)
  - a selected ID column may be subjected to a delim operation do str_split_i(delim, i = 1) (optional), but always undergoes:
  - Duplicate handling: append .1, .2, ... to internal IDs and warn with examples.
  - First occurrence remains unsuffixed and may map; duplicates are suffixed and are not mapped.
  - Internal DB duplicate IDs are resolved by deterministic first-match selection.
  - choose ID type (uniprot, ensembl, gene_symbol, protein_name)
  - species is used for DB mapping
  - mapping feedback shows coverage, multi-mapping rate, and unmapped count
  - auto-select best ID column by mapping score; manual override allowed (advanced)
  - To improve user experience, show non-numeric columns with the most unique values first (higher chance of being an ID). If a delimiter is selected, columns containing the delimiter are shown first.
Raw assay configuration:
- Show a density plot of intensities to help users confirm log-transform status and detect unexpected negative values.
- Optional flag for log-transformed expression values; prevents double log downstream. 
- Detect properties: ContainsNA (now evaluated on the non-log-transformed raw expression assay).

Final output
- Continue commits: build sparse unlogtransformed raw expression matrix +
    rowData from user + internal rowData (optionally stored together with prefixes: internal = int_, user = ext_)
    store mapping provenance, so that steps are repeatable from input dataframe.


### Tab 3: Sample Data (Step 4)
Source: `User_Notes/step_04_sample_data_colData_configuration.md`
- Goal: build a flexible `colData` from sample names; minimal valid `colData` is enough to proceed.
- Base table:
  - `sample_id` from expression column names
  - unique IDs (auto-suffix duplicates with warning)
  - live preview always visible
- Column types:
  - trait (default)
  - replicate
  - combined trait
  - label (single column; default is raw sample names)
- Column creation flow:
  - define column name + type
  - new tab created per column
  - values assigned row-wise
- Manual assignment:
  - add one category value at a time
  - show matched sample count immediately
  - live update of the sample table
  - unassigned samples list always visible
- Delimiter-aware auto-suggestion:
  - detect delimiter (default `_`)
  - compute modal delimiter count
  - infer token position for entered value and suggest other values from same slot
  - Enter accepts, Backspace ignores; suggestions apply sequentially
- Autofill:
  - auto-assign all suggestions
  - enabled only for modal delimiter count or accepted non-modal counts
  - enforce no overlaps with live preview
- Irregular sample names:
  - flag non-modal delimiter counts
  - highlight at top of unassigned list
  - options: manual assign, move to Ignore, or move to RowData (requires Step 2)
  - actions require confirmation and are reversible
- Validation:
  - no overlapping category assignments
  - empty metadata columns allowed but marked inactive
  - analyses requiring grouping stay locked until suitable trait columns exist
- Column configuration:
  - ordering via drag & drop
  - colors: seeded auto palette or manual picker
  - modify-values sub-column for corrections (unique values required)
  - active identity: select a (combined)trait column as the main grouping (Seurat-style Idents)
  - label column: choose which column defines display labels; default is input sample names, but can be derived from active identity trait + replicate
- Combined traits:
  - available when >= 2 trait columns exist
  - concatenation with `_`
  - combined traits cannot be inputs for further combinations
  - do not change sample IDs unless requested
- Replicate handling:
  - extract from sample names (needs to be done by user, and columns get assigned the role of replicate) or auto-generate if label schema exists
  - replicate values are user-controlled
- Persistence:
  - columns can be saved, reopened, modified, deleted
  - all edits update the table live
  - full configuration stored in provenance

## Preprocessing Contract (V1)
Goal: preprocess a configured dataset into a preprocessed dataset by filtering rowData, colData, and the raw assay; adding normalized/imputed and scaled assays; storing an imputation mask; adding variable feature flags; computing PCA (default top 10 PCs) from scaled data using variable features; and computing UMAP coords from selected PCs.

The preprocessed dataset is stored in the dataset slot of the OmicsWorkspace object. The configured dataset may be removed from memory but can be reconstructed from the raw input dataframe because steps are saved.

Sources:
- `User_Notes/preprocessing_guidelines.md`
- `User_Notes/backend_preprocessing_design.md`
- `User_Notes/backend_async_and_state_management.md`

- Configured dataset is the start point of this workflow
- Linear, single-state pipeline with explicit Save checkpoint.
- Apply commits a single step’s parameters and outputs; Save Preprocessed Data is a distinct freeze that unlocks downstream analyses.
- V1 runs synchronously with minimal running indicators; async queues and background processing are post-V1 only.
- Strict invalidation on data-touching changes. (when user wants to change parameters, that will require downstream re-running of params) especially, when data has been configured and preprocessed)
- guide users through settings params for processing by providing plots
- Keep track of current step in preprocessing workflow, Only allow going to next step when previous step is confirmed)
### Tab 1: Filtering of samples and features:
- Input: configured dataset (kept in cache to allow reconfiguring filters)
- Purpose: define which samples and features are in the active dataset by filtering from the configured dataset.
- Outputs: filtered active dataset in the OmicsWorkspace dataset slot plus `sample_mask` and `feature_mask` stored as provenance masks.
- Backend:
  - filtering does not change the configured dataset in cache; it hard-filters assays, rowData, and colData in the active dataset
  - defaults keep all samples/features (no filtering applied)
  - changing filters invalidates downstream preprocessing steps
  - short step; can run synchronously
- UI:
  - manual selection by sample name lookup
  - QC-driven filtering:
    - hierarchical clustering to spot outliers
    - distribution of detected feature counts
    - distribution of total intensity (per sample/cell)
    - slider-based bounds (keep samples within range)
  - UI feedback:
    - mark filtered samples on distributions with thresholds
    - show which active identity group is affected by filtering
  - Feature filtering:
    - presence/missingness thresholds
    - group-aware filtering if grouping metadata exists; skipped otherwise
  - UI details:
    - slider for minimum number of samples; show both count and percentage
    - histogram of feature presence with a single cutoff line (no range)
    - summary bars show total filtered and per active identity group
  - Group-aware filtering:
    - user selects a trait column
    - own slider and histogram for group-aware thresholds
    - per-group presence is computed, but each feature is shown once using its max presence across groups

### Tab 2: Normalization
Purpose:
- Transform expression values into a normalized assay suitable for downstream analyses.
Inputs:
- Active dataset in the OmicsWorkspace dataset slot.
- Raw assay (from the active dataset) as the normalization input.
Outputs:
- Normalized assay written back into the active dataset.
Backend:
- Unlike filtering, normalization does not rely on a preserved configured dataset; it updates the active dataset directly.
- Double-normalization is prevented because the raw assay is configured as non-log-transformed.
- Method and parameters are explicitly recorded.
- V1 method options:
  - log2 transform (checkbox shown but locked on)
  - additional method: none (default) or `normalize_vsn` (DEP2)
- NA counts are preserved: number of NAs in raw equals number of NAs after normalization.
- Completion rule: normalized assay exists, parameters recorded, and NA count is unchanged.
UI:
- intensity density lines per sample for three views: raw, raw+log2, raw+log2+method (third view only if method selected)
- density lines: each sample plotted on the same x-axis
- boxplots: intensity distribution grouped by active identity
- toggle between density plots and boxplots

### Tab 3: Imputation + data scaling (always done)
- Imputation
  - Input: active dataset normalized assay.
  - Uses imputation mask (default `is.na(raw)`) to reset imputed positions to NA before re-running.
  - Method and parameters are recorded.
  - V1 methods: zero-imputation (default) and DEP2 `MinProb` (q = 0.01 default). (other methods from DEP2 and seurat are added later)
  - Runs only after normalization.
  - Diagnostics: missingness before and after imputation.
  - Store a single imputation mask to track missingness; applies to normalized and scaled assays.
  - Record RNG seed for reproducibility.
  - UI feedback:
    - density distributions before vs after imputation
    - static ComplexHeatmap of genes with at least one NA (white = present, black = missing), columns grouped by active identity
- Scaling
  - Always performed after imputation.
  - Row-wise scaling with defaults: center = TRUE, scale = TRUE.
  - Settings are shown under advanced.

### Tab 4: Variable Features + Dimensionality Reduction
- Variable feature selection:
  - calculated on normalized/imputed assay
  - store variance metric in internal rowData
  - store rank column for each feature
  - user selects top N via slider
  - rank plot: x = rank, y = variance (no labels)
- Variance methods:
  - basic variance (sd)
  - Seurat-style mean-adjusted variance (FindVariableFeatures)
- PCA:
  - always computed on the scaled assay
  - compute first 50 PCs by default (editable under advanced)
  - UseVariableFeatures = TRUE (advanced; default)
  - explained variance per PC is stored
  - elbow plot (variance vs PC index)
  - user selects top N PCs via slider (default = 10)
  - selected top N PCs drive downstream analyses that depend on PCA
- UMAP / t-SNE:
  - optional toggles to compute UMAP and/or t-SNE
  - computed using the selected top N PCs (Seurat-style workflow)
  - advanced: custom RNG seed options for UMAP and t-SNE
- Plots:
  - buttons to render PCA (PC1/PC2), UMAP, or t-SNE when available
  - color by active identity when present



## Glossary
- Active dataset: the dataset that lives within the OmicsWorkspace object.
- Configured dataset: the dataset after all configuration steps are completed.
- Preprocessed dataset: configured dataset + preprocessing steps applied.

## Section G: Backend Architecture Principles
Source: `User_Notes/omn_omics_backend_high_level_design_takeaways.md`
- Single internal data model with adapters to external tools.
- Results stored as typed objects in a results registry.
- Metadata-driven capability gating.

## Section H: Analysis Configuration (Later, POST V1 ignore for now)
Source: `User_Notes/Main Analysis configuration style prompt.txt`
- Users select analyses and configure required inputs.
- Queued background computation with progress indicator.
- Visualization panels consume computed results.

## Tech Stack Direction
Source: `User_Notes/tech_stack_brainstorm_v_1.md`
- Shiny + golem + bslib foundation.
- bslib for an appealing and clean data dashboard look; use for sidebar navigation and theme dropdown.
- Async via future/promises (only configured on demand, when analysis).
- Plotting with ggplot2/ComplexHeatmap; optional plotly.


Open questions: What should be documented from reference packages to aid the developers?

## Revisions (Memory + Onboarding)
- Data size: 2 GB is a current guideline, not a hard limit; expected to evolve.
- Data limits are soft guardrails (warnings only) and do not block execution in V1.
- Memory model: assume ~16 GB RAM is typical; keeping datasets in memory is acceptable for V1.
- Resource awareness: track memory usage and warn at ~80% of total RAM utilization.
- Onboarding: provide a written guide.
- In-app support: info buttons with instructions and examples.
- Risk: Poor ID mapping yields weak downstream capability flags.
  Mitigation: surface mapping quality + explain downstream impacts.
- Risk: UX complexity in configuration and preprocessing.
  Mitigation: default path + hide advanced options until needed.
