# Nimテストツール

## 概要

* Nimで書いたソースを実行し、ソースと実行結果をMarkdownに出力します。
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

## ソース書式

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

* kotsukotsu(.exe)にソースファイル(sample.nim)を引数に渡すと、以下のMarkdownがmarkdown/フォルダに出力されます。

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