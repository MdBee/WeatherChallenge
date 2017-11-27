//
//  Functions.swift
//  WeatherChallenge
//
//  Created by Bearson, Matt D. on 11/27/17.
//  Copyright © 2017 Bearson, Matt D. All rights reserved.
//

import Foundation
import UIKit

class Functions {
    
    static func colorForTemperature(temperature: Double) -> UIColor {
        switch temperature {
        case _ where temperature < 32:
            return UIColor.white
        case _ where 32 <= temperature && temperature <= 50:
            return UIColor.blue
        case _ where 50 < temperature && temperature < 80:
            return UIColor.yellow
        case _ where 80 <= temperature:
            return UIColor.red
        default:
            return UIColor.clear
        }
    }
    
}
