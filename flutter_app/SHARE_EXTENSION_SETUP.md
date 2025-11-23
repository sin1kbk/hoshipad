# iOS Share Extension 設定ガイド

このガイドでは、XcodeでShare Extensionを設定し、SafariからhoshipadアプリにレシピURLを共有できるようにする手順を説明します。

## 前提条件

- macOS上でXcodeがインストールされている
- `receive_sharing_intent`パッケージが既にインストールされている（`flutter pub get`実行済み）

## ステップ1: Xcodeでプロジェクトを開く

1. ターミナルで以下のコマンドを実行：

```bash
cd /Users/bacchus/dev/sin1kbk/hoshipad/flutter_app/ios
open Runner.xcworkspace
```

> [!IMPORTANT]
> `.xcodeproj`ではなく、`.xcworkspace`を開いてください。

## ステップ2: Share Extension Targetを追加

1. Xcodeの左側のProject Navigatorで、一番上の`Runner`プロジェクトをクリック
2. メニューバーから `File` → `New` → `Target...` を選択
3. テンプレート選択画面で：
   - 上部のタブで `iOS` を選択
   - スクロールして `Share Extension` を探してクリック
   - `Next` をクリック
4. Share Extensionの設定：
   - **Product Name**: `ShareExtension`
   - **Team**: あなたのApple Developer Team（ドロップダウンから選択）
   - **Organization Identifier**: 既存のBundle Identifierと同じもの
   - **Bundle Identifier**: 自動的に`com.yourorg.hoshipadApp.ShareExtension`のような形式になります
   - **Language**: `Swift`
   - `Finish` をクリック
5. 「Activate "ShareExtension" scheme?」と聞かれたら `Activate` をクリック

## ステップ3: Share ExtensionのInfo.plistを設定

1. Project Navigatorで `ShareExtension` フォルダを展開
2. `Info.plist` ファイルを右クリック → `Open As` → `Source Code` を選択
3. 以下のように編集します：

`NSExtensionActivationRule`の部分を探し、以下のように変更：

**変更前（例）：**

```xml
<key>NSExtensionActivationRule</key>
<string>TRUEPREDICATE</string>
```

**変更後：**

```xml
<key>NSExtensionActivationRule</key>
<dict>
    <key>NSExtensionActivationSupportsWebURLWithMaxCount</key>
    <integer>1</integer>
    <key>NSExtensionActivationSupportsWebPageWithMaxCount</key>
    <integer>1</integer>
</dict>
```

この設定により、WebページやURLを共有する際にShare Extensionが表示されるようになります。

## ステップ4: App Groupsを設定

Share Extensionとメインアプリがデータを共有するには、App Groupsを設定する必要があります。

### 4.1 メインアプリ（Runner）にApp Groupsを追加

1. Project Navigatorで`Runner`プロジェクトを選択
2. `TARGETS`セクションで`Runner`を選択
3. `Signing & Capabilities`タブをクリック
4. `+ Capability`ボタンをクリック
5. `App Groups`を検索して追加
6. `+`ボタンをクリックして新しいApp Groupを作成：
   - `group.com.yourorg.hoshipadApp`（あなたのBundle Identifierに合わせて変更）
7. チェックボックスをオンにして有効化

### 4.2 ShareExtensionにApp Groupsを追加

1. `TARGETS`セクションで`ShareExtension`を選択
2. `Signing & Capabilities`タブをクリック
3. `+ Capability`ボタンをクリック
4. `App Groups`を検索して追加
5. **同じApp Group**（`group.com.yourorg.hoshipadApp`）を選択してチェックボックスをオン

> [!IMPORTANT]
> 両方のTargetで**完全に同じApp Group ID**を使用してください。

## ステップ5: ShareViewController.swiftを編集

1. Project Navigatorで`ShareExtension/ShareViewController.swift`を開く
2. ファイルの内容を以下に置き換え：

