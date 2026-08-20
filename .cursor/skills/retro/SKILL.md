---
name: retro
description: >-
  Summarizes parent-issue event comments into friction, permission
  requests, and loop-improvement GitHub Issues. Use after merge to
  default, or when the user asks to retrospect a loop.
disable-model-invocation: true
---

# retro

着手前に [../protocol/reference.md](../protocol/reference.md) を読む。プロダクト機能の新 Issue は作らない（ループ改善だけ）。

## 手順

1. 親 `#番号`（無ければ最近 `done` の `loop`、複数なら聞く）。
2. 親のコメントから `## イベント` を集める。`kind` 集合外は無視。
3. 特に `permission`、`acceptance.fail`、`implement.retry`、`ci.timeout`、`integrate.blocked`、`review.findings` を要約する。
4. 改善提案を **GitHub Issue** にする（ラベルは付けない。消費側のトリアージに任せる）。本文に親ループへのリンク、根拠イベント、提案する ADR の下書き（状態 `proposed`）。
5. 親に `kind: retro.proposed`（note に改善 Issue 番号）。
6. 人間に `/accept-adr` で `docs/adr/` へ落とすか聞く。承認前に ADR ファイルを `accepted` で書かない。
