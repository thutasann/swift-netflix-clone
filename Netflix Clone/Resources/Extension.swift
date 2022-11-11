//
//  Extension.swift
//  Netflix Clone
//
//  Created by Thuta sann on 11/11/22.
//

import Foundation


extension String{
    func capitalizeFirstLetter() -> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
