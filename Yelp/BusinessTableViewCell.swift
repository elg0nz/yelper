//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Gonzalo Maldonado Martinez on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {
    @IBOutlet weak var businessPicture: UIImageView!
    @IBOutlet weak var businessName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(business: Business) {
        self.businessName.text = business.name
        self.businessPicture.setImageWith(business.imageURL!)
    }
}
