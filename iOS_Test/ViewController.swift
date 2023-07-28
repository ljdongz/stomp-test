//
//  ViewController.swift
//  iOS_Test
//
//  Created by 이정동 on 2023/07/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("이동", for: .normal)
        return button
    }()
    
    private lazy var button2: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("이동2", for: .normal)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        view.addSubview(button)
        view.addSubview(button2)
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        button2.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button2.addTarget(self, action: #selector(button2Tapped), for: .touchUpInside)
        
    }
    
    @objc func buttonTapped() {
        navigationController?.pushViewController(CustomChatRoomViewController(), animated: true)
    }
    
    @objc func button2Tapped() {
        navigationController?.pushViewController(ChatRoomViewController(), animated: true)
    }

}
