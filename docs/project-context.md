# Project Context: OMNI_OMICS_HUB

## Description
This project is a re-do of an earlier OMNI_OMICS effort that started with enterprise-track implementation. The scope is now intentionally smaller to focus on a clear, V1 MVP: an OMICs data import and preprocessing platform with explicit checkpoints, reproducibility, and predictable downstream gating.

## Core Goal
Deliver a stable OMNI_OMICS V1 foundation that:
- Creates project-based analyses centered around a single analysis object.
- Focuses on import and setup for one preprocessed dataset per analysis object.
- Guides users through Steps 0-4 (dataset properties, import, mapping, rowData, colData).
- Preserves provenance and establishes predictable downstream gating.

## Scope Direction (V1)
- Scope now emphasizes project-based analysis setup and import.
- One analysis object per preprocessed dataset.
- Explicit commit points for every state-changing action.
- Focused UI/UX with minimal but sufficient validation to proceed.

## Key Contracts (from User_Notes)
- Preprocessing contract and assays: `User_Notes/preprocessing_guidelines.md`
- Backend preprocessing state model, invalidation, and save semantics:
  - `User_Notes/backend_preprocessing_design.md`
  - `User_Notes/backend_async_and_state_management.md`
- Import, mapping, rowData, and colData flows:
  - `User_Notes/steps_01_to_03_import_and_rowdata_flow.md`
  - `User_Notes/step_04_sample_data_colData_configuration.md`
  - `User_Notes/step_00_dataset_properties_bmad.md`
- Internal annotation DB requirements:
  - `User_Notes/internal_feature_annotation_db_mvp.md`
- Correct-course EPIC sequencing and guardrails:
  - `User_Notes/user_notes_correct_course_and_epics_bundle.md`
- Tech stack direction and constraints:
  - `User_Notes/tech_stack_brainstorm_v_1.md`
- Analysis configuration overview:
  - `User_Notes/Main Analysis configuration style prompt.txt`
- High-level backend architecture principles:
  - `User_Notes/omn_omics_backend_high_level_design_takeaways.md`

## Current Focus
Start with project context and planning artifacts (brainstorm + product brief), then proceed through the BMad Method workflow in a greenfield track, keeping the scope aligned to the V1 MVP contracts above.

## Output Location
All BMad outputs are written to `docs/` or subfolders within `docs/`.
