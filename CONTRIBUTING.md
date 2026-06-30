# Contributing

Thanks for your interest. This repo publishes reusable Terraform modules under `aws/`, `azure/`, and `gcp/`. Each module is consumed by tag, so backward compatibility matters.

## Documentation map

Don't duplicate rules here — read these:

- [docs/repo.md](docs/repo.md) — where things live in this repo.
- [docs/guardrail.md](docs/guardrail.md) — module authoring rules (file layout, naming, variables, outputs, state). **Source of truth.**
- [docs/qa.md](docs/qa.md) — local commands to validate, test, and regenerate docs.
- [azure/aks/](azure/aks/) — canonical module example.

## Branch model

- **`master`** — release branch. Tagged versions live here. Direct pushes are blocked; updates land via PR from `dev`.
- **`dev`** — integration branch. Feature branches PR into `dev`.
- **Feature branches** — `feat/<short-name>`, `fix/<short-name>`, `docs/<short-name>`. Branch from `dev`.

## Workflow

1. Branch from `dev`.
2. Make changes following [docs/guardrail.md](docs/guardrail.md).
3. Run the [local checks](#local-checks-before-opening-a-pr) below.
4. Open a PR into `dev`. All CI checks must pass.
5. Maintainers cut a release by PR'ing `dev` → `master` and tagging.

## Local checks before opening a PR

See [docs/qa.md](docs/qa.md) for the full command reference. At minimum, from the module directory:

```sh
terraform fmt -recursive -diff
terraform init -backend=false
terraform validate
terraform test -verbose
tflint --recursive
terraform-docs .
```

If `terraform-docs .` produces a diff, commit the regenerated `README.md`.

## Required CI checks

PRs cannot merge until these pass:

- `fmt` — repo-wide format check
- `validate` — per module
- `test` — per module that has `tests/*.tftest.hcl`
- `tflint` — per module
- `docs` — per module (fails if `README.md` is out of date)

## Versioning

Tag releases on `master` as `vMAJOR.MINOR.PATCH` (semver):

- **MAJOR** — breaking input/output rename or removal, removed resource, raised Terraform/provider floor.
- **MINOR** — new optional input, new output, new resource.
- **PATCH** — bug fix, doc fix, internal cleanup.

Modules are consumed by tag, never by branch:

```hcl
source = "git::https://github.com/simonangel-fong/terraform-template.git//<cloud>/<module>?ref=v1.0.0"
```

## License

By contributing, you agree your contribution is licensed under the repository's [LICENSE](LICENSE).
