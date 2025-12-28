# Story 1.4: Create, Open, and Delete Workspaces

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a workspace owner,
I want to create, open, and delete workspaces within a project,
so that I can manage multiple datasets and workflows.

## Acceptance Criteria

1. Given an open project, when I create a new workspace, then a workspace folder and manifest are created and registered in the project manifest, and the workspace appears in the project's workspace list.
2. Given an existing workspace in a project, when I open the workspace, then the workspace loads from its manifest and becomes the active workspace, and missing or invalid workspace manifests block open with an actionable error.
3. Given an existing workspace, when I choose to delete it, then I must explicitly confirm deletion before any files are removed, and the workspace is removed from the project manifest and no longer listed after deletion, and if deletion fails mid-operation, the workspace remains listed with an actionable error and no partial deletion is recorded.

## Tasks / Subtasks

- [ ] Task 1: Workspace create/open/delete UX (AC: 1, 2, 3)
  - [ ] Subtask 1.1: Add workspace create/open/delete actions to the project dashboard (no file IO in modules).
  - [ ] Subtask 1.2: Create workspace form captures name and location within the project and surfaces validation errors.
  - [ ] Subtask 1.3: Delete action uses explicit confirmation copy (workspace name, irreversible, path).
  - [ ] Subtask 1.4: Open action shows actionable errors for missing/invalid manifests and for workspace-in-use/locked-file scenarios.
  - [ ] Subtask 1.5: Preserve workspace selection and routing state after create/open/delete (no unexpected navigation).
- [ ] Task 2: Workspace lifecycle services (AC: 1, 2, 3)
  - [ ] Subtask 2.1: Implement create/open/delete in `R/services/workspace_service.R` (or equivalent), delegating all file IO to persistence.
  - [ ] Subtask 2.2: Validate workspace manifests via persistence helpers (reuse project/manifest validation patterns from Story 1.2/1.3).
  - [ ] Subtask 2.3: On create, atomically write workspace manifest and update project manifest only after workspace persistence succeeds.
  - [ ] Subtask 2.4: On delete, remove workspace folder recursively and update project manifest only after delete succeeds; if delete fails, leave registry unchanged.
  - [ ] Subtask 2.5: On open, set active workspace in session state only after manifest validation and successful load.
  - [ ] Subtask 2.6: Update recent-workspaces list only after successful persistence and active workspace changes.
- [ ] Task 3: Persistence + path resolution (AC: 1, 2, 3)
  - [ ] Subtask 3.1: Use `R/persistence/path_resolver.R` for all workspace paths; no hard-coded or CWD-relative paths.
  - [ ] Subtask 3.2: Extend `R/persistence/workspace_manifest.R` for manifest create/read/validate as needed.
  - [ ] Subtask 3.3: Ensure crash-safe writes for manifest updates (temp + rename in same directory).
- [ ] Task 4: Tests (AC: 1, 2, 3)
  - [ ] Subtask 4.1: testthat coverage for workspace create: manifest + registry updates, failure leaves state intact.
  - [ ] Subtask 4.2: testthat coverage for open: invalid/missing manifest blocks open with actionable error.
  - [ ] Subtask 4.3: testthat coverage for delete: explicit confirmation required; failure leaves workspace listed.
  - [ ] Subtask 4.4: testthat coverage for active workspace changes only after successful open/delete.

## Dev Notes

### Developer Context

