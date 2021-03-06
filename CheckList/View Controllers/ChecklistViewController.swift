//
//  ChecklistTableViewController.swift
//  CheckList
//
//  Created by Jackson Lu on 2/20/21.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemTableViewControllerDelegate{
    
    //var items = [ChecklistItem]()
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        print("Documents folder is \(documentsDirectory())")
//        print("Data file path is \(dataFilePath())")
//
        //changes title in the nav bar
        title = checklist.name
        //doesnt allow large title
        navigationItem.largeTitleDisplayMode = .never
        
        //items = checklist.items
        
        //loadChecklistItems()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    
    // MARK: - Helper Functions
    func configureCheckmark(for cell: UITableViewCell,with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        }
        else {
            label.text = ""
        }
        //saveChecklistItems()
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
//        label.text = "\(item.itemID): \(item.text)"
    }
    
//    func documentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//
//    func dataFilePath() -> URL {
//        return documentsDirectory().appendingPathComponent("Checklists.plist")
//    }
//
//    func saveChecklistItems() {
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(items)
//            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
//        }
//        catch {
//            print("Error encoding item array: \(error.localizedDescription)")
//        }
//    }
//
//    func loadChecklistItems() {
//        let path = dataFilePath()
//
//        if let data = try? Data(contentsOf: path) {
//            let decoder = PropertyListDecoder()
//            do {
//                items = try decoder.decode([ChecklistItem].self, from: data)
//            }
//            catch {
//                print("Error decoding item array: \(error.localizedDescription)")
//            }
//        }
//    }
    
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return items.count
        return checklist.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        //let item = items[indexPath.row]       // Add this
        let item = checklist.items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            //let item = items[indexPath.row]
            let item = checklist.items[indexPath.row]
            
            item.checked.toggle()

            configureCheckmark(for: cell, with: item)
          }
          tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      // 1 Remove from datasource
        //items.remove(at: indexPath.row)
        checklist.items.remove(at: indexPath.row)

      // 2 Remove from table view
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        //saveChecklistItems()
    }

    
    
    // MARK: -AddItemTableViewController delegate protocol methods
    
    func addItemViewControllerDidCancel(_ controller: AddItemTableViewController) {
        //print("Ive been summoned")
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemTableViewController, didFinishAdding item: ChecklistItem){
//        let newRowIndex = items.count
//        items.append(item)
        let newRowIndex = checklist.items.count
        checklist.items.append(item)

        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        
        //saveChecklistItems()

    }
    
    func addItemViewController(_ controller: AddItemTableViewController, didFinishEditing item: ChecklistItem){
        //if let index = items.firstIndex(of: item)
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        
        //saveChecklistItems()
    }

    
    
    // MARK: -Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! AddItemTableViewController
            controller.delegate = self
        }
        
        else if segue.identifier == "EditItem" {
            let controller = segue.destination as! AddItemTableViewController
            controller.delegate = self

            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
//                controller.itemToEdit = items[indexPath.row]
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
}
