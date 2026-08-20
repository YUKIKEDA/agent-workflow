---
name: integrate
description: >-
  Opens the gate-2 PR from the loop branch to the default branch when
  every slice is merged, or blocks until the human cuts scope. Use when
  implementation is done, the user asks to integrate, or /dev-loop
  reaches the merge gate.
disable-model-invocation: true
---

# integrate

着手前に [../protocol/reference.md](../protocol/reference.md) を読む。

## 前提

親状態 `implementing` または `awaiting-scope-cut`。デフォルトブランチへ勝手にマージしない。

## 手順

1. 親に紐づく `slice` を列挙（ネイティブ Sub-issues、だめなら `## スライス` と `Parent: #親` 検索）。
2. **未マージのサブが 1 件でもあれば** PR を出さない。状態 `awaiting-scope-cut`、`kind: integrate.blocked`、未達一覧を `note` に書く。人間が非ゴールへ移しサブを閉じるまで待つ。閉じたら `scope.cut` を書いてからやり直す。
3. 全サブがループブランチに入っていれば、`loop/#親` → デフォルトブランチの PR を作る（無ければ）。本文に親 URL、スライス一覧、Acceptance の残り。
4. 状態を `awaiting-main`。チャットで **ゲート②**: コードの意図確認と「マージしてよい」。並行して `/security-review #<親>` を走らせる（まだなら）。
5. `security-blocker` が残っていたらマージしない。
6. 人間が「マージしてよい」と言ったら `gh pr merge`。状態 `done`、`kind: merge.main`。
7. 人間が GitHub 上で先にマージしていたら、状態とイベントだけ合わせる。
