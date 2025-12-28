# Sprint Change Proposal

**Project:** OMNI_OMICS_HUB  
**Date:** 2025-12-28  
**Trigger Story:** 1.2 Create and Open Project with Manifest  
**Author:** John (PM)

## 1) Issue Summary

During Story 1.2 implementation we discovered a hard R packaging constraint: only `.R` files directly under `R/` are auto-sourced. Subfolders like `R/domain/`, `R/persistence/`, `R/services/`, and `R/state/` are not loaded by default, so `testthat::test_local()` / `pkgload::load_all()` fail with missing objects when code is stored under subfolders. `DESCRIPTION` Collate only orders files that are already sourced and does not fix this.

## 2) Impact Analysis

**Epic Impact**
- Epic 1 remains viable; no scope or acceptance criteria changes required.
- No changes to Epics 2-6, but future implementation must respect flat `R/` layout.

**Story Impact**
- Story 1.2 needs a structural correction task to align file layout with R package loading constraints.
- No functional requirements change.

**Artifact Conflicts**
- `docs/architecture.md` currently specifies `R/` subfolders for domain/state/persistence/services; this is incompatible with R's loading behavior.
- `DESCRIPTION` Collate needs to reference root-level filenames.
- Optional: add a brief development/testing note documenting the R loading constraint.

**Technical Impact**
- Code organization changes (file locations and names), not behavior.
- Testing stability improves once code is in root `R/` with prefixed filenames.

## 3) Recommended Approach

**Selected Path:** Direct Adjustment (Option 1)  
**Effort:** Low  
**Risk:** Low  
**Rationale:** The change is structural, preserves requirements, and aligns architecture with R package mechanics. Minimal scope and timeline impact.

## 4) Detailed Change Proposals

### A) Architecture Document Updates (`docs/architecture.md`)

**Section:** Project Structure & Boundaries (directory tree + boundaries)

**OLD:**
```
R/
  domain/
    omics_project.R
    ...
  state/
    workflow_state.R
    ...
  persistence/
    path_resolver.R
    project_manifest.R
    ...
  services/
    import_service.R
    ...
```

**NEW:**
```
R/
  app_ui.R
  app_server.R
  domain_omics_project.R
  domain_omics_workspace.R
  domain_omics_dataset.R
  domain_db_manager.R
  domain_registry.R
  state_workflow_state.R
  state_step_status.R
  state_validation_rules.R
  state_invalidation_rules.R
  persistence_path_resolver.R
  persistence_project_manifest.R
  persistence_workspace_manifest.R
  persistence_workspace_store.R
  persistence_export_import.R
  services_import_service.R
  services_mapping_service.R
  services_preprocessing_service.R
  services_registry_service.R
  provenance_provenance_writer.R
  provenance_provenance_schema.R
  utils_config_defaults.R
  utils_ui_helpers.R
  utils_error_helpers.R
  utils_logging.R
  modules/...
```

**Rationale:** R does not auto-source subfolders under `R/`; root-level files with prefixed names are required for reliable loading and tests.

**Section:** Naming + Structure Patterns

**OLD:**
```
R files: snake_case.R
R/ subfolders for domain/state/persistence/services
```

**NEW:**
```
R files: snake_case.R with responsibility prefixes (domain_, persistence_, services_, state_, provenance_, utils_)
No code subfolders under R/ because R does not recursively source them
R/modules/ remains for UI modules (sourced via root files)
```

### B) `DESCRIPTION` Collate Update

**OLD:**
```
Collate:
    'persistence/path_resolver.R'
    'persistence/project_manifest.R'
    'domain/omics_project.R'
    'state/app_session_state.R'
    'services/project_service.R'
```

**NEW:**
```
Collate:
    'persistence_path_resolver.R'
    'persistence_project_manifest.R'
    'domain_omics_project.R'
    'state_app_session_state.R'
    'services_project_service.R'
```

### C) Development/Testing Note (optional but recommended)

Add a short note in architecture or project-context:
"R does not recursively source `R/` subfolders. All package code must live in `R/` root with prefixed filenames."

## 5) Implementation Handoff

**Scope Classification:** Moderate  
- Requires doc updates + file moves + Collate alignment.  
- No change to product scope or UX; low technical risk.

**Handoff Recipients**
- **PM/Architect:** Approve and update `docs/architecture.md`.
- **Dev:** Move files to root `R/` with prefixed names, update `DESCRIPTION`, verify tests.
- **PO/SM:** Update story/task notes to reflect structural change.

**Success Criteria**
- Tests pass with root-level `R/` files.
- Architecture doc accurately reflects the flat `R/` structure.
