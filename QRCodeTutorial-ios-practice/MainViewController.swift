//
//  ViewController.swift
//  QRCodeTutorial-ios-practice
//
//  Created by kimhyungyu on 2021/01/12.
//

import UIKit
import WebKit
import AVFoundation
import QRCodeReader

class MainViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var qrcodeBtn: UIButton!
    // Good practice: create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // Configure the view controller (optional)
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = false
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    //MARK: - 오버라이드 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let url = URL(string:
            "https://www.naver.com")
        let requestObj = URLRequest(url: url!)
        webView.load(requestObj)
        
        qrcodeBtn.layer.borderWidth = 3
        qrcodeBtn.layer.borderColor = UIColor.blue.cgColor
        qrcodeBtn.layer.cornerRadius = 10
        qrcodeBtn.addTarget(self, action: #selector(qrcodeReaderLaunch), for: .touchUpInside)
    }
    
    //MARK: - fileprivate methods
    @objc func qrcodeReaderLaunch(){
        print("MainViewController - qrcodeReaderLaunch called")
        // Retrieve the QRCode content
          // By using the delegate pattern
          readerVC.delegate = self

          // Or by using the closure pattern
          readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            print(result)
            //옵셔널 값 언랩
            if let unwrappedResult = (result?.value)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                let unwrappedUrl = URL(string: unwrappedResult)
                //웹 뷰에 url 띄우기
                if let url = unwrappedUrl{
                    self.webView.load(URLRequest(url: url))
                }
            }
            //강제 추출
//            guard let scannedUrlString = result?.value else { return }
//            let scannedUrl = URL(string: scannedUrlString)
//            //웹 뷰에 url 띄우기
//            self.webView.load(URLRequest(url: scannedUrl!))
          }

          // Presents the readerVC as modal form sheet
          readerVC.modalPresentationStyle = .formSheet
         
          present(readerVC, animated: true, completion: nil)
    }
    
    //MARK: - QRCodeReaderViewControllerDelegate methods
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
      reader.stopScanning()

      dismiss(animated: true, completion: nil)
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
      reader.stopScanning()

      dismiss(animated: true, completion: nil)
    }

}

