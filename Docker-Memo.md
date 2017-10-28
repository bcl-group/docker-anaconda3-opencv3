---
title: Dockerを使う
---

なんだかインストール関連の記事ばかり書いている気がするが，プログラムのお勉強の一番最初の壁は開発環境を整えることで，
ここに思いの外苦労することが多く，メモを残しておかないと後で再度インストールするときに困ることも多い。
いきなりDockerのインストールとか言われても意味わかんねぇよというヒトも多いかもしれないし，気にしないでメモを残す。

## 経緯

卒論生が`anaconda + opencv`でプログラムを作ろうと，Linux上で
```
$ conda install -c menpo opencv
```
としたが，動画表示ができない。
opencvをbuildし直してffmpegと連携させる必要アリとのこと。
いろいろな事情で，WindowsでもLinuxでもMacでも同じ環境でテストできるようにしたいので, Dockerでイメージを作っておくのが，一番ラクかという結論に。

というわけで 以下はDockerイメージの作り方と使い方のメモ。

## 基本用語

かなり適当な説明なので，正確なことはgoogleに聞いて下さい。
- [Docker](https://www.docker.com/): 軽量なアプリケーション開発用仮想マシンのようなもの
- イメージ: 仮想マシンのOSのようなもの
- コンテナ: イメージを読み込んで実行する環境

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

ちなみに以下はお掃除を少しサボっていた場合の例。なんどかbuildに失敗したりしてるとあっという間に数10GBを消費されてて大笑い。(笑ってる場合ではないが...)
中にはbuildのためにダウンロードされているイメージもあるので，どれを消すかは要注意。
```
$ docker images
REPOSITORY                         TAG                 IMAGE ID            CREATED             SIZE
<none>                             <none>              a5c45a7e6ba5        15 minutes ago      4.5GB
<none>                             <none>              f3e00f637740        5 hours ago         1.19GB
ubuntu-anaconda3-opencv3   latest              1ab351999a28        23 hours ago        6.77GB
<none>                             <none>              5c0142dffb0c        24 hours ago        6.77GB
<none>                             <none>              4244ce54ef9b        24 hours ago        6.77GB
<none>                             <none>              7508c15932f9        35 hours ago        6.42GB
ubuntu                             16.04               747cb2d60bbe        2 weeks ago         122MB
hello-world                        latest              05a3bd381fc2        6 weeks ago         1.84kB
ubuntu                             16.10               7d3f705d307c        3 months ago        107MB
```

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

なんでもすぐに忘れられるという特技を持つ僕は，Makefileやスクリプトを作ったり，alias設定をしたりする。
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
実行は，`$ make build`等で。

## 参考URL
- [Dockerfile作成のStep by Step](https://qiita.com/icoxfog417/items/2eba17cfd2a17aa5abde)
