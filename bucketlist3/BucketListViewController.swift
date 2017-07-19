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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded")
        getAllItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getAllItems() {
        TaskModel.getAllTasks(completionHandler: {
            data, response, error in
            
            do {
                if let d = data {
                    if let results = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? [NSDictionary] {
                        //print (results)
                        
                        self.items = results
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } else {
                    print("where is the data?")
                }
            } catch {
                print ("Something went wrong")
            }
        })
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
        
        if let id = item["_id"] {
            print (id)
            
            TaskModel.deleteTask(id: id as! String, completionHandler: {
                data, response, error in
            
                do {
                    
//                    DispatchQueue.main.async {
//                        self.items.remove(at: indexPath.row)
//                        self.tableView.reloadData()
//                    }
                } catch {
                    print ("Something went wrong")
                }
            })
        }
        self.items.remove(at: indexPath.row)
        self.tableView.reloadData()
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
                //print("SENDER:",indexPath)
                let item = items[indexPath.row]
                
                addItemTableViewController.item = item["objective"] as? String
                addItemTableViewController.indexPath = indexPath
            }
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
        //print("I'm the hidden controller, but I am responding to the CANCEL button press on the top view controller")
        
        dismiss(animated: true, completion: nil)
    }
    
    //function that lets BLVC be CBD //save
    func itemSaved(by controller: AddItemTableViewController, with text: String, at indexPath: NSIndexPath?) {
        
        print("REACHED ITEMSAVED()")
        
        if let ip = indexPath {
            
            print("INDEXPATH ROW: \(ip.row)")
            
            let item = items[ip.row]
            if let id = item["_id"] {
            
                TaskModel.updateTask(id: id as! String, objective: text, completionHandler: {
                    data, response, error in
                
                    do {
                        if let d = data {
                            if let result = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {

                                if let d = data {
                                    print("DATA: \(d)")
                                    print("ITEM ID: \(id)")
                                    print("OBJECTIVE: \(text)")
                                    
                                    if let result = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                                        
                                        print ("RESULT: \(result)")
                            
                                        let item = result
                                        self.items[ip.row] = item
                                        DispatchQueue.main.async {
                                            self.tableView.reloadData()
                                        }
                                    }
                                } else {
                                    print ("where is the data?")
                                }
                            }
                        }
                    }catch {
                        print ("Something went wrong")
                    }
                })
                
            }
            
            //items[ip.row] = text
            //var item = items[ip.row]
            //item["objective"] = text
            self.tableView.reloadData()
        }
        
        else {
            print("Received Text from Top View: \(text)")
            TaskModel.addTaskWithObjective(objective: text, completionHandler: {
                data, response, error in
                
                do {
                    if let d = data {
                        if let result = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            //print (results)
                            
                            self.items.append(result)
                            print ("RESULT: \(result)")
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    } else {
                        print ("where is the data?")
                    }
                } catch {
                    print ("Something went wrong")
                }
            })
        }
        dismiss(animated: true, completion: nil)
    }
}

