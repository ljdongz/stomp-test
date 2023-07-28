//
//  CustomChatRoomViewController.swift
//  iOS_Test
//
//  Created by 이정동 on 2023/07/28.
//

import UIKit
import SnapKit

class CustomChatRoomViewController: UIViewController {
    
    private lazy var keyboardInputBar: KeyboardInputBar = {
        let bar = KeyboardInputBar()
        bar.delegate = self
        return bar
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Property
    
    private var tapGesture = UITapGestureRecognizer()
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        
        addSubviews()
        configureConstraints()
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - viewWillDisappear
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - addSubviews()
    
    private func addSubviews() {
        view.addSubview(keyboardInputBar)
        view.addSubview(bottomView)
    }
    
    // MARK: - configureConstraints()
    
    private func configureConstraints() {
        keyboardInputBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(0)
        }
    }
    
    // MARK: - @objc func
    
    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillShow(_ notification: NSNotification){
        
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture) // 테이블 뷰에 추가해주기
        
        
        // 키보드의 높이만큼 화면을 올려준다.
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue

//            // 네비 바 + 상태 바 높이
//            let scenes = UIApplication.shared.connectedScenes
//            let windowScene = scenes.first as? UIWindowScene
//            let window = windowScene?.windows.first
        
//
//            let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//            let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
            
            UIView.animate(withDuration: 0.3) {
                //self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                let safeAreaBottom = self.view.safeAreaInsets.bottom
                
                self.bottomView.snp.updateConstraints { make in
                    make.height.equalTo(keyboardRectangle.height - safeAreaBottom)
                }
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHide(_ notification: NSNotification){
        
        view.removeGestureRecognizer(tapGesture)
        
        // 키보드의 높이만큼 화면을 내려준다.
        UIView.animate(withDuration: 0.3) {
            //self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            
            self.bottomView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
}

extension CustomChatRoomViewController: KeyboardInputBarDelegate {
    func didTapSend() {
        print("Tapppp")
    }
}
