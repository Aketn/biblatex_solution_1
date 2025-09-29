# Translator Macro Demo 用 latexmk 設定
# LuaLaTeX + BibLaTeX を前提に最小構成を記載しています。

# LuaLaTeX / Biber のコマンド設定
$lualatex = 'lualatex %O -synctex=1 -interaction=nonstopmode -file-line-error %S';
$biber    = 'biber %O --bblencoding=utf8 -u -U --output_safechars %B';

# LuaLaTeX + BibLaTeX ワークフローを既定にする
$pdf_mode = 4;      # 4 = LuaLaTeX で直接 PDF を生成
$bibtex_use = 2;     # Biber を利用

# BibLaTeX の依存関係解決
add_cus_dep('bcf', 'bbl', 0, 'run_biber');
sub run_biber {
    system "biber --bblencoding=utf8 -u -U --output_safechars $_[0]";
}

# 日本語文書向けツールチェーン（必要に応じて利用）
$latex    = 'uplatex %O -kanji=utf8 -no-guess-input-enc -synctex=1 -interaction=nonstopmode %S';
$pdflatex = 'pdflatex %O -synctex=1 -interaction=nonstopmode %S';
$xelatex  = 'xelatex %O -no-pdf -synctex=1 -shell-escape -interaction=nonstopmode %S';
$makeindex = 'upmendex %O -o %D %S';
$dvipdf    = 'dvipdfmx %O -o %D %S';
$dvips     = 'dvips %O -z -f %S | convbkmk -u > %D';
$ps2pdf    = 'ps2pdf.exe %O %S %D';

# Windows の既定 PDF ビューワで開く
$pdf_previewer = "start %S";

# version.dat など .dat ファイル更新による再実行ループを抑止
$hash_calc_ignore_pattern{'dat'} = qr/./;

# 参考: より詳細な設定例やトラブルシュートはリポジトリの README を参照
