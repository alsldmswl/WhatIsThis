//
//  DetailTableViewCell.swift
//  WhatIsThis3
//
//  Created by eun-ji on 2023/04/09.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
