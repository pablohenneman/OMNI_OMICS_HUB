---
stepsCompleted: [1, 2, 3, 4, 5]
inputDocuments:\n  - docs/brainstorm-project.md\n  - docs/project-context.md
workflowType: 'product-brief'
lastStep: 0
project_name: 'OMNI_OMICS_HUB'
user_name: 'Pablo'
date: '2025-12-23'
---
# Product Brief: OMNI_OMICS_HUB

**Date:** 2025-12-23
**Author:** Pablo

---

<!-- Content will be appended sequentially through collaborative workflow steps -->
## Executive Summary

OMNI_OMICS_HUB is a guided omics data import and preprocessing platform focused on proteomics LFQ for V1. It helps bench scientists (and non-omics collaborators) configure datasets correctly, preserve provenance, and reach an analysis-ready state with clear checkpoints. The platform reduces setup errors, saves time, improves collaboration, and empowers researchers to extend their capabilities without deep technical barriers. V1 is intentionally scoped to project-based analysis setup and preprocessing; downstream analysis, multi-omics, and AI guidance are future extensions.
Terminology note: OmicsWorkspace is the canonical top-level container; OmicsAnalysis is a legacy synonym for the same object.

---

## Core Vision

### Problem Statement

Omics data configuration and preprocessing are error-prone and difficult to set up correctly, especially for bench scientists and non-omics collaborators. Existing tools are either limited in scope or difficult to access, leaving teams without a reliable, guided path to an analysis-ready dataset.

### Problem Impact

When setup goes wrong, researchers lose time, collaboration slows, and the path to insights stalls. Teams struggle to share reproducible, well-configured datasets, limiting their ability to explore omics data or extend analyses confidently.

### Why Existing Solutions Fall Short

- Perseus focuses on preprocessing but doesn't provide a broader, guided workflow or integrated downstream analysis.
- OmicsPlayground is hard to install and becomes paywalled after a limited number of analyses.
- Many solutions assume omics expertise, leaving non-specialists without a reliable, structured path.

### Proposed Solution

A project-based platform that guides users through Steps 0-4 (dataset properties, import, mapping, rowData, colData), with explicit checkpoints and provenance. It creates a predictable, reproducible, analysis-ready dataset per workspace, with strict gating and clear state tracking.

### Key Differentiators

- Clear, stepwise workflow with explicit commit points and reproducible state.
- Designed for bench scientists and cross-disciplinary teams, not just omics specialists.
- Built to grow into downstream analysis, multi-omics, and AI-assisted guidance over time.
## Target Users

### Primary Users

**1) Bench Scientist (Primary User)**
A lab-based researcher who needs to process proteomics results without getting stuck in configuration complexity. They want a guided UI that keeps them moving, builds confidence in their decisions, and avoids confusing errors.

**2) Non-Omics Researcher (Primary User)**
A collaborator who sent samples to a core facility and now needs to explore the results themselves. They value a clear, stepwise workflow that helps them reach analysis-ready data without specialist tooling knowledge.

**3) Core Facility Analyst (Primary User)**
A staff analyst who repeatedly runs similar preprocessing steps for many clients. They want fast, reliable workflows with minimal repetitive configuration and easy ways to share results back to requesters.

**4) Builder/Analyst (Primary User)**
The platform's developer and primary analyst who extends the product with new analyses. They need strong logging, a centralized state object for debugging, and modular analysis components that can be adapted into the platform (e.g., SummarizedExperiment or Seurat adapters). For UI development, they prefer working panel-by-panel (tab-centric) to incrementally build and validate workflows.

### Secondary Users

**PI/Supervisor**
A decision-maker who reviews shared results. They want clean, intuitive visualizations of data quality and core analysis outputs without a cluttered interface.

### User Journey

