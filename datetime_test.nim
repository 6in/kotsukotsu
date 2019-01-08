# =============================
# overview: Nimの日付処理をコツコツと(Part2)
# 前回作成した記事が古くなったのと、利用しているAPIがdeprecatedだったりしたのでリニューアルしました

# =============================
# imports: インポートモジュール
import times
import os,strutils
let fmtstr = "yyyy-MM-dd HH:mm:ss"

# =============================
# title: 今何時？
block:
  echo $now()

# =============================
# title: 日付フォーマット
block:
  echo format(now(),fmtstr)

# =============================
# title: UTCへ変換
block:
  echo format(utc(now()),fmtstr)

# =============================
# title: 日付文字列のパース
block:
  echo $parse("2019-01-01 23:59:59",fmtstr)

# =============================
# title: 日付オブジェクトの初期化
block:
  let dtm1 = initDateTime(1, mJan, 1970, 0, 0, 0, utc())
  echo format(dtm1,fmtstr)

  let dtm2 = initDateTime(1, mJan, 1970, 0, 0, 0, local())
  echo format(utc(dtm2),fmtstr)

# =============================
# title: 日付時刻の加減算
block:
  let dtm = now()
  echo "today    =>" & format(dtm, fmtstr)
  echo "tomorrow =>" & format(dtm + 1.days, fmtstr)
  echo "yesterday=>" & format(dtm - 1.days, fmtstr)
  echo "next year=>" & format(dtm + 1.years, fmtstr)

# =============================
# title: 処理時間の計測
block:
  let start = cpuTime()
  for x in 0..10 :
    echo $x
  echo "cpu time=>" & $(cpuTime() - start)


  