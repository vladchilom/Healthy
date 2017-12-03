//
//  HistoryDetailViewController.swift
//  Healthy
//
//  Created by Vlad Chilom on 12/3/17.
//  Copyright © 2017 chilom. All rights reserved.
//

import UIKit

class HistoryDetailViewController: UIViewController {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var caloriesLabel: UILabel!
  @IBOutlet weak var proteinLabel: UILabel!
  @IBOutlet weak var carbohydratesLabel: UILabel!
  @IBOutlet weak var fatLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  var food: Food?
  let dateFormatter = DateFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dateFormatter.dateFormat = "MMM dd, yyyy"
    nameLabel.text = food!.name
    setNameLabelFont()
    caloriesLabel.text = String(food!.calories * food!.servings)
    proteinLabel.text = String(food!.protein  * food!.servings)
    carbohydratesLabel.text = String(food!.carbohydrates  * food!.servings)
    fatLabel.text = String(food!.fat  * food!.servings)
    dateLabel.text = dateFormatter.string(from: food!.date)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func setNameLabelFont() {
    let size = nameLabel.text!.count
    switch size {
    case 30...35:
      nameLabel.font = nameLabel.font.withSize(20)
    case 36...40:
      nameLabel.font = nameLabel.font.withSize(17)
    case 40...Int.max:
      nameLabel.font = nameLabel.font.withSize(14)
    default:
      return
    }
  }
  
}
