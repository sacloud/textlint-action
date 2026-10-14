# textlint-action

このリポジトリは、[github.com/sacloud](https://github.com/sacloud) 配下のリポジトリで
[textlint](https://textlint.org/) の実行を高速化するための GitHub Action です。sacloud organization 内での利用を目的としており、
外部からの利用は想定・サポートしていません。

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
