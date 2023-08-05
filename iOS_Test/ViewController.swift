//
//  ViewController.swift
//  iOS_Test
//
//  Created by 이정동 on 2023/07/24.
//

import UIKit
import SnapKit
import StompClientLib

class ViewController: UIViewController, StompClientLibDelegate {
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("이동", for: .normal)
        return button
    }()
    
    private lazy var connectButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("연결", for: .normal)
        return button
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("보내기", for: .normal)
        return button
    }()
    
    var socketClient = StompClientLib()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        view.addSubview(button)
        view.addSubview(connectButton)
        view.addSubview(sendButton)
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        connectButton.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(connectButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        connectButton.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        navigationController?.pushViewController(CustomChatRoomViewController(), animated: true)
    }
    
    @objc func connectButtonTapped() {
        connectSocket()
    }
    
    @objc func sendButtonTapped() {
        stompClientDidConnect(client: socketClient)
    }
    
    func connectSocket() {
        let url = NSURL(string: "http://localhost:8080/ws")! // 웹소켓 서버 URL을 입력하세요
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL), delegate: self)
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("Stomp client connected!")
        // 구독하려는 주제를 등록하세요 예: "/topic/messages"
        socketClient.subscribe(destination: "/sub/channel/53")
        // 데이터 전송을 위해 JSON 문자열을 사용할 수 있습니다.
        let jsonObject: [String : Any] = [
            "userId": 37,
            "partyId": 53,
            "content": "hi",
            "type": 0
        ]
        if let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
           let jsonString = String(data: data, encoding: .utf8) {
            socketClient.sendJSONForDict(dict: jsonString as AnyObject, toDestination: "/pub/redisChat")
        }
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Stomp client disconnected!")
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("Receipt: \(receiptId)")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("Error: \(String(describing: message))")
    }
    
    func serverDidSendPing() {
        print("Server ping")
    }
    
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("Received message: \(String(describing: jsonBody))")
        // 메시지를 처리하는 데 필요한 작업을 수행합니다.
    }
    
    func disconnectSocket() {
        socketClient.disconnect()
    }
}


