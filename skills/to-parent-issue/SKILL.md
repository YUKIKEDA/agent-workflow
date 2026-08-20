---
name: to-parent-issue
description: >-
  Creates the parent GitHub Issue that is the spec source of truth after
  a grilling session. Use when alignment is done, the user asks to file
  the parent issue, or /dev-loop needs a loop Issue.
disable-model-invocation: true
---

# to-parent-issue

着手前に [../protocol/reference.md](../protocol/reference.md) を読む。`loop` ラベルが無ければ `/setup-agent-workflow` を先に要求する。

## 手順

1. 壁打ちの合意を親テンプレに落とす。`## 未決` に項目が残っていれば作らず、`grill-me` に戻す。
2. Acceptance は検証可能なチェックリストにする（「ちゃんと動く」は不合格）。
3. `gh issue create --label loop --title "..." --body-file <file>`。タイトルはゴールの一行要約。
4. `## ループ状態` を `parent-created` にする（テンプレどおりならそのままでよい）。
5. 親へイベント:

```markdown
## イベント
- kind: parent.created
- issue: #<番号>
- result: ok
- note: 壁打ち完了。レビューは /plan-review
```

6. 人間に URL を渡し、次は `/plan-review #<番号>`（または `/dev-loop` 継続）。
