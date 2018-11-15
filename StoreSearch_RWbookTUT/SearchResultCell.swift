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
  
  var downloadTask: URLSessionDownloadTask?
  
  
  
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: CGRect.zero)
      selectedView.backgroundColor = UIColor(red: 20/255,
                                             green: 160/255,
                                             blue: 160/255,
                                             alpha: 0.5)
      selectedBackgroundView = selectedView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configure(for result: SearchResult){
    nameLabel.text = result.name
    
    if result.artist.isEmpty {
      artistNameLabel.text = "Unknown"
    } else {
      artistNameLabel.text = String(format: "%@ (%@)", result.artist, result.type)
    }
    
    if let smallURL = URL(string: result.imageSmall){
      downloadTask = artworkImageView.loadImage(url: smallURL)
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    downloadTask?.cancel()
    downloadTask = nil
  }

}
