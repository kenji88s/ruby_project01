###################################################################################################
## ↓ 下記変更 OK
###################################################################################################

DEFAULT = {
    currentDir: {
        label: '画像があるフォルダ名',                          ## 項目名
        question: '画像が入っているフォルダ名を指定してください', ## 質問
        default: ''                                           ## 初期値／デフォルト値
    },
    imgExt: {
        label: '拡張子',
        question: '画像の拡張子を指定してください（画像以外も可）',
        default: '.jpg'
    },
    makeDir: {
        label: 'フォルダ作成',
        question: '新しくフォルダを作成しますか？[Y/N]',
        default: false
    },
    dirName: {
        label: '新フォルダ名',
        question: 'フォルダ名を入力してください',
        default: 'test'
    },
    renameImg: {
        label: '画像名の変更',
        question: '画像の名前を変更しますか？[Y/N]',
        default: true
    },
    imgName: {
        label: '画像名',
        question: '画像の名前を入力してください',
        default: 'test'
    },
    makeSuffix: {
        label: '接尾辞の作成',
        question: '接尾辞を作成しますか？[Y/N]',
        default: true
    },
    suffixName: {
        label: '接尾辞',
        question: '接尾辞を入力してください（test01_thumb.jpg etc）',
        default: '_thumb'
    },
    copyImg: {
        label: '画像の複製',
        question: '画像を複製しますか？[Y/N]',
        default: true
    },
    countUpdown: {
        label: 'カウントアップ／ダウン',
        question: 'カウントアップで連番化しますか？カウントダウンで連番化しますか？',
        default: true
    },
    countFirst: {
        label: '最初の数字',
        question: '最初の数字を指定してください',
        default: 1
    },
    digitNum: {
        label: 'ケタ数',
        question: '数字のケタ数を指定してください（0をつけて桁数を揃える 例：test01.jpg, test02.jpg…）',
        default: 2
    },
}

###################################################################################################
## ↓ 下記変更 NG
###################################################################################################

require 'fileutils'

$overwrite
$currentPath
$renameInt
$errorLog

# ファイルのパス／名前
$before = []
$after = []
$targetFile = []

###################################################################################################
## ↓ 処理（全体）
###################################################################################################

# 設定
def setting
    $overwrite = {}

    puts "\n"
    puts "画像の連番化を行います[ENTERキー]"
    gets.chomp

    ## 画像があるフォルダ名
    makeName('currentDir','現在のフォルダ')
    ## 拡張子
    makeName('imgExt')
    ## フォルダ作成
    caseWhich('makeDir','作成する','作成しない')
    ## 新フォルダ名
    if $overwrite[:makeDir] == true then makeName('dirName') end
    ## 画像名の変更
    caseWhich('renameImg','変更する','変更しない')
    ## 画像名
    if $overwrite[:renameImg] == true then makeName('imgName') end
    ## 接尾辞の有無
    caseWhich('makeSuffix','作成する','作成しない')
    ## 接尾辞の設定
    if $overwrite[:makeSuffix] == true then makeName('suffixName') end
    ## 画像の複製
    caseWhich('copyImg','複製する','複製しない')
    ## カウントアップ／ダウン
    caseWhich('countUpdown','カウントアップ','カウントダウン','y:カウントアップ　n:カウントダウン　[Y/N]')
    ## 最初の数字
    makeName('countFirst')
    ## ケタ数
    makeName('digitNum')

    newLine()
    return true
end

# 設定結果
def resultSetting    
    DEFAULT.each do |item|
        case item.to_a[0].to_s
            when "currentDir" then
                answer = $overwrite[item.to_a[0]] == "" ? "現在のフォルダ" : $overwrite[item.to_a[0]]
            when "countUpdown" then
                answer = $overwrite[item.to_a[0]] == true ? "カウントアップ" : "カウントダウン"
            when "makeDir","renameImg","copyImg","makeSuffix" then
                answer = $overwrite[item.to_a[0]] === true ? "する" : "しない"
            else
                answer = $overwrite[item.to_a[0]]
        end
        puts "#{item.to_a[1][:label]}：#{answer}"
    end

    confirm('この設定でよろしいでしょうか？')
end

