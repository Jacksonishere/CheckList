//
//  AddItemTableViewController.swift
//  CheckList
//
//  Created by Jackson Lu on 2/25/21.
//

import UIKit
import UserNotifications

// MARK: - PROTOCOL
//Usually, we define class className : inheritclassfrom
protocol AddItemTableViewControllerDelegate: class {
    func addItemViewControllerDidCancel(_ controller: AddItemTableViewController)
    func addItemViewController(_ controller: AddItemTableViewController,didFinishAdding item: ChecklistItem)
    func addItemViewController(_ controller: AddItemTableViewController, didFinishEditing item: ChecklistItem)

}

class AddItemTableViewController: UITableViewController, UITextFieldDelegate {
    weak var delegate: AddItemTableViewControllerDelegate?
    var itemToEdit: ChecklistItem?

    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet var shouldRemindSwitch: UISwitch!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true    // initially set false
            //set ison and date to the one it was set of the checklist item if it was sent to edit
            shouldRemindSwitch.isOn = item.shouldRemind
            datePicker.date = item.dueDate
        }
       
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      textField.becomeFirstResponder() //so that the keyboard automatically comes up
    }
    
    // MARK: - Text Field Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      let oldText = textField.text!
        //let s = "hello"
        //print(s.count)
        
      let stringRange = Range(range, in: oldText)!
      let newText = oldText.replacingCharacters(in: stringRange, with: string)
//        print(oldText, oldText.count, newText)
      if newText.isEmpty {
        doneBarButton.isEnabled = false
      } else {
        doneBarButton.isEnabled = true
      }
      return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
      doneBarButton.isEnabled = false
      return true
    }

    // MARK: - Actions
    @IBAction func cancel() {
        delegate?.addItemViewControllerDidCancel(self)
    }

    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            
            item.scheduleNotification()
            
            delegate?.addItemViewController(self, didFinishEditing: item)
        }
        else {
            let item = ChecklistItem()
            item.text = textField.text!
            
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            //check if we should schedule a notification if date selected is greater than curr date
            item.scheduleNotification()
            
            delegate?.addItemViewController(self, didFinishAdding: item)
        }
    }
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
      textField.resignFirstResponder()
        
        //before we prompted 
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {_, _ in
            // do nothing
            }
        }
    }
}


