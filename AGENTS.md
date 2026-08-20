# AGENTS

このリポジトリは **agent-workflow** スキルパックの正本である。

- スキル正本: `skills/`
- Cursor dogfood: `.cursor/skills/`（`scripts/sync-cursor-skills.ps1` で同期。`powershell-git` は対象外）
- プロトコル: `skills/protocol/reference.md`
- コミットは Conventional Commits。PR 本文は `.github/pull_request_template.md`
- Windows では PowerShell。bash heredoc と未引用 `@{u}` は使わない
