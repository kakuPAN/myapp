# Topic Board

■サービス概要
どんなサービスなのかを３行で説明してください。

本サービスは、多彩なテーマについて自由にトピックを作成し、フレームを追加して情報を共有できる掲示板です。直感的で使いやすいデザインにより、投稿や編集もスムーズに行えます。さらに、コメント機能を通じてユーザー同士が気軽に交流でき、興味のある話題について深く語り合うことができます。多様なテーマを自由に楽しめる、開かれたコミュニティを提供します。

■ このサービスへの思い・作りたい理由
このサービスの題材となるものに関してのエピソードがあれば詳しく教えてください。
このサービスを思いつくにあたって元となる思いがあれば詳しく教えてください。

私がこのサービスを作りたいと思い至った理由は、誰でも気軽に情報共有をしたり好きに語ったりできる場を提供したいと考えたからです。昔、友人と漫画や映画など特定のテーマについて話すことが好きだった一方、最近ではそういった機会が少ないと感じていました。そこで、気軽に自分の好きなテーマについて好きに語ったり、他の人の意見を聞いたりできる場があればいいなと思い、本サービスの作成に取り掛かりました。

■ ユーザー層について
決めたユーザー層についてどうしてその層を対象にしたのかそれぞれ理由を教えてください。

本サービスは、主に趣味を持つ人をターゲットとしています。本サービスではユーザーが自分の趣味に関する話題を気軽に投稿できるプラットフォームを提供することで、同じ興味を持つ仲間と交流し、意見や感想を交わす場を作り出します。これにより、ユーザーの興味・趣味について語りたいという欲求を満たしつつ、ユーザー同士が深い理解や新たな視点を得られる機会を提供します。

■サービスの利用イメージ
ユーザーがこのサービスをどのように利用できて、それによってどんな価値を得られるかを簡単に説明してください。

ユーザーは自身の興味や関心に基づいて新しいトピックを簡単に作成できます。たとえば、映画、音楽、旅行、料理などのテーマに関するトピックを立ち上げることができます。これにより、自分の好きなことを発信する場が得られ、他のユーザーと共通の興味を持つ仲間との交流を楽しむことができます。
また、ユーザーは他の投稿に対してコメントを行うことができ、気軽に意見や感想を交換することができます。これにより、活発なディスカッションが生まれ、さまざまな視点やアイディアを得ることができます。
このように、本サービスはユーザーが自由に情報を発信し、交流することで多くの価値を提供することを目指しています。

■ ユーザーの獲得について
想定したユーザー層に対してそれぞれどのようにサービスを届けるのか現状考えていることがあれば教えてください。

■ サービスの差別化ポイント・推しポイント
似たようなサービスが存在する場合、そのサービスとの明確な差別化ポイントとその差別化ポイントのどこが優れているのか教えてください。
独自性の強いサービスの場合、このサービスの推しとなるポイントを教えてください。

このサービスの差別化ポイントは、直感的で使いやすいデザインと、自由にトピックを作成できる柔軟性にあります。多くの掲示板サービスはテーマが限定されていたり、複雑な操作を必要としたりしますが、このサービスではユーザーが自分の興味に基づいて簡単にトピックを立ち上げることができます。さらに、フレームを追加できる機能があることで、情報が整理されて見やすくなるのも大きなポイントです。フレームを区切ることで情報をまとめやすく、視覚的にもわかりやすくなります。


■ 機能候補(MVP以前の予定)
現状作ろうと思っている機能、案段階の機能をしっかりと固まっていなくても構わないのでMVPリリース時に作っていたいもの、本リリースまでに作っていたいものをそれぞれ分けて教えてください。

＜MVPリリース時に実装したい機能＞
○ユーザーについて
▶︎ユーザー登録
　・ユーザー名
　・簡単なプロフィール
▶︎タスクの設定
　・タスクの作成　
　　・タイトル
　　・期限
　　・内容
　・「進行中」、「達成」のステータスの設定
　・他ユーザーに対する公開・非公開の設定
　▶︎タスクリスト
  　・街の掲示板にユーザーのタスクが掲示されている。
  　・進行中などのステータスが確認できる。
  　・タスクに対して応援コメントなどができても良い。

