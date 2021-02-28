//
//  AddItemTableViewController.swift
//  CheckList
//
//  Created by Jackson Lu on 2/25/21.
//

import UIKit

//Usually, we define class className : inheritclassfrom
protocol AddItemTableViewControllerDelegate: class {
  func addItemViewControllerDidCancel(_ controller: AddItemTableViewController)
  
    func addItemViewController(_ controller: AddItemTableViewController,didFinishAdding item: ChecklistItem)
}

class AddItemTableViewController: UITableViewController, UITextFieldDelegate {
    weak var delegate: AddItemTableViewControllerDelegate?

    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
      let newText = oldText.replacingCharacters(
        in: stringRange,
        with: string)
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
        let item = ChecklistItem()
        item.text = textField.text!

        delegate?.addItemViewController(self, didFinishAdding: item)
    }
}


