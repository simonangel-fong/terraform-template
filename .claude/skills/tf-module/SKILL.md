---
name: tf-module
description: Scaffold a new Terraform module or refine an existing one in this repo, following docs/guardrail.md. Invoke when the user types /tf-module or asks to create, scaffold, add, edit, or refine a module under aws/, azure/, or gcp/.
---

# tf-module

Author Terraform modules in this repo that conform to the project conventions. Scope is **this repo only**.

## When to use

- User types `/tf-module`.
- User asks to create, scaffold, or add a new module.
- User asks to refine, edit, or extend an existing module under `aws/`, `azure/`, or `gcp/`.

## Inputs to collect

Before doing anything, confirm:

1. **Module name** — short noun, no provider prefix (e.g. `aks`, not `azure-aks`).
2. **Cloud** — `aws` (default), `azure`, or `gcp`. If the name implies a cloud (e.g. "AKS" → azure), confirm rather than guess.
3. **Tests** — include by default. Add `tests/basic.tftest.hcl` only if the user explicitly skips.

## Repo location

Modules live at `<cloud>/<name>/` where `<cloud>` is `aws`, `azure`, or `gcp`. See [docs/repo.md](../../../docs/repo.md) for the full repo layout.

## Authoring rules

[docs/guardrail.md](../../../docs/guardrail.md) is the source of truth for file layout, naming, variables, outputs, resources, and state. **Read it before scaffolding or editing.** Do not restate or paraphrase its rules — follow them.

Use [azure/aks/](../../../azure/aks/) as the canonical example.

## Workflow

1. **Check if the module exists** at `<cloud>/<name>/`.
   - **Does not exist** → create the directory, then go to step 2 (new module).
   - **Exists** → read every `.tf` file before editing, then go to step 3 (refine), treating the requested change as a single layer.

### New module path

2. **Plan infrastructure layers.**
   - From the user's prompt, list the layers the module needs. Keep the set **minimal** — omit auxiliary layers (logging, monitoring, diagnostics, backups) unless the user explicitly asks.
   - Order the layers from most fundamental to least (e.g. for AKS: resource group → vnet → AKS cluster → node pools).
   - **Confirm the layer list with the user before writing any code.**

### Per-layer loop (both paths)

3. **For each layer, in order, do steps 3a–3d before moving to the next layer:**

   **3a. Design the layer's parameters.**
   - List the parameters the layer needs.
   - Classify each as **input variable** (caller-controlled or environment-specific) or **local** (internal, derived, or constant within the module).
   - **Confirm the parameter split with the user before writing code.**

   **3b. Write the layer.**
   - Follow [docs/guardrail.md](../../../docs/guardrail.md) for file layout, naming, and placement.
   - Update `01_variables.tf`, `02_locals.tf`, `03_providers.tf`, `04_outputs.tf` as needed for this layer.

   **3c. Verify.**
   - Run the validate commands in [docs/qa.md](../../../docs/qa.md) (`terraform fmt`, `terraform init -backend=false`, `terraform validate`) from the module directory.
   - Fix any errors before continuing.

   **3d. Confirm with the user** that the layer is acceptable, then move to the next layer.

### Finalization

4. **Tests** — only if the user opted in during input collection. Create `tests/basic.tftest.hcl` with one `command = plan` case exercising required variables. Run `terraform test -verbose` (see [docs/qa.md](../../../docs/qa.md)).
5. **Generate `README.md`.**
   - Ensure `.terraform-docs.yml` exists in the module dir (copy from [azure/aks/.terraform-docs.yml](../../../azure/aks/.terraform-docs.yml) if missing).
   - Create `README.md` with hand-written sections (title, usage, notes) plus the inject markers `<!-- BEGIN_TF_DOCS -->` / `<!-- END_TF_DOCS -->` where the generated tables go. Use [azure/aks/README.md](../../../azure/aks/README.md) as the structural reference.
   - Run `terraform-docs .` to inject the Requirements / Providers / Resources / Inputs / Outputs tables. See [docs/qa.md](../../../docs/qa.md).
   - Do **not** hand-write the table content — terraform-docs owns everything between the markers.

## Checklist before reporting done

- [ ] [docs/guardrail.md](../../../docs/guardrail.md) was read this session
- [ ] Module lives at `<cloud>/<name>/` under the correct cloud
- [ ] QA commands from [docs/qa.md](../../../docs/qa.md) pass (`fmt`, `validate`, and `test` if opted in)
- [ ] `.terraform-docs.yml` present
- [ ] `README.md` present with inject markers, regenerated via `terraform-docs .`
- [ ] If opted in: `tests/basic.tftest.hcl` present