○タスクの達成とポイントについて
▶︎タスクの達成状況に応じたポイント付与
　・その日に設定されたタスクの数と、その内達成されたものの数からタスクの達成度を計算し、街に達成度に応じたポイント
　　を付与する。
　・街の保有ポイントは、タスクの達成度が５０％未満の場合、またはタスクが設定されない時間が一定時間を超えた場合に減少す
　　る。ポイントが０を下回った場合、街の中のオブジェクトが一つ減少する。

○定期実行する機能
▶︎リザルトの表示
　・１日に１回、その日のタスク達成度の結果を表示する。
　・誰が何のタスクを達成したのかを一覧表示する。いいね機能などあればいい。

▶︎オブジェクト設置・削除
　・リザルト発表時に保有ポイントが０を下回っていた場合、オブジェクトを削除する。保有ポイントが１００を超えていた場合、
　　新たなオブジェクトを設置する。（全ての設置場所が埋まっていた場合はランダムで置き換える。）

▶︎つぶやき機能
　・短文を投稿すると、街の中に吹き出しとして表示される。
　・投稿はその日の内のランダムなタイミングで、繰り返し表示される。

＜本リリースまでに実装したい機能＞
▶選択できる街の追加
　・デフォルトの「大都市の街」に加え、「田舎の街」、「雪の街」、「海辺の街」、「天空の街」など複数の街を用意する。
　・ユーザーは、ユーザー登録時にいずれかの街を選択する。

▶︎街に昼・夜の区別をつける
　・ホーム画面に時計を表示させる。
　・７：００〜１７：００までを昼、それ以外を夜として区別をつける。
　・UI、背景、オブジェクトを昼用と夜用を分けて用意し、時間によって入れ替える。

▶︎イベント
　・土日に特殊イベントが発生
　　・例えば、「今週土曜日に街に怪獣が襲来します！期日までにタスクをこなし、ポイントを貯めて防衛隊を整備しよう！」な
　　　ど。土日にタスクを設定することを促す。
　　・失敗すると保有ポイントが減少し、オブジェクトも消去される。

■ 機能の実装方針予定(MVP以前の予定)
一般的なCRUD以外の実装予定の機能についてそれぞれどのようなイメージ(使用するAPIや)で実装する予定なのか現状考えているもので良いので教えて下さい。

▶︎画像・アニメーションの扱い
　・オブジェクト用に画像を多用することが予想されるため、WebPファイルを使用して軽量化する。railsのpicture_tagヘルパ
　　ーを使用して実装する。
　・オブジェクトに簡単な動きをつけたいので、GIFファイルやCSSプロパティを使用する。

以下、主に使用するgem

# 画像加工
gem 'carrierwave'
gem 'mini_magick'

# 保有ポイント等の遷移グラフ
gem 'chartkick'

# 入力フォーム
gem 'turbo-rails'
gem 'simple_form'

# ページネーション
gem 'kaminari'
gem 'kaminari-i18n'

# スライド
gem 'swiper'

# パンくずリスト
gem 'gretel'

# 認証
gem 'pundit'
gem 'sorcery'

# 定期実行
gem 'whenever'

# フォント
gem 'bootstrap-sass'
gem 'font-awesome-rails'

# UI/UX
gem 'rails-i18n'
gem 'jbuilder'
gem 'meta-tags'

# アプリケーションサーバー
gem 'puma'

# ストレージ
gem 'aws-sdk-s3', require: false
gem 'image_processing'

# デバッグ
gem 'pry-byebug'

▶︎画面遷移図(MVP以前)
https://www.figma.com/design/LNoV7BkVCoRH8SfHYSSKxP/%E3%82%BF%E3%82%B9%E3%82%AF%E7%AE%A1%E7%90%86%E2%9C%96%EF%B8%8E%E8%A1%97%E3%81%A5%E3%81%8F%E3%82%8A?node-id=0-1&t=gIxH8MtqJKMTlBpX-1

▶︎ER図(MVP以前)
https://drive.google.com/file/d/1TkIv1CYKVMZfh9OBLdjJxYjb2tp-L8MI/view?usp=sharing
