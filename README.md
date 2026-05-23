# learning-ruby

Ruby / Rails の学習用モノレポ。サブディレクトリごとに独立した題材を置いている。

## ディレクトリ構成

| パス                | 内容                                                                                              |
| ------------------- | ------------------------------------------------------------------------------------------------- |
| `blog_api/`         | Rails 8 API モードで作る学習用ブログ。User / Post / Comment + RSpec (Post の Request spec まで)   |
| `rails-playground/` | Rails の機能を試す素振り場（フル機能版）                                                          |
| `plane-ruby/`       | 素の Ruby スクリプト置き場 (※ `plain` の typo、現状そのまま)                                      |

## 前提

- Ruby 3.4.9（rbenv 推奨。`blog_api/.ruby-version` を参照）
- Bundler

## クイックスタート (blog_api)

```sh
cd blog_api
bin/setup --skip-server   # 依存インストール + DB 準備 (seed まで)
bin/rails s               # http://localhost:3000
bundle exec rspec         # テスト実行
```

`bin/setup` は `--skip-server` を付けないと最後に `bin/dev` で開発サーバまで起動する。初回は付けずに走らせて一気にサーバまで上げてもよい。

## ルートの足場について

エディタ統合（ruby-lsp / rubocop）をリポジトリルートで開いても効くようにするための仕掛け。

- `Gemfile` — `blog_api/Gemfile` を `eval_gemfile` で取り込み
- `.rubocop.yml` — `blog_api/.rubocop.yml` を `inherit_from`
- `.vscode/settings.json` — Ruby ファイルの default formatter を ruby-lsp に
- `.gitignore` — ルートで生成される `Gemfile.lock` / `.bundle/` を除外

```sh
bundle install
```

をルートで叩けば、VSCode + Shopify.ruby-lsp 拡張で保存時の rubocop フォーマットが効く状態になる。
