### Pythonの特徴

# 文末のセミコロンを付ける必要はない(付けてもOK)。
# 値の代入はイコール(`=``)。
a = 10
b = 20;

# セミコロンで文を区切れば1行に複数の処理を記載できる。
c = a + b; d = a * b
print(c, d)


# 単行コメントは「# ～～」、複数行コメントは「""" ～～ """」(ヒアドキュメントとして)。

# 処理のブロックはインデントで表現する。
# 文字列はダブルクォート(`""`)、もしくはシングルクォート(`''`)で括る。`r"`と`"`で括るとraw文字列。`"""`や`'''`で括ると複数行文字列(ヒアドキュメント)。

# 大文字と小文字は区別される。
# - 識別子に使えるのは大文字小文字のアルファベットと数字とアンダースコアが使える。2バイト文字も使用可。先頭（一文字目）に数字は使えない。
鳥 = "鶏"
print(鳥)

# 変数宣言は不要（いきなり使える）
# 文字列連結には `+` を使う。
# 関数定義は「def 関数名(引数…)」、戻り値の指定は「return」。
# タプルがある。
# 「return」や型宣言時に複数値を指定できる(タプルで返却される)。
# クラスのメンバアクセスはドットで行う。
# アクセス修飾子はない。(慣習的な命名規則によってプライベートとみなす方式を採る。`_`で始める)
# クラスの多重継承ができる。
# クラスのコンストラクタ相当のメソッドは`__init__`
# インスタンスメソッドの第一引数には常に`self`とする。