- **Discovery:** Bench scientists and non-omics collaborators learn about OMNI_OMICS_HUB through core facilities or team referrals when they need to process omics data quickly.
- **Onboarding:** The guided, step-by-step UI leads them through dataset properties, import, mapping, rowData, and colData without dead-ends.
- **Core Usage:** They complete preprocessing with explicit checkpoints and confidence in the state of the data.
- **Success Moment:** They get a clean, analysis-ready dataset and trustworthy QC/summary plots they can share with their PI.
- **Long-term:** Core facility staff reuse consistent workflows; builders add new analyses and data-type adapters as the platform expands beyond proteomics.
## Success Metrics

User success (V1): Researchers can complete configuration and preprocessing without getting stuck, producing consistent and reproducible outputs.

### Business Objectives

- Establish a stable, usable V1 for proteomics teams.
- Validate workflow usability with early adopters.

### Key Performance Indicators

- TBD (instrumentation and quantitative tracking are out of scope for V1).
## MVP Scope

### Core Features

- **Project-based workspace setup:** create/open/delete projects; single active project; workspaces live within project folders with a clear manifest.
- **OmicsWorkspace + OmicsDataset model:** each workspace owns an OmicsDataset; raw data state is explicit and never changes silently.
- **Architecture clarity:** OmicsProject owns multiple OmicsWorkspaces; each OmicsWorkspace owns exactly one OmicsDataset.
- **Internal feature mapping DB:** mapping relies on a DB Manager object that builds/loads feature mapping tables and provides deterministic ID mapping with provenance.
- **Stepwise data configuration (Steps 0-4):**
  - Step 0: Dataset properties (required fields, explicit gating, editable with warnings).
  - Step 1: Import & parsing with robust NA handling, preview, and explicit parsed-NA vs token-normalized missingness reporting (expression vs rowData).
  - Steps 2-3: Column mapping + rowData configuration, feature ID mapping, provenance; first occurrence maps, duplicates get .1/.2 and do not map; internal DB duplicates resolve by deterministic first match.
  - Step 4: Sample metadata (colData) configuration with guided UI and validation.
- **Preprocessing workflow (V1):**
  - Filtering, normalization, imputation, scaling, variable features, PCA/UMAP options.
  - Explicit checkpoints with provenance and invalidation rules.
- **Apply vs Save:** Apply commits a single step’s parameters and outputs; Save Preprocessed Data freezes the dataset to unlock downstream analyses.
- **Execution model:** V1 runs synchronously with minimal running indicators; async queues/background processing are post-V1 only.
- **Logging & provenance:** each step records parameters, start/end time, and total duration; User logs show outcomes/warnings/failures, Dev logs include parameter diffs and load/compute timings.
- **Error taxonomy:** Validation errors are user-fixable and block Apply/Continue; System errors are unexpected and logged with an error ID.
- **State tracking + reproducibility:** explicit commit points, saved parameters, and deterministic state transitions.
- **User-focused UI flow:** panel/tab-centric workflow that mirrors the logical steps and avoids dead-ends.
- **Export/import lifecycle:** workspace export is self-contained (data, configuration, preprocessing state, provenance, and referenced internal databases); import always creates a new workspace.

In this project, OmicsDataset represents the complete dataset, including data, metadata, and preprocessing state.

### Out of Scope for MVP

- Downstream analysis modules and advanced visualization beyond core QC/summary plots.
- Multi-omics and cross-dataset analysis.
- AI agents/chatbots for guidance.
- Advanced auto-detection presets and extended import formats beyond core CSV/TSV/XLSX.
- Asynchronous heavy compute optimization beyond baseline sync execution.

### MVP Success Criteria

- Users can complete Steps 0-4 and preprocessing without getting stuck.
- Analyses produce a reproducible, analysis-ready dataset with clear provenance.
- The UI flow mirrors the stepwise thinking process and feels stable for repeated use.
Data limits are soft guardrails (warnings only) and do not block execution in V1.

### Future Vision

- Add downstream analysis modules and richer interactive visualization.
- Expand to other omics types and cross-dataset workflows.
- Introduce AI-assisted guidance and troubleshooting.
- Modular adapter layer to support additional data formats and analysis frameworks.

