---
name: plan-review
description: >-
  Reviews a parent loop Issue for empty open questions, testable
  Acceptance, missing non-goals, and split-readiness. Use after
  to-parent-issue, before split-issues, or when the user asks to review
  the spec Issue.
disable-model-invocation: true
---

# plan-review

着手前に [../protocol/reference.md](../protocol/reference.md) を読む。対象は親 Issue（`loop`）。チャットの壁打ちメモは正本にしない。

## 手順

1. 引数 `#番号` が無ければ、open の `loop` で状態 `parent-created` または `in-review` を探す。複数なら聞く。
2. 状態を `in-review` に更新する。
3. 次を見る。指摘は **親への Issue コメント** にする（チャットだけにしない）。

   - `## 未決` が空か
   - Acceptance が検証可能か（観測できる失敗条件があるか）
   - 非ゴール漏れ（やりすぎそうな範囲）
   - 制約と決定済みの矛盾
   - このまま縦スライスに落とせるか（1 Issue に複数プロダクトが混ざっていないか）

4. 不合格: コメントに修正要求。状態は `in-review` のまま。`kind: review.findings`。親本文を直すのは人間か、人間が「直して」と言ったあと。
5. 合格: `kind: review.passed`。状態を `awaiting-split` にする。チャットで **ゲート①**（「この分解に進んでよいか / 分割してよいか」）を待つ。`split-issues` は承認前に走らせない。
