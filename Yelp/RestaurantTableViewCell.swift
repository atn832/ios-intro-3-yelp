//
//  RestaurantTableViewCell.swift
//  Yelp
//
//  Created by Anh Tuan on 9/21/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    
    @IBOutlet weak var ratings: UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var restaurantType: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var detailsView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
