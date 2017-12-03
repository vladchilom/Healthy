//
//  Search.swift
//  Healthy
//
//  Created by Vlad Chilom on 12/3/17.
//  Copyright © 2017 chilom. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Search {
  
  var ndb: Int?
  
  func getNdb(query: String, completed: @escaping () -> () ) {
    let url = "https://api.nal.usda.gov/ndb/search/?format=json&q=\(query)&max=1&offset=0&api_key=POUBKv8Vn0y4lhVxWCvuVwY0Vss7Lzfz0kebDoM8"
    Alamofire.request(url).responseJSON { response in
      switch response.result {
      case .success(let value):
        let json = JSON(value)
        self.ndb = json["list"]["item"][0]["ndbno"].intValue
      case .failure(let error):
        print("Oh no! There was an error accessing the JSON! Error code: \(error)")
      }
      completed()
    }
  }
  
}
