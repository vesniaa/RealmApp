//
//  StorageManager.swift
//  RealmApp
//
//  Created by Евгения Аникина on 22.04.2022.
//

import Foundation
import RealmSwift

class StorageManager {
    static let shared = StorageManager()
    let realm = try! Realm()
    
    private init() {}
    
    // MARK: - Task List
    //to save the test data set
    func save(_ taskLists: [TaskList]) {
        write {
            realm.add(taskLists)
        }
    }
    //we save the finished list, this method is called when we click the save button at the AlertController
    func save(_ taskList: TaskList) {
        write {
            realm.add(taskList)
        }
    }
    //the method is called by clicking on the delete button, deleting the list
    func delete(_ taskList: TaskList) {
        write {
            realm.delete(taskList.tasks)
            realm.delete(taskList)
        }
    }
    //editing the list by clicking on the edit button
    func edit(_ taskList: TaskList, newValue: String) {
        write {
            taskList.name = newValue
        }
    }
    //by clicking on the done button
    func done(_ taskList: TaskList) {
        write {
            taskList.tasks.setValue(true, forKey: "isComplete")
        }
    }

    // MARK: - Tasks
    //methods for working with tasks
    func save(_ task: Task, to taskList: TaskList) {
        write {
            taskList.tasks.append(task)
        }
    }
    
    func delete(_ task: Task) {
        write {
            realm.delete(task)
        }
    }
    
    func rename(_ task: Task, to name: String, withNote note: String) {
        write {
            task.name = name
            task.note = note
        }
    }
    
    func done(_ task: Task) {
        write {
            task.isComplete.toggle()
        }
    }
    
    private func write(completion: () -> Void) {
        do {
            try realm.write { completion() }
        } catch let error {
            print(error)
        }
    }
}

