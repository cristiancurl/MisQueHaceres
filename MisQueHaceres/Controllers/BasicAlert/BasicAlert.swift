//
//  BasicAlert.swift
//  MisQueHaceres
//
//  Created by Cristian Plascencia on 13/05/23.
//

import Foundation
import UIKit

struct BasicAlert {
    
    
    func Showalert(title: String, placeHolder: String, onSave: @escaping (String) -> Void) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = placeHolder
        }
        
        let cancelAction = UIAlertAction(title: "Cerrar", style: .cancel, handler: nil)
        
        let saveAction = UIAlertAction(title: "Guardar", style: .default) { _ in
            guard let textField = alertController.textFields?.first, let name = textField.text, !name.isEmpty else { return }
            
            print("Nombre ingresado: \(name)")
            
            onSave(name)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        return alertController
        
    }
}
