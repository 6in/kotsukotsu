# =============================
# overview: NimのJSON処理をコツコツと
# [json](https://nim-lang.org/docs/json.html)モジュールのメソッドを一通り試します

# =============================
# imports: インポートモジュール
import json
import os,strutils,tables

# =============================
# title: JSONオブジェクトを構築
block:
  # %* マクロでJsonオブジェクトを構築
  let jsonObj = %* { "key1": "value1", "key2": 1 }
  echo "# キーを指定して取得"
  echo "key1=>" & $jsonObj["key1"]
  echo "key2=>" & $jsonObj["key2"]
  echo "# 型を指定して取得"
  echo "key1=>" & jsonObj["key1"].getStr()
  echo "key2=>" & $jsonObj["key2"].getInt()
  echo "# 存在しないキーを指定"
  #echo "keyx=>" & $jsonObj["keyx"]
  echo "Error: unhandled exception: key not found: keyx [KeyError]"
  echo "# デフォルト値を指定して取得(これもエラー)"
  # echo "keyx=>" & $jsonObj["keyx"].getStr("")
  echo "Error: unhandled exception: key not found: keyx [KeyError]"

# =============================
# title: JSONをファイルへ保存
block:
  let jsonObj = %* { "key1": "value1", "key2": 1 }
  let f = open("sample.json", FileMode.fmWrite)
  f.write(jsonObj.pretty())
  f.close()
  echo "file exists=>" & $"sample.json".existsFile

# =============================
# title: JSONファイルの読み込み
block:
  let jsonObj1 = %* { "key1": "value1", "key2": 1 }
  # さっき書き込んだファイルを読み込む
  let jsonObj2 = parseFile("sample.json")
  echo "compare json=>" , jsonObj1 == jsonObj2
  echo jsonObj2.pretty

# =============================
# title: JSON文字列からの構築
block:
  # %* マクロでJsonオブジェクトを構築
  let jsonObj1 = %* { "key1": "value1", "key2": 1 }
  # さっき書き込んだファイルを読み込む
  let jsonStr = parseFile("sample.json").pretty
  let jsonObj2 = parseJson(jsonStr)
  echo "compare json=>" , jsonObj1 == jsonObj2

# =============================
# title: キーの存在チェック
block:
  # %* マクロでJsonオブジェクトを構築
  let jsonObj = %* { "key1": "value1", "key2": 1 }
  echo "# キーの存在チェック"
  echo "hasKey[key1]=>" & $jsonObj.hasKey("key1")
  echo "hasKey[key3]=>" & $jsonObj.hasKey("key3")
  echo "hasKey[key1]=>" & $jsonObj.contains("key1")
  echo "hasKey[key3]=>" & $jsonObj.contains("key3")

# =============================
# title: JSONのPretty表示
block:
  let jsonObj = %* { "key1": "value1", "key2": 1 }
  echo jsonObj.pretty()

# =============================
# title: JSONオブジェクトに属性を追加
block:
  # %* マクロでJsonオブジェクトを構築
  let jsonObj = %* { "key1": "value1", "key2": 1 }
  # 文字列を追加
  jsonObj["key3"] = newJString("value3")
  echo "key3=>" & $jsonObj["key3"]
  # %* で追加
  jsonObj["key3"] = %* "value3"
  echo "key3=>" & $jsonObj["key3"]
  # 数値(int)を追加
  jsonObj["key3"] = newJInt(999)
  echo "key3=>" & $jsonObj["key3"]
  # %* で追加
  jsonObj["key3"] = %* 999
  echo "key3=>" & $jsonObj["key3"]
  # 配列を追加(newJArrayの引数は空なのでこれはできない))
  # jsonObj["key3"] = newJArray([1,2,3,4])
  # echo "key3=>" & $jsonObj["key3"]
  # %* で追加
  jsonObj["key3"] = %* [1,2,3,4]
  echo "key3=>" & $jsonObj["key3"]

# =============================
# title: JSONのキー一覧を取得
block:
  # %* マクロでJsonオブジェクトを構築
  let jsonObj = %* { "key1": "value1", "key2": 1 }
  let fields: OrderedTable[string,JsonNode] = jsonObj.getFields()
  var keys: seq[string] = @[]
  for key in fields.keys:
    keys.add key
  echo "keys=>" & keys

# =============================
# title: 属性の型を確認する
block:
  # %* マクロでJsonオブジェクトを構築
  let jsonObj = %* { 
    "key1": "value1", 
    "key2": 1, 
    "key3": true, 
    "key4": 3.141592, 
    "key5": nil, 
    "key6": [11,2,3], 
    "key7": {"name": "object"}
  }
  # JsonNodeKindは省略可能
  echo jsonObj["key1"].kind == JsonNodeKind.JString
  echo jsonObj["key2"].kind == JsonNodeKind.JInt
  echo jsonObj["key3"].kind == JsonNodeKind.JBool
  echo jsonObj["key4"].kind == JsonNodeKind.JFloat
  echo jsonObj["key5"].kind == JsonNodeKind.JNull
  echo jsonObj["key6"].kind == JsonNodeKind.JArray
  echo jsonObj["key7"].kind == JsonNodeKind.JObject

