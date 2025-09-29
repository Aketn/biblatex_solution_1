# Translator Macro Demo

欧米語文献に `trans. by` を表示し、日本語文献では訳者名の末尾に「訳」を追加する `biblatex` カスタマイズの最小実装です。`Themes/mymacro.sty` をプロジェクトに取り込み、LuaLaTeX + Biber でビルドすると、言語に応じた訳者ブロックの出し分けを確認できます。本リポジトリには LuaLaTeX のワークフローを前提にした `.latexmkrc` も同梱しており、同じ設定を手元環境にコピーするだけで再現できます。

## 構成

- `main.tex` — デモ本文。`Themes/mymacro.sty` を読み込み、サンプル引用を表示します。
- `Themes/mymacro.sty` — 既存環境から切り出したカスタムスタイル一式。訳者判定やレイアウト調整を含みます。
- `bib/references.bib` — 欧米語と日本語の文献を含むテスト用 BibTeX データ。
- `.latexmkrc` — LuaLaTeX + Biber を標準にした `latexmk` 設定。`.dat` ファイルのハッシュを無視して再実行ループを防ぎます。

## ビルド手順

LuaLaTeX と Biber を使用し、以下のコマンドを実行します。

```powershell
latexmk -lualatex -synctex=1 -interaction=nonstopmode -file-line-error main.tex
```

ビルド後、`main.pdf` の参考文献で以下を確認できます。

- `nowak2018`（英語文献）: `trans. by` の接頭辞が表示され、訳者名が英字表記で整形される。
- `kant2022`（日本語文献）: 訳者名の末尾に「訳」が付与され、欧文接頭辞は出力されない。

## `.latexmkrc` 取り扱いガイド

1. プロジェクト直下の `.latexmkrc` を VS Code などで開き、必要に応じてコマンドパスやプレビューア設定を調整してください。
2. 既存環境に同じ設定を適用する場合は、ユーザーディレクトリ（Windows なら `%USERPROFILE%`）へコピーするか、任意のプロジェクト直下に配置します。
3. `latexmk` はカレントディレクトリを再帰的に探索して `.latexmkrc` を読み込みます。別ディレクトリからビルドする場合は `-r` オプションで設定ファイルを指定できます。
4. `version.dat` のように毎回更新されるファイルは、既定でハッシュ比較から除外されるため、再コンパイルが無限ループするケースを防げます。詳細は補足資料を参照してください。

## 追加リソース

- Qiita: [latexmk の設定や使い方まとめ](https://qiita.com/alpaca-honke/items/f30a2d04eedaa3c36a21)
- リポジトリ内資料: `../docs/latexmk_troubleshooting_report.md` — `.dat` ファイルを巡る再実行ループの原因分析と対策を掲載。

## 再利用メモ

1. プロジェクトに `Themes/mymacro.sty` をコピーし、`\input{Themes/mymacro.sty}` を追加する。
2. `biblatex` の `langid` フィールドに言語ラベル（`english`／`japanese` など）を設定する。
3. LuaLaTeX + Biber でビルドし、PDF内の訳者表示を確認する。
