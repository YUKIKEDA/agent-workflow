---
name: implement
description: >-
  Implements one vertical-slice GitHub Issue on a branch targeting the
  loop branch, opens a PR, and runs acceptance-check. Use when the user
  names a slice Issue or /dev-loop launches a sub-issue.
disable-model-invocation: true
---

# implement

着手前に [../protocol/reference.md](../protocol/reference.md) と [../acceptance-check/SKILL.md](../acceptance-check/SKILL.md) を読む。

## 前提（欠けたら拒否）

- 対象は `slice`
- 親の状態が `implementing`
- ラベル `blocked` が無い（Blocked-by が未解決なら拒否）
- ループブランチ `loop/#<親>` が remote にある

## 手順

1. 親に `kind: implement.start`（`issue: #子`）。
2. デフォルトではなく **ループブランチ** からサブ枝:

   ```powershell
   git fetch origin
   git checkout "loop/#<親>"
   git pull
   git checkout -b "loop/#<親>/#<子>"
   ```

3. そのスライスの Acceptance だけを実装する。親の他スライスや非ゴールに手を出さない。
4. 消費リポジトリにコミット規約があれば従う。無ければ Conventional Commits（`type(scope): subject`、subject は日本語可）。
5. push し、PR の base は `"loop/#<親>"`:

   ```powershell
   git push -u origin "loop/#<親>/#<子>"
   gh pr create --base "loop/#<親>" --head "loop/#<親>/#<子>" --title "..." --body-file <file>
   ```

   PR 本文に `Closes #子` は **付けない**（デフォルトブランチへ閉じない）。`Slice: #子` / `Parent: #親` を書く。
6. Checks がある PR は **acceptance-check の前に** 緑を待つ（30 秒 × 最大 10）。pending は待つ。完了して失敗なら Checks 失敗（手順 7 の再実行対象）。超えてまだ pending なら `ci.timeout`、未マージで終了（`acceptance-failed` にしない）。
7. [acceptance-check](../acceptance-check/SKILL.md) を実行する。Acceptance または完了済み Checks の失敗なら手順 3–7 を **同じサブで 1 回だけ** 繰り返し、親に `implement.retry`。それでもだめならマージせず `acceptance-failed`、`acceptance.fail`、終了（他スライスは止めない）。
8. 通過したらループブランチへマージ（`gh pr merge --merge`。リポジトリが squash 必須ならそれに合わせる）。親に `pr.merged`。子の `acceptance-failed` は外す。親チェックリストがあれば `[x]`。
9. 権限が要れば止めて `permission`。
