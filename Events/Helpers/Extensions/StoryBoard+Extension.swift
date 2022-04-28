//
//  StoryBoard+Extension.swift
//  Events
//
//  Created by Krishna Jukuru on 04/27/22.
//  Copyright © 2022 Krishna Jukuru. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {

    /// The uniform place where we state all the storyboard we have in our application
    enum Storyboard: String {
        case main               = "Main"
        var filename: String {
            return rawValue
        }
    }

    // MARK: - Convenience Initializers
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }

    // MARK: - Class Functions
    class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: bundle)
    }

    // MARK: - View Controller Instantiation from Generics
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        return viewController
    }

}

//Create a protcol so that we can identify the name of the viewControllers
protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

//Apply the withIdentifieronly to ViewController classes
extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

//Global conformance of all UIViewControllers
extension UIViewController: StoryboardIdentifiable { }
