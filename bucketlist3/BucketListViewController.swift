//
//  ViewController.swift
//  bucketlist3
//
//  Created by Placoderm on 7/10/17.
//  Copyright © 2017 Placoderm. All rights reserved.
//

import UIKit
import CoreData

//CancelButtonDelegate sets BLVC as CBD
class BucketListViewController: UITableViewController, AddItemTableViewControllerDelegate {

    var items = [NSDictionary]()
    
    //can add change and delete items to core data here, then save it
    //let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded")
        //fetchAllItems()
        
        TaskModel.getAllTasks(completionHandler: {
        data, response, error in
            
            do {
                if let d = data {
                    if let results = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                        //print (results)
                        
                        let tasksArray = results as! [NSDictionary]
                        self.items = tasksArray
                        self.tableView.reloadData()
                    }
                } else {
                    print("where is the data?")
                }
            } catch {
                print ("Something went wrong")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //num of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    //cells
    override func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]["objective"] as! String!
        
        return cell
    }
    
    //swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        //managedObjectContext.delete(item)
        
        //do {
        //    try managedObjectContext.save()
        //} catch {
        //    print("\(error)")
        //}
        
        items.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    ////listen for user to select row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Selected")
    //    //perform segue given sender
    //    performSegue(withIdentifier: "EditItemSegue", sender: indexPath)
    }
    
    //listen for user to click on arrow
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //perform segue given sender
        performSegue(withIdentifier: "AddItemSegue", sender: indexPath)
    }
    
    //delegate - control cancel of modal view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //if something sent
        if let send_me = sender {
            
            //if sender is from bar button
            if send_me is UIBarButtonItem {
                let navigationController = segue.destination as! UINavigationController
                let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
                
                addItemTableViewController.delegate = self
            }
                
            //if sender is from accessory button
            else {
                let navigationController = segue.destination as! UINavigationController
                let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
                
                addItemTableViewController.delegate = self
                
                let indexPath = sender as! NSIndexPath //sender used
                print("SENDER:",indexPath)
                let item = items[indexPath.row]
                
                //addItemTableViewController.item = item.text
                addItemTableViewController.indexPath = indexPath
            }
        }
        //if no sender
        else {
            let navigationController = segue.destination as! UINavigationController
            let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
            addItemTableViewController.delegate = self
        }
        
        ////click on add item
        //if segue.identifier == "AddItemSegue" {
            
        //    let navigationController = segue.destination as! UINavigationController
        //    let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
            
        //    addItemTableViewController.delegate = self
        //}
            
        ////click on a row
        //else if segue.identifier == "EditItemSegue" {
            
        //    let navigationController = segue.destination as! UINavigationController
        //    let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
            
        //    addItemTableViewController.delegate = self
            
        //    let indexPath = sender as! NSIndexPath //sender used
        //    print("SENDER:",indexPath)
        //    let item = items[indexPath.row]
            
        //    addItemTableViewController.item = item
        //    addItemTableViewController.indexPath = indexPath
        //}
    }
    //function that lets BLVC be CBD //cancel
    func cancelButtonPressed(by controller: AddItemTableViewController) {
        print("I'm the hidden controller, but I am responding to the CANCEL button press on the top view controller")
        
        dismiss(animated: true, completion: nil)
    }
    //function that lets BLVC be CBD //save
    func itemSaved(by controller: AddItemTableViewController, with text: String, at indexPath: NSIndexPath?) {
        
        if let ip = indexPath {
            //items[ip.row] = text
            let item = items[ip.row]
            //item.text = text
        }
        
        else {
            print("Received Text from Top View: \(text)")
            //items.append(text)
            //let item = NSEntityDescription.insertNewObject(forEntityName: "BucketListItem", into: managedObjectContext) as! BucketListItem
            //item.text = text
            //items.append(item)
        }
        
        //do {
        //    try managedObjectContext.save()
        //} catch {
        //    print("\(error)")
        //}
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    //call to database to call items
    func fetchAllItems() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BucketListItem")
        
        //do {
            //this method throws, so need to do/try/catch
            //let result = try managedObjectContext.fetch(request)
            //items = result as! [BucketListItem]
        //} catch {
            //print("\(error)")
        //}
    }
}

