//
//  ViewController.swift
//  iOS_Test
//
//  Created by 이정동 on 2023/07/17.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import SnapKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var photoURLString: String?
    var senderId: String
    var displayName: String
}


class ChatRoomViewController: MessagesViewController {
    
    // MARK: - UI Property
    
    // InputBar 번역 설정 버튼
    lazy var topLeftButton: InputBarButtonItem = {
        let button = InputBarButtonItem(type: .system)
        button.tintColor = .black
        button.image = UIImage(systemName: "arrow.left")
        //button.backgroundColor = .white
        return button
    }()
    
    lazy var topCenterButton: InputBarButtonItem = {
        let button = InputBarButtonItem(type: .system)
        button.tintColor = .black
        button.image = UIImage(systemName: "arrow.up")
        //button.backgroundColor = .white
        return button
    }()
    
    lazy var topRightButton: InputBarButtonItem = {
        let button = InputBarButtonItem(type: .system)
        button.tintColor = .black
        button.image = UIImage(systemName: "arrow.right")
        //button.backgroundColor = .white
        return button
    }()
    
    // InputBar 번역 버튼
    lazy var translateBarButtonItem: InputBarButtonItem = {
        let button = InputBarButtonItem(type: .system)
        button.tintColor = .black
        button.image = UIImage(systemName: "arrow.left.arrow.right")
        button.addTarget(self, action: #selector(didTapTranslateButton), for: .touchUpInside)
        return button
    }()
    
    // InputBar 추가 버튼
    lazy var plusBarButtonItem: InputBarButtonItem = {
        let button = InputBarButtonItem(type: .system)
        button.tintColor = .black
        button.image = UIImage(systemName: "plus")
        button.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Property
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private var messages: [Message] = []
    
    private let selfSender = Sender(senderId: "1", displayName: "JD")
    private let otherSender = Sender(senderId: "2", displayName: "unknown")
    private let thirdSender = Sender(senderId: "3", displayName: "Who")
    
    private var inputBarIntrinctSize: CGSize = CGSize()
    
    private var tapGesture = UITapGestureRecognizer()
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true

        updateSubTitleView(title: "Channel", subtitle: "모임 정보 보기")
        
//        editMenuInteraction = UIEditMenuInteraction(delegate: self)
//        messagesCollectionView.addInteraction(editMenuInteraction!)
//
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
//        longPress.allowedTouchTypes = [UITouch.TouchType.direct.rawValue as NSNumber]
//        messagesCollectionView.addGestureRecognizer(longPress)
        
        makeDummyData()
        setupInputBar()
        setupMessagesCollectionView()
        setupMessagesCollectionViewFlowLayout()
        
        
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
//    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
//        let location = sender.location(in: self.messagesCollectionView)
//        let configuration = UIEditMenuConfiguration(identifier: nil, sourcePoint: location)
//
//        if let interaction = editMenuInteraction {
//            // Present the edit menu interaction.
//            interaction.presentEditMenu(with: configuration)
//        }
//    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - setupDelegate()
    
    func setupMessagesCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        messageInputBar.delegate = self
        
        //scrollsToLastItemOnKeyboardBeginsEditing = true // default false
        maintainPositionOnInputBarHeightChanged = true // default false
        
        showMessageTimestampOnSwipeLeft = true // default false
        
        messagesCollectionView.keyboardDismissMode = .onDrag
    }
    
    // MARK: - makeDummyData() {
    
    func makeDummyData() {
        messages.append(Message(sender: selfSender, messageId: "Mock Id 1", sentDate: Date(), kind: .text("Hello")))
        messages.append(Message(sender: otherSender, messageId: "Mock Id 2", sentDate: Date(), kind: .text("Hi1")))
        messages.append(Message(sender: otherSender, messageId: "Mock Id 2", sentDate: Date(), kind: .text("Hi2")))
        messages.append(Message(sender: otherSender, messageId: "Mock Id 2", sentDate: Date(), kind: .text("Hi3")))
        messages.append(Message(sender: thirdSender, messageId: "Mock Id 2", sentDate: Date(), kind: .text("Hi4")))
        messages.append(Message(sender: otherSender, messageId: "Mock Id 2", sentDate: Date(), kind: .text("Hi5Hi5Hi5Hi5Hi5Hi5Hi5Hi5Hi5Hi5Hi5Hi5Hi5Hi5Hi5Hi5Hi5Hi5Hi5Hi5Hi5Hi5Hi5Hi5Hi5")))
        
        //Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    
        messagesCollectionView.reloadData()
    }
    
    // MARK: - setupMessagesCollectionViewFlowLayout()
    
    func setupMessagesCollectionViewFlowLayout() {
        
        guard let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout else { return }
        
        // 내 아바타 제거
        layout.setMessageOutgoingAvatarSize(.zero)
        
        // 메시지 바텀 라벨 위치 조정
        layout.setMessageIncomingMessageBottomLabelAlignment(.init(textAlignment: .left, textInsets: .init(top: 0, left: 45, bottom: 0, right: 0)))
        layout.setMessageOutgoingMessageBottomLabelAlignment(.init(textAlignment: .right, textInsets: .init(top: 0, left: 0, bottom: 0, right: 10)))
        
        // 상대 아바타 사이즈
        layout.setMessageIncomingAvatarSize(CGSize(width: 35, height: 35))
        
        // 상대 아바타 위치
        layout.setMessageIncomingAvatarPosition(.init(horizontal: .cellLeading, vertical: .messageLabelTop))
    }
    
    
    // MARK: - setupInputBar()
    
    func setupInputBar() {
        // 전송 버튼 커스텀
        messageInputBar.sendButton.image = UIImage(systemName: "paperplane")
        messageInputBar.sendButton.tintColor = .black
        messageInputBar.sendButton.title = ""
        
        // 우측 스택 뷰 설정
        messageInputBar.rightStackView.alignment = .center
        messageInputBar.rightStackView.distribution = .fillEqually
        messageInputBar.setRightStackViewWidthConstant(to: 80, animated: false)
        
        // 전송 + 번역 버튼 설정
        messageInputBar.setStackViewItems([translateBarButtonItem, messageInputBar.sendButton], forStack: .right, animated: true)
        
        // 좌측 스택 뷰 설정
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 30, animated: false)
        
        // 추가 버튼 설정
        messageInputBar.setStackViewItems([plusBarButtonItem], forStack: .left, animated: true)
        
        messageInputBar.topStackView.alignment = .fill
        messageInputBar.topStackView.axis = .horizontal
        messageInputBar.topStackView.distribution = .fillEqually
        messageInputBar.topStackView.spacing = 1
        //messageInputBar.topStackView.backgroundColor = .black
        
        messageInputBar.setStackViewItems([topLeftButton, topCenterButton, topRightButton], forStack: .top, animated: true)
        
        messageInputBar.topStackView.snp.makeConstraints { make in
            make.height.equalTo(0)
        }
        
    }
    
