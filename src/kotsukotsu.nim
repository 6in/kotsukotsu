import os,system
import json
import yaml
import strutils
import tables,algorithm,sequtils
import nre
import osproc,streams

const splitter = "# ============================="
let reg_overview = re"^# overview: (?<overview>.+)$"
let reg_imports = re"^# imports: (?<some>.+)$"
let reg_title = re"^# title: (?<title>.+)$"
let reg_comment = re"^# (?<comment>.+)$"


proc readText(file_name:string) : seq[string] =
  # read file
  let f : File = open(file_name , FileMode.fmRead)
  defer :
    close(f)

  result = (f.readAll() & "\p").splitLines()

proc writeText(file_name:string,text: string) =

  var f : File = open(file_name ,FileMode.fmWrite)
  f.write text
  f.close()

proc exec_nim(title:string, imp:string , code:string) : string =
  let text = [imp,code].join("\p")
  let os_tmp = os.getTempDir()
  let file = [os_tmp , "sample.nim"].joinPath()
  # Nimコード書き出し
  writeText file, text

  echo "exec " & title

  # コンパイル実行
  block:
    let p: Process = startProcess("nim",os_tmp,@["c","-d:release","--hints:off","--verbosity:0", file])
    discard p.waitForExit()
    p.close

  # プロセス実行
  let p: Process = startProcess(os_tmp / "sample")

  # 標準出力を取得し、コンソールに表示
  let outstr = p.outputStream
  var line:string = ""
  var buff: seq[string] = @[]
  # ストリームから１行ずつフェッチ
  while outstr.readLine(line):
    buff.add line
  # 終了待機
  discard p.waitForExit()
  outstr.close()
  result = buff.join("\p")
  p.close()

proc main(file_name: string) =

  let (dir, name, ext) = file_name.splitFile()

  let lines = readText(file_name)
  var startSection = false
  var contents = initTable[string,string]()
  var curSection = ""
  var buff: seq[string] = @[] 
  var titles: seq[string] = @[]

  for line in lines:
    if line == splitter :
      startSection = true
      if curSection != "" :
        contents[curSection] = buff.join("\p")
        curSection = ""
        buff = @[]
    else:
      let capOverview = line.match(reg_overview)
      if capOverview.isSome :
        let overview = capOverview.get().captures["overview"]
        curSection = "overview"
        buff.add(overview)
      elif line.match(reg_imports).isSome :
        curSection = "imports"
      elif line.match(reg_title).isSome :
        curSection = line.match(reg_title).get.captures["title"]
        if titles.binarySearch(curSection) != -1:
            echo "section already exists: " & curSection
            system.programResult = 1
            return 
        titles.add curSection   
      elif line.match(reg_comment).isSome :
        buff.add line.match(reg_comment).get().captures["comment"]
      else:
        buff.add line

  # 最後のブロックを格納
  contents[curSection] = buff.join("\p")

  var output: seq[string] = @[]
  output.add "# 概要"
  output.add $contents["overview"]
  output.add ""
  output.add "## 以下メモ"
  output.add ""

  let import_text = contents["imports"]
  for title in titles:
    output.add "### " & title
    output.add ""
    output.add "```nim"
    output.add import_text
    output.add ""
    output.add $contents[title]
    output.add "```"
    output.add ""
    output.add "```shell-session"
    output.add "(stdout)"
    output.add exec_nim(title,import_text,contents[title])
    output.add "```"
    output.add ""

  writeFile([dir, "../markdown", name & ".md"].joinPath(), output.join("\p"))

if os.commandLineParams().len == 0:
  main("sample.nim".expandFilename())
else:
  main($os.commandLineParams()[0].expandFilename())

