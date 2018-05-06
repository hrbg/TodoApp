//
//  TodoTableViewController.swift
//  TodoApp
//
//  Created by Hector Bavio on 26/04/2018.
//  Copyright © 2018 Hector Ramon Bavio Garbarino. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ToDoTableViewController: UITableViewController {
    
    var todoItems:[TodoItem]!
    var peerID:MCPeerID!
    var mcSession:MCSession!
    var mcAdvertiserAssistant:MCAdvertiserAssistant!
    var connectionButtonReference:UIButton!
    var filteredTodoItems: [TodoItem]!
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        createSearchBar()
        setupConnectivity()
        loadData()
        setupProgressView()
    }
    
    func createSearchBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func addNewTodo() {
        let addAlert = UIAlertController(title: "New Todo", message: "Enter a title", preferredStyle: .alert)
        
        addAlert.addTextField { (textfield:UITextField) in
            textfield.placeholder = "ToDo Item Title"
        }
        
        addAlert.addAction(UIAlertAction(title: "Create", style: .default, handler: { (action:UIAlertAction) in
            guard let title = addAlert.textFields?.first?.text else { return }
            let newTodo = TodoItem(title: title, completed: false, createdAt: Date(), itemIdentifier: UUID())
            
            newTodo.saveItem()
            self.todoItems.append(newTodo)
            let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.setupProgressView()
        }))
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(addAlert, animated: true, completion: nil)
    }
    
    func showConnectivityAction() {
        let actionSheet = UIAlertController(title: "ToDo Exchange", message: "Do you want to host or join a session", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Host Session", style: .default, handler: { (action:UIAlertAction) in
            self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hrbg-todo", discoveryInfo: nil, session: self.mcSession)
            self.mcAdvertiserAssistant.start()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Join Session", style: .default, handler: { (action:UIAlertAction) in
            let mcBrowser = MCBrowserViewController(serviceType: "hrbg-todo", session: self.mcSession)
            mcBrowser.delegate = self
            self.present(mcBrowser, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func setupConnectivity() {
        peerID             = MCPeerID(displayName: UIDevice.current.name)
        mcSession          = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    
    func loadData() {
        todoItems = [TodoItem]()
        todoItems = DataManager.loadAll(TodoItem.self).sorted(by: { $0.createdAt < $1.createdAt })
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredTodoItems.count : todoItems.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ToDoTableViewCell
        
        let todoItem = isFiltering() ? filteredTodoItems[indexPath.row] : todoItems[indexPath.row]

        cell.todoLabel.text = todoItem.title
        if todoItem.completed {
            cell.todoLabel.attributedText = strikeThrough(todoItem.title)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let shareAction = UITableViewRowAction(style: .normal, title: "Share") { (action:UITableViewRowAction, indexPath:IndexPath) in
            let todoItem = self.todoItems[indexPath.row]
            self.sendTodo(todoItem)
        }
        shareAction.backgroundColor = UIColor(named: "mainBlueColor")
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (action:UITableViewRowAction, indexPath:IndexPath) in
            self.todoItems[indexPath.row].deleteItem()
            self.todoItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.setupProgressView()
        }
        deleteAction.backgroundColor = UIColor(named: "mainRedColor")

        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action:UITableViewRowAction, indexPath:IndexPath) in
            let todoItem             = self.todoItems[indexPath.row]
            let detailViewController = DetailTodoViewController()
            detailViewController.todoItem = todoItem
            detailViewController.indexPath = indexPath
            detailViewController.todoItemDelegate = self
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
        editAction.backgroundColor = UIColor(named: "mainGreenColor")
        
        return [deleteAction, shareAction, editAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didMarkAsCompleted(at: indexPath)
    }

    
    func strikeThrough(_ text:String) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
    
    func sendTodo(_ todoItem:TodoItem) {
        if mcSession.connectedPeers.count > 0 {
            if let todoData = DataManager.loadData(todoItem.itemIdentifier.uuidString) {
                do {
                    try mcSession.send(todoData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    print("Could not send todo Item")
                }
            }
        } else {
            showConnectivityAction()
        }
    }
    
    fileprivate func toggleAttributedText(for todoItem: TodoItem) -> NSAttributedString {
        return todoItem.completed ? strikeThrough(todoItem.title) : NSMutableAttributedString(string: todoItem.title, attributes: [:])
    }
    
    fileprivate func setupProgressView() {
        let completedTodos = todoItems.filter { (todoItem) -> Bool in
            todoItem.completed
        }

        let progress = Float(completedTodos.count) / Float(todoItems.count)
        progressView.setProgress(progress, animated: true)
    }
    
    func completeItemToggle(_ indexPath:IndexPath) {
        var todoItem = todoItems[indexPath.row]
        todoItem.toggle()
        todoItems[indexPath.row] = todoItem
        setupProgressView()
        if let cell = tableView.cellForRow(at: indexPath) as? ToDoTableViewCell {
            cell.todoLabel.attributedText = toggleAttributedText(for: todoItem)
            
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = cell.transform.scaledBy(x: 1.5, y: 1.5)
            }, completion: {(success) in
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform.identity
                }, completion: nil)
            })
        }
        
    }


}

// MARK: - MC Delegate Functions
extension ToDoTableViewController: MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
        case MCSessionState.connecting:
            print("Connected: \(peerID.displayName)")
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let todoItem = try JSONDecoder().decode(TodoItem.self, from: data)
            DataManager.save(todoItem, with: todoItem.itemIdentifier.uuidString)
            DispatchQueue.main.async {
                self.loadData()
            }
        } catch {
            print("Unable to process the recieved data")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    

}

// MARK - Search todo Item

extension ToDoTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print(#function)
        filterContentForSearchText(searchController.searchBar.text!)

    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredTodoItems = todoItems.filter({( todoItem: TodoItem) -> Bool in
            return todoItem.title.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}


// MARK - Update todo item delegate

extension ToDoTableViewController: UpdatingTodoItemDelegate {
    func didMarkAsCompleted(at indexPath: IndexPath) {
        var todoItem = todoItems[indexPath.row]
        todoItem.toggle()
        todoItems[indexPath.row] = todoItem
        setupProgressView()
        if let cell = tableView.cellForRow(at: indexPath) as? ToDoTableViewCell {
            cell.todoLabel.attributedText = toggleAttributedText(for: todoItem)
            
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = cell.transform.scaledBy(x: 1.5, y: 1.5)
            }, completion: {(success) in
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform.identity
                }, completion: nil)
            })
        }

    }
    
    func didChangeTodo(title: String, at indexPath: IndexPath) {
        print(#function)
        var todoItem = todoItems[indexPath.row]
        todoItem.title = title
        todoItem.saveItem()
        todoItems[indexPath.row] = todoItem
        tableView.reloadData()
    }
}
