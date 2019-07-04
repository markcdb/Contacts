//
//  SectionHeader.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import UIKit

class SectionHeader: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var container: UIView?
    @IBOutlet weak var titleLabel: BaseLabel?
    
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
}

