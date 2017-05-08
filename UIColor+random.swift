//
//  UIColor+random.swift
//  Jobok
//
//  Created by Bogdan Manshilin on 08.05.17.
//  Copyright © 2017 Jobok. All rights reserved.
//

import UIKit

extension UIColor {
    static var random: UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
}
