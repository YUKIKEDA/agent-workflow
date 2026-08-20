---
name: integrate
description: >-
  Opens the gate-2 PR from the loop branch to the default branch when
  every in-scope slice is merged, or blocks until the human cuts scope.
  Use when implementation is done, the parent is awaiting-main and the
  human approved merge, the user asks to integrate, or /dev-loop
  reaches the merge gate.
disable-model-invocation: true
---

# integrate

着手前に [../protocol/reference.md](../protocol/reference.md) を読む。

## 前提

親状態は `implementing`、`awaiting-scope-cut`、または `awaiting-main`。デフォルトブランチへ勝手にマージしない。

## スコープ内スライス

親に紐づく `slice` のうち、**スコープ内**だけをループブランチへ入れる必須とする。

スコープ外（落とす）:

- 親の `## 非ゴール` に移され、閉じ済みのサブ
- `kind: scope.cut` の `note` に除外した番号

これらはループブランチに入っていなくてよい。open のままのサブは、未マージならブロッカーのまま（黙って落とさない）。

## 手順

状態が `awaiting-main` で、ゲート② PR（`loop/#親` → デフォルトブランチ）が既にあれば、手順 1–3 はスキップして 4 以降へ。PR が消えていたら 1 からやり直す。

1. 親に紐づく `slice` を列挙（ネイティブ Sub-issues、だめなら `## スライス` と `Parent: #親` 検索）。スコープ内 / スコープ外に分ける。
2. **スコープ内で未マージ**が 1 件でもあれば PR を出さない。状態 `awaiting-scope-cut`、`kind: integrate.blocked`、未達一覧を `note` に書く。人間が非ゴールへ移しサブを閉じるまで待つ。閉じたら `scope.cut`（`note` に落とした `#`）を書いてからやり直す。
3. スコープ内がすべてループブランチに入っていれば、`loop/#親` → デフォルトブランチの PR を作る（無ければ）。本文に親 URL、入ったスライス、スコープ外（閉じた）スライス、Acceptance の残り。
4. 状態を `awaiting-main`。チャットで **ゲート②**: コードの意図確認と「マージしてよい」。並行して `/security-review #<親>` を走らせる（まだなら）。
5. `security-blocker` が残っていたらマージしない。
6. 人間が「マージしてよい」と言ったら `gh pr merge`。状態 `done`、`kind: merge.main`。
7. 人間が GitHub 上で先にマージしていたら、状態とイベントだけ合わせる。
