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
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var ratingPicture: UIImageView!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var costGroup: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var category: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(business: Business) {
        if let imageUrl = business.imageURL {
            self.businessPicture.setImageWith(imageUrl)
        }
        self.businessName.text = business.name
        self.distance.text = business.distance
        self.ratingPicture.setImageWith(business.ratingImageURL!)
        self.reviews.text = "\(business.reviewCount!) Reviews"
        self.costGroup.text = "" // TODO: get this data from the API
        self.address.text = business.address
        self.category.text = business.categories
    }
}
