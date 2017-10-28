# ubuntu-anaconda3-opencv3

anaconda3+opencv3の開発環境です。
Linux環境の場合，`conda install -c menpo opencv3`でopencv3をインストールすすると動画を扱えません。
ffmpegをイントールした上でopencv3をrebuildしないといけないので，この点を対応しています。

他に以下も導入しています。
- scikitlearn
- 日本語環境
- デフォルトユーザは pochi (UCI=1000,GID=1000)
