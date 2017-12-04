//
//  HistoryViewController.swift
//  Healthy
//
//  Created by Vlad Chilom on 12/3/17.
//  Copyright © 2017 chilom. All rights reserved.
//

import UIKit
import FirebaseFirestore

class HistoryViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var db: Firestore!
  var foodArray = [Food]()
  var filteredFoodArray = [Food]()
  var indicator = UIActivityIndicatorView()
  var isSearching = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addIndicator()
    launchIndicator()
    db = Firestore.firestore()
    tableView.delegate = self
    tableView.dataSource = self
    searchBar.delegate = self
    searchBar.returnKeyType = UIReturnKeyType.done
    loadData()
    checkForUpdates()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func addIndicator() {
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
    indicator.center = self.view.center
    self.view.addSubview(indicator)
  }
  
  func launchIndicator() {
    tableView.isHidden = true
    indicator.startAnimating()
    indicator.backgroundColor = UIColor.white
  }
  
  func stopIndicator() {
    indicator.stopAnimating()
    tableView.isHidden = false
    indicator.hidesWhenStopped = true
  }
  
  func checkForUpdates() {
    db.collection("food")
      .whereField("uuid", isEqualTo: UIDevice.current.identifierForVendor!.uuidString)
      .addSnapshotListener { (querySnapshot, error) in
        guard let snapshot = querySnapshot
          else {
            return
        }
        guard error == nil else {
          print("ERROR: adding the snapshot listener \(error!.localizedDescription)")
          return
        }
        self.loadData()
    }
  }
  
  func loadData() {
    db.collection("food")
      .whereField("uuid", isEqualTo: UIDevice.current.identifierForVendor!.uuidString)
      .getDocuments { (querySnapshot, error) in
        guard error == nil else {
          print("ERROR: reading documents \(error!.localizedDescription)")
          return
        }
        self.foodArray = []
        for document in querySnapshot!.documents {
          let foodData = Food(dictionary: document.data())
          self.foodArray.append(foodData!)
        }
        self.foodArray = self.foodArray.sorted(by: {$0.date > $1.date})
        self.stopIndicator()
        self.tableView.reloadData()
    }
  }
  
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate   {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (isSearching) {
      return filteredFoodArray.count
    }
    return foodArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryViewCell
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd"
    if (isSearching) {
      cell.nameLabel?.text = filteredFoodArray[indexPath.row].name.components(separatedBy: ", UPC")[0]
      cell.dateLabel?.text = dateFormatter.string(from: filteredFoodArray[indexPath.row].date)
    } else {
      cell.nameLabel?.text = foodArray[indexPath.row].name.components(separatedBy: ", UPC")[0]
      cell.dateLabel?.text = dateFormatter.string(from: foodArray[indexPath.row].date)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "GoToHistoryDetail", sender: nil)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destination = segue.destination as! HistoryDetailViewController
    let selectedIndex = tableView.indexPathForSelectedRow!
    destination.food = foodArray[selectedIndex.row]
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = false
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    isSearching = false
    searchBar.text = ""
    view.endEditing(true)
    tableView.reloadData()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if (searchBar.text == nil || searchBar.text == "" || searchText.count == 0) {
      isSearching = false
      view.endEditing(true)
      tableView.reloadData()
    } else {
      isSearching = true
      filteredFoodArray = foodArray.filter({ (food: Food) -> Bool in
        let name = food.name.components(separatedBy: ", UPC")[0].lowercased()
        return name.contains(searchText.lowercased())
      })
      tableView.reloadData()
    }
  }
}