```swift
import UIKit
import Social
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController {
    // メインアプリと同じApp Group IDを指定
    let appGroupId = "group.com.yourorg.hoshipadApp"
    let userDefaultsKey = "ShareKey"

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        if let content = extensionContext?.inputItems.first as? NSExtensionItem,
           let itemProvider = content.attachments?.first {

            // URLの処理
            if itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { [weak self] (url, error) in
                    if let shareURL = url as? URL {
                        self?.saveSharedData(shareURL.absoluteString)
                    }
                    self?.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                }
                return
            }

            // テキストの処理（URLがテキストとして共有される場合）
            if itemProvider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
                itemProvider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { [weak self] (text, error) in
                    if let shareText = text as? String {
                        self?.saveSharedData(shareText)
                    }
                    self?.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                }
                return
            }
        }

        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        return []
    }

    private func saveSharedData(_ data: String) {
        let userDefaults = UserDefaults(suiteName: appGroupId)
        userDefaults?.set(data, forKey: userDefaultsKey)
        userDefaults?.synchronize()

        // メインアプリを開くためのURL Schemeを呼び出す
        openMainApp()
    }

    private func openMainApp() {
        guard let url = URL(string: "hoshipad://") else { return }

        var responder: UIResponder? = self as UIResponder
        let selector = #selector(openURL(_:))

        while responder != nil {
            if responder!.responds(to: selector) && responder != self {
                responder!.perform(selector, with: url, afterDelay: 0)
                break
            }
            responder = responder?.next
        }
    }

    @objc private func openURL(_ url: URL) {
        // このメソッドは動的に呼び出されます
    }
}
```

> [!WARNING]
> `appGroupId`の値を、ステップ4で設定したApp Group IDに変更してください！

## ステップ6: Info.plist（メインアプリ）にURL Schemeを追加

メインアプリの`Info.plist`にURL Schemeを追加します。

1. Project Navigatorで`Runner/Info.plist`を開く
2. ファイルを右クリック → `Open As` → `Source Code`
3. `</dict>`タグの**前**に以下を追加：

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>com.yourorg.hoshipadApp</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>hoshipad</string>
        </array>
    </dict>
</array>
```

> [!NOTE]
> `CFBundleURLName`はあなたのBundle Identifierに変更してください。

## ステップ7: ビルドして実行

1. Xcodeの上部のScheme選択ドロップダウンで`Runner`を選択（ShareExtensionではない）
2. デバイスまたはシミュレータを選択
3. ビルドして実行（⌘R）

## 動作確認

1. iPhoneのSafariでCookpadのレシピページを開く（例：`https://cookpad.com/recipe/123456`）
2. 共有ボタン（四角と上矢印のアイコン）をタップ
3. アクティビティビューで下にスクロール
4. 「hoshipad」アイコンが表示されるのでタップ
5. hoshipadアプリが起動し、レシピ追加画面が開く
6. URLフィールドにCookpadのURLが自動入力される

## トラブルシューティング

### Share Extensionが表示されない

- App Groupsが両方のTargetで正しく設定されているか確認
- `Info.plist`の`NSExtensionActivationRule`が正しく設定されているか確認
- アプリを一度アンインストールしてから再インストール

### アプリが開かない

- URL Schemeが正しく設定されているか確認（`Info.plist`）
- `ShareViewController.swift`の`appGroupId`が正しいか確認

### URLが渡されない

- App Group IDが両方のTargetで**完全に同じ**か確認
- `ShareViewController.swift`の`userDefaultsKey`が正しいか確認
- Flutterコードで同じApp Group IDとキーを使用しているか確認

## 次のステップ（オプション）

現在の実装では、URLのみを受け取っています。今後、以下の機能を追加できます：

1. **メタデータの自動取得**: URLからタイトルや画像を自動的に取得
2. **カスタムUI**: Share Extensionに独自のUIを実装
3. **オフライン対応**: ネットワークがない場合の処理

これらの機能を追加したい場合は、お知らせください！
