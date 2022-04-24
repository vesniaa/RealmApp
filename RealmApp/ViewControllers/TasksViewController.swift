//
//  TasksViewController.swift
//  RealmApp
//
//  Created by Евгения Аникина on 22.04.2022.
//

import UIKit
import RealmSwift

class TasksViewController: UITableViewController {
    
    // MARK: - Public Properties
    var taskList: TaskList!
    
    // MARK: - Private Properties
    private var currentTasks: Results<Task>!
    private var completedTasks: Results<Task>!
    
    // MARK: - life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = taskList.name
        
        currentTasks = taskList.tasks.filter("isComplete = false")
        completedTasks = taskList.tasks.filter("isComplete = true")
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed)
        )
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    
    }
    
    // MARK: - Table view data source
    //sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? currentTasks.count : completedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }
    // to display content
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        content.text = task.name
        content.secondaryText = task.note
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
            showAlert(with: task) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
            
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
                StorageManager.shared.delete(task)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, isDone in
                self.showAlert(with: task) {
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                isDone(true)
            }
            
            let doneAction = UIContextualAction(style: .normal, title: "Done") { _, _, isDone in
                StorageManager.shared.done(task)

                let range = NSMakeRange(0, self.tableView.numberOfSections)
                let sections = NSIndexSet(indexesIn: range)
                self.tableView.reloadSections(sections as IndexSet, with: .automatic)
                        
                isDone(true)
            }
            
            editAction.backgroundColor = .orange
            doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            
            return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
        }
    
    @objc private func addButtonPressed() {
        showAlert()
    }
}

// MARK: - Private Methods
extension TasksViewController {
    private func showAlert(with task: Task? = nil, completion: (() -> Void)? = nil) {
        let title = task != nil ? "Edit Task" : "New Task"
        
        let alert = UIAlertController.createAlert(withTitle: title, andMessage: "What do you want to do?")
        
        alert.action(with: task) { newValue, note in
            if let task = task, let completion = completion {
                StorageManager.shared.edit(self.taskList, newValue: newValue)
                completion()
            } else {
                self.saveTask(withName: newValue, andNote: note)
            }
        }
        
        present(alert, animated: true)
    }
    
    private func saveTask(withName name: String, andNote note: String) {
        let task = Task(value: [name, note])
        StorageManager.shared.save(task, to: taskList)
        
        let rowIndex = IndexPath(row: currentTasks.index(of: task) ?? 0, section: 0)
        tableView.insertRows(at: [rowIndex], with: .automatic)
    }
    
}



