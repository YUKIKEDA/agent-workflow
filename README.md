# agent-workflow

日本語 | [English](#english)

Cursor 向けの **開発ループ用 Agent Skills** パック。壁打ち → 親 Issue レビュー → 縦スライス分割 → 並列実装 → 人間の意図確認と脆弱性チェック → 振り返り ADR、を標準化する。

モデル名は固定しない。司令塔は `/dev-loop`。各工程は単体でも呼べる。

## インストール（v1）

1. このリポジトリの `skills/` 配下を、消費プロジェクトの `.cursor/skills/` にコピーする。
2. 消費プロジェクトで `/setup-agent-workflow` を一度回す（ラベル、Issue テンプレ、`docs/adr/`）。
3. `/dev-loop` を開始する。

`npx skills add` 用の CLI はまだ無い。パスは `skills/<name>/SKILL.md` なので、後からインストーラを足しても正本は変わらない。

このリポジトリで dogfood するときは、`skills/` を直したあと:

```powershell
.\scripts\sync-cursor-skills.ps1
```

`.cursor/skills/powershell-git` は工程外の補助で、このスクリプトは上書きしない。

## スキル

| 呼び出し                | 役割                                        |
| ----------------------- | ------------------------------------------- |
| `/setup-agent-workflow` | 導入                                        |
| `/grill-me`             | 壁打ち                                      |
| `/to-parent-issue`      | 親 Issue                                    |
| `/plan-review`          | 親のレビュー                                |
| `/split-issues`         | 分割 + ループブランチ（ゲート①のあと）      |
| `/dev-loop`             | 標準ルート                                  |
| `/implement`            | サブ 1 本                                   |
| `/integrate`            | ループ → デフォルトブランチの PR（ゲート②） |
| `/security-review`      | 差分の脆弱性                                |
| `/retro`                | イベントから改善 Issue                      |
| `/accept-adr`           | ADR を accepted                             |
| `acceptance-check`      | サブ PR の完了判定（工程から呼ばれる）      |

規約の正本: [`skills/protocol/reference.md`](skills/protocol/reference.md)

## 人間ゲート

1. サブ Issue 分割の承認
2. ループ PR をデフォルトブランチへ入れる承認（意図確認）。脆弱性の High/Critical もここでブロック。明示の「マージしてよい」のあとエージェントがマージしてよい。

ADR 承認はマージと独立。

## ライセンス

MIT

---

## English

Agent Skills that standardize a development loop: grill → parent GitHub Issue → review → vertical-slice split → parallel implement → human intent check + security review → retro ADR.

No pinned models. `/dev-loop` is the recommended path; every stage is also callable on its own.

**Install (v1):** copy `skills/` into the consuming repo’s `.cursor/skills/`, run `/setup-agent-workflow` once, then `/dev-loop`.

Canonical protocol: [`skills/protocol/reference.md`](skills/protocol/reference.md). License: MIT.
