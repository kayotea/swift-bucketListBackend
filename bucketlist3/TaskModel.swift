//
//  TaskModel.swift
//  bucketlist3
//
//  Created by Placoderm on 7/17/17.
//  Copyright © 2017 Placoderm. All rights reserved.
//

import Foundation


class TaskModel {
    
    //function will get info from localhost/tasks
    //localhost/tasks will call routes function on back end '/tasks' route
    //and put up the tasks stored in the database (as written in backend)
    static func getAllTasks(completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        
        let url = URL(string: "http://localhost:8000/tasks")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: completionHandler)
        task.resume()
    }
    
    static func addTaskWithObjective(objective: String, completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        
        if let urlToReq = URL(string: "http://localhost:8000/newitem") {//url to request
            
            // Create an NSMutableURLRequest using the url. This Mutable Request will allow us to modify the headers.
            var request = URLRequest(url: urlToReq)
            //print ("OBJECTIVE: \(objective)")
            request.httpMethod = "POST"// Set the method to POST
            let bodyData = "objective=\(objective)"// Create some bodyData and attach to HTTPBody
            request.httpBody = bodyData.data(using: .utf8)
            
            let session = URLSession.shared// Create the session
            let task = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            task.resume()
        }
    }
    
    static func deleteTask(id: String, completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        
        if let urlToReq = URL(string: "http://localhost:8000/delete") {
            
            var request = URLRequest(url: urlToReq)
            request.httpMethod = "POST"
            
            let bodyData = "_id=\(id)" //{_id: 8493104s8293efs2f048ba}
            request.httpBody = bodyData.data(using: .utf8)
            
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            task.resume()
        }
    }
    
    static func updateTask(id: String, objective: String, completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
      
        let url = "http://localhost:8000/update/\(id)"
        print("url: \(url)")
        if let urlToReq = URL(string: url) {
         
            var request = URLRequest(url: urlToReq)
            request.httpMethod = "POST"
            
            let bodyData = "objective=\(objective)"
            request.httpBody = bodyData.data(using: .utf8)
            
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            task.resume()
        }
    }
}
