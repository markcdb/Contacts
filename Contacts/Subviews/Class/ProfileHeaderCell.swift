//
//  ProfileHeaderCell.swift
//  Contacts
//
//  Created by Mark Christian Buot on 04/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import UIKit

internal enum ButtonType: Int {
    
    case message = 0
    case call
    case email
    case favourite
}

protocol ProfileHeaderCellDelegate: class {
    
    func doMessage()
    func doCall()
    func doEmail()
    func doFavourite()
}

class ProfileHeaderCell: BaseCell {

    @IBOutlet weak var buttonStackHeight: NSLayoutConstraint?
    @IBOutlet weak var buttonStack: UIStackView?
    @IBOutlet weak var messageImageView: UIImageView?
    @IBOutlet weak var callImageView: UIImageView?
    @IBOutlet weak var emailImageView: UIImageView?
    @IBOutlet weak var favouriteImageView: UIImageView?
    
    @IBOutlet weak var profileImageView: UIImageView?
    @IBOutlet weak var profileName: BaseLabel?
    
    weak var delegate: ProfileHeaderCellDelegate?
    
    internal var isFavourite: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let frame                             = profileImageView?.frame.width ?? 0
        profileImageView?.layer.masksToBounds = true
        profileImageView?.layer.cornerRadius  = frame / 2
        profileImageView?.layer.borderWidth   = 3
        profileImageView?.layer.borderColor   = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapMessage(_ sender: UIButton) {
        delegate?.doMessage()
        
        messageImageView?.bounce(withCompletion: nil)
    }
    
    @IBAction func didTapCall(_ sender: UIButton) {
        delegate?.doCall()
        
        callImageView?.bounce(withCompletion: nil)
    }
    
    @IBAction func didTapEmail(_ sender: UIButton) {
        delegate?.doEmail()
        
        emailImageView?.bounce(withCompletion: nil)
    }
    
    @IBAction func didTapFavourite(_ sender: UIButton) {
        delegate?.doFavourite()
        
        isFavourite.toggle()
        
        UIView.animate(withDuration: 5) {
            if self.isFavourite == false {
                self.favouriteImageView?.image = Images.favorite_button
            } else {
                self.favouriteImageView?.image = Images.favorite_button_selected
            }
        }
       
        favouriteImageView?.bounce(withCompletion: nil)
    }
}
