# Translator Macro Demo

`Themes/` ディレクトリに最新の `mymacro.sty` と 3 種類の BibLaTeX プロファイル (`mybiblatex1/2/3.sty`) を格納し、言語別の訳者表示・参考文献グルーピングを再現するための最小構成プロジェクトです。LuaLaTeX + Biber を想定しており、`.latexmkrc` をそのまま流用すればワンコマンドでビルドできます。

## 主なポイント

- `mymacro.sty`: LuaLaTeX 向けの共通マクロ。フォントフォールバック、`jlreq` の調整、穴埋め問題の Lua 自動採番などを提供します。
- `mybiblatex1/2/3.sty`: 言語グループごとの出し分け・訳者表記を担う BibLaTeX プロファイル。用途に応じて読み替え可能です。
- `bib/references.bib`: `langid` を使った新しいサンプルデータ。西洋文献、翻訳文献（2 パターン）、日本語文献を含み、グループ見出しと訳者書式の違いが掴めます。

## クイックスタート

1. 任意のプロジェクトへ `Themes/` と `bib/` ディレクトリをコピーし、`\input{Themes/mymacro.sty}` および必要な `mybiblatex*.sty` をプレアンブルに追加します。
2. BibLaTeX のオプションは `\usepackage[backend=biber,style=authoryear]{biblatex}` が起点です。プロファイル側で `sorting=lnyt` などを自動指定します。
3. 参考文献の `langid` を下表のルールで付与し、Biber を通してビルドします。

PowerShell からのビルド例:

```powershell
latexmk -lualatex -synctex=1 -interaction=nonstopmode -file-line-error main.tex
```

## BibLaTeX プロファイルの選び方

- `mybiblatex1.sty` — 最小構成。脚注引用の姓のみ化、訳者接尾辞、LangID ベースのグルーピングを行います。
- `mybiblatex2.sty` — 本文と参考文献の両方で混在表記を整形。`dashed=true`、モノニム著者向け区切り調整、視覚的なグループ見出しを含みます。
- `mybiblatex3.sty` — `style=authoryear` をターゲットにした拡張版。`textcite` の括弧づけや `nameyeardelim` まで最適化しています。（デモではこちらを読み込んでいます。）

複数のプロファイルを試す場合は、`
\input{Themes/mybiblatexX.sty}` 部分を差し替えるだけで挙動の違いを比較できます。

## `langid` の割り当て指針

| `langid` 値        | 用途 / 出力                      | 例示キー |
|--------------------|----------------------------------|----------|
| `English` など西洋 | 欧米語文献。`trans.~by` 付き訳者 | `nowak2018` |
| `transJPN`         | 翻訳書（名→姓を中点で連結）      | `franklin2023` |
| `transJPNfamily`   | 翻訳書（姓→名を維持、コンマ区切り）| `ishikawa2024` |
| `Japanese`         | 日本語原著。訳者末尾に「訳」      | `kant2022` |

追加で `usera` を指定すると、背後の `sorting=lnyt` が明示的ソートキーとして使用します。

## サンプルデータで確認できること

- `nowak2018`: 西洋文献の訳者に `trans.~by` が付与され、名前区切りが英語スタイルになります。
- `franklin2023` / `ishikawa2024`: 翻訳文献グループが見出し「翻訳文献」として挿入され、訳者の名寄せが `langid` に応じて変化します。
- `kant2022`: 日本語文献セクションが「日本語文献」として出力され、訳者名の末尾に「訳」が付与されます。

## プロジェクト構成

- `main.tex` — プロファイルの読み込み例と引用サンプル。
- `Themes/` — `mymacro.sty` と 3 種類の BibLaTeX プロファイル。
- `bib/references.bib` — 新しい `langid` 規約で整備したサンプルデータ。
- `.latexmkrc` — LuaLaTeX + Biber ワークフローを前提にした設定ファイル。
- `docs/latexmk_troubleshooting_report.md` — `.dat` ファイルで再コンパイルがループする際の調査ノート。

## ビルドと運用のヒント

1. `.latexmkrc` はプロジェクト直下に置いたままでも、ユーザーディレクトリにコピーして共通設定としても使用できます。
2. `version.dat` など常時更新されるファイルは設定済みの無視リストによりハッシュ比較から除外され、無限ループを避けられます。
3. Bib ファイルを更新したら `latexmk -c` で補助ファイルを一掃し、再コンパイルすると状態が揃います。

## 追加リソース

- Qiita: [latexmk の設定や使い方まとめ](https://qiita.com/alpaca-honke/items/f30a2d04eedaa3c36a21)
- リポジトリ内資料: `../docs/latexmk_troubleshooting_report.md`

このリポジトリの `main.pdf` をビルドすれば、上記の挙動をそのまま確認できます。プロファイルを差し替えつつ、`langid` の運用ルールをチームに展開するサンプルとしてご活用ください。
