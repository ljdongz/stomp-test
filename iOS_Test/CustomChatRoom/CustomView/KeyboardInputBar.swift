//
//  KeyboardInputBar.swift
//  iOS_Test
//
//  Created by 이정동 on 2023/07/28.
//

import UIKit
import SnapKit

protocol KeyboardInputBarDelegate: AnyObject {
    func didTapSend()
}

class KeyboardInputBar: UIView {
    
    private lazy var divLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private lazy var inputField: UITextView = {
        let tv = UITextView()
        tv.textColor = .black
        tv.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        tv.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        tv.backgroundColor = .systemGray5
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 10
        return tv
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    private lazy var translateButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left.arrow.right"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    weak var delegate: KeyboardInputBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        configureConstraints()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - addSubviews()
    
    private func addSubviews() {
        addSubview(inputField)
        addSubview(plusButton)
        addSubview(translateButton)
        addSubview(sendButton)
        addSubview(divLine)
    }
    
    // MARK: - configureConstraints()
    
    private func configureConstraints() {
        plusButton.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(10)
            make.width.height.equalTo(30)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(10)
            make.width.height.equalTo(30)
        }
        
        translateButton.snp.makeConstraints { make in
            make.trailing.equalTo(sendButton.snp.leading).offset(-10)
            make.bottom.equalToSuperview().inset(10)
            make.width.height.equalTo(30)
        }
        
        inputField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(plusButton.snp.trailing).offset(10)
            make.trailing.equalTo(translateButton.snp.leading).offset(-10)
            make.height.equalTo(30)
        }
        
        divLine.snp.makeConstraints { make in
            make.bottom.equalTo(inputField.snp.top).offset(-10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func addTargets() {
        translateButton.addTarget(self, action: #selector(translateButtonTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    @objc func translateButtonTapped() {
        print("Translate")
    }
    
    @objc func sendButtonTapped() {
        print("Send")
        delegate?.didTapSend()
    }
}
