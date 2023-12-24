# 【Ruby】画像名を連番化するシステム

## 開発環境／実行環境
ruby 2.6.5p114  
※windows PCにインストールしてコマンドプロンプトで実行

## 特徴／説明
- 連番化したい画像とRubyファイルを同じフォルダに入れ、Rubyファイルをダブルクリックで実行
- コマンドプロンプトでの質問の回答が反映
- 質問の回答が面倒なときは初期値を変更後（定数DEFAULTのdefaultプロパティの値を変更）、ENTERキー連打で即実行
- 「設定結果」と「変更前／変更後 画像名」が表示後、「実行」もしくは「最初から設定をやり直す」を選択
- 変更前と変更後の画像名が重複する場合は実行不可（「画像を複製する」場合）、「最初から設定をやり直す」を選択
- 画像以外の拡張子でも実行可

## 質問
- 画像が入っているフォルダ名を指定してください
- 画像の拡張子を指定してください（画像以外も可）
- 新しくフォルダを作成しますか？[Y/N]
- フォルダ名を入力してください
- 画像の名前を変更しますか？[Y/N]
- 画像の名前を入力してください
- 接尾辞を作成しますか？[Y/N]
- 接尾辞を入力してください（test01_thumb.jpg etc）
- 画像を複製しますか？[Y/N]
- カウントアップで連番化しますか？カウントダウンで連番化しますか？
- 最初の数字を指定してください
- 数字のケタ数を指定してください（0をつけて桁数を揃える 例：test01.jpg, test02.jpg…）

## 「設定結果」例
```settings.cmd
画像があるフォルダ名：現在のフォルダ  
拡張子：.jpg  
フォルダ作成：しない  
新フォルダ名：  
画像名の変更：する  
画像名：test  
接尾辞の作成：する  
接尾辞：_thumb  
画像の複製：する  
カウントアップ／ダウン：カウントアップ  
最初の数字：1  
ケタ数：2  

この設定でよろしいでしょうか？  
(y:実行　n:最初から設定をやり直す)[Y/N]
```

## 「変更前／変更後 画像名」例
```rename.cmd
変更前：test01.jpg  
変更後：test01_thumb.jpg  
---------------------------------------------------------------  
  
変更前：test02.jpg  
変更後：test02_thumb.jpg  
---------------------------------------------------------------  
  
変更前：test03.jpg  
変更後：test03_thumb.jpg  
---------------------------------------------------------------  
  
変更前：test04.jpg  
変更後：test04_thumb.jpg  
---------------------------------------------------------------  
  
変更前：test05.jpg  
変更後：test05_thumb.jpg  
---------------------------------------------------------------  
  
上記のファイル名でよろしいでしょうか？  
(y:実行　n:最初から設定をやり直す)[Y/N]  
```

## 「画像名重複結果」例
```dup.cmd
変更後の画像名が変更前にも存在し、「画像を複製する」場合、実行できません ※検出された画像名  
  
test01.jpg  
test02.jpg  
test03.jpg  
test04.jpg  
test05.jpg  
  
(最初から設定をやり直す [ENTERキー]）  
```

<!--
## バージョンアップ情報
-->
