//
//  ViewController+Storyboard.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import UIKit

extension UIViewController {
    static func instantiate() -> Self {
        let storyboard = UIStoryboard.init(name: self.name, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: self.name)

        guard let viewController = viewController as? Self else {
            fatalError("The initialViewController of '\(storyboard)' is not of class '\(self)'")
        }

        return viewController
    }
}
