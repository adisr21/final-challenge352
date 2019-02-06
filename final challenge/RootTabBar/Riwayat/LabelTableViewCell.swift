//
//  LabelTableViewCell.swift
//  spiki
//
//  Created by Alva Wijaya on 30/01/19.
//  Copyright © 2019 Adi Sukarno Rachman. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    var accessoryButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //selectionStyle = .none
        accessoryType = .disclosureIndicator
        accessoryButton = subviews.compactMap { $0 as? UIButton }.first
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        super.setHighlighted(false, animated: false)
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        accessoryAction?.frame.origin.y = 8
        accessoryButton?.frame.origin.y = 28
        
    }

}
