//
//  Lookup.swift
//  Healthy
//
//  Created by Vlad Chilom on 12/3/17.
//  Copyright © 2017 chilom. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Lookup {
  
  var name = ""
  var calories = ""
  var servings = ""
  var protein = ""
  var carbohydrates = ""
  var fat = ""
  
  
  func getNutritionalInformation(ndb: String, completed: @escaping () -> () ) {
    let url = "https://api.nal.usda.gov/ndb/V2/reports?ndbno=\(ndb)&type=b&format=json&api_key=POUBKv8Vn0y4lhVxWCvuVwY0Vss7Lzfz0kebDoM8"
    Alamofire.request(url).responseJSON { response in
      switch response.result {
      case .success(let value):
        let json = JSON(value)
        self.name = json["foods"][0]["food"]["desc"]["name"].stringValue
        let nutrients = json["foods"][0]["food"]["nutrients"].arrayValue
        for nutrient in nutrients {
          if (nutrient["nutrient_id"].stringValue == "208") {
            self.calories = nutrient["measures"][0]["value"].stringValue.components(separatedBy: ".")[0]
          }
          if (nutrient["nutrient_id"].stringValue == "203") {
            self.protein = nutrient["measures"][0]["value"].stringValue.components(separatedBy: ".")[0]
          }
          if (nutrient["nutrient_id"].stringValue == "205") {
            self.carbohydrates = nutrient["measures"][0]["value"].stringValue.components(separatedBy: ".")[0]
          }
          if (nutrient["nutrient_id"].stringValue == "204") {
            self.fat = nutrient["measures"][0]["value"].stringValue.components(separatedBy: ".")[0]
          }
        }
      case .failure(let error):
        print("Oh no! There was an error accessing the JSON! Error code: \(error)")
      }
      completed()
    }
  }
  
}
