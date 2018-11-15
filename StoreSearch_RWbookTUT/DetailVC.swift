//
//  DetailVC.swift
//  StoreSearch_RWbookTUT
//
//  Created by Emin Roblack on 11/15/18.
//  Copyright © 2018 emiN Roblack. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

  @IBOutlet weak var popupView: UIView!
  @IBOutlet weak var artworkImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var kindLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var priceButton: UIButton!
  
  var searchResult: SearchResult!
  var downloadTask: URLSessionDownloadTask?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      configure()
        popupView.layer.cornerRadius = 10
      
      let gestureReckognizer = UITapGestureRecognizer(target: self, action: #selector(close))
      gestureReckognizer.cancelsTouchesInView = false
      gestureReckognizer.delegate = self
      view.addGestureRecognizer(gestureReckognizer)
    }
  
  deinit {
    print("DESTROY")
    downloadTask?.cancel()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    modalPresentationStyle = .custom
    transitioningDelegate = self
  }
  
  @IBAction func close() {
    dismiss(animated: true, completion: nil)
  }
  
  func configure(){
    nameLabel.text = searchResult.name
    
    if searchResult.artist.isEmpty {
      artistNameLabel.text = "Unknown"
    } else {
      artistNameLabel.text = searchResult.artist
    }
    
    kindLabel.text = searchResult.type
    genreLabel.text = searchResult.genre
    
    // Show price
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = searchResult.currency
    
    let priceText: String
    if searchResult.price == 0 {
      priceText = "Free"
    } else if let text = formatter.string(
      from: searchResult.price as NSNumber) {
      priceText = text
    } else {
      priceText = ""
    }
    
    priceButton.setTitle(priceText, for: .normal)
    
    if let largeURL = URL(string: searchResult.imageLarge){
      downloadTask = artworkImageView.loadImage(url: largeURL)
    }
    
  }
  
  @IBAction func openInStore() {
    if let url = URL(string: searchResult.storeURL) {
      UIApplication.shared.open(url, options: [:],
                                completionHandler: nil)
    }
  }
  
}



extension DetailVC: UIViewControllerTransitioningDelegate {
  
  func presentationController(
    forPresented presented: UIViewController,
    presenting: UIViewController?, source: UIViewController) ->
    UIPresentationController? {
      return DimmingPresentationController(
        presentedViewController: presented,
        presenting: presenting)
  }
}


extension DetailVC: UIGestureRecognizerDelegate {
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return (touch.view === self.view)
  }
  
}
