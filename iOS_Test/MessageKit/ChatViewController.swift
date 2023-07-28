//
//  ChatViewController.swift
//  iOS_Test
//
//  Created by 이정동 on 2023/07/24.
//

import UIKit
import SnapKit

class ChatViewController: UIViewController {
    
    private lazy var bannerView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    private lazy var chatView: UIView = {
        let view = UIView()
        return view
    }()
    
    let chatRoomViewController = ChatRoomViewController()
    
//    /// Required for the `MessageInputBar` to be visible
//    override var canBecomeFirstResponder: Bool {
//      chatRoomViewController.canBecomeFirstResponder
//    }
//
//    /// Required for the `MessageInputBar` to be visible
//    override var inputAccessoryView: UIView? {
//      chatRoomViewController.inputAccessoryView
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addSubviews()
        configureConstraints()

        navigationController?.navigationBar.isHidden = true
    }
    
    func addSubviews() {
        view.addSubview(bannerView)
        view.addSubview(chatView)
        
        addChild(chatRoomViewController)
        chatView.addSubview(chatRoomViewController.view)
    }
    
    func configureConstraints() {
        bannerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(60)
        }
        
        chatView.snp.makeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        chatRoomViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        chatRoomViewController.didMove(toParent: self)
    }
    
}
