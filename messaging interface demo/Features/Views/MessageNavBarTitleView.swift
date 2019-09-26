//
//  MessageNavBarTitleView.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 15/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import UIKit

class MessageNavBarTitleView: UIView, NibLoadable {

	@IBOutlet var photoViewContainer: UIView!
	@IBOutlet var userPhotoView: UIImageView!
	@IBOutlet var userNameLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()


		userPhotoView.layer.borderWidth = 1
		userPhotoView.layer.borderColor = UIColor.mPink.cgColor
		userPhotoView.layer.masksToBounds = false
		userPhotoView.layer.cornerRadius = userPhotoView.bounds.size.height/2
		userPhotoView.clipsToBounds = true
		userPhotoView.backgroundColor = .mGray

	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	func setupView(with userImage: UIImage, name userName: String) {
		userPhotoView.image = userImage
		userNameLabel.text = userName
	}
	

}
