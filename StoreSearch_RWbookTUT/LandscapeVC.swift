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
  
  var searchResults = [SearchResult]()
  private var firstTime = true
  
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
      tileButtons(searchResults)
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
      let button = UIButton(type: .system)
      button.backgroundColor = UIColor.white
      button.setTitle("\(index)", for: .normal)
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
    }
    
    // Set scroll view content size
    let buttonsPerPage = columnsPerPage * rowsPerPage
    let numPages = 1 + (searchResults.count - 1) / buttonsPerPage
    
    scrollView.contentSize = CGSize(
      width: CGFloat(numPages) * viewWidth,
      height: scrollView.bounds.size.height)
    
    print("Number of pages: \(numPages)")
    
    //Page controll setup
    
    
    
    
    
  }
  

}
