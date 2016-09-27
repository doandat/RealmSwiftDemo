//
//  ViewController.swift
//  RealmSwiftDemo
//
//  Created by DatDV on 9/20/16.
//  Copyright © 2016 DatDV. All rights reserved.
//

import UIKit
import RealmSwift

class DemoObject: Object {
    dynamic var title = ""
    dynamic var date = NSDate()
}

class Cell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
}

class ViewController: UITableViewController {
    
    let realm = try! Realm()
    let results = try! Realm().objects(DemoObject.self).sorted("date")
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // Set results notification block
        self.notificationToken = results.addNotificationBlock { (changes: RealmCollectionChange) in
            switch changes {
            case .Initial:
                // Results are now populated and can be accessed without blocking the UI
                self.tableView.reloadData()
                break
            case .Update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the TableView
                self.tableView.beginUpdates()
                self.tableView.insertRowsAtIndexPaths(insertions.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)
                self.tableView.deleteRowsAtIndexPaths(deletions.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)
                self.tableView.reloadRowsAtIndexPaths(modifications.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)
                self.tableView.endUpdates()
                break
            case .Error(let err):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(err)")
                break
            }
        }
    }
    
    // UI
    
    func setupUI() {
        tableView.registerClass(Cell.self, forCellReuseIdentifier: "cell")
        
        self.title = "TableView"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "BG Add", style: .Plain,
                                                                target: self, action: #selector(backgroundAdd))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add,
                                                                 target: self, action: #selector(add))
    }
    
    // Table view data source
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! Cell
        
        let object = results[indexPath.row]
        cell.textLabel?.text = object.title
        cell.detailTextLabel?.text = object.date.description
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            realm.beginWrite()
            realm.delete(results[indexPath.row])
            try! realm.commitWrite()
        }
    }
    
    // Actions
    
    func backgroundAdd() {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        // Import many items in a background thread
        dispatch_async(queue) {
            // Get new realm and table since we are in a new thread
            let realm = try! Realm()
            realm.beginWrite()
            for _ in 0..<5 {
                // Add row via dictionary. Order is ignored.
                realm.create(DemoObject.self, value: ["title": ViewController.randomString(), "date": ViewController.randomDate()])
            }
            try! realm.commitWrite()
        }
    }
    
    func add() {
        realm.beginWrite()
        realm.create(DemoObject.self, value: [ViewController.randomString(), ViewController.randomDate()])
        try! realm.commitWrite()
    }
    
    // Helpers
    
    class func randomString() -> String {
        return "Title \(arc4random())"
    }
    
    class func randomDate() -> NSDate {
        return NSDate(timeIntervalSince1970: NSTimeInterval(arc4random()))
    }
}