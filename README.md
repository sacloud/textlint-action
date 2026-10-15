# textlint-action

このリポジトリは、[github.com/sacloud](https://github.com/sacloud) 配下のリポジトリで
[textlint](https://textlint.org/) の実行を高速化するための GitHub Action です。sacloud organization 内での利用を目的としており、
外部からの利用は想定・サポートしていません。

## リリース

tagpr が `main` の変更をまとめたリリース PR を作成します。
リリース PR をマージすると、タグと GitHub Release が作成され、
同じ workflow 内でそのタグの Docker イメージと `latest` が GHCR に公開されます。

`action.yml` のイメージタグは自動更新しません。公開前のイメージを参照しないよう、
次の手順で手動更新してください。

1. tagpr のリリース PR をマージします。
2. `tagpr` workflow の Docker イメージ公開が成功したことを確認します。
3. `action.yml` の `runs.image` を、公開されたイメージタグ
   （例: `docker://ghcr.io/sacloud/textlint-action:v0.1.2`）に変更する PR を作成し、マージします。

リリースタグ時点の `action.yml` は以前のイメージを参照します。
新しいイメージを利用する場合は、手動更新後のコミットまたは `main` を参照してください。
既存のリリースタグは移動しません。

Docker イメージの公開に失敗した場合は、`action.yml` を更新せず、
次のリリースで公開し直します。

## テスト

Docker イメージのテストは、次のコマンドで実行できます。

```sh
make test
```

Docker がインストールされ、起動している必要があります。テストではイメージをビルドし、
必要な textlint パッケージがインストールされていること、正しい文章の lint が成功すること、
既知の誤字がエラーとして検出されることを確認します。

## 依存関係の更新

Docker の Node.js イメージはバージョンと digest で固定し、textlint とその依存パッケージは
`package-lock.json` で固定しています。Dependabot が Docker イメージ、npm パッケージ、
GitHub Actions の更新を提案します。
