# =============================
# overview: Nimのオブジェクト指向をコツコツと
# Nimでもオブジェクト指向できるとは聞いていても、いまいちrefとか良くわからないので、
# [チュートリアル２](https://nim-lang.org/docs/tut2.html)を見ながら実験します
# 説明3

# =============================
# imports: インポートモジュール
import strformat

# =============================
# title: 親・子クラスを定義
block:
  type
    Person = ref object of RootObj
      name*: string  # * 他のモジュールからアクセスできる
      age: int       # * が付いていないのは、このモジュールだけアクセスできる
  
    Student = ref object of Person # Student は Person 継承
      id: int                      # id フィールドをつけたよ
  
  proc `$`(s: Student) : string =
    result = fmt"{{ name:{s.name}, age:{s.age}, id:{s.id} }}"
  
  var
    student: Student
    person: Person
  
  assert(student of Student) # is true
  # object construction:
  student = Student(name: "Anton", age: 5, id: 2)
  echo student[] # この[]って何？ 表示されてるんだけど。 
                 # system.nimで定義されてた。デバッガ便利！ 
                 #  proc `$`*[T: tuple|object](x: T): string 
                 # にて、オブジェクト・タプルの中身を
                 # ダンプするプロシジャみたい
  # $関数で表示
  echo $student

# =============================
# title: refが付くTypeと付かないTypeで構築方法の違い
block:
  type
    Node = ref object  # a reference to an object with the following field:
      le, ri: Node     # left and right subtrees
      sym: ref Sym     # leaves contain a reference to a Sym
    
    Sym = object       # a symbol
      name: string     # the symbol's name
      line: int        # the line the symbol was declared in
      code: Node       # the symbol's abstract syntax tree
  
  var 
    n1: Node
    s1: Sym
    s2: ref Sym
  
  proc `$`(n:Node) : string = result= fmt"{{ Node object }}"
  proc `$`(n:Sym) : string = result= fmt"{{ Sym object }}"
  proc `$`(n:ref Sym) : string = result= fmt"{{ Sym object }}"
  
  proc newSym(name:string,line:int,code: Node) : ref Sym =
    result = new Sym
    result.name = name
    result.line = line
    result.code = code
  
  # ref付きType
  n1 = Node()
  echo "(ref付きType)引数なしコンストラクタで構築:" & $n1
  
  n1 = new Node
  echo "(ref付きType)引数なしnewで構築:" & $n1
  
  n1 = Node(le:Node(),ri:Node(),sym:new Sym)
  echo "(ref付きType)引数ありコンストラクタで構築:" & $n1
  
  #n1 = new Node(le:Node(),ri:Node(),sym:new Sym)
  echo "(ref付きType)引数ありnewで構築:これは失敗する" 
  
  # ref無しType
  s1 = Sym()
  echo "(ref無しType)引数なしコンストラクタで構築:" & $s1
  
  # s1 = new Sym    Error: type mismatch: got <ref Sym> but expected 'Sym = object'
  echo "(ref無しType)引数なしnewで構築: ref無しTypeはnewで構築できない"
  
  s2 = new Sym
  echo "(ref無しType)ref Sym型でnewで構築:" & $s2
  proc finalizer(obj: ref Sym) {.noSideEffect.} =
    let i = obj.code

  # s2 = new(s2,finalizer)

# =============================
# title: XXXX3処理
block:
    echo "test3"
