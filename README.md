# ai_project

複数の AI エージェント（Claude・Gemini・Codex・Copilot）に対して、統一した指示を与えるためのリポジトリテンプレート。

---

## 設計思想

AI エージェントへの指示を「単一の真実の源」で管理し、各ツール固有のファイルへ自動同期する。

```
master.md ──┬──► .claude/claude.md
            ├──► .codex/agents.md
            ├──► .gemini/gemini.md
            ├──► .github/copilot-instructions.md
            ├──► AGENTS.md
            └──► GEMINI.md

rules.md   ──┬──► .claude/rules/rules.md
             ├──► .codex/rules/rules.md
             └──► .gemini/rules/rules.md
```

`master.md` / `rules.md` だけを編集すれば、コミット時に全ツール向けファイルへ自動でコピーされる。

---

## ドキュメント構成

### 編集するファイル（単一の真実の源）

| ファイル | 目的 |
|---|---|
| `master.md` | AI への行動原則・技術スタック・コマンド・境界条件。すべてのセッションで最初に読ませる |
| `rules.md` | プロジェクト固有の判断基準。技術選択の理由・テスト方針・Git 規約など |
| `LEARNINGS.md` | プロジェクトで得た知見の蓄積。ハマりポイントや設計判断の記録 |

**`master.md` と `rules.md` のみ編集する。コピー先のファイルは直接触らない。**

### 自動生成されるファイル（編集禁止）

| ファイル | 対応ツール |
|---|---|
| `.claude/claude.md` | Claude Code |
| `.claude/rules/rules.md` | Claude Code |
| `.codex/agents.md` | OpenAI Codex |
| `.codex/rules/rules.md` | OpenAI Codex |
| `.gemini/gemini.md` | Gemini CLI |
| `.gemini/rules/rules.md` | Gemini CLI |
| `.github/copilot-instructions.md` | GitHub Copilot |
| `AGENTS.md` | OpenAI Codex（ルート参照） |
| `GEMINI.md` | Gemini（ルート参照） |

### フック関連ファイル（原則変更不要）

| ファイル | 役割 |
|---|---|
| `.githooks/pre-commit` | git フックのエントリポイント。pre-commit フレームワークへ処理を委譲する |
| `.pre-commit-config.yaml` | `master.md` / `rules.md` が staged になったときだけ同期フックを起動する設定 |
| `scripts/sync_ai_docs.sh` | 実際のコピー処理。差分があるファイルのみコピーし `git add` まで行う |

---

## セットアップ

クローン後に一度だけ実行する:

```bash
pip install pre-commit
git config core.hooksPath .githooks
```

> `core.hooksPath` はローカル設定（`.git/config` に書かれる）のため、クローンごとに必要。

---

## 日常のワークフロー

```bash
# 1. master.md または rules.md を編集する
vim master.md

# 2. 通常どおりステージ・コミットするだけ
git add master.md
git commit -m "docs: ..."
# → pre-commit フックが自動で全コピー先を同期してコミットに含める
```

コピー先ファイルを手動で `git add` する必要はない。

---

## 手動で同期したい場合

```bash
git add master.md rules.md
pre-commit run sync-ai-docs
```
