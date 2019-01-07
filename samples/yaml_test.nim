# =============================
# overview: NimのYAML処理をコツコツと
# NimYAMLの低レベルメソッドを試します
# NimYAMLの現行バージョン0.10.3だと、nim-0.19.0ではコンパイルエラーとなります。
# 自分用にNimYAMLをForkしてたんですが、なんか間違えて本家のGitHubに[PR](https://github.com/flyx/NimYAML/pull/63/commits/07a1b8ceb500be288c85e237bcb6646b8c483812)送ってしまいました。
# 大した修正ではないので、以下実行後にPRの内容を参考に手動でパッチを当ててもらえれば動くかと思います。
#
# ```
# nimble install yaml
# ```
# 
# 以下は、yaml.domを利用して一からYamlを組み立てるサンプルとなります。

# =============================
# imports: インポートモジュール
import yaml,yaml/presenter,yaml/serialization
import json,strutils,os,streams

# =============================
# title: 低レベルなYaml構築
block:
  # ヘルパー関数群
  proc y(val:string) : YamlNode = newYamlNode(val)
  proc y(val:int) : YamlNode = newYamlNode($val,"int")
  proc y(key,val:string) : YamlNode = newYamlNode( [ (y(key),y(val)) ] )
  # key,valueのペアからYamlNodeを生成
  proc y( keyValues: openArray[(string,string)] ) : YamlNode = 
    var kvs: seq[(YamlNode,YamlNode)] = @[]
    for kv in keyValues:
      kvs.add ( y(kv[0]), y(kv[1]) )
    result = newYamlNode(kvs)    
  # YamlNodeの配列を構築
  proc y( values: openArray[YamlNode] ) : YamlNode = 
    var vals: seq[YamlNode] = @[]
    for val in values:
      vals.add val
    result = newYamlNode(vals)
  # ファイルを表示
  proc cat(file:string) =
    let f = open(file,FileMode.fmRead)
    defer: f.close
    echo f.readAll
  # Yamlをダンプ
  proc dump(yamlDoc:YamlDocument ,file:string, style:PresentationStyle) =
    var s = newFileStream(file, fmWrite)
    yamlDoc.dumpDom(s, options= defineOptions(style = style) )
    s.close()
    cat(file)
  #
  # YamlDocを作成
  let yamlDoc = initYamlDoc( y([("string","val1")]) )
  #
  # 属性追加
  yamlDoc.root[y"number"] = y(2)
  # オブジェクトを追加
  yamlDoc.root[y"object"] = y("child1","3")
  # 配列を追加
  yamlDoc.root[y"array"] = y( [ y"child2", y"child3", y"child4", y"child5" ] )
  # 配列[オブジェクト]を追加
  yamlDoc.root[y"arrayObject"] = y( [ y("key1","val1"),y("key2","val2"),y("key3","val3") ] )
  #
  # Yamlをダンプ
  # psMinimal, psCanonical, psDefault, psJson, psBlockOnly
  echo "============================="
  echo "Yamlを表示(psMinimal)"
  yamlDoc.dump( "psMinimal.yaml", psMinimal)
  echo "============================="
  echo "Yamlを表示(psCanonical)"
  yamlDoc.dump( "psCanonical.yaml", psCanonical)
  echo "============================="
  echo "Yamlを表示(psDefault)"
  yamlDoc.dump( "psDefault.yaml", psDefault)
  echo "============================="
  echo "Yamlを表示(psJson)"
  yamlDoc.dump( "psJson.yaml", psJson)
  echo "============================="
  echo "Yamlを表示(psBlockOnly)"
  yamlDoc.dump( "psBlockOnly.yaml", psBlockOnly)

# =============================
# title: 文字列から構築
block:
  # yamlDoc.root.new()
  let yamlDoc2 = loadDom("""
test:
  test1: 1
  """)
  echo $yamlDoc2

# =============================
# title: ファイルから構築
block:
  let fileStream = newFileStream("psBlockOnly.yaml",FileMode.fmRead)
  let yamlDoc = loadDom( fileStream )
  defer:
    fileStream.close
  echo $yamlDoc
