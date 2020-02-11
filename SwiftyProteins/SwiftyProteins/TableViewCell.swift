//
//  TableViewCell.swift
//  SwiftyProteins
//
//  Created by Ihor KOVALENKO on 12/19/19.
//  Copyright © 2019 Ihor KOVALENKO. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var protein: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
