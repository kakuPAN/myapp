▶︎画面遷移図　
https://www.figma.com/design/LNoV7BkVCoRH8SfHYSSKxP/%E3%82%BF%E3%82%B9%E3%82%AF%E7%AE%A1%E7%90%86%E2%9C%96%EF%B8%8E%E8%A1%97%E3%81%A5%E3%81%8F%E3%82%8A?node-id=0-1&t=gIxH8MtqJKMTlBpX-1

▶︎ER図
https://drive.google.com/file/d/1TkIv1CYKVMZfh9OBLdjJxYjb2tp-L8MI/view?usp=sharing

■サービス概要
どんなサービスなのかを３行で説明してください。

本サービスは、「タスク管理✖︎街づくり」をテーマに、タスクをこなして街を発展させていく、ユーザー協力型ゲーム感覚のタスク管理サービスです。ユーザーは自分で設定したタスクを達成することでポイントを稼ぐことができ、そのポイントが街の発展のために使用されます。そのポイントの多寡によって、街にあるオブジェクトが増えたり減ったりすることで、常に変化する街並みを楽しむことができます。

■ このサービスへの思い・作りたい理由
このサービスの題材となるものに関してのエピソードがあれば詳しく教えてください。
このサービスを思いつくにあたって元となる思いがあれば詳しく教えてください。

タスク管理サービスを作ろうと決めた時に真っ先に取り入れたいと思ったことは「他のユーザーとの協力」という要素でした。タスクを先延ばしにしてしまう要因の一つは、自分で設定したタスクに対する責任感の薄さがあると思い、タスクを達成できなかった場合にユーザー全員に影響を与えるような状況を作りたいと考えました。また、ユーザーで協力して街づくりに取り組むという形を取ることで、タスクをこなした時の達成感にもつながると考え、「タスク管理✖︎街づくり」というテーマに至りました。

■ ユーザー層について
決めたユーザー層についてどうしてその層を対象にしたのかそれぞれ理由を教えてください。

本サービスではタスク管理が苦手な人をメインターゲットとしています。そういった人がタスクを達成できない理由として、設定したタスクに対しての責任感の薄さがあると考えられるので、その点に関してプレッシャーをかけるサービスには需要があると考えました。

■サービスの利用イメージ
ユーザーがこのサービスをどのように利用できて、それによってどんな価値を得られるかを簡単に説明してください。

ユーザーは自分で設定したタスクをこなすことで、自分の暮らす街にポイントを付与することができます。その街では保有するポイントを利用して建物を建てたり、逆に、ユーザーがタスクを達成できなかった場合、ポイントは減少し、街は衰退していきます。つまり、街を発展させ続けるためには、ユーザーが日々タスクを達成することが必要となります。ユーザーは日々変化していく街を楽しみながら、ゲーム感覚でタスクに取り組むことができます。

■ ユーザーの獲得について
想定したユーザー層に対してそれぞれどのようにサービスを届けるのか現状考えていることがあれば教えてください。

Instagram、Xでサービス利用画面を提示します。

■ サービスの差別化ポイント・推しポイント
似たようなサービスが存在する場合、そのサービスとの明確な差別化ポイントとその差別化ポイントのどこが優れているのか教えてください。
独自性の強いサービスの場合、このサービスの推しとなるポイントを教えてください。

タスク管理サービスは多数存在しますが、タスクの達成状況を視覚的に楽しむことができるサービスはあまり見られません。このサービスでは、タスクの達成度によって日々変化する街の様子を楽しむことができます。それに加えて、他のユーザーとの協力要素によって、自分のタスクに対して連帯感を持って取り組むことができます。

■ 機能候補
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

■ 機能の実装方針予定
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