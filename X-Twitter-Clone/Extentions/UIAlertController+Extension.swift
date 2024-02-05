//
//  UIAlertController+Extension.swift
//  X-Twitter-Clone
//
//  Created by Mohamed Abd Elhakam on 27/01/2024.
//

import Foundation
import UIKit


extension UIAlertController {
    static func PresentAlert(msg : String , form controller : UIViewController){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        controller.present(alert, animated: true)
    }
}
