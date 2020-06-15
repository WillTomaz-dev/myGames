//
//  ViewController+CoreData.swift
//  MyGames
//
//  Created by William Tomaz on 10/06/20.
//  Copyright © 2020 William Tomaz. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
