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
  
  var searchResults = [SearchResult]()
  var hasSearched = false
  var isLoading = false
  
  override func viewDidLoad() {
    super.viewDidLoad()

    searchBar.becomeFirstResponder()
    
    tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
    
    //RegisterNibs
    var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
    //Register nothing found nib
    cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
    //Register loading cell
    cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
  }
  
  //MARK:- String litteral to constant
  struct TableView {
    struct CellIdentifiers {
      static let searchResultCell = "SearchResultCell"
      static let nothingFoundCell = "NothingFoundCell"
      static let loadingCell = "LoadingCell"
    }
  }
  //------------------------------------------------------------------------
  
  
  //MARK:- Helper methods - PARSE!
  
  func iTunesURL(searchText: String) -> URL {
    let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    let urlString = String(format: "https://itunes.apple.com/search?term=%@", encodedText)
    let url = URL(string: urlString)
    return url!
  }
  
  func performRequests(with url: URL) -> Data? {
    do {
      return try Data(contentsOf: url)
    } catch {
      print("Download error: \(error.localizedDescription)")
      showNetworkError()
      return nil
    }
  }
  
  func parse(data: Data) -> [SearchResult] {
    do {
      let decoder = JSONDecoder()
      let result = try decoder.decode(ResultArray.self, from: data)
      return result.results
    } catch {
      print("JSON Error: \(error)")
      return []
    }
  }
  
  //------------------------------------------------------------------------

  
  //MARK:- Error handling
  
  func showNetworkError() {
    let alert = UIAlertController(title: "Whoopsy Dayz", message: "There was an error with iTunes Store. \n Pls try again", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  
  
  //------------------------------------------------------------------------
  
  
  

}




// MARK:- Search Bar Extension
extension SearchVC: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    if !searchBar.text!.isEmpty {
      searchBar.resignFirstResponder()
      
      isLoading = true
      tableView.reloadData()
      hasSearched = true
      searchResults = []
      
      let queue = DispatchQueue.global()
      let url = self.iTunesURL(searchText: searchBar.text!)
      
      queue.async {
        if let data = self.performRequests(with: url) {
          self.searchResults = self.parse(data: data)
          self.searchResults.sort { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
          DispatchQueue.main.async {
            self.isLoading = false
            self.tableView.reloadData()
          }
          return
      }
        
        //MARK:- sorting variants
//        searchResults.sort(by: { result1, result2 in
//          return result1.name.localizedStandardCompare(result2.name) == .orderedAscending
//          })
        //------------------------------------------------------------------------
        
//        searchResults.sort { $0 < $1 }
//        searchResults.sort (by: <)
        //------------------------------------------------------------------------
      }
    }
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
  
}




// MARK:- Table View Delegate
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if isLoading {
      return 1
    } else if !hasSearched {
      return 0
    } else if searchResults.count == 0 {
      return 1
    } else {
      return searchResults.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if isLoading {
      let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
      let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell
      
    } else if searchResults.count == 0 {
      return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
    } else {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
      let searchResult = searchResults[indexPath.row]
      cell.nameLabel.text = searchResult.name
      
      if searchResult.artist.isEmpty {
        cell.artistNameLabel.text = "unknown"
      } else {
        cell.artistNameLabel.text = String(format: "%@ (%@)", searchResult.artist, searchResult.type)
      }
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if searchResults.count == 0 || isLoading {
      return nil
    } else {
      return indexPath
    }
  }
  
  
}