    /// 한 사람이 연속해서 메시지를 보내는지 체크
    /// - Parameter indexPath: indexPath
    /// - Returns: true: 연속, false: 비연속
    func isSenderConsecutiveMessages(indexPath: IndexPath) -> Bool {
        if indexPath.section != 0 && (messages[indexPath.section - 1].sender.senderId == messages[indexPath.section].sender.senderId) {
            return true
        } else { return false }
    }
    
    // MARK: - @objc func
    
    @objc func didTapTranslateButton() {
        print("translate")
    }
    
    @objc func didTapPlusButton() {
        print("plus")
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        // 메시지 컬렉션 뷰 클릭 동작 X -> 화면 터치 시 키보드 내려가도록 하기 위함
        
        // Case 1. 키보드 올린 상태에서 스크롤 시 키보드 내려감 (touchBegan 오버라이드 메서드 추가 필요)
        //messagesCollectionView.isUserInteractionEnabled = false
        
        // Cse 2. 키보드 올린 상태에서 스크롤 시 키보드 내려가지 않음
        // (But, 키보드를 바로 내릴 시 InputBar 오토레이아웃이 이상해서 스크롤 시 키보드 내려가도록 설정함)
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        messagesCollectionView.addGestureRecognizer(tapGesture)
        
        messageInputBar.topStackView.snp.updateConstraints { make in
            make.height.equalTo(40)
        }
        
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            UIView.animate(withDuration: 0.3, animations: {
//                self.messagesCollectionView.transform = CGAffineTransform(translationX: 0, y: -(keyboardSize.height + 40))
//            })
//        }
    }
    
    @objc func keyboardWillHide() {
        // 메시지 컬렉션 뷰 클릭 가능하도록
        
        // Case 1.
        //messagesCollectionView.isUserInteractionEnabled = true
        
        // Case 2. keyboardWillShow에서 추가한 제스처 삭제
        messagesCollectionView.removeGestureRecognizer(tapGesture)
        
        messageInputBar.topStackView.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
        
        //self.messagesCollectionView.transform = .identity
    }
    
    @objc func timerAction() {
        guard let sd = [otherSender, thirdSender].randomElement() else { return }
        messages.append(Message(sender: sd, messageId: "1", sentDate: Date(), kind: .text("Test")))
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
    }
    
}

// MARK: - Ext: MessagesDataSource

extension ChatRoomViewController: MessagesDataSource {
    var currentSender: MessageKit.SenderType {
        // 채팅 내에서 나(Self)를 설정
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 5 == 0 {
            return NSAttributedString(
                string: MessageKitDateFormatter.shared.string(from: message.sentDate),
                attributes: [
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                    NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                ])
        }
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        
        if message.sender.senderId == selfSender.senderId { return nil }
        
        if isSenderConsecutiveMessages(indexPath: indexPath) { return nil }
        else {
            return NSAttributedString(string: name, attributes: [.font: UIFont.preferredFont(forTextStyle: .caption1), .foregroundColor: UIColor(white: 0.3, alpha: 1)])
        }
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at _: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        
        return NSAttributedString(
            string: dateString,
            attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
    func cellBottomLabelAttributedText(for _: MessageType, at _: IndexPath) -> NSAttributedString? {
        return NSAttributedString(
            string: "Read",
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            ])
    }
}

// MARK: - Ext: MessagesDisplayDelegate

// 상대방이 보낸 메시지, 내가 보낸 메시지를 구분하여 색상과 모양 지정
extension ChatRoomViewController: MessagesDisplayDelegate {
    // 말풍선의 배경 색상
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .tintColor : .lightGray
    }
    
    // 텍스트 색상
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .black : .white
    }
    
    // 말풍선의 꼬리 모양 방향
    //    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
    //        let cornerDirection: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
    //        return .bubbleTail(cornerDirection, .curved)
    //    }
    
    // 아바타 설정 (이미지 및 숨김 설정)
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if isSenderConsecutiveMessages(indexPath: indexPath) {
            avatarView.isHidden = true
        } else {
            avatarView.isHidden = false
            avatarView.set(avatar: .init(image: UIImage(named: "RF-icon")))
        }
    }
}

