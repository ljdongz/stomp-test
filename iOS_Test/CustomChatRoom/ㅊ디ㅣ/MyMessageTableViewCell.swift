//
//  MyMessageTableViewCell.swift
//  iOS_Test
//
//  Created by 이정동 on 2023/07/28.
//

import UIKit

class MyMessageTableViewCell: UITableViewCell {
    
    static let identifier = "MyMessageTableViewCell"
    
    private lazy var messageView: UIView = {
        let view = UIView()
        view.backgroundColor = .tintColor
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping // 글자 단위로 줄바꿈
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()

    var message: String? {
        didSet {
            messageLabel.text = message
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - addSubviews()
    
    private func addSubviews() {
        contentView.addSubview(messageView)
        contentView.addSubview(timeLabel)
        
        messageView.addSubview(messageLabel)
    }
    
    // MARK: - configureConstraints()
    
    private func configureConstraints() {
        
        messageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(2)
            make.trailing.equalToSuperview().inset(5)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        
    }
}
