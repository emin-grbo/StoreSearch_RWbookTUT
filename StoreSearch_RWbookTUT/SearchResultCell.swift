//
//  SearchResultCell.swift
//  StoreSearch_RWbookTUT
//
//  Created by Emin Roblack on 11/13/18.
//  Copyright © 2018 emiN Roblack. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

  
  @IBOutlet weak var artworkImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  
  
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
