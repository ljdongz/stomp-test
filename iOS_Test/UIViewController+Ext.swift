//
//  UIViewController+Ext.swift
//  iOS_Test
//
//  Created by 이정동 on 2023/07/24.
//

import UIKit

extension UIViewController {
    
    func updateTitleView(title: String) {
        self.title = title
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 20, weight: .medium)
        ]
    }
    
    func setupCustomBackButton() {
        // 버튼에 기본 설정을 적용하고 여백 변경
        let buttonConfig = UIButton.Configuration.plain()
        
        let backButtonImage = UIImage(systemName: "chevron.left") // navigation bar의 back 버튼 이미지
        let backButton = UIButton(configuration: buttonConfig, primaryAction: UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        backButton.setImage(backButtonImage, for: .normal)
        backButton.imageView?.preferredSymbolConfiguration = .init(weight: .bold)
        backButton.tintColor = .black
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    // 네비게이션으로 넘어가기 전 화면에서 호출
    func updateNavigationBarBackButton(title: String = "") {
        let backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func updateSubTitleView(title: String, subtitle: String?) {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = .gray
        subtitleLabel.text = subtitle
        subtitleLabel.textAlignment = .center
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.sizeToFit()
        
        let titleView =
        UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        if subtitle != nil {
            titleView.addSubview(subtitleLabel)
        } else {
            titleLabel.frame = titleView.frame
        }
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(titleViewTapped)))
        
        navigationItem.titleView = titleView
    }
    
    @objc func titleViewTapped() {
        print("Title View Tap")
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    
}
