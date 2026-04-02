//
//  BasicAlert.swift
//  MisQueHaceres
//
//  Created by Cristian Plascencia on 13/05/23.
//

import Foundation
import UIKit

struct BasicAlerts {
    
    /// Return defaul accept controller with two buttons
    /// - Parameters:
    ///   - title: Title Alert
    ///   - message: Message Alert
    ///   - onAccept: onAccept button clousure
    ///   - onCancel: onCancel button clousure
    /// - Returns: UIAlertController
    func showAcceptAlert(title: String, message: String, onAccept: @escaping() -> Void, onCancel: @escaping() -> Void) -> UIAlertController {
        
        // Alert
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Actions
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { _ in
            onCancel()
        }
        
        let acceptAction = UIAlertAction(title: "Aceptar", style: .default) { _ in
            onAccept()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(acceptAction)
        
        return alertController
        
    }
    
    /// Alert controller with TextField
    /// - Parameters:
    ///   - title: Title Alert
    ///   - placeHolder: PlaceHolder TextField
    ///   - onSave: onSave button scaping
    ///   - dismiss: dismiss button scaping
    /// - Returns: UIAlertController
    func showTextFieldAlert(
        title: String,
        placeHolder: String,
        onSave: @escaping (String) -> Void,
        dismiss: (() -> Void)? = nil) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = placeHolder
            textField.autocapitalizationType = .sentences
        }
        
        let cancelAction = UIAlertAction(title: "Cerrar", style: .cancel) { _ in
            dismiss?()
        }
        
        let saveAction = UIAlertAction(title: "Guardar", style: .default) { _ in
            guard let textField = alertController.textFields?.first, let name = textField.text, !name.isEmpty else {
                return
            }
            
            print("Nombre ingresado: \(name)")
            
            onSave(name)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        return alertController
        
    }
    
}
