//
//  LandscapeVC.swift
//  StoreSearch_RWbookTUT
//
//  Created by Emin Roblack on 11/20/18.
//  Copyright © 2018 emiN Roblack. All rights reserved.
//

import UIKit

class LandscapeVC: UIViewController {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var pageControll: UIPageControl!
  
  var search: Search!
  private var firstTime = true
  
  private var downloads = [URLSessionDownloadTask]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
    
    view.removeConstraints(view.constraints)
    view.translatesAutoresizingMaskIntoConstraints = true
    
    pageControll.removeConstraints(pageControll.constraints)
    pageControll.translatesAutoresizingMaskIntoConstraints = true
    
    scrollView.removeConstraints(scrollView.constraints)
    scrollView.translatesAutoresizingMaskIntoConstraints = true
    
    pageControll.numberOfPages = 0
    
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    scrollView.frame = view.bounds
    
    pageControll.frame = CGRect(x: 0, y: view.frame.size.height - pageControll.frame.size.height, width: view.frame.size.width, height: pageControll.frame.size.height)
    
    if firstTime {
      firstTime = false
      
      switch search.state {
      case .notSearchedYet:
        break
      case .loading:
        showSpinner()
      case .noResults:
        showNothingFoundLabel()
      case .results(let list):
        tileButtons(list)
      }
    }
  }
  
  // MARK:- Private Methods
  private func tileButtons(_ searchResults: [SearchResult]) {
    var columnsPerPage = 5
    var rowsPerPage = 3
    var itemWidth: CGFloat = 96
    var itemHeight: CGFloat = 88
    var marginX: CGFloat = 0
    var marginY: CGFloat = 20
    
    let viewWidth = scrollView.bounds.size.width
    
    switch viewWidth {
    case 568:
      columnsPerPage = 6
      itemWidth = 94
      marginX = 2
      
    case 667:
      columnsPerPage = 7
      itemWidth = 95
      itemHeight = 98
      marginX = 1
      marginY = 29
      
    case 736:
      columnsPerPage = 8
      rowsPerPage = 4
      itemWidth = 92
      
    default:
      break
    }
    
    // Button size
    let buttonWidth: CGFloat = 82
    let buttonHeight: CGFloat = 82
    let paddingHorz = (itemWidth - buttonWidth)/2
    let paddingVert = (itemHeight - buttonHeight)/2
  
  
  // Add the buttons
    var row = 0
    var column = 0
    var x = marginX
    for (index, result) in searchResults.enumerated() {
      // 1
      let button = UIButton(type: .custom)
      button.setBackgroundImage(UIImage(named:"LandscapeButton"), for: .normal)
      //button.setTitle("\(index)", for: .normal)
      // 2
      button.frame = CGRect(x: x + paddingHorz,
                            y: marginY + CGFloat(row)*itemHeight + paddingVert,
                            width: buttonWidth, height: buttonHeight)
      // 3
      scrollView.addSubview(button)
      // 4
      row += 1
      if row == rowsPerPage {
        row = 0; x += itemWidth; column += 1
        
        if column == columnsPerPage {
          column = 0; x += marginX * 2
        }
      }
      downloadImage(for: result, andPlaceOn: button)
      button.tag = 2000 + index
      button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    // Set scroll view content size
    let buttonsPerPage = columnsPerPage * rowsPerPage
    let numPages = 1 + (searchResults.count - 1) / buttonsPerPage
    
    scrollView.contentSize = CGSize(
      width: CGFloat(numPages) * viewWidth,
      height: scrollView.bounds.size.height)
    
    print("Number of pages: \(numPages)")
    
    //Page controll setup
    
    pageControll.numberOfPages = numPages
    pageControll.currentPage = 0
    //-------------------------------------------------------------
  }

  
  
  // Adding images to buttons
  private func downloadImage(for searchResult: SearchResult, andPlaceOn button: UIButton) {
    if let url = URL(string: searchResult.imageSmall) {
      let task = URLSession.shared.downloadTask(with: url) {
        [weak button] url, response, error in
        
        if error == nil, let url = url,
          let data = try? Data(contentsOf: url),
          let image = UIImage(data: data) {
          DispatchQueue.main.async {
            if let button = button {
              button.setImage(image, for: .normal)
            }
          }
        }
      }
      task.resume()
      downloads.append(task)
      
    }
  }
  
  deinit {
    print("deinit \(self)")
    for task in downloads {
      task.cancel()
    }
  }
  
  //-------------------------------------------------------------
  
  @IBAction func pageChanged(_ sender: UIPageControl) {
    UIView.animate(withDuration: 0.3, delay: 0,
      options: [.curveEaseInOut], animations: {
      self.scrollView.contentOffset = CGPoint(x: self.scrollView.bounds.size.width * CGFloat(sender.currentPage), y: 0)
      },
      completion: nil)
  }
  
}



extension LandscapeVC: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let width = scrollView.bounds.size.width
    let page = Int((scrollView.contentOffset.x + width/2) / width)
    pageControll.currentPage = page
  }
  
  
  //MARK:- Adding a spinner
  private func showSpinner() {
    let spinner = UIActivityIndicatorView(style: .whiteLarge)
    spinner.center = CGPoint(x: scrollView.bounds.midX + 0.5, y: scrollView.bounds.midY + 0.5)
    spinner.tag = 1000
    view.addSubview(spinner)
    spinner.startAnimating()
  }
  //------------------------------------------------------------------------
  
  
  
  func searchResultsReceived() {
    hideSpinner()
    
    switch search.state {
    case .notSearchedYet, .loading:
      break
    case .noResults:
      showNothingFoundLabel()
    case .results(let list):
      tileButtons(list)
    }
    
  }
  
  func hideSpinner() {
    view.viewWithTag(1000)?.removeFromSuperview()
  }
  
  
  
  private func showNothingFoundLabel() {
    
    let label = UILabel(frame: CGRect.zero)
    label.text = "Nothing Found"
    label.textColor = UIColor.white
    label.backgroundColor = UIColor.clear
    label.sizeToFit()
    
    var rect = label.frame
    rect.size.width = ceil(rect.size.width/2)*2
    rect.size.height = ceil(rect.size.height/2)*2
    
    label.frame = rect
    label.center = CGPoint(x: scrollView.bounds.midX, y: scrollView.bounds.midY)
    
    view.addSubview(label)
    
  }
  
  
  @objc func buttonPressed(_ sender: UIButton) {
    performSegue(withIdentifier: "ShowDetail", sender: sender)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowDetail"{
      if case .results(let list) = search.state {
        let controller = segue.destination as! DetailVC
        let searchResult = list[(sender as! UIButton).tag - 2000]
        controller.searchResult = searchResult
      }
    }

  }
  
  
}
