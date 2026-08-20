---
name: split-issues
description: >-
  Splits a reviewed parent Issue into vertical-slice sub-issues with
  blocking edges, then creates the loop branch after human gate 1.
  Use when the user approves the split or the parent is awaiting-split.
disable-model-invocation: true
---

# split-issues

着手前に [../protocol/reference.md](../protocol/reference.md) を読む。

## 前提

- 親の状態が `awaiting-split`
- 人間がこのセッションで分割を承認している（「分割してよい」相当）
- `## 未決` が空
- 親 Acceptance をサブの和で覆える

どれか欠ければ拒否し、理由を書く。状態は進めない。

## 手順

1. 縦スライスに切る。層（DB/API/UI）やファイル単位で切らない。各サブに検証可能な Acceptance、`Blocked-by` / `Blocks`。
2. 各サブを `gh issue create --label slice --body-file`。本文はプロトコルのサブ必須セクション。
3. 親子:

   ```text
   childId=$(gh api repos/OWNER/REPO/issues/CHILD --jq .id)
   gh api repos/OWNER/REPO/issues/PARENT/sub_issues -f sub_issue_id="$childId"
   ```

   PowerShell では `gh api ... --jq .id` の結果を変数に入れ、失敗したらフォールバック: 子本文 `Parent: #親`、親 `## スライス` に `- [ ] #子 タイトル`。
4. `Blocked-by` が未解決なら子に `blocked`。
5. デフォルトブランチからループブランチを切って push:

   ```powershell
   $base = gh repo view --json defaultBranchRef --jq .defaultBranchRef.name
   git fetch origin
   git checkout $base
   git pull
   git checkout -b "loop/#<親>"
   git push -u origin "loop/#<親>"
   ```

6. 状態を `implementing`。イベント `split.approved` と `loop.branch`（note にブランチ名）。
7. 次は `/dev-loop #<親>` または未ブロックな `/implement #子`。
