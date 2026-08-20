---
name: setup-agent-workflow
description: >-
  Installs agent-workflow labels, the parent Issue template, and docs/adr
  into a consuming GitHub repository. Use when onboarding a repo, first
  run of /dev-loop, or the user asks to setup agent-workflow.
disable-model-invocation: true
---

# setup-agent-workflow

着手前に [../protocol/reference.md](../protocol/reference.md) を読む。秘密情報・既存 CI・CODEOWNERS・既存 README は触らない。

## 手順

1. `gh repo view` でカレントが GitHub リポジトリか確認。だめなら止める。
2. 次を **作ってよいか** 人間に確認してから書く。既存の同名があれば **上書きせず報告して止める**（その項目だけスキップしてよいか聞く）。
3. ラベル（無ければ作成。`--force` で色だけ合わせるのは、同名ラベルが既にあるとき人間が OK した場合のみ）:

   | 名前                | 説明                                  |
   | ------------------- | ------------------------------------- |
   | `loop`              | 親 Issue（仕様の正本）                |
   | `slice`             | 縦スライスのサブ Issue                |
   | `blocked`           | 未解決の Blocked-by                   |
   | `acceptance-failed` | Acceptance / CI が 1 リトライ後も未達 |
   | `security-blocker`  | High/Critical 未解消                  |

4. `docs/adr/README.md` が無ければ [templates/adr-readme.md](templates/adr-readme.md) をコピー。
5. `.github/ISSUE_TEMPLATE/loop.md` が無ければ [templates/loop.md](templates/loop.md) をコピー。
6. `AGENTS.md` が **ある** 場合のみ、[templates/agents-snippet.md](templates/agents-snippet.md) を追記してよいか確認してから追記。無ければ作らない。
7. 結果を一覧する（作った / スキップした / 既存）。

`gh label create <name> --description "..." --color "0E8A16"` が既に存在で失敗したら、既存として報告する。
