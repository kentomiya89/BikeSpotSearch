# バイク関連サーチ
現在地から周辺のバイク駐輪場やバイク屋を簡易的に探せるアプリです。
近場のバイク駐輪場を探すときに **「バイク駐輪場」** で探すと、バイクだけはなく自転車専用の駐輪場も候補として出て探しにくいです。
また走行中、自分のバイクに何かトラブルがあったときに見てもらうために最寄りのバイク屋も探します。
アプリを開くだけで、最寄りのバイク駐輪場とバイク屋を地図ベースで探せるというコンセプトでアプリを開発しました。

# スクリーンショット
アプリを開くと現在地から半径3000m以内にあるバイク駐輪場はバイクのアイコン、バイク屋はお店のアイコンでそれぞれ表示します。  
<img src="https://user-images.githubusercontent.com/26946838/102017246-1241c680-3da9-11eb-8051-89c016376d1d.png" width="200">
<img src="https://user-images.githubusercontent.com/26946838/102017263-2f769500-3da9-11eb-8e34-e41d309f2b71.png" width="200">
<img src="https://user-images.githubusercontent.com/26946838/102017267-31405880-3da9-11eb-9d09-aa7900e1a38c.png" width="200">


また、もしバイクの駐輪場を契約している場合に「My駐輪場」として追加することできます。長押しで何か名称をつけて登録するとMy駐輪場として地図に追加されます。  
<img src="https://user-images.githubusercontent.com/26946838/102017403-24703480-3daa-11eb-9250-e017b059ba9b.png" width="200">
<img src="https://user-images.githubusercontent.com/26946838/102017409-2803bb80-3daa-11eb-993e-69599200480c.png" width="200">


# 動作環境
* iOS 13.0以上

# 環境
* Xcode 12
* Swift 5
* CocoaPods: 1.10.0
* Mint: 0.16.0

[CocoaPods](https://qiita.com/ShinokiRyosei/items/3090290cb72434852460)と[Mint](https://qiita.com/uhooi/items/6a41a623b13f6ef4ddf0)のインストールしていない場合は導入からお願いします。
 
 # 使用技術
 * UI: Stroyboard + XIB
 * Architecture: 
   * MVP (地図画面)
   * MVVM (My駐輪場一覧画面)
 * Library
   * CocoaPods
     * GoogleMaps 4.1.0 
     * MaterialComponents 119.2.0
   * Swift Package Manager
     * Alamofire 5.4.0
     * PKHUD 5.4.0
     * Realm 10.3.0
     * RxSwift 6.0.0
     * RxRealm 5.0.1
     * RxDataSpurce 5.0.0
 * Mint
   * LicensePlist 3.0.5
   * SwiftGen 6.4.0
   * SwiftLint 0.41.0
  
# 地図に関して
APIはGoogleMapsPlatform [Place Search API](https://developers.google.com/places/web-service/search) を使って
GoogleMapのViewに関しては[Maps SDK for iOS](https://developers.google.com/maps/documentation/ios-sdk/overview)を使用しています。
Xcodeでビルドする際はGooglMapsPlatformでkeyの発行が必要になります。　**※ Place Search APIは初期の無料期間はあるがお金がかかるので注意**
MapViewの方は今のところは無料です。

# セットアップ
1. プロジェクトをクローンする
```
$ git clone https://github.com/kentomiya89/BikeSpotSearch.git
$ cd BikeSpotSearch
```
2. CocoaPodsからライブラリをインストール
```
$ pod install
```
3. Mintからパッケージをインストール
```
$ mint bootstap
```
4. APIKey.plistファイルをBikeSpotSearch/Resourcesに作成し以下のスクショのように追加します。
<img width="632" alt="スクリーンショット 2020-12-14 2 41 54" src="https://user-images.githubusercontent.com/26946838/102019276-07d9f980-3db6-11eb-9eed-d39d3b56586a.png">
Place Search APIはお金がかかるので頻繁にアクセスするのはという方はDemo用のJSONファイルも用意しています。
DemoスキームをビルドするとAPIキーなしで動くものを確認でき、データは国分寺〜府中近辺なので現在地をその辺りにずらすと
バイク駐輪場とバイク屋を確認できます。
