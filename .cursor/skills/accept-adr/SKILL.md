---
name: accept-adr
description: >-
  Writes an accepted loop-improvement ADR under docs/adr after the human
  approves a retro proposal. Use when the user accepts an ADR, says to
  record the loop decision, or finishes retro with approval.
disable-model-invocation: true
---

# accept-adr

着手前に [../protocol/reference.md](../protocol/reference.md) を読む。人間の承認がこのセッションに無ければ書かない。

## 手順

1. 対象の改善 Issue（と親ループ）を読む。
2. `docs/adr/` の既存 `NNNN-*.md` の最大番号 + 1。無ければ `0001`。
3. `docs/adr/NNNN-slug.md` を書く:

```markdown
# <題>

- 状態: accepted
- 日付: <今日>
- 元 Issue: #<改善Issue>

## 文脈

## 決定

## 結果
```

4. 改善 Issue をクローズしてよいなら、人間に確認してからクローズ。
5. 親ループがまだ open / 特定できるなら `kind: adr.accepted`。親が `done` で閉じ済みでもコメント可。
