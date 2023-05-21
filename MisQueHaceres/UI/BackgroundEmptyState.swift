//
//  BackgroundEmptyState.swift
//  MisQueHaceres
//
//  Created by Cristian Plascencia on 16/05/23.
//

import Foundation
import UIKit

class EmptyStateView: UIView {
    private let image: UIImageView
    
    override init(frame: CGRect) {
        image = UIImageView(image: UIImage(named: "pullLogo"))
        image.contentMode = .center
        
        super.init(frame: frame)
        
        self.addSubview(image)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 135).isActive = true
        image.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
