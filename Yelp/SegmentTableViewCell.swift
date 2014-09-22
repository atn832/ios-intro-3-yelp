//
//  SegmentTableViewCell.swift
//  Yelp
//
//  Created by Anh Tuan on 9/22/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class SegmentTableViewCell: UITableViewCell {
    @IBOutlet weak var segment: UISegmentedControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
