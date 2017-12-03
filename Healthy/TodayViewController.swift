//
//  TodayViewController.swift
//  Healthy
//
//  Created by Vlad Chilom on 12/3/17.
//  Copyright © 2017 chilom. All rights reserved.
//

import UIKit
import FirebaseFirestore

class TodayViewController: UIViewController {
  
  @IBOutlet weak var caloriesTotalLabel: UILabel!
  @IBOutlet weak var proteinTotalLabel: UILabel!
  @IBOutlet weak var carbohydratesTotalLabel: UILabel!
  @IBOutlet weak var fatTotalLabel: UILabel!
  @IBOutlet weak var caloriesPercentLabel: UILabel!
  @IBOutlet weak var proteinPercentLabel: UILabel!
  @IBOutlet weak var carbohydratesPercentLabel: UILabel!
  @IBOutlet weak var fatPercentLabel: UILabel!
  @IBOutlet weak var caloriesLabel: UILabel!
  @IBOutlet weak var proteinLabel: UILabel!
  @IBOutlet weak var carbohydratesLabel: UILabel!
  @IBOutlet weak var fatLabel: UILabel!
  
  var db: Firestore!
  var foodArray = [Food]()
  var indicator = UIActivityIndicatorView()
  var labels = [UILabel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    labels = [caloriesTotalLabel, proteinTotalLabel, carbohydratesTotalLabel, fatTotalLabel, caloriesPercentLabel, proteinPercentLabel, carbohydratesPercentLabel, fatPercentLabel, caloriesLabel, proteinLabel, carbohydratesLabel, fatLabel]
    addIndicator()
    launchIndicator()
    db = Firestore.firestore()
    loadData()
    checkForUpdates()
    prepareUI()
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
    for label in labels {
      label.isHidden = true
    }
    indicator.startAnimating()
    indicator.backgroundColor = UIColor.white
  }
  
  func stopIndicator() {
    indicator.stopAnimating()
    for label in labels {
      label.isHidden = false
    }
    indicator.hidesWhenStopped = true
  }
  
  
  func prepareUI() {
    var calories = 0
    var protein = 0
    var carbohydrates = 0
    var fat = 0
    for food in foodArray {
      calories += food.calories * food.servings
      protein += food.protein * food.servings
      carbohydrates += food.carbohydrates * food.servings
      fat += food.fat * food.servings
    }
    caloriesTotalLabel.text = String(calories)
    proteinTotalLabel.text = String(protein)
    carbohydratesTotalLabel.text = String(carbohydrates)
    fatTotalLabel.text = String(fat)
    caloriesPercentLabel.text = "\(Int(Double(calories) / 2000.0 * 100)) %"
    proteinPercentLabel.text = "\(Int(Double(protein) / 50.0 * 100)) %"
    carbohydratesPercentLabel.text = "\(Int(Double(carbohydrates) / 310.0 * 100)) %"
    fatPercentLabel.text = "\(Int(Double(fat) / 70.0 * 100)) %"
  }
  
  func getDay() -> Date {
    let gregorian = Calendar(identifier: .gregorian)
    var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
    components.hour = 0
    components.minute = 0
    components.second = 0
    return gregorian.date(from: components)!
  }
  
  func checkForUpdates() {
    db.collection("food")
      .whereField("uuid", isEqualTo: UIDevice.current.identifierForVendor!.uuidString)
      .whereField("date", isGreaterThan: getDay())
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
      .whereField("date", isGreaterThan: getDay())
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
        self.prepareUI()
        self.stopIndicator()
    }
  }
  
}
