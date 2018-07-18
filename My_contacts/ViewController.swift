//
//  ViewController.swift
//  My_contacts
//
//  Created by Dilyana Yankova on 7/18/18.
//  Copyright © 2018 Dilyana Yankova. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UITableViewController {

    let cellId = "cellId"
    
    //use custom delegation
    
    func method(cell: UITableViewCell) {
    //we are going to figure which name we click on
        //prevent ! wrapping
        guard  let indexPathTapped =  tableView.indexPath(for: cell) else {
            return
        }
        let contact = twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row]
        let hasFavorited = contact.hasFavorited
        twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row].hasFavorited = !hasFavorited //if it is favorite make it not...
        
        cell.accessoryView?.tintColor = hasFavorited ? UIColor.lightGray : .red
//        tableView.reloadRows(at: [indexPathTapped], with: .fade)
    }
    
    
    func fetchContext(){
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print (err)
                return
            }
            if granted {
                print("granted")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor] )
                
                do {
                    
                    var favoritableContacts = [FavoritableContact]()
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        print(contact.givenName)
                
                        favoritableContacts.append(FavoritableContact(contact: contact, hasFavorited: false))
                    })
                    
                    let names = ExpandlableNames(isExpanded: true, names: favoritableContacts)
                    self.twoDimensionalArray = [names]
                    
                    
                }  catch let err {
                        print(err)
                    }
            
            } else {
                print("denied")
            }
        }
    }
    
    //how many sections we need
    var twoDimensionalArray = [ExpandlableNames]()
//        ExpandlableNames(isExpanded: true, names: ["Ani", "Lili", "Dani", "Niki"].map{ FavoritableContact(name: $0, hasFavorited: false)
//        }),//1
//        ExpandlableNames(isExpanded: true, names: ["Tofi", "Eva", "Mia", "Lori"].map{ FavoritableContact(name: $0, hasFavorited: false)}) ,//2
//        ExpandlableNames(isExpanded: true, names: [FavoritableContact(name: "Sara", hasFavorited: false),  FavoritableContact(name: "Fifi", hasFavorited: false),  FavoritableContact(name: "Jamie", hasFavorited: false),  FavoritableContact(name: "Iva", hasFavorited: false)]),
//
//        ]
    //matrice
    
    var showIndexPaths = false
    
  @objc func handleShowIndexPath(button : UIButton){
    
    //create all the indexPaths we want to reload
    var indexPathsToReload = [IndexPath]()
    let section = button.tag //for all sections
    for section in twoDimensionalArray.indices {
        for row in twoDimensionalArray[section].names.indices {
           let indexPath = IndexPath(row: row, section: section)
            indexPathsToReload.append(indexPath)
        }
    }
    
        showIndexPaths = !showIndexPaths //to revert the position of animatiion
        let animationStyle  = showIndexPaths ? UITableViewRowAnimation.right  : .left
        let isExpanded = twoDimensionalArray[section].isExpanded
        if isExpanded {
         tableView.reloadRows(at: indexPathsToReload , with: animationStyle)
       }
    
    }
    
    @objc func handleExpandClose(button : UIButton){
    
        //we will try to clse sections by deletind rows
        var indexPaths = [IndexPath]()
        
        let section = button.tag //for all sections
        
        for row in twoDimensionalArray[section].names.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = twoDimensionalArray[section].isExpanded
         twoDimensionalArray[section].isExpanded = !isExpanded
        
        button.setTitle(isExpanded ? "Open" : "Close", for: .normal)
        if isExpanded {
          tableView.deleteRows(at: indexPaths, with: .fade)
        } else{
          tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchContext()
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show IndexPath", style: .plain, target: self, action: #selector(handleShowIndexPath))
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //tableview requires cell to be registered
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
    }
    
    //for divider of sections
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.yellow
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.tag = section
        
        return button
    }
    
    //the height!
  override  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return twoDimensionalArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !twoDimensionalArray[section].isExpanded {
            return 0
        }
        return twoDimensionalArray[section].names.count //number of sections
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)as! ContactCell
        
        let cell = ContactCell(style: .subtitle, reuseIdentifier: cellId) //for subtitle
        cell.link = self //!!!Otherwise it will be nil in ContactCell
        
        let favoritableContact = twoDimensionalArray[indexPath.section].names[indexPath.row] // matrice elements
        cell.textLabel?.text = favoritableContact.contact.givenName + " " + favoritableContact.contact.familyName
        
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        cell.detailTextLabel?.text = favoritableContact.contact.phoneNumbers.first?.value.stringValue
       
        cell.accessoryView?.tintColor = favoritableContact.hasFavorited ? UIColor.red : .lightGray
        
        return cell
    }
}

