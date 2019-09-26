//
//  ViewController.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 14/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import UIKit
import InputBarAccessoryView

class ConversationViewController: UIViewController {

	enum Constant {
		static let cellReuseIdentifierSender = "messageTableViewCellSender"
		static let cellReuseIdentifierReceiver = "messageTableViewCellReceiver"

		static let rowHeight: CGFloat = 0
		static let headerViewHeight: CGFloat = 32

		static let allowsRowSelection = false

		static let headerViewBackgroundColor: UIColor = .clear
		static let headerViewTextFontSize: CGFloat = 14
		static let headerViewTextAlignment: NSTextAlignment = .center
		static let headerViewTextColor: UIColor = .black
	}

	@IBOutlet var rightBarItem: UIBarButtonItem!
	@IBOutlet var messageTableView: UITableView!

	var conversationViewModel: ConversationViewModel?

	let textInputBar = InputBarAccessoryView()
	let keyboardManager = KeyboardManager()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		setupNavigationBar()
		registerMessageTableView()
		setupTableViewAppearance()
		
		initializeViewModel()

		setupInputBar()


	}

	func setupInputBar() {

		textInputBar.delegate = self
		textInputBar.inputTextView.keyboardType = .twitter
		view.addSubview(textInputBar)

		keyboardManager.bind(inputAccessoryView: textInputBar)
		keyboardManager.bind(to: messageTableView)
		keyboardManager.on(event: .didChangeFrame) { [weak self] (notification) in
			guard let _self = self else {
				fatalError("Something went wrong with inputbar frame change.")
			}
			let barHeight = _self.textInputBar.bounds.height
			_self.messageTableView.contentInset.top = -(barHeight - notification.endFrame.height)
			_self.messageTableView.scrollIndicatorInsets.top = -(barHeight - notification.endFrame.height)
		}.on(event: .didHide) { [weak self] _ in
			guard let _self = self else {
				fatalError("Something went wrong with inputbar frame change.")
			}
			_self.messageTableView.contentInset.top = 0
			_self.messageTableView.scrollIndicatorInsets.top = 0
		}.on(event: .didShow, do: { [weak self] _ in
			self?.messageTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
		})
	}


	func setupNavigationBar() {
		guard let navTitleView = MessageNavBarTitleView.loadFromNib() else {
			fatalError("Problem loading messageNavBarView nib")
		}
		rightBarItem.width = 44
		navigationController?.navigationBar.removeShadowBorder()
		navigationController?.navigationBar.backgroundColor = .white
		navigationController?.navigationBar.tintColor = .black

		let navBarHeight = self.navigationController!.navigationBar.frame.size.height
		navTitleView.frame = CGRect(x: 0, y: 0, width: navBarHeight, height: navBarHeight)

		navTitleView.setupView(with: UIImage(), name: "HELLO")

		self.navigationItem.titleView = navTitleView
	}

	func registerMessageTableView() {
		messageTableView.rowHeight = UITableView.automaticDimension
		messageTableView.register(
			UINib(
				nibName: String(describing: MessageTableViewCellSender.self),
				bundle: nil
			),
			forCellReuseIdentifier: Constant.cellReuseIdentifierSender
		)
		messageTableView.register(
			UINib(
				nibName: String(describing: MessageTableViewCellReceiver.self),
				bundle: nil
			),
			forCellReuseIdentifier: Constant.cellReuseIdentifierReceiver
		)
		messageTableView.delegate = self
		messageTableView.dataSource = self

		messageTableView.allowsSelection = Constant.allowsRowSelection
		messageTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
	}

	func setupTableViewAppearance() {
		messageTableView.separatorStyle = .none
	}

	func initializeViewModel() {
		conversationViewModel = ConversationViewModel(with: self, apiManager: APIManager.shared)
	}

}

//Should be broke out into a class for the tableView and extended onto that


extension ConversationViewController: ConversationViewDelegate {

	func conversation(_ conversationViewModel: ConversationViewModel, didAddMessage: MessageViewModel, at indexPath: IndexPath, needsNewSection: Bool) {

		self.messageTableView.performBatchUpdates({ [weak self] in
			if needsNewSection {
				self?.messageTableView.insertSections(IndexSet.init(integer: 0), with: .none)
			}
			self?.messageTableView.insertRows(at: [indexPath], with: .right)
		}) {  [weak self] update in
			self?.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
		}
	}

	func conversation(_ conversationViewModel: ConversationViewModel, didLoadConversation: ConversationViewData) {
		DispatchQueue.main.async {
			self.messageTableView.reloadData()
		}
	}


}

extension ConversationViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return conversationViewModel?.numberOfSections ?? 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard
			let sectionedMessages = conversationViewModel?.conversationViewData?.messages,
			let keyForSectionIndex = conversationViewModel?.key(for: section),
			let rowCountAtSection = sectionedMessages[keyForSectionIndex]?.count
		else {
			return 0
		}
		return rowCountAtSection
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard
			let messageVM = conversationViewModel?.messageViewModel(at: indexPath),
			let isOwner = messageVM.messageViewData?.isMessageOwner
		else {
			fatalError("Unable to dequeue messageCell")
		}
		if isOwner {
			let messageCell: MessageTableViewCellSender = tableView.dequeueReusableCell(
				withIdentifier: Constant.cellReuseIdentifierSender,
				for: indexPath
			) as! MessageTableViewCellSender

			messageVM.delegate = messageCell
			messageCell.messageViewModel = messageVM
			messageVM.heightForRow = messageCell.frame.height
			return messageCell
		} else {
			let messageCell: MessageTableViewCellReceiver = tableView.dequeueReusableCell(
				withIdentifier: Constant.cellReuseIdentifierReceiver,
				for: indexPath
			) as! MessageTableViewCellReceiver
			messageVM.delegate = messageCell
			messageCell.messageViewModel = messageVM
			messageVM.heightForRow = messageCell.frame.height
			return messageCell
		}
	}

	func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		let header = view as! UITableViewHeaderFooterView
		header.tintColor = .white
		header.textLabel?.textColor = Constant.headerViewTextColor
		header.textLabel?.textAlignment = Constant.headerViewTextAlignment
		header.textLabel?.font = header.textLabel?.font.withSize(Constant.headerViewTextFontSize)
		header.transform = CGAffineTransform(scaleX: 1, y: -1)
	}

	func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		guard let formattedHeader = conversationViewModel?.headerTitle(for: section) else {
			return ""
		}
		return formattedHeader
	}

}

extension ConversationViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("Selected message")
	}

}

extension ConversationViewController: InputBarAccessoryViewDelegate {

	func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

		let attributedText = inputBar.inputTextView.attributedText!
		let range = NSRange(location: 0, length: attributedText.length)
		attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (attributes, range, stop) in

			let substring = attributedText.attributedSubstring(from: range)
			let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
			print("Autocompleted: `", substring, "` with context: ", context ?? [])
		}

		inputBar.inputTextView.text = String()
		inputBar.invalidatePlugins()

		inputBar.inputTextView.placeholder = "Sending..."
		DispatchQueue.main.async { [weak self] in
			inputBar.sendButton.stopAnimating()
			inputBar.inputTextView.placeholder = "Aa"
			self?.conversationViewModel?.addMessageToCurrentConversation(with: text)
		}
	}

	func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {

	}

	func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
		messageTableView.contentInset.bottom = -(size.height + 300) // keyboard size estimate
	}
}



