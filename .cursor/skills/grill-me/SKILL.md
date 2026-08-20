---
name: grill-me
description: >-
  Interview the user relentlessly about a plan or design until reaching
  shared understanding, resolving each branch of the decision tree. Use
  when the user wants to stress-test a plan, get grilled on their design,
  mentions grill me, or starts /dev-loop with no in-progress parent Issue.
disable-model-invocation: true
---

# grill-me

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time.

If a question can be answered by exploring the codebase, explore the codebase instead.

## 出口（agent-workflow）

合意が閉じたら、要約をチャットに出す（ゴール / 非ゴール / 制約 / Acceptance / 決定済み / 未決は空）。

そのあと [../to-parent-issue/SKILL.md](../to-parent-issue/SKILL.md) に従い親 Issue を作る。まだ作らないなら、人間に「親 Issue を作るか」だけ確認する。
