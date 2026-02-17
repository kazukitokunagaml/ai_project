# Project Rules

このファイルには **AIが既に知っている一般常識ではなく、本プロジェクト固有の判断** を記載する。
一般的なベストプラクティス（命名規約、SOLID原則、セキュリティ基本等）は記載しない。AIは既知のものとして振る舞え。

---

## Python 固有の選択

- データ構造の定義には `pydantic.BaseModel` を優先せよ（`dataclass` より先に検討）
- パス操作は `pathlib.Path` 統一。`os.path` は使わない
- HTTP クライアントは `httpx`。`requests` は使わない
- 型ヒントは必須。`Any` は原則禁止

## テスト

- バグ修正は必ず「再現テスト → 修正 → テストパス」の順で行え
- 外部依存のモックには `pytest-mock` を使え
- テストファイルは `tests/` に配置、`test_` プレフィックス

## Git

- コミットメッセージは Conventional Commits 形式: `feat|fix|docs|refactor|test|chore(scope): description`
- 1コミット = 1つの論理的変更

## ディレクトリ構成

```
src/
  app/
    main.py          # エントリポイント
    models/          # データモデル
    services/        # ビジネスロジック
    api/             # API エンドポイント
tests/
```

構成が変わったらこのセクションを更新すること。

## HANDOFF.md のフォーマット

セッション引き継ぎ時に作成する `HANDOFF.md` は以下の構成とせよ:

```markdown
# Session Handoff

## 現在の状況
（何をしていたか、どこまで完了したか）

## 未完了タスク
- [ ] タスク1
- [ ] タスク2

## 注意事項
（次のセッションで気をつけるべきこと、ハマりポイント等）

## 関連ファイル
（変更中・参照すべきファイルパス）
```