- Workspace lifecycle is part of the authoritative project registry; project manifest is the single source of truth. [Source: docs/architecture.md#Data Architecture]
- No silent data loss; destructive actions require explicit confirmation and must be crash-safe. [Source: docs/prd.md#Reliability]
- UI state is derived; core logic must remain headless and callable without UI. [Source: docs/project-context.md#Framework-Specific Rules]

### Technical Requirements

- All file paths must go through `R/persistence/path_resolver.R`. [Source: docs/project-context.md#Language-Specific Rules]
- Use atomic writes for manifest updates (temp + rename in same directory). [Source: docs/architecture.md#Core Architectural Decisions]
- Do not update `renv.lock` or add dependencies for this story. [Source: docs/project-context.md#Development Workflow Rules]
- Workspace create/open/delete should reuse project manifest validation patterns from Story 1.2/1.3. [Source: docs/implementation-artifacts/1-2-create-and-open-project-with-manifest.md]

### Architecture Compliance

- Modules in `R/modules/` must not perform file IO; delegate to services + persistence. [Source: docs/project-context.md#Framework-Specific Rules]
- Persistence for manifests and workspace folders lives in `R/persistence/`. [Source: docs/architecture.md#Architectural Boundaries]
- Services orchestrate domain + persistence; keep ownership boundaries intact. [Source: docs/architecture.md#Data Architecture]

### UX Requirements

- Provide explicit confirmation copy for destructive actions; include workspace name and path. [Source: docs/ux-design-specification.md#Feedback Patterns]
- Actionable validation errors must block destructive actions and explain next steps. [Source: docs/prd.md#Reliability]
- One primary action visible at a time; destructive actions are never primary. [Source: docs/ux-design-specification.md#Button Hierarchy]
- Error UX must cover locked-file or workspace-in-use cases with a clear retry path. [Source: docs/prd.md#Reliability]

### File Structure Requirements

- Service: `R/services/workspace_service.R` (create/open/delete orchestration). [Source: docs/architecture.md#Project Structure & Boundaries]
- Persistence: `R/persistence/path_resolver.R`, `R/persistence/project_manifest.R`, `R/persistence/workspace_manifest.R`. [Source: docs/architecture.md#Project Structure & Boundaries]
- UI: `R/modules/project_dashboard/` for workspace actions and confirmation modal. [Source: docs/architecture.md#Project Structure & Boundaries]
- Tests: `tests/testthat/` for headless lifecycle coverage. [Source: docs/project-context.md#Testing Rules]

### Testing Requirements

- Use testthat for deterministic workspace lifecycle tests; clean up temp folders. [Source: docs/project-context.md#Testing Rules]
- Keep shinytest2 coverage minimal and gated. [Source: docs/project-context.md#Testing Rules]

### Project Structure Notes

- Workspace folder is a subfolder of the project; manifest updates must be atomic and ordered (workspace first, project registry second). [Source: docs/architecture.md#Persistence Boundaries]
- Active workspace changes only after successful open/delete; UI reflects authoritative state and preserves current navigation/selection. [Source: docs/project-context.md#Framework-Specific Rules]

### Previous Story Intelligence

- Story 1.3 established explicit confirmation patterns and deletion error handling; mirror the same guardrails for workspace deletion. [Source: docs/implementation-artifacts/1-3-delete-project-with-explicit-confirmation.md]
- Story 1.2 established manifest validation and path resolver usage; reuse those helpers. [Source: docs/implementation-artifacts/1-2-create-and-open-project-with-manifest.md]

### Git Intelligence Summary

- Recent commits established golem scaffold, module/persistence/service boundaries, and test harness; align new workspace lifecycle code to these paths. [Source: git log]

### Latest Tech Information

- No web research required for this story; rely on architecture-pinned stack and avoid dependency updates. [Source: docs/architecture.md#Dependency Sourcing Notes]

### References

- Story requirements and ACs: [Source: docs/epics.md#Story 1.4: Create, Open, and Delete Workspaces]
- Project reliability and destructive action safety: [Source: docs/prd.md#Reliability]
- UX confirmation and button hierarchy: [Source: docs/ux-design-specification.md#Feedback Patterns]
- Architecture boundaries and persistence rules: [Source: docs/architecture.md#Architectural Boundaries]

## Dev Agent Record

### Agent Model Used

Codex (GPT-5)

### Debug Log References

### Completion Notes List

### File List
