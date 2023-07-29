//
//  OtherMessageTableViewCell.swift
//  iOS_Test
//
//  Created by 이정동 on 2023/07/28.
//

import UIKit

class OtherMessageTableViewCell: UITableViewCell {

    static let identifier = "OtherMessageTableViewCell"
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var avatarView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "RF-icon")
        iv.layer.cornerRadius = contentView.frame.width * 0.1 / 2.0
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var messageView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
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
        label.text = "오후 7:15"
        return label
    }()

    var message: String? {
        didSet {
            messageLabel.text = message
        }
    }
    
    var time: Date? {
        didSet {
            
        }
    }
    
    var isAvatarHidden: Bool = false {
        didSet {
            avatarView.isHidden = isAvatarHidden
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .blue
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - addSubviews()
    
    private func addSubviews() {
        
        contentView.addSubview(containerView)
        
        
        containerView.addSubview(messageView)
        containerView.addSubview(timeLabel)
        
        containerView.addSubview(avatarView)
        
        messageView.addSubview(messageLabel)
    }
    
    // MARK: - configureConstraints()
    
    private func configureConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
        }
        
        avatarView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(3)
            make.leading.equalToSuperview().inset(5)
            make.width.height.equalTo(contentView.snp.width).multipliedBy(0.1)
        }
        
        messageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(3)
            make.leading.equalTo(avatarView.snp.trailing).offset(5)
            make.width.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(messageView.snp.bottom)
            make.leading.equalTo(messageView.snp.trailing).offset(3)
        }
        
    }

}
