# 資料一覧
コードなど分かりにくい点あるかと思いますがご了承ください。間違い等発見されましたらご指摘ください。

## scraping_part.R 
スクレイピングのコードです。実行に時間がかかる点にご留意ください。適宜改善していただけると幸いです。
また鬼仏表のサイトは日々更新されているので再現性は保証できません。その点もご留意ください。
univ_in_pref.csvとtohoku_uni.csvというかたちでデータが書き出されます。

## univ_in_pref.csv
鬼仏表サイトに登録されてある大学のURLと大学名、評価投稿数のデータファイルです。

## tohoku_uni.csv
東北大学の授業の評価（rec）とレポートの有無（report）、出席の有無（attend）のデータファイルです。

## analysis_part.R
分析パートです。

## Sendai_R_2_presentation.pdf
発表に使用したスライドです。

## scraping_purrr.R
takuizumさんによって作成された、scraping_part.Rの一部をpurrrを使用して高速化したverです。
takuizumさんのページ：https://github.com/takuizum

## scraping_tohoku_purrr.R
takuizumさんによって作成された、scraping_part.Rの一部をpurrrを使用して高速化したverです。
takuizumさんのページ：https://github.com/takuizum
