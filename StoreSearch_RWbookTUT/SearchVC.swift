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
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  private let search = Search()
  var landscapeVC: LandscapeVC?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    searchBar.becomeFirstResponder()
    
    tableView.contentInset = UIEdgeInsets(top: 88, left: 0, bottom: 0, right: 0)
    
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

  
  //MARK:- Error handling
  
  func showNetworkError() {
    let alert = UIAlertController(title: "Whoopsy Dayz", message: "There was an error with iTunes Store. \n Pls try again", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  
  
  //------------------------------------------------------------------------
  
  @IBAction func segmentChanged(_ sender: UISegmentedControl) {
    performSearch()
  }
  
  

}




// MARK:- Search Bar Extension
extension SearchVC: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    performSearch()
  }
  
  func performSearch() {
    if let category = Search.Category(
      rawValue: segmentedControl.selectedSegmentIndex) {
      search.performSearch(for: searchBar.text!,
                           category: category, completion: { success in
      
      if !success {
        self.showNetworkError()
      }
      self.tableView.reloadData()
      } )
    
    tableView.reloadData()
    searchBar.resignFirstResponder()
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
  
}
  
}




// MARK:- Table View Delegate
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
      switch search.state {
    case .notSearchedYet:
      return 0
    case .loading:
      return 1
    case .noResults:
      return 1
    case .results(let list):
      return list.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch search.state {
    case .notSearchedYet:
      fatalError("Should never get here")
      
    case .loading:
      let cell = tableView.dequeueReusableCell(
        withIdentifier: TableView.CellIdentifiers.loadingCell,
        for: indexPath)
      
      let spinner = cell.viewWithTag(100) as!
      UIActivityIndicatorView
      spinner.startAnimating()
      return cell
      
    case .noResults:
      return tableView.dequeueReusableCell(
        withIdentifier: TableView.CellIdentifiers.nothingFoundCell,
        for: indexPath)
      
    case .results(let list):
      let cell = tableView.dequeueReusableCell(
        withIdentifier: TableView.CellIdentifiers.searchResultCell,
        for: indexPath) as! SearchResultCell
      let searchResult = list[indexPath.row]
      cell.configure(for: searchResult)
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: "ShowDetail", sender: indexPath)
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    switch search.state {
    case .notSearchedYet, .loading, .noResults:
      return nil
    case .results:
      return indexPath
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
    if segue.identifier == "ShowDetail" {
      if case .results(let list) = search.state {
      let controller = segue.destination as? DetailVC
      let indexPath = sender as! IndexPath
      let searchResult = list[indexPath.row]
      
      controller?.searchResult = searchResult
      }
    }
  }
  
  
}

func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
  return lhs.name.localizedStandardCompare(rhs.name) ==
    .orderedAscending
}


// MARK:- Landscape
extension SearchVC {
  
  override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransition(to: newCollection, with: coordinator)
    
    switch newCollection.verticalSizeClass {
    case .compact:
      showLandscape(with: coordinator)
    case .regular, .unspecified:
      hideLandscape(with: coordinator)
    }
    
  }
  
  func showLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
    guard landscapeVC == nil else {return}
    
    landscapeVC = storyboard?.instantiateViewController(withIdentifier: "LandscapeVC") as? LandscapeVC
    
    if let controller = landscapeVC {
      
      controller.search = search
      
      controller.view.frame = view.bounds
      controller.view.alpha = 0
      
      view.addSubview(controller.view)
      addChild(controller)
      
      //animation
      coordinator.animate(alongsideTransition: { _ in
        controller.view.alpha = 1
        self.searchBar.resignFirstResponder()
        // dismiss if modal opened
        if self.presentedViewController != nil {
          self.dismiss(animated: true, completion: nil)
        }
        //-------------------------------------------------------------
      }) { _ in
        controller.didMove(toParent: self)
      }
    }
  }
  //-------------------------------------------------------------
  
  func hideLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
   
    if let controller = landscapeVC {
      
      controller.willMove(toParent: nil)
      
      //animate
      coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
        controller.view.alpha = 0
      }) { (UIViewControllerTransitionCoordinatorContext) in
        //remove
        controller.view.removeFromSuperview()
        controller.removeFromParent()
        self.landscapeVC = nil
      }
      //-------------------------------------------------------------
    }
  }
 
  
  
}

