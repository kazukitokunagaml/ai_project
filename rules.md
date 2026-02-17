# Coding Rules & Detailed Guidelines (詳細ルール集)

本ドキュメントは `master.md` の基本原則を補完する、具体的かつ詳細なルールを定義する。AIエージェントはこのルールに従ってコードの作成・修正を行うこと。

---

## 1. コーディング規約 (Coding Standards)

### 1.1 Python

- Python 3.12+ の構文を使用せよ
- 型ヒント (Type Hints) を必ず付与せよ。`Any` の使用は原則禁止
- f-string を文字列フォーマットの標準とせよ
- `dataclass` または `pydantic.BaseModel` をデータ構造の定義に使用せよ
- パスの操作には `pathlib.Path` を使用せよ（`os.path` は使用しない）
- 例外処理は具体的な例外クラスで捕捉せよ（裸の `except:` や `except Exception:` は禁止）

```python
# ✅ Good
def calculate_total(items: list[Item]) -> Decimal:
    return sum(item.price for item in items)

# ❌ Bad - 型ヒントなし、汎用例外
def calculate_total(items):
    try:
        return sum(item.price for item in items)
    except Exception:
        return 0
```

### 1.2 命名規約

| 対象 | 規約 | 例 |
|---|---|---|
| 変数・関数 | snake_case | `user_name`, `get_user_by_id()` |
| クラス | PascalCase | `UserService`, `HttpClient` |
| 定数 | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT`, `API_BASE_URL` |
| プライベート | 先頭アンダースコア | `_internal_cache`, `_validate()` |
| ファイル名 | snake_case | `user_service.py`, `test_auth.py` |

### 1.3 インポート順序

以下の順序でインポートを記述し、各グループ間に空行を入れよ。

1. 標準ライブラリ
2. サードパーティライブラリ
3. ローカルモジュール

```python
import os
from pathlib import Path

import httpx
from pydantic import BaseModel

from app.models import User
from app.services import UserService
```

### 1.4 関数・メソッドの設計

- 1つの関数は1つの責務のみを持つこと (Single Responsibility)
- 関数の行数は原則50行以内に収めよ
- 引数は5つ以下を目安とせよ。超える場合はデータクラスでまとめよ
- 副作用のある関数と純粋関数を明確に分離せよ
- docstring は公開API（パブリック関数・クラス）にのみ記述せよ。内部実装の自明な関数には不要

---

## 2. テスト規約 (Testing Standards)

### 2.1 基本原則

- テスト駆動開発 (TDD) を原則とする: Red → Green → Refactor
- バグ修正時は、まず当該バグを再現するテストを書け
- テストは独立して実行可能であること（他のテストの状態に依存しない）
- テストファイルは `tests/` ディレクトリに配置し、`test_` プレフィックスを付けよ

### 2.2 テスト構造

```python
# Arrange-Act-Assert パターンを使用
def test_user_creation_with_valid_data():
    # Arrange: テストデータの準備
    user_data = {"name": "Taro", "email": "taro@example.com"}

    # Act: テスト対象の実行
    user = UserService.create(user_data)

    # Assert: 結果の検証
    assert user.name == "Taro"
    assert user.email == "taro@example.com"
```

### 2.3 モックとスタブ

- 外部依存（DB、API、ファイルシステム）はモック化せよ
- `unittest.mock.patch` または `pytest-mock` を使用せよ
- モックは必要最小限に留め、過度なモックによるテストの脆弱化を避けよ

### 2.4 禁止事項

- 既存のパスしているテストを削除するな
- テストを通すためにプロダクションコードのロジックを歪めるな
- `sleep()` による時間依存のテストは書くな（タイムアウトやリトライのテストには適切なモックを使え）

---

## 3. Git 規約 (Git Standards)

### 3.1 コミットメッセージ

Conventional Commits 形式に従え。

```
<type>(<scope>): <description>

