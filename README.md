# Topic Board

<img src="app/assets/images/free_images/logo_ogp.png" width="250">

## 目次
- [サービス概要](#サービス概要)
- [サービスURL](#サービスURL)
- [サービス開発の背景](#サービス開発の背景)
- [機能紹介](#機能紹介)
- [使用技術](#使用技術)

## サービス概要

本サービスは、多彩なテーマについて自由にトピックを作成し、フレームを追加して情報を共有できる掲示板です。直感的で使いやすいデザインにより、投稿や編集もスムーズに行えます。さらに、コメント機能を通じてユーザー同士が気軽に交流でき、興味のある話題について深く語り合うことができます。多様なテーマを自由に楽しめる、開かれたコミュニティを提供します。

## サービスURL

https://topic-board.jp

## サービス開発の背景

私がこのサービスを作りたいと思い至った理由は、誰でも気軽に情報共有をしたり好きに語ったりできる場を提供したいと考えたからです。昔、友人と漫画や映画など特定のテーマについて話すことが好きだった一方、最近ではそういった機会が少ないと感じていました。そこで、気軽に自分の好きなテーマについて好きに語ったり、他の人の意見を聞いたりできる場があればいいなと思い、本サービスの作成に取り掛かりました。

ユーザーは自身の興味や関心に基づいて新しいトピックを簡単に作成できます。たとえば、映画、音楽、旅行、料理などのテーマに関するトピックを立ち上げることができます。これにより、自分の好きなことを発信する場が得られ、共通の趣味・関心を持つユーザーとの交流を楽しむことができます。また、ユーザーは他の投稿に対してコメントを行うことができ、気軽に意見や感想を交換することができます。これにより、活発なディスカッションが生まれ、さまざまな視点やアイディアを得ることができます。
このように、本サービスはユーザーが自由に情報を発信し、交流することで多くの価値を提供することを目指しています。

## 機能紹介
このサービスの特徴は、直感的で使いやすいデザインと、自由にトピックを作成できる柔軟性にあります。多くの掲示板サービスはテーマが限定されていたり、複雑な操作を必要としたりしますが、このサービスではユーザーが自分の興味に基づいて簡単にトピックを立ち上げることができます。さらに、トピックの内容ごとにフレーム分けることができるので、情報が整理されて見やすくなるのも大きなポイントです。フレームを区切ることで情報をまとめやすく、視覚的にもわかりやすくなります。

#### トピックの作成
- あるトピックについて、関連するトピックを紐づけて作成できます

![トピック](https://github.com/user-attachments/assets/04c0bdd7-ab46-446b-8f41-d79837cd7cd7)

#### フレーム（トピックの内容）の作成

![テキストフレーム](https://github.com/user-attachments/assets/3ae7a99f-8cf7-47a3-ab18-0e0580395a65)

#### フレームの作成（画像）

![画像フレーム](https://github.com/user-attachments/assets/4cb02eb6-2e5b-4696-a243-27d785125583)

## 使用技術
| カテゴリ  | 技術 |
| ------------- | ------------- |
| サーバーサイド  | Ruby on Rails 8.0.0・Ruby 3.2.2 |
| フロントエンド | Ruby on Rails・JavaScript |
| web API | Google API |
| データベースサーバー | PostgreSQL |
| ファイルサーバー | AWS S3 |
| アプリケーションサーバー | Render |
| バージョン管理ツール | GitHub |

## ER図
<img src="app/assets/images/free_images/ER.drawio.png" width="500">
