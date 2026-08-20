# agent-workflow プロトコル

全工程スキルは、着手前にこのファイルを読む。モデル名は書かない。自由な状態値・`kind` は禁止。

## 用語

| 用語                  | 意味                                                   |
| --------------------- | ------------------------------------------------------ |
| 親 Issue              | 仕様の正本。ラベル `loop`                              |
| サブ Issue / スライス | 縦スライス。ラベル `slice`                             |
| ループブランチ        | `loop/#<親番号>`（引用必須）                           |
| サブ枝                | `loop/#<親番号>/#<子番号>`（引用必須）                 |
| ゲート①               | 人間が分割を承認する                                   |
| ゲート②               | 人間がループ PR の意図を確認し「マージしてよい」と言う |

## 親 Issue 必須セクション

```markdown
## ゴール

## 非ゴール

## 制約

## Acceptance

- [ ] 検証可能な条件

## 決定済み事項

## 未決

## ループ状態
parent-created

## スライス
```

分割前に `## 未決` は空（項目なし、または「なし」のみ）。

## ループ状態（この 7 値のみ）

遷移のスキップは禁止。

| 値                   | 意味                                                    |
| -------------------- | ------------------------------------------------------- |
| `parent-created`     | 親あり、レビュー前                                      |
| `in-review`          | plan-review 中、または指摘対応中                        |
| `awaiting-split`     | レビュー通過、ゲート①待ち                               |
| `implementing`       | ループブランチあり、サブ実装中                          |
| `awaiting-main`      | スコープ内のサブがループブランチ入り、ゲート②の PR あり |
| `done`               | デフォルトブランチへマージ済み                          |
| `awaiting-scope-cut` | 未達サブあり、integrate 不可                            |

壁打ち中は親が無い。`## ループ状態` はまだ存在しない。

単体 `/implement` でも、状態が `implementing` でなければ拒否し、ゲート①を要求する。

## サブ Issue 必須セクション

```markdown
## スライスゴール

## 非ゴール

## Acceptance

- [ ] 検証可能な条件

## 依存
- Parent: #<親>
- Blocked-by:
- Blocks:

## 範囲（任意）
触る目安のパス。必須ではない。
```

親の Acceptance はサブの和で覆う。覆えない項目がある分割は不合格。
`Blocked-by` が未解決ならラベル `blocked`。解決したら外す。

## 親子の結び

1. GitHub ネイティブ Sub-issues を試す。子作成後、子の REST `id` を取り、親に `POST .../issues/<親number>/sub_issues`（`sub_issue_id`）。
2. 失敗したら本文規約: 子に `Parent: #<親>`、親の `## スライス` に `- [ ] #<子> タイトル`。

## ラベル

setup が作る。状態機械には使わない。

| ラベル              | 対象                              |
| ------------------- | --------------------------------- |
| `loop`              | 親                                |
| `slice`             | 子                                |
| `blocked`           | 未解決の Blocked-by               |
| `acceptance-failed` | 1 リトライ後も未達                |
| `security-blocker`  | High/Critical が未解消・未 waiver |

段階は親の `## ループ状態` のみ。

## Git

- デフォルトブランチ: `gh repo view --json defaultBranchRef --jq .defaultBranchRef.name`（`main` と決めない）
- ゲート①直後: デフォルトから `loop/#<親>` を切って push。空コミット不要
- サブ PR の `--base` はループブランチ、`--head` はサブ枝
- ブランチ名の `#` はシェルでコメントになるため、**常に引用する**（例: `git diff "origin/<default>...origin/loop/#<親>"`）
- デフォルトブランチへはゲート②のあとだけ

## イベントコメント

親 Issue へ投稿する。この `kind` 以外は禁止。不足は `note` に日本語で書く。

```markdown
## イベント
- kind: parent.created
- issue: #12
- result: ok
- note: 補足
```

`kind` 集合:

`parent.created` · `review.findings` · `review.passed` · `split.approved` · `loop.branch` · `implement.start` · `implement.retry` · `acceptance.pass` · `acceptance.fail` · `ci.timeout` · `pr.merged` · `permission` · `integrate.blocked` · `scope.cut` · `security.findings` · `merge.main` · `retro.proposed` · `adr.accepted`

壁打ち完了は親作成前なので、`parent.created` の `note` に含める。

権限が必要なら作業を止め、`kind: permission` を書き、人間の承認を待つ。

## 人間ゲート

1. 分割承認（`awaiting-split` → 人間が「分割してよい」）
2. ループ PR の意図確認 + 「マージしてよい」。`security-blocker` が残っていたらマージしない

ADR 承認はマージと独立。GitHub 上で人間が先にマージしたら、状態を `done` に合わせ `merge.main` を書くだけ。

## 並列と失敗

- `/dev-loop` は `blocked` でも `acceptance-failed` でもない `slice` を最大 **3** 件まで並列起動
- Acceptance または必須 Checks の失敗: 同じサブを **1 回だけ** 再実行（`implement.retry`）。だめならマージせず `acceptance-failed`、他の未ブロックを続ける
- Checks が 1 つでもあれば緑必須。無ければ Acceptance のみ
- Checks 待ちは `acceptance-check` **より先**（目安 30 秒 × 10）。pending を `acceptance.fail` にしない。超えてまだ pending なら `ci.timeout`、未マージのまま（`acceptance-failed` にしない）
- スコープ内の未マージサブが残る間は `/integrate` は PR を出さない（状態 `awaiting-scope-cut`、`integrate.blocked`）
- 人間が未達を親の非ゴールへ移し、該当サブを閉じたら `scope.cut`。閉じたサブはループブランチに入っていなくてよい。残ったスコープ内が揃えば PR 可
- `/integrate` は `implementing` / `awaiting-scope-cut` / `awaiting-main` で開始できる。`awaiting-main` では既存のゲート② PR のマージ手順へ（作り直ししない）

## `/dev-loop` 再開

- 引数 `#番号` があればその親
- 無ければ `loop` の open のうち状態が `done` 以外を数える。1 件なら継続、0 件なら新規壁打ち、2 件以上なら番号を聞く
- チャットが切れても親 Issue がランブック

## ADR

対象は **ループ改善だけ**。プロダクト決定の正本は親 Issue。

- パス: 消費リポジトリの `docs/adr/NNNN-slug.md`
- 短い Nygard: 題 / 状態 / 日付 / 元 Issue / 文脈 / 決定 / 結果
- `proposed` → `/accept-adr` で `accepted`

## セキュリティ

対象はループブランチとデフォルトブランチの差分（`git diff "origin/<default>...origin/loop/#<親>"`。`#` を含む ref は引用する）。秘密情報、注入、認可、パストラバーサル、変更箇所の依存。High/Critical は `main` ブロッカー（`security-blocker`）。waiver はゲート②の人間だけ。攻撃手順や PoC は書かない。

## gh / シェル

本文は一時ファイル + `gh ... --body-file`。bash heredoc は使わない。PowerShell では `@{u}` を引用する。ブランチ名は引用する。
