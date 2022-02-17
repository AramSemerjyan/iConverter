//
//  NSObject+Extension.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import UIKit

extension NSObject {
    static var name: String{
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