# =============================
# title: JSONのオブジェクト階層を探索しながら値を取得
block:
  # %* マクロでJsonオブジェクトを構築
  let jsonObj = %* { 
    "parent": { 
      "child1": "value1",
      "child2": {
        "child3": [1,2,3]
      }
    }
  }
  # {}演算子を使って、親・子のキーを並べて指定する
  echo "parent.child1=>" & $jsonObj{"parent","child1"}
  echo "parent.child2.child3=>" & $jsonObj{"parent","child2","child3"}

# =============================
# title: 属性の削除
block:
  # %* マクロでJsonオブジェクトを構築
  let jsonObj = %* { "key1": "value1", "key2": 1 }
  # deleteで削除
  jsonObj.delete("key1")
  echo jsonObj.pretty
  echo "# もう一度deleteで削除->キーが無いのでエラー"
  echo """jsonObj.delete("key1")"""
  echo "Error: unhandled exception: key not in object [IndexError]"

# =============================
# title: JSONエスケープ処理
block:
  echo "escapeJson=>" & escapeJson("test1\ntest2\n")

# =============================
# title: 整形しないでJson文字列を作成(toUgly)
block:
  let jsonObj = %* { 
    "parent": { 
      "child1": "value1",
      "child2": {
        "child3": [1,2,3]
      }
    }
  }
  var result = ""
  toUgly(result,jsonObj)
  echo "toUgly=>" & result

# =============================
# title: イテレータ(items) 対象は配列オブジェクトのみ
block:
  # %* マクロでJsonオブジェクトを構築
  let jsonObj = %* [ 
    {"key1": "value1"}, 
    {"key2": 1}, 
    {"key3": true}, 
    {"key4": 3.141592}, 
    {"key5": nil}, 
    {"key6": [1,2,3]}, 
    {"key7": {"name": "object"}}
  ]
  for item in jsonObj.items:
    echo "==================="
    echo $item

# =============================
# title: イテレータ(mitems) 対象はミュータブルなJson配列オブジェクトのみ。
block:
  # %* マクロでJsonオブジェクトを構築
  var jsonObj = %* [ 
    {"key1": "value1"}, 
    {"key2": 1}, 
    {"key3": true}, 
    {"key4": 3.141592}, 
    {"key5": nil}, 
    {"key6": [1,2,3]}, 
    {"key7": {"name": "object"}}
  ]
  for item in jsonObj.mitems:
    # 中身を変更できる
    item["message"] = %* "hello"
    echo "==================="
    echo $item

# =============================
# title: イテレータ(pairs) 対象はオブジェクトのみ。
block:
  # %* マクロでJsonオブジェクトを構築
  let jsonObj = %* { 
    "key1": "value1", 
    "key2": 1, 
    "key3": true, 
    "key4": 3.141592, 
    "key5": nil, 
    "key6": [1,2,3], 
    "key7": {"name": "object"}
  }
  for item in jsonObj.pairs:
    echo "==================="
    echo "key=>" & $item.key
    echo "val=>" & $item.val

# =============================
# title: イテレータ(mpairs) 対象はミュータブルなJsonオブジェクト
block:
  # %* マクロでJsonオブジェクトを構築
  var jsonObj = %* { 
    "key1": "value1", 
    "key2": 1, 
    "key3": true, 
    "key4": 3.141592, 
    "key5": nil, 
    "key6": [1,2,3], 
    "key7": {"name": "object"}
  }
  # mpairsで列挙
  for item in jsonObj.mpairs:
    echo "==================="
    echo "key=>" & $item.key
    echo "val=>" & $item.val
    jsonObj[item.key] = %* "message"
  echo "書き換え結果=>" & jsonObj.pretty    

# =============================
# title: JSONオブジェクトからオブジェクトに変換
block:
  let jsonNode = parseJson("""
  {
    "person": {
      "name": "Nimmer",
      "age": 21
    },
    "list": [1, 2, 3, 4]
  }
  """)
  type
    Person = object
      name: string
      age: int
    Data = object
      person: Person
      list: seq[int]
  var data = to(jsonNode, Data)
  echo "data.person.name=>" & data.person.name
  echo "data.person.age=>" & $data.person.age
  echo "data.list=>" & $data.list

# =============================
# title: JSON配列内の要素を配列オブジェクトに変換
block:
  let jsonNode = parseJson("""[
  {
    "person": {
      "name": "Nimmer",
      "age": 21
    },
    "list": [1, 2, 3, 4]
  }]
  """)
  type
    Person = object
      name: string
      age: int
    Data = object
      person: Person
      list: seq[int]
  var data = to(jsonNode, seq[Data])
  echo "data[0].person.name=>" & data[0].person.name
  echo "data[0].person.age=>" & $data[0].person.age
  echo "data[0].list=>" & $data[0].list

