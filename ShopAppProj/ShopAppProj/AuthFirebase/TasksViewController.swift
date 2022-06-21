//
//  TasksViewController.swift
//  ShopAppProj
//
//  Created by admin on 21.06.2022.
//

import UIKit
import Firebase

class TasksViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var user: User!
    var ref: DatabaseReference!
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = Auth.auth().currentUser else { return }
        user = User(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(user.uid).child("tasks")
    }
    
    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewTaskTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New task", message: "Add new task", preferredStyle: .alert)
        alertController.addTextField()
        // action 1
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            // достали text
            guard let textField = alertController.textFields?.first,
                  let text = textField.text,
                  let uid = self?.user.uid else { return }
            // создаем задачу
            let task = Task(title: text, userId: uid)
            // где хранится на сервере
            let taskRef = self?.ref.child(task.title.lowercased()) // нижний регистр
            // добавляем на сервак
            taskRef?.setValue(task.convertToDictionary()) // помещаем словарь по ref
        }
        // action 2
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
}
