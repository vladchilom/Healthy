//
//  HistoryViewController.swift
//  Healthy
//
//  Created by Vlad Chilom on 12/3/17.
//  Copyright © 2017 chilom. All rights reserved.
//

import UIKit
import FirebaseFirestore

class HistoryViewController: UIViewController{
  
  @IBOutlet weak var tableView: UITableView!
  
  var db: Firestore!
  var foodArray = [Food]()
  var indicator = UIActivityIndicatorView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addIndicator()
    launchIndicator()
    self.title = "Food History"
    db = Firestore.firestore()
    tableView.delegate = self
    tableView.dataSource = self
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

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return foodArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = foodArray[indexPath.row].name
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
}
