//
//  ViewController.swift
//  StoreSearch_RWbookTUT
//
//  Created by Emin Roblack on 11/12/18.
//  Copyright © 2018 emiN Roblack. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var searchResults = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
  }


}




// MARK:- Search Bar Extension
extension SearchVC: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    searchBar.resignFirstResponder()
    searchResults = []
    
    for i in 0...2 {
      searchResults.append(String(format: "Fake Result %d for '%@'", i, searchBar.text!))
    }
    tableView.reloadData()
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
  
}




// MARK:- Table View Delegate
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchResults.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cellIdentifier = "SearchResultCell"
    var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
    
    if cell == nil{
      cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    }
    
    cell.textLabel!.text = searchResults[indexPath.row]
    
    return cell
  }
  
  
}