# リネーム/連番化 結果
def resultPath
    $currentPath = $overwrite[:currentDir] == "" ? "" : "#{$overwrite[:currentDir]}/"
    movePath = $overwrite[:makeDir] == true && $overwrite[:dirName] != '' ? "#{$overwrite[:dirName]}/" : ''
    suffixName = $overwrite[:makeSuffix] == true ? $overwrite[:suffixName] : '';
    targetPath = "#{$currentPath}*#{$overwrite[:imgExt]}"
    $renameInt = $overwrite[:countFirst].to_i
    if Dir.glob(targetPath).empty?
        $errorLog = ["#{DEFAULT[:currentDir][:label]}：#{$overwrite[:currentDir] == "" ? "現在のフォルダ" : $overwrite[:currentDir]}"]
        $errorLog.push("#{DEFAULT[:imgExt][:label]}：#{$overwrite[:imgExt]}")
        alert('該当するファイルが見つかりません')
    else
        $before.clear
        $after.clear
        Dir.glob(targetPath) do |item|        
            renamePath = $currentPath + movePath + $overwrite[:imgName] + makeNum() + suffixName + $overwrite[:imgExt]
            $overwrite[:countUpdown] == true ? $renameInt += 1 : $renameInt -= 1
            $before.push(item)
            $after.push(renamePath)
            puts "変更前：#{item}"
            puts "変更後：#{renamePath}"
            newLine()
        end
        confirm('上記のファイル名でよろしいでしょうか？')
    end    
end

# リネーム実行
def rename
    $errorLog = dupFile()
    if $errorLog.any?
        alert('変更後の画像名が変更前にも存在し、「画像を複製する」場合、実行できません ※検出された画像名') 
        ## ↑ 「ファイル名の重複の確認」実行後、エラーがあればアラートを実行
    else
        $overwrite[:makeDir] == true && $overwrite[:dirName] != '' ? Dir.mkdir($currentPath + $overwrite[:dirName]) : nil
        ## ↑ フォルダの作成
        if copyFile() && deleteFile()
            $targetFile.each do |item|
                FileUtils.mv(item, $after[$targetFile.index(item)])
            end
            ## ↑ 「ファイルの複製」「変更前の画像名の画像削除」実行後、リネームを実行
            return true
        end

    end
end

###################################################################################################
## ↓ 関数（設定）
###################################################################################################

# 記入
def makeName(item, option = "")
    newLine()
    item = item.to_sym
    puts DEFAULT[item][:question]
    if option == ""
        puts "（初期値：#{DEFAULT[item][:default]} [ENTERキー]）"
    else
        puts "（初期値：#{DEFAULT[item][:default] == "" ? option : DEFAULT[item][:default]} [ENTERキー]）"
    end
    answer = gets.chomp
    $overwrite[item] = answer == "" ? DEFAULT[item][:default] : answer
end

# 「はい」「いいえ」の確認
def caseWhich(item,option1,option2,sup = "")
    newLine()
    item = item.to_sym
    puts DEFAULT[item][:question]
    if sup != "" then puts sup end
    puts "（初期値：#{DEFAULT[item][:default] == true ? option1 : option2} [ENTERキー]）"
    answer = gets.chomp
    case answer
        when "y" then
            $overwrite[item] = true
        when "n" then
            $overwrite[item] = false
        when "" then
            $overwrite[item] = DEFAULT[item][:default]
    end
end

###################################################################################################
## ↓ 関数（リネーム/連番化 結果）
###################################################################################################

# 0をつけて桁数を揃える
def makeNum
    calc = $overwrite[:digitNum].to_i - $renameInt.to_s.length
    num = $renameInt.to_s
    if calc > 0
        int = 0        
        while int < calc do
            num = "0" + num
            int += 1
        end
    end
    return num
end

###################################################################################################
## ↓ 関数（リネーム実行）
###################################################################################################

# ファイル名の重複の確認
def dupFile
    list = []
    $after.each do |item|        
        $overwrite[:copyImg] && $before.include?(item) ? list.push(item) : nil
    end
    return list
end

# ファイルの複製
def copyFile
    int = 1
    $before.each do |item|
        copyPath = "_copy_#{int}#{$overwrite[:imgExt]}"
        $targetFile.push(copyPath)
        FileUtils.cp(item, copyPath)
        int += 1
    end
    return true
end

# 変更前の画像名の画像削除
def deleteFile
    if $overwrite[:copyImg] == false
        $before.each do |item|
            FileUtils.rm(item)
        end
    end
    return true
end

###################################################################################################
## ↓ 関数（その他）
###################################################################################################

# 改行
def newLine
    puts "---------------------------------------------------------------"
    puts "\n"
end

# 確認
def confirm(string)
    puts "\n"
    puts string
    puts "(y:実行　n:最初から設定をやり直す)[Y/N]"
    answer = gets.chomp
    case answer
        when "","y"
            return true
        when "n"
            action()
        else
            action()
    end
end

# 警報
def alert(string)
    puts "\n"
    puts string
    puts "\n"
    puts $errorLog
    puts "\n"
    puts "(最初から設定をやり直す [ENTERキー]）"
    gets.chomp
    action()
end

###################################################################################################
## ↓ 全体的な流れ
###################################################################################################

# 実行／再実行
def action
    if setting() && resultSetting() && resultPath() && rename()
        puts '連番化が完了しました'
        gets.chomp
        exit
    end
end

# プログラム実行
action()

## setting()       設定
## resultSetting() 設定結果
## resultPath()    リネーム/連番化 結果
## rename()        リネーム実行
