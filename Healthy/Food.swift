//
//  Food.swift
//  Healthy
//
//  Created by Vlad Chilom on 12/3/17.
//  Copyright © 2017 chilom. All rights reserved.
//

import Foundation
import Firebase

protocol DocumentSerializable {
  init?(dictionary: [String: Any])
}

struct Food {
  var name: String
  var calories: Int
  var servings: Int
  var protein: Int
  var fat: Int
  var carbohydrates: Int
  var uuid: String
  var date: Date
  
  var dictionary: [String: Any] {
    return [
      "name": name,
      "calories": calories,
      "servings": servings,
      "protein": protein,
      "fat": fat,
      "carbohydrates": carbohydrates,
      "uuid": uuid,
      "date": date
    ]
  }
}

extension Food: DocumentSerializable {
  init?(dictionary: [String: Any]) {
    guard let name = dictionary["name"] as? String,
      let calories = dictionary["calories"] as? Int,
      let servings = dictionary["servings"] as? Int,
      let protein = dictionary["protein"] as? Int,
      let fat = dictionary["fat"] as? Int,
      let carbohydrates = dictionary["carbohydrates"] as? Int,
      let uuid = dictionary["uuid"] as? String,
      let date = dictionary["date"] as? Date
    else {
        return nil
    }
  
    self.init(name: name,
      calories: calories,
      servings: servings,
      protein: protein,
      fat: fat,
      carbohydrates: carbohydrates,
      uuid: uuid,
      date: date
    )
    
  }
}
