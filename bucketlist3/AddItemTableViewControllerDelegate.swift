//
//  AddItemTableViewControllerDelegate.swift
//  bucketlist3
//
//  Created by Placoderm on 7/10/17.
//  Copyright © 2017 Placoderm. All rights reserved.
//

import Foundation

protocol AddItemTableViewControllerDelegate: class {
    func itemSaved(by controller: AddItemTableViewController, with text: String, at indexPath: NSIndexPath?)
    func cancelButtonPressed(by controller: AddItemTableViewController)
}
