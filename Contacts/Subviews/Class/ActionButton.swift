//
//  ActionButton.swift
//  Contacts
//
//  Created by Mark Christian Buot on 04/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import UIKit

internal protocol ActionButtonDelegate: class {
    
    func didTapButton(_ actionButton: ActionButton, tag: Int)
}

class ActionButton: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    weak var delegate: ActionButtonDelegate?
    
    @IBOutlet weak var container: UIView?
    @IBOutlet weak var button: UIButton?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var titleLabel: BaseLabel?
    
    @IBInspectable var image: UIImage? {
        didSet {
            imageView?.image = image
        }
    }
    @IBInspectable var message: String? {
        didSet {
            titleLabel?.text = message
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initNib()
    }
    
    private func initNib() {
        self.backgroundColor = .clear
        Bundle.main.loadNibNamed(Nibs.sectionHeader,
                                 owner: self,
                                 options: nil)
        container?.frame = bounds
        container?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let container = container {
            addSubview(container)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        
        delegate?.didTapButton(self,
                               tag: self.tag)
    }
}
