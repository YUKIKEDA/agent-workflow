---
name: dev-loop
description: >-
  Runs the recommended agent-workflow pipeline: grill, parent Issue,
  plan review, split, parallel implement (max 3), integrate, security
  review, retro. Use when the user wants the standard development loop,
  /dev-loop, or to resume an in-progress loop Issue.
disable-model-invocation: true
---

# dev-loop

着手前に [../protocol/reference.md](../protocol/reference.md) を読む。工程の実体は各スキル。このスキルは順序とゲートと再開だけを担う。

## 初回チェック

`gh label list` に `loop` が無ければ止めて `/setup-agent-workflow` を要求する。

## 再開

1. 引数 `#番号` → その親。
2. 引数なし → `loop` かつ open、本文の状態が `done` 以外を数える。
   - 0 件: 新規。`grill-me` から。
   - 1 件: それを継続。
   - 2 件以上: 番号を聞く。

## 状態 → 次の一手（スキップ禁止）

| 状態                 | 行うこと                                                                                                                                                                       |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| （親なし）           | [grill-me](../grill-me/SKILL.md) → [to-parent-issue](../to-parent-issue/SKILL.md)                                                                                              |
| `parent-created`     | [plan-review](../plan-review/SKILL.md)                                                                                                                                         |
| `in-review`          | 指摘が残っていれば修正を待つ / 再レビュー。無ければ合格処理                                                                                                                    |
| `awaiting-split`     | **停止**。人間の「分割してよい」のあと [split-issues](../split-issues/SKILL.md)                                                                                                |
| `implementing`       | 下記「並列実装」                                                                                                                                                               |
| `awaiting-scope-cut` | **停止**。人間のスコープ縮小を待つ。その後 [integrate](../integrate/SKILL.md) を再実行                                                                                         |
| `awaiting-main`      | [security-review](../security-review/SKILL.md) を未実施なら並行。**停止**。人間の「マージしてよい」のあと [integrate](../integrate/SKILL.md)（`awaiting-main` ならマージ手順） |
| `done`               | [retro](../retro/SKILL.md) を提案。ADR は `/accept-adr`                                                                                                                        |

## 並列実装

未ブロックな `slice`（`blocked` なし、`acceptance-failed` なし、未マージ）を最大 **3** 件。

- Cursor のサブエージェントで [implement](../implement/SKILL.md) を Issue ごとに起動する。プロンプトに親番号・子番号・「protocol と implement を読め」を含める。
- 3 件走っている間はキュー。1 件終わったら次の未ブロックを繰り上げる（Blocked-by がマージ済みになったら `blocked` を外す）。
- サブエージェント完了後、親イベントと PR 状態を見て、必要なら acceptance-check の結果を確認する。
- スコープ内が全部マージ済み（または人間がスコープ縮小して閉じた）なら [integrate](../integrate/SKILL.md)。

単体 `/implement #子` で進んだ分も、親のイベントとチェックリストで拾う。

## やってはいけない

- モデル名で役割を固定する
- ゲート①②をエージェント判断で通過する
- 未達サブを黙って落とす
- デフォルトブランチへゲート②なしでマージする
