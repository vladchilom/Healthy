//
//  AddFoodViewController.swift
//  Healthy
//
//  Created by Vlad Chilom on 12/3/17.
//  Copyright © 2017 chilom. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AddFoodViewController: UIViewController {
  
  @IBOutlet weak var nameInput: UITextField!
  @IBOutlet weak var caloriesInput: UITextField!
  @IBOutlet weak var servingsInput: UITextField!
  @IBOutlet weak var proteinInput: UITextField!
  @IBOutlet weak var carbohydratesInput: UITextField!
  @IBOutlet weak var fatInput: UITextField!
  @IBOutlet weak var addFoodButton: UIButton!
  
  var db: Firestore!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    db = Firestore.firestore()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
    self.view.addGestureRecognizer(tapGesture)
    addFoodButton.isEnabled = false
    setUIDefaults()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    setUIDefaults()
  }
  
  func setUIDefaults() {
    let defaults = UserDefaults.standard
    nameInput.text = defaults.string(forKey: "name")
    caloriesInput.text = defaults.string(forKey: "calories")
    proteinInput.text = defaults.string(forKey: "protein")
    carbohydratesInput.text = defaults.string(forKey: "carbohydrates")
    fatInput.text = defaults.string(forKey: "fat")
  }
  
  func clearDefaults() {
    let defaults = UserDefaults.standard
    defaults.set("", forKey: "name")
    defaults.set("", forKey: "calories")
    defaults.set("", forKey: "carbohydrates")
    defaults.set("", forKey: "fat")
    defaults.set("", forKey: "protein")
  }
  
  @IBAction func clearButtonClicked(_ sender: UIButton) {
    clearFields()
    clearDefaults()
  }
  
  @IBAction func addFoodButtonClicked(_ sender: UIButton) {
    let newFood = Food(name: nameInput.text!,
                       calories: Int(caloriesInput.text!)!,
                       servings: Int(servingsInput.text!)!,
                       protein: Int(proteinInput.text!)!,
                       fat: Int(fatInput.text!)!,
                       carbohydrates: Int(carbohydratesInput.text!)!,
                       uuid: UIDevice.current.identifierForVendor!.uuidString,
                       date: Date())
    var ref: DocumentReference? = nil
    ref = db.collection("food").addDocument(data: newFood.dictionary) { (error) in
      if error != nil {
        print("Error adding item.")
      } else {
        print("Document was added with ID: \(ref!.documentID)")
      }
    }
    clearFields()
    clearDefaults()
  }
  
  func clearFields() {
    nameInput.text = ""
    caloriesInput.text = ""
    servingsInput.text = ""
    proteinInput.text = ""
    carbohydratesInput.text = ""
    fatInput.text = ""
    addFoodButton.isEnabled = false
  }
  
  @IBAction func appNameEditingChanged(_ sender: UITextField) {
    if (nameInput.text?.count == 0
      || caloriesInput.text?.count == 0
      || caloriesInput.text?.count == 0
      || servingsInput.text?.count == 0
      || proteinInput.text?.count == 0
      || carbohydratesInput.text?.count == 0
      || fatInput.text?.count == 0) {
      addFoodButton.isEnabled = false
    } else {
      addFoodButton.isEnabled = true
    }
  }
  
  @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
    nameInput.resignFirstResponder()
    caloriesInput.resignFirstResponder()
    servingsInput.resignFirstResponder()
    proteinInput.resignFirstResponder()
    carbohydratesInput.resignFirstResponder()
    fatInput.resignFirstResponder()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}
