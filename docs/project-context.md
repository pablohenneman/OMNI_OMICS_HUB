---
project_name: 'OMNI_OMICS_HUB'
user_name: 'Pablo'
date: '2025-12-27'
sections_completed: ['technology_stack', 'language_rules', 'framework_rules', 'testing_rules', 'quality_rules', 'workflow_rules', 'anti_patterns']
existing_patterns_found: 0
---
status: 'complete'
rule_count: 37
optimized_for_llm: true


# Project Context for AI Agents

_This file contains critical rules and patterns that AI agents must follow when implementing code in this project. Focus on unobvious details that agents might otherwise miss._

---

## Technology Stack & Versions

- Runtime: R + Shiny (golem scaffolding); UI theming via bslib + bsicons.
- Tables: reactable default; DT only for heavy interaction/editing (e.g., Sample Metadata Builder).
- Visualization: ggplot2; ComplexHeatmap + InteractiveComplexHeatmap; optional plotly.
- Preprocessing adapters: Seurat-inspired workflows; DEP2/ vsn as needed.
- Async: future + promises (use only when explicitly required).
- Testing: testthat (mandatory headless tests); shinytest2 (small set of gated e2e flows).
- Dependency management: renv is authoritative; versions listed in architecture are informational only.
- DEP2: expected GitHub/Bioc-devel–adjacent source; confirm and pin via renv before final lock.
## Critical Implementation Rules

### Language-Specific Rules

- Use `snake_case` for functions/variables; S4 classes stay `OmicsProject`, `OmicsWorkspace`, `OmicsDataset`.
- All file paths must go through the path resolver in `R/persistence/`; no hard-coded or CWD-relative paths.
- State changes must occur only via explicit Apply/Run/Save actions; UI is never authoritative.
- Commit boundary: mark step completion only after state + provenance are durably written.
- Preprocessing may mutate only the active dataset; configured dataset is never modified (reconstruct as needed).

### Framework-Specific Rules

- Use golem module structure; UI logic stays in `R/modules/` only.
- Modules must not perform file IO; persistence lives in `R/persistence/`.
- Workspace nav and stepper are reusable modules driven by workspace state; they never override state.
- Resume behavior: Configuration/Preprocessing routes to active step if incomplete, latest completed if finished.

### Testing Rules

- testthat is mandatory for headless domain logic (state transitions, preprocessing, mapping, persistence).
- shinytest2 is limited to a small number of deterministic end-to-end flows; may be gated/skipped for runtime.
- Prefer deterministic “golden” datasets for any integration/UI tests.

### Code Quality & Style Rules

- Keep domain/state/persistence/provenance boundaries explicit; avoid cross-layer shortcuts.
- Logging is a utility (`R/utils/logging.R`) and must not be used for replay or state reconstruction.
- Provenance is authoritative and immutable once committed; one entry per state-changing action.

### Development Workflow Rules

- renv.lock updates are explicit and only on request/approval, not as side effects of experimentation.
- Use project/workspace manifests and path resolver for all persistence; no ad-hoc paths.

### Critical Don't-Miss Rules

- No implicit recomputation or background execution in V1.
- No silent mutations of workflow state or dataset state.
- Step completion only after persistence + provenance commit succeeds.
- Use step/substep IDs `{phase}.{step_order}.{short_name}` consistently in provenance/logging.
---

## Usage Guidelines

**For AI Agents:**

- Read this file before implementing any code
- Follow ALL rules exactly as documented
- When in doubt, prefer the more restrictive option
- Update this file if new patterns emerge

**For Humans:**

- Keep this file lean and focused on agent needs
- Update when technology stack changes
- Review quarterly for outdated rules
- Remove rules that become obvious over time

Last Updated: 2025-12-27

