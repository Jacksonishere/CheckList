//
//  AllListViewController.swift
//  CheckList
//
//  Created by Jackson Lu on 3/6/21.
//

import UIKit

class AllListViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Navigation Controller Delegates
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController,animated: Bool) {
        // Was the back button tapped?
        if viewController === self {
//            UserDefaults.standard.set(-1, forKey: "ChecklistIndex")
            dataModel.indexOfSelectedChecklist = -1   // change this
        }
    }
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        
//        let newRowIndex = dataModel.lists.count
//        dataModel.lists.append(checklist)
//
//        let indexPath = IndexPath(row: newRowIndex, section: 0)
//        let indexPaths = [indexPath]
//        tableView.insertRows(at: indexPaths, with: .automatic)
//
//        navigationController?.popViewController(animated: true)
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
//        if let index = dataModel.lists.firstIndex(of: checklist) {
//            let indexPath = IndexPath(row: index, section: 0)
//            if let cell = tableView.cellForRow(at: indexPath) {
//                cell.textLabel!.text = checklist.name
//            }
//        }
//        navigationController?.popViewController(animated: true)
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //set delegate in viewdidappear after viewdidload which loaded the viewcontrollers so this delegate wont fire off the willshow method overwriting  the userdefault
        navigationController?.delegate = self
            
        //dont want to register default cell.
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        //if the user last segued to the checklist vc, wouldve set this user default. so we set index. if it hasnt it would be -1. if it was, we want to segue to where the user left off
//        let index = UserDefaults.standard.integer(forKey: "ChecklistIndex")
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            print("Transitioning to where i left off")
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }

    let cellIdentifier = "ChecklistCell"
    //var dataModel.lists = [Checklist]()
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //registers the cell identifier with the underlying table view.
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        //set title large
        navigationController?.navigationBar.prefersLargeTitles = true
        

        //adding fake data to the checklist item array
//        for list in dataModel.lists {
//            let item = ChecklistItem()
//            item.text = "Item for \(list.name)"
//            list.items.append(item)
//        }
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }
    //right now list contains statically created checklists
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //dont want to dequeue default cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let cell: UITableViewCell!
        //dequeues reusable cell. if nil
        if let tmp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = tmp
            print("Failure")
        }
        //create a new cell of a different style
        else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
            
        //set the properties of this new cell
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        //set the subtexts
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No Items)"
        }
        else {
            cell.detailTextLabel!.text = count == 0 ? "All Done" : "\(count) Remaining"
        }
        
        //set imageview
        cell.imageView!.image = UIImage(named: checklist.iconName)
        
        return cell
    }
    //used this method to performsegue when user selects a checklist cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = dataModel.lists[indexPath.row]
        
//        UserDefaults.standard.set(indexPath.row, forKey: "ChecklistIndex")
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    //two ways we perform segue. one is the one from select cell which does segue and passes in a checklist as the sender (can pass anything if you're not hooking up segue via a control (aka button))
    //another is throught he add button
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist"{
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist
        }
        else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        dataModel.lists.remove(at: indexPath.row)

        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    //other way to segue from tapping on accessory button in cell
    //we instnaitate a new vew controller, set its varaibles, and push on to that new controller
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        
        controller.delegate = self

        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist

        navigationController?.pushViewController(controller,animated: true)
    }
}
