//
//  costumTableViewCell.swift
//  PeriStem
//
//  Created by Sogol Moezzi on 2017-01-04.
//  Copyright © 2017 ArashAsh. All rights reserved.
//

import UIKit

class costumTableViewCell: UITableViewCell {

    @IBOutlet var stemSongTitleLabel: UILabel!
    
    @IBOutlet var pairButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
