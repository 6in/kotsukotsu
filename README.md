# Nimテストツール

## 概要

* Nimで書いたソースを実行し、ソースと実効結果をMarkdownに出力します。
* ほぼ、Qiita投稿用の出力を行います。
* VSCodeによる実行を想定しています。

## 定義済みタスク

* ctrl+shift+pからTasksを選ぶと表示されるのは以下の４つ
* githubからCloneしたら、Build Releaseを実行して、kotsukotsu(.exe)を生成してください
* ctrl+shift+b で実行できるのは、Build Nowタスクとなります。

| task | memo | default |
| ---- | ---- | ------- |
| Build Release | kotsukotsuモジュールのビルド | no |
| Build Debug   | 現在編集中のソースをデバッグビルド | no |
| Build Now   | 現在編集中のソースを実行 | yes |
| Make a Markdown | 現在編集中のソースをkotsukotsuで実行し、Markdownを生成 | no |

本リポジトリをclone後は、Ctrl+Shift+Pでコマンドパレットを表示後、*Tasks: Run Task*を選択し、最初に"Build Release"を選んで、bin/kotsukotsu(.exe)を作成します。

## ソース書式

実験したいソースなどは、samplesフォルダ配下に配置してください。

サンプルコードは、全体構成として３つのパートから構成されます。
- overviewセクション
- importsセクション
- サンプルコード(複数ブロック)


overviewセクションは、Markdownの冒頭に記述する文章です。
importsセクションは、各ブロックを実行するときに先頭に付与される共通コードとなります。

importsセクションは、import文だけという制約はなく、構造体やらマクロ・定数なども書いておくこともできます。

下記のソースなら、XXXX1処理を実行するには、以下のソースがテンポラリフォルダに作成され、コンパイル＆実行後の(標準出力に出力された)結果がMarkdownに追加されます。

```nim:/tmp/temporary.nim
import json,strutils
import os
block:
    echo "test1"
```

### ソース

```nim: sample.nim
# =============================
# overview: NimのXXX処理をコツコツと
# 説明1
# 説明2
# 説明3

# =============================
# imports: インポートモジュール
import json,strutils
import os

# =============================
# title: XXXX1処理
block:
    echo "test1"

# =============================
# title: XXXX2処理
block:
    echo "test2"

# =============================
# title: XXXX3処理
block:
    echo "test3"

```

### 出力結果

* タスク *Make a Markdown* をサンプルコードに対して実行すると以下のMarkdownがmarkdown/フォルダに出力されます。

```
# 概要
NimのXXX処理をコツコツと
説明1
説明2
説明3

## 以下メモ

### XXXX1処理

"""nim
import json,strutils
import os

block:
    echo "test1"
"""

"""shell-session
(stdout)
test1
"""

### XXXX2処理

"""nim
import json,strutils
import os

block:
    echo "test2"
"""

"""shell-session
(stdout)
test2
"""

### XXXX3処理

"""nim
import json,strutils
import os

block:
    echo "test3"
"""

"""shell-session
(stdout)
test3
"""

```