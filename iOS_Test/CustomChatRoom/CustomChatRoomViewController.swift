//
//  CustomChatRoomViewController.swift
//  iOS_Test
//
//  Created by 이정동 on 2023/07/28.
//

import UIKit
import SnapKit

class CustomChatRoomViewController: UIViewController {
    
    // 메시지 입력 창
    private lazy var keyboardInputBar: KeyboardInputBar = {
        let bar = KeyboardInputBar()
        bar.delegate = self
        return bar
    }()
    
    // 번역 언어 설정 화면
    private lazy var inputBarTopStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 0
        sv.distribution = .fill
        sv.alignment = .fill
        sv.isHidden = true
        return sv
    }()
    
    private lazy var sourceLanguageButton: UIButton = {
        let button = UIButton()
        button.setTitle("한국어 ", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .lightGray
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    private lazy var targetLanguageButton: UIButton = {
        let button = UIButton()
        button.setTitle("영어 ", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .lightGray
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    private lazy var swapLanguageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left.arrow.right"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    private lazy var messagesTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        return tv
    }()
    
    // 키보드 뒤에 숨겨지는 뷰
    private lazy var bottomView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Property
    
    private var tapGesture = UITapGestureRecognizer()
    
    var dummy: [String] = [
        "hellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohello",
        "hello \n hahah",
        "hello \n hahah \n hadfha"
    ]
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        
        addSubviews()
        configureConstraints()
        addTargets()
        configureTableView()
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
        view.addSubview(messagesTableView)
        view.addSubview(inputBarTopStackView)
        
        inputBarTopStackView.addArrangedSubview(sourceLanguageButton)
        inputBarTopStackView.addArrangedSubview(swapLanguageButton)
        inputBarTopStackView.addArrangedSubview(targetLanguageButton)
        
        view.addSubview(bottomView)
    }
    
    // MARK: - configureConstraints()
    
    private func configureConstraints() {
        keyboardInputBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        inputBarTopStackView.snp.makeConstraints { make in
            make.bottom.equalTo(keyboardInputBar.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(40)
        }
        
        swapLanguageButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.1/0.5)
        }
        
        sourceLanguageButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2/0.5)
        }
        
        targetLanguageButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2/0.5)
        }
        
        messagesTableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(keyboardInputBar.snp.top)
        }
        
        bottomView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(0)
        }
    }
    
    // MARK: - addTargets()
    
    private func addTargets() {
        swapLanguageButton.addTarget(self, action: #selector(swapLanguageButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - configureTableView()
    
    private func configureTableView() {
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        
        messagesTableView.register(MyMessageTableViewCell.self, forCellReuseIdentifier: MyMessageTableViewCell.identifier)
        messagesTableView.register(OtherMessageTableViewCell.self, forCellReuseIdentifier: OtherMessageTableViewCell.identifier)
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
    
    @objc func swapLanguageButtonTapped() {
        let swap = targetLanguageButton.titleLabel?.text
        targetLanguageButton.setTitle(sourceLanguageButton.currentTitle, for: .normal)
        sourceLanguageButton.setTitle(swap, for: .normal)
    }
}

extension CustomChatRoomViewController: KeyboardInputBarDelegate {
    func didTapSend() {
        print("Tapppp")
        inputBarTopStackView.isHidden = true
        keyboardInputBar.isTranslated = false
    }
    func didTapTranslate(_ isTranslated: Bool) {
        print("Tapppp")
        inputBarTopStackView.isHidden = !isTranslated
    }
}


extension CustomChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyMessageTableViewCell.identifier, for: indexPath) as? MyMessageTableViewCell else { return UITableViewCell() }
            
            cell.message = dummy[indexPath.row]
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherMessageTableViewCell.identifier, for: indexPath) as? OtherMessageTableViewCell else { return UITableViewCell() }
            
            cell.message = dummy[indexPath.row]
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
}
