//
//  BaseViewController.swift
//  Events
//
//  Created by Krishna Jukuru on 04/27/22.
//  Copyright © 2022 Krishna Jukuru. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    func showAlert(with alertTitle:String, alertMessage:String) {
        let alertController = UIAlertController(title: alertTitle ,
                                                message: alertMessage,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "Ok",
                                                     style: .cancel,
                                                     handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
