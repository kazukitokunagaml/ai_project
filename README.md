# ai_project
AIの利用環境をすぐに作れるようにするためのリポジトリ

## セットアップ

クローン後に一度だけ実行する:

```bash
pip install pre-commit
git config core.hooksPath .githooks
```

これで `master.md` / `rules.md` を編集してコミットするたびに、
各 AI エージェント向けのファイルへ自動同期される。
