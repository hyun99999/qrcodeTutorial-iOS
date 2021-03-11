# QRCodeTutorial-ios-practice
QRCodeReader 오픈소스 라이브러리를 활용한 튜토리얼

<img src = "https://user-images.githubusercontent.com/69136340/104285623-3ce18500-54f7-11eb-8310-1951f6d89ba1.png" width = "400">
<img src = "https://user-images.githubusercontent.com/69136340/104285675-4ff45500-54f7-11eb-853f-b3a2897dc3d9.png" width = "400">
<img src = "https://user-images.githubusercontent.com/69136340/104285724-5da9da80-54f7-11eb-9cb1-3769dabf3049.png" width = "400">

1. 사진을 찍는다 -> qrcode 인식
2. URL 주소로 만든다.
3. 주소를 웹뷰에 띄어준다.
4. 오픈소스 라이브러리로 qrcode 읽어낸다.

- webkit 사용하기 위해서 **project 의 build phases 에서 설정.**
- 인터넷을 사용하기 위해서 **info plist 에서 App Transport Security Settings 에서 Allow Arbitrary loads 를 Yes 로 설정.**
- camera 사용하기 위해서 **info plist 에서 Privacy - Camera Usage Description 에 description 입력.**

**라이브러리**
오픈소스 라이브러리 : 
https://github.com/yannickl/QRCodeReader.swift

- installation 따라서 설치 후 확인.
- usage 따라서 진행.
- 성공 시 webview 에 URLRequest 를 통해서 주소를 전달.

## 에러
- 일반적인 qr코드로 진행할때는 성공했는데 url값에 한글이 들어가면 옵셔널 에러가 발생했다.(마치 나무위키에서 qr코드를 소개하는 url처럼. https://namu.wiki/w/QR코드)
<img src = "https://user-images.githubusercontent.com/69136340/104285275-b75dd500-54f6-11eb-86de-0c8096388532.png">

- **주소에 띄어쓰기나 한글이 들어갈 경우 url 로 변환할 때(인코딩) nil 이 될 수 있다고 한다.**
- ! 을 통한 강제 추출 중에 에러가 발생했기 때문에 qr코드를 url로 만들때 nil이 아니라는 보장이 없어졌다.
- 해결하기 위해서 우선 optional binding 으로 unwrap.
- 한글과 띄어쓰기 등의 url 변환문제를 해결.
```swift
//addingPercentEncoding 의 옵션 .urlQueryAllowed 으로 지정된 set 에 없는 문자(띄어쓰기, 한글)를 바꾸어 새로운 문자열을 반환해주는 함수다.
if let unwrappedResult = (result?.value)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
  //URL 로 변경시 옵셔널 타입이 된다.
  let unwrappedUrl = URL(string: unwrappedResult)
  //url 의 값을 꺼낵 위해서 다시 한번 더 옵셔널 바인딩
  if let url = unwrappedUrl {
      self.webView.load(URLRequest(url: url))
  }
}
```
## 해결
- 한글을 포함한 url의 qr코드도 실행. (https://namu.wiki/w/QR코드)
<img src ="https://user-images.githubusercontent.com/69136340/104292239-ecbaf080-54ff-11eb-8dad-da63547b177b.png" width="400">


참고예제 : [개발하는 정대리]https://www.youtube.com/watch?v=Q5slh29MZ_I&list=PLgOlaPUIbynqRzpQBIdEDnjDdkVsjHqxK&index=5 
