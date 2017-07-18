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
}
