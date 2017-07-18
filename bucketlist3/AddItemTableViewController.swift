//
//  AddItemTableViewController.swift
//  bucketlist3
//
//  Created by Placoderm on 7/10/17.
//  Copyright © 2017 Placoderm. All rights reserved.
//

import UIKit

class AddItemTableViewController: UITableViewController {

    weak var delegate: AddItemTableViewControllerDelegate?
    var item: String?
    var indexPath: NSIndexPath?
    
    @IBOutlet weak var itemTextField: UITextField!
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.cancelButtonPressed(by: self)
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let text = itemTextField.text!
        delegate?.itemSaved(by: self, with: text, at: indexPath)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //both these guys are optional
        itemTextField.text = item
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