// MARK: - Ext: MessagesLayoutDelegate

extension ChatRoomViewController: MessagesLayoutDelegate {
    // 아래 여백
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    // 셀 탑
    func cellTopLabelHeight(for _: MessageType, at indexPath: IndexPath, in _: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 5 == 0 { return 20 }
        else { return 0 }
    }
    
    // 메시지 탑
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        if isSenderConsecutiveMessages(indexPath: indexPath) { return 0 }
        else { return 15 }
    }
    
    // 메시지 바텀
    func messageBottomLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
        return 15
    }

    // 셀 바텀
    func cellBottomLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    
}

// MARK: - Ext: InputBarAccessoryViewDelegate

extension ChatRoomViewController: InputBarAccessoryViewDelegate {
    
    // 전송 버튼 눌렀을 때
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        inputBar.inputTextView.text.removeAll()
        
        messages.append(Message(sender: Sender(senderId: "1", displayName: "JD"), messageId: "1", sentDate: Date(), kind: .text(text)))
        
        messagesCollectionView.reloadData()
        
        // 기존 messagesCollectionView 컨텐트 사이즈 높이에서 늘어난 inputBar 사이즈 높이만큼 빼기
        let before = messagesCollectionView.contentSize
        messagesCollectionView.contentSize = CGSize(width: before.width, height: before.height - inputBarIntrinctSize.height)
        view.layoutIfNeeded()
        
        
        self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
    }
    
    // inputBar size가 변경될 때
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        // 기존 보다 얼마만큼 높이가 늘어났는지 저장
        inputBarIntrinctSize = CGSize(width: size.width, height: size.height - 50)
    }
}

// MARK: - Ext: MessageCellDelegate

extension ChatRoomViewController: MessageCellDelegate {
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Tap Avatar")
    }
    
    func didTapMessage(in _: MessageCollectionViewCell) {
        print("Message tapped")
    }
}

//extension ChatRoomViewController: UIEditMenuInteractionDelegate {
//    func editMenuInteraction(_ interaction: UIEditMenuInteraction, menuFor configuration: UIEditMenuConfiguration, suggestedActions: [UIMenuElement]) -> UIMenu? {
//
//
//        let ac1 = UIAction(title: "Increase", image: UIImage(systemName: "increase.indent")) { (action) in
//            // Increase indentation action.
//            print("increase indent")
//        }
//        let ac2 = UIAction(title: "Decrease", image: UIImage(systemName: "decrease.indent")) { (action) in
//            // Decrease indentation action.
//            print("decrease indent")
//        }
//
//        return UIMenu(children: suggestedActions + [ac1, ac2])
//    }
//}
