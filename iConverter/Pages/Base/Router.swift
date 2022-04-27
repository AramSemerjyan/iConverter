//
//  Router.swift
//  iConverter
//
//  Created by Aram Semerjyan on 13.04.22.
//

import UIKit

class Router {

    deinit {
        print("********")
        print("Router deinited")
        print("********")
    }

    private var topViewController: UIViewController? {
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            return topController
        }

        return nil
    }

    func show(_ controller: UIViewController) {
        topViewController?.show(controller, sender: nil)
    }

    func present(_ controller: UIViewController) {
        show(UINavigationController(rootViewController: controller))
    }

    func presentWithoutNavigation(
        _ controller: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        topViewController?.present(
            controller, animated:
                animated, completion:
                completion
        )
    }
}
