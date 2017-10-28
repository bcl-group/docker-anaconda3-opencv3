---
title: Dockerを使う
---

なんだかインストール関連の記事ばかり書いている気がするが，プログラムのお勉強の一番最初の壁は開発環境を整えることで，ここに思いの外苦労することが多く，メモを残して行いと後で後悔することも多い。
いきなりDockerのインストールとか言われても意味わかんねぇよというヒトも多いかもしれないが，気にしないでメモを残す。

## Dockerイメージを作る

### docker build

1. Dockerfileを作るかどこかから持ってくる
2. [docker buld](https://docs.docker.com/engine/reference/commandline/build/)コマンドでイメージを作る。

Dockerfileのあるディレクトリで以下を実行。
```
$ docker build --force-rm=true -t <イメージ名> .
```
- `force-rm=true`: ビルド中にできる中間コンテナを削除する。
- `-t <イメージ名>`: イメージ名の設定
- 最後の引数はDockerfileのあるディレクトリ。カレントディレクトリに有るなら，上記のように`.`で良い。

プロキシ設定が必要なときには以下の指定する。
```
docker build --force-rm=true -t <イメージ名> --build-arg http_proxy=http://proxy:port --build-arg https_proxy=http://proxy:port .
```
### お掃除
build後に結構大きなサイズのゴミが残ることがあるのでお掃除をする。
特に`docker build`で`--force-rm=true`の指定をしなかったときには必ずする。

- `$ docker ps -a`: 不要なコンテナがないか確認。
  `-a`をつけないと実行中のコンテナのみが表示される。
- `$ docker rm <コンテナID>`: 不要なコンテナがあったら，コンテナのIDを確認して削除する。ID指定は最初の3文字のみでもOK。
- `$ docker images`: 不要なイメージがないか確認。
- `$ docker rmi <イメージID>`: 不要なイメージを削除。

## docker の実行
[docker run](https://docs.docker.com/engine/reference/commandline/run/)を使う。
状況に応じていろんなオプションがある。

一番単純な方法は以下。
```
$ docker run --rm <イメージ名>
```
`--rm`は終了後にコンテナを消すオプション。これをつけないとお掃除が必要になる。

juyter notebook等のwebアプリケーションを使うときはコンテナとホストのポート転送設定をする。
```
$ docker run -p 8080:8080 --rm <イメージ名>
```
ホスト側で作ったファイルをDocker上で見れるようにコンテナにマウントするには`-v`オプションで指定する。
```
$ docker run -v /Users/pochi/:/home/pochi/ --rm <イメージ名>
```
これで，ホスト上の`/Users/pochi`がDocker上の`/home/pochi`にマウントされる。


## 終了後

- `docker ps`: 稼働しているコンテナがないか確認
- `docker stop`: コンテナの終了
- `docker rm`: コンテナを削除

## Makefile

いろいろと面倒なので，Makefileかスクリプトを作っておくと便利。
以下のMakefileの例。
```
$ cat Makefile
build:
	docker build --force-rm=true -t <イメージ名> .

run:
	docker run -it --rm <イメージ名>

ps:
	docker ps -a

clean:
	rm *~
```

## 参考URL
- [Dockerfile作成のStep by Step](https://qiita.com/icoxfog417/items/2eba17cfd2a17aa5abde)
