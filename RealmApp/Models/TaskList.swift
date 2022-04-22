//
//  TaskList.swift
//  RealmApp
//
//  Created by Евгения Аникина on 22.04.2022.
//

import Foundation
import RealmSwift

//columns
class TaskList: Object {
    @Persisted var name = ""
    @Persisted var date = Date()
    @Persisted var tasks = List<Task>()
}
//the task column is linked to this table
class Task: Object {
    @Persisted var name = ""
    @Persisted var note = ""
    @Persisted var date = Date()
    @Persisted var isComplete = false
}
