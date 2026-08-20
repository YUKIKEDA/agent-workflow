---
name: security-review
description: >-
  Reviews the loop-branch diff for secrets, injection, authorization,
  path traversal, and dependency risk. High and Critical block merge to
  default. Use in parallel with human intent review at gate 2, or when
  the user asks for a vulnerability check on the loop.
disable-model-invocation: true
---

# security-review

着手前に [../protocol/reference.md](../protocol/reference.md) を読む。**PoC・攻撃手順・exploit は書かない。** 修正方針と防御だけ。

## 対象

ループブランチ `loop/#<親>` とデフォルトブランチの差分（`git diff origin/<default>...origin/loop/#親`）。リポジトリ全体の pentest はしない。

## 見るもの

秘密情報漏れ、注入、認可の抜け、パストラバーサル、変更した依存関係の明らかな危険。

## 出力

親 Issue コメント:

```markdown
## イベント
- kind: security.findings
- issue: #<親>
- result: ok | blocker
- note: 指摘一覧（severity / 箇所 / 修正方針）。無ければ「指摘なし」
```

各指摘: `Critical` / `High` / `Medium` / `Low`。`Critical` または `High` が未修正ならラベル `security-blocker`（`result: blocker`）。Medium 以下はブロッカーにしない。

waiver できるのはゲート②の人間だけ。人間が「これは waiver」と言った項目は note に残し、ブロッカーから外してよいか確認してから `security-blocker` を外す。
