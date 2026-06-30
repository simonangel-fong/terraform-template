# Repo Structure

Reference for the `tf-module` skill. Modules live under `<cloud>/<name>/`.

```
.
├── .claude/skills/         # Skills (tf-module, etc.)
├── .github/                # GitHub Actions workflows
├── docs/
│   ├── guardrail.md        # Module authoring rules (source of truth)
│   ├── repo.md             # This file
│   └── workflow.md         # Local validate / test / docs commands
├── aws/<module>/           # AWS modules
├── azure/<module>/         # Azure modules (e.g. azure/aks/ — canonical example)
├── gcp/<module>/           # GCP modules
├── CONTRIBUTING.md
├── LICENSE
└── README.md               # Top-level module index
```

For the module directory layout and file rules, see [guardrail.md](./guardrail.md). Canonical example: [azure/aks/](../azure/aks/).
