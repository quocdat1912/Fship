//
//  OrderCell.swift
//  FshipApp
//
//  Created by Nguyễn Đạt on 4/30/19.
//  Copyright © 2019 Nguyễn Đạt. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var addressOrderLabel: UILabel!
    @IBOutlet weak var nameOrderLabel: UILabel!
    @IBOutlet weak var dateOrderLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
