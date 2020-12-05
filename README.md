# verilog_elelock
Verilogで実装した電子錠
## 参考書籍
小林優 (2004) 「入門Verilog HDL記述 ハードウェア記述言語の速習&実践」 CQ出版

## シミュレーション
```bash
iverilog -o sim ledout.v syncro.v elelock.v elelocktop.v testbench.v
vvp sim > log.txt
gtkwave wave.vcd
```

## MU200-ECへの書き込み
```bash
#コンパイル
quartus_sh --flow compie elelock
```
USB-Blasterを接続し，Quartus II Programmerにて書き込み．

## 入力について
|     |     |     |     |
| :-: | :-: | :-: | :-: |
|     |     |     |     |
| MEM | 7   | 8   | 9   |
| CLS | 4   | 5   | 6   |
| 0   | 1   | 2   | 3   |

## 諸々
宗教の違いや入出力の環境の違いなどから本に掲載されているサンプルコードとは殆ど一致していない．
入出力に関しては以下の書籍を参照．
浅田邦博 (2003) 「ディジタル集積回路の設計と試作」培風館

