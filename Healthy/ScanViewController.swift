//
//  ScanViewController.swift
//  Healthy
//
//  Created by Vlad Chilom on 12/3/17.
//  Copyright © 2017 chilom. All rights reserved.
//

import UIKit
import AVFoundation
import BarcodeScanner

class ScanViewController: UIViewController {
  
  let controller = BarcodeScannerController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    controller.codeDelegate = self
    controller.errorDelegate = self
    controller.dismissalDelegate = self
    controller.navigationItem.hidesBackButton = true
    clearDefaults()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    showCamera()
  }
  
  func clearDefaults() {
    let defaults = UserDefaults.standard
    defaults.set("", forKey: "name")
    defaults.set("", forKey: "calories")
    defaults.set("", forKey: "carbohydrates")
    defaults.set("", forKey: "fat")
    defaults.set("", forKey: "protein")
  }
  
  func showCamera() {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      controller.title = "Barcode Scanner"
      navigationController?.pushViewController(controller, animated: true)
    } else {
      AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
        if response {
          self.controller.title = "Barcode Scanner"
          self.navigationController?.pushViewController(self.controller, animated: true)
        } else {
          self.showAlert(title: "Camera Not Available", message: "There is no camera available on this device.")
        }
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(defaultAction)
    view.addSubview(alertController.view)
    present(alertController, animated: true, completion: nil)
  }
  
}

extension ScanViewController: BarcodeScannerCodeDelegate {
  func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
    let defaults = UserDefaults.standard
    let search = Search()
    search.getNdb(query: code) {
      if let ndb = search.ndb {
        let lookup = Lookup()
        lookup.getNutritionalInformation(ndb: String(ndb)) {
          defaults.set(lookup.name, forKey: "name")
          defaults.set(lookup.calories, forKey: "calories")
          defaults.set(lookup.carbohydrates, forKey: "carbohydrates")
          defaults.set(lookup.fat, forKey: "fat")
          defaults.set(lookup.protein, forKey: "protein")
          self.endSearch()
        }
      } else {
        self.endSearch()
      }
    }
  }
  
  func endSearch() {
    let delayTime = DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime ) {
      self.controller.reset()
      self.tabBarController?.selectedIndex = 1
    }
  }
}

extension ScanViewController: BarcodeScannerErrorDelegate {
  func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
    print(error)
  }
}

extension ScanViewController: BarcodeScannerDismissalDelegate {
  func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
    controller.dismiss(animated: true, completion: nil)
  }
}

