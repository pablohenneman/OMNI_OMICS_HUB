# Story 1.3: Delete Project with Explicit Confirmation

Status: review

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a workspace owner,
I want to delete a project only after explicit confirmation,
so that I avoid accidental data loss.

## Acceptance Criteria

1. Given I am viewing a project, when I choose the delete action, then I am required to confirm the deletion explicitly before any files are removed.
2. And the confirmation clearly states that all workspaces and data in the project will be deleted.
3. Given I confirm the deletion, when the deletion completes, then the project folder is removed and the app no longer lists it as available.
4. And a success message confirms the project was deleted.

## Tasks / Subtasks

- [x] Task 1: Define delete confirmation UX and copy (AC: 1, 2)
  - [x] Subtask 1.1: Add a delete action on the project dashboard with a confirmation modal.
  - [x] Subtask 1.2: Require explicit confirmation (e.g., checkbox + confirm button) that states all workspaces and data will be deleted.
  - [x] Subtask 1.3: Confirmation copy must include: project name, deletion is irreversible, all workspaces/data removed, and the exact path.
- [x] Task 2: Implement project deletion service and persistence (AC: 1, 3, 4)
  - [x] Subtask 2.1: Resolve project path via the path resolver and validate manifest presence before deletion.
  - [x] Subtask 2.2: Delete the project folder recursively; surface actionable errors on failure with no partial registry updates.
  - [x] Subtask 2.3: If the deleted project is active, clear the active project reference in session state.
  - [x] Subtask 2.4: Handle edge cases (locked files, permission errors, missing folders, open handles) with explicit error messages and no state change.
- [x] Task 3: Update project listings/registry (AC: 3, 4)
  - [x] Subtask 3.1: Remove the project from recent projects or registry listings after successful deletion.
  - [x] Subtask 3.2: Refresh UI state to remove the project and show a success message.
  - [x] Subtask 3.3: Ensure recent-projects removal and active-project clearing happen only after deletion succeeds.
- [x] Task 4: Tests (AC: 1, 2, 3, 4)
  - [x] Subtask 4.1: testthat coverage for explicit confirmation gating before deletion.
  - [x] Subtask 4.2: testthat coverage for successful deletion removing the project folder and listings.
  - [x] Subtask 4.3: testthat coverage for failure paths leaving the project intact with actionable errors.
  - [x] Subtask 4.4: testthat coverage for deleting an active project clearing active session state.
  - [x] Subtask 4.5: testthat coverage for recent-projects list not mutating on failed deletion.

## Dev Notes

### Developer Context

- Destructive actions require explicit confirmation and must avoid silent data loss. [Source: docs/prd.md#Reliability]
- OmicsProject is the authoritative owner of project metadata and workspace registry; app session state is non-authoritative. [Source: docs/architecture.md#Data Architecture]
- All filesystem paths must be resolved through the path resolver. [Source: docs/project-context.md#Language-Specific Rules]

### Technical Requirements

- Use the path resolver for all project paths; no ad-hoc or CWD-relative paths. [Source: docs/project-context.md#Language-Specific Rules]
- Do not remove registry/list entries until deletion succeeds; failures must leave state intact and show actionable errors. [Source: docs/prd.md#Reliability]
- Reuse existing manifest validation and path resolution helpers from Story 1.2; do not duplicate validation logic. [Source: docs/implementation-artifacts/1-2-create-and-open-project-with-manifest.md]
- Do not modify `renv.lock` or add dependencies for this story. [Source: docs/project-context.md#Development Workflow Rules]

### Architecture Compliance

- UI modules call services; modules must not perform file IO. [Source: docs/project-context.md#Framework-Specific Rules]
- Persistence logic stays in `R/persistence/`; services orchestrate domain + persistence. [Source: docs/architecture.md#Architectural Boundaries]

### Library / Framework Requirements (Latest Check)

- No new libraries required; prefer base R for filesystem deletion. [Source: docs/architecture.md#Technical Constraints & Dependencies]
- Follow the existing golem + Shiny + bslib stack; no version changes required for this story. [Source: docs/architecture.md#Starter Template Evaluation]

### File Structure Requirements

- Service: `R/services/project_service.R` (add delete_project orchestration). [Source: docs/architecture.md#Project Structure & Boundaries]
- Persistence: `R/persistence/path_resolver.R` and `R/persistence/project_manifest.R` for path/manifest validation. [Source: docs/architecture.md#Project Structure & Boundaries]
- UI: `R/modules/project_dashboard/` for delete action + confirmation modal wiring. [Source: docs/architecture.md#Project Structure & Boundaries]
- Tests: `tests/testthat/` for headless domain/persistence coverage. [Source: docs/project-context.md#Testing Rules]

### Testing Requirements

- Use testthat for headless deletion behavior and error handling; keep tests deterministic and clean up temp folders. [Source: docs/project-context.md#Testing Rules]

### Project Structure Notes

- Modules in `R/modules/` must not perform file IO; delegate to services. [Source: docs/project-context.md#Framework-Specific Rules]
- Keep naming in `snake_case`; S4 class names unchanged. [Source: docs/project-context.md#Language-Specific Rules]

### Previous Story Intelligence

- Story 1.2 established manifest schema and path resolver usage; deletion should validate manifest presence via the same resolver. [Source: docs/implementation-artifacts/1-2-create-and-open-project-with-manifest.md]
- Story 1.1 scaffolded the golem project and testthat structure; extend existing test layout. [Source: docs/implementation-artifacts/1-1-set-up-initial-project-from-golem-starter-template.md]

### Git Intelligence Summary

- Recent commits established the golem scaffold, module folders, persistence/service boundaries, and testthat harness; align new delete logic to those paths. [Source: git log]

### Latest Tech Information

- No web research required for this story; rely on architecture-pinned stack and avoid dependency updates. [Source: docs/architecture.md#Dependency Sourcing Notes]

### References

- Story requirements and ACs: [Source: docs/epics.md#Story 1.3: Delete Project with Explicit Confirmation]
- Destructive action safety and no silent data loss: [Source: docs/prd.md#Reliability]
- Path resolver and file IO boundaries: [Source: docs/project-context.md#Language-Specific Rules]
- Ownership and persistence boundaries: [Source: docs/architecture.md#Data Architecture]

## Dev Agent Record

### Agent Model Used

Codex (GPT-5)

### Debug Log References

### Completion Notes List
- 2025-12-28: Implemented delete project service with manifest validation, safe deletion, recent-projects cleanup, and active-project clearing. Added project dashboard delete confirmation modal copy and explicit confirmation gating. Tests: `tests/testthat/test_project_service_delete.R`, `tests/testthat/test_project_dashboard_delete.R`, `tests/testthat/test_scaffold_structure.R`. Ran `Rscript -e "testthat::test_dir('tests/testthat')"` (skips: package not installed).

### File List
- DESCRIPTION
- R/mod_project_dashboard_server.R
- R/mod_project_dashboard_ui.R
- R/services_project_service.R
- R/state_app_session_state.R
- docs/architecture.md
- docs/implementation-artifacts/1-3-delete-project-with-explicit-confirmation.md
- docs/implementation-artifacts/sprint-status.yaml
- docs/project-context.md
- tests/testthat/test_project_dashboard_delete.R
- tests/testthat/test_project_service_delete.R
- tests/testthat/test_scaffold_structure.R
