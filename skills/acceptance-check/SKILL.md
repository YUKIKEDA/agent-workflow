---
name: acceptance-check
description: >-
  Checks a slice pull request against the sub-issue Acceptance checklist
  and required GitHub Checks. Use after implement opens a PR, on retry,
  or when judging whether a slice may merge into the loop branch.
---

# acceptance-check

着手前に [../protocol/reference.md](../protocol/reference.md) を読む。攻撃手順は書かない。

## 入力

- サブ Issue 番号
- その PR（head が `loop/#親/#子`）

## 判定

1. サブ本文の `## Acceptance` を項目ごとに、PR 差分と（あれば）テストで照合する。曖昧な項目は未達。
2. `gh pr checks <PR>`。チェックが 1 件以上あれば全て成功が必須。0 件ならスキップ。
3. 親の非ゴールを侵していないか（やりすぎ）。

## 出力（チャットと親コメント）

```markdown
## イベント
- kind: acceptance.pass
- issue: #<子>
- result: ok
- note: 満たした項目の要約
```

未達時は `kind: acceptance.fail`、`result: fail`、`note` に **未達の Acceptance 項目** を列挙。呼び出し元（`implement`）が 1 リトライを担当する。このスキルはマージしない。