[optional body]
```

| type | 用途 |
|---|---|
| `feat` | 新機能の追加 |
| `fix` | バグの修正 |
| `docs` | ドキュメントのみの変更 |
| `style` | コードの意味に影響しない変更（フォーマット等） |
| `refactor` | バグ修正でも機能追加でもないコードの変更 |
| `test` | テストの追加・修正 |
| `chore` | ビルドプロセスや補助ツールの変更 |

### 3.2 コミットの粒度

- 1コミット = 1つの論理的変更
- 「テスト追加」と「実装」は可能な限り別コミットにせよ
- WIP (Work In Progress) コミットは避けよ

### 3.3 ブランチ戦略

- `main` ブランチへの直接プッシュは禁止
- 機能開発は `feature/` プレフィックスのブランチで行え
- バグ修正は `fix/` プレフィックスのブランチで行え

---

## 4. セキュリティ規約 (Security Standards)

### 4.1 秘密情報の管理

- API キー、パスワード、トークンをソースコードに直接記述するな
- 秘密情報は環境変数または専用の秘密管理サービスで管理せよ
- `.env` ファイルは `.gitignore` に含め、コミットしない
- `.env.example` をテンプレートとして提供せよ（値は空またはダミー）

### 4.2 入力の検証

- ユーザーからの入力は必ずバリデーションせよ
- SQL クエリにはパラメータ化クエリを使用せよ（文字列結合による SQL 構築は禁止）
- ファイルパスの操作にはパストラバーサル攻撃を考慮せよ
- HTML 出力にはエスケープ処理を施せよ

### 4.3 依存関係

- 新しい依存関係の追加前にセキュリティ監査を確認せよ
- 使用していない依存関係は速やかに削除せよ
- メジャーバージョンアップは慎重に行い、変更内容を確認せよ

---

## 5. エラーハンドリング規約 (Error Handling)

### 5.1 原則

- エラーハンドリングはシステム境界（ユーザー入力、外部API、ファイルI/O）でのみ行え
- 内部コードやフレームワークの保証がある箇所では過剰な防御コーディングをするな
- 発生し得ないシナリオのためのフォールバックやバリデーションは書くな

### 5.2 ログ出力

- `print()` ではなく `logging` モジュールを使用せよ
- ログレベルを適切に使い分けよ: `DEBUG`, `INFO`, `WARNING`, `ERROR`, `CRITICAL`
- 秘密情報をログに出力するな
- 構造化ログ（JSON形式等）を推奨する

```python
import logging

logger = logging.getLogger(__name__)

# ✅ Good
logger.error("Failed to connect to database", extra={"host": db_host, "port": db_port})

# ❌ Bad
print(f"Error: could not connect to {db_host}:{db_port} with password {db_password}")
```

---

## 6. ファイル・ディレクトリ構成 (Project Structure)

以下の構成を標準とする。プロジェクトの成長に応じて更新すること。

```
project_root/
├── master.md              # AI 憲法（本プロジェクトの基本原則）
├── rules.md               # 詳細ルール（本ドキュメント）
├── LEARNINGS.md            # 学習ログ
├── README.md               # プロジェクト概要
├── pyproject.toml          # プロジェクト設定・依存関係
├── src/                    # ソースコード
│   └── app/
│       ├── __init__.py
│       ├── main.py
│       ├── models/
│       ├── services/
│       ├── api/
│       └── utils/
├── tests/                  # テストコード
│   ├── __init__.py
│   ├── conftest.py
│   └── test_*.py
├── docs/                   # ドキュメント（必要な場合のみ）
└── .env.example            # 環境変数テンプレート
```

---

## 7. コードレビュー基準 (Review Criteria)

AIが生成したコードは、以下の基準で自己評価せよ。

| 基準 | チェック項目 |
|---|---|
| 正確性 | テストがすべてパスしているか |
| 最小性 | 不要な変更が含まれていないか（diff が最小か） |
| 一貫性 | 既存のコードスタイルに合致しているか |
| 安全性 | セキュリティ脆弱性が導入されていないか |
| 可読性 | コードが自明で理解しやすいか |
| テスト | 変更に対応するテストが存在するか |

---

## 8. ルールの優先順位

ルール間で矛盾が生じた場合、以下の優先順位に従え。

1. **セキュリティ規約** (最優先)
2. **master.md の基本行動原理**
3. **本ドキュメント (rules.md) の詳細ルール**
4. **既存コードベースの慣習**
5. **一般的なベストプラクティス**
