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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        
    }
    
    @objc func buttonTapped() {
        navigationController?.pushViewController(ChatRoomViewController(), animated: true)
    }

}
