//
//  MasterViewController.swift
//  Plain Ol' Notes
//
//  Created by Amartya Banerjee on 1/29/16.
//  Copyright © 2016 Northwestern University. All rights reserved.
//

import UIKit

var objects: [String] = [String]()
var currentIndex: Int = 0
var masterView:MasterViewController?
var detailViewController:DetailViewController?

let kNotes = "notes"
let BLANK_NOTE = "(New Note)"

class MasterViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        masterView = self
        load()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        saveNote()
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        if objects.count == 0{
            insertNewObject(self)
        }
        
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        //this logic ensures that one does not have multiple blank notes, and we create a blank note IFF there are no notes
        //or there is a non-empty note on top
        if objects.count == 0 || objects[0] != BLANK_NOTE{
            objects.insert(BLANK_NOTE, atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        
        //every time we insert a new note, it's inserted at the top!
        currentIndex = 0
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
 
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //show detail is the string identifier that's attached to our detail view
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                currentIndex = indexPath.row
            }
            let object = objects[currentIndex]
            detailViewController?.detailItem = object
            detailViewController?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            detailViewController?.navigationItem.leftItemsSupplementBackButton = true
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    //this is called whenever we enter or exit editing mode
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing{
            return
        }
        saveNote()
    }
    
    //Now this button is not called when the edit button is pressed, it's called when an item is deleted by swiping it to the left. So we're supporting that as well, and saving that data to persistent storage.
    override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        saveNote()
    }
    
    func saveNote(){
        //User defaults saves data to persistent storage using key value pairs, so the key is our "k" all "Notes" which if we scroll to the top of our code is just the string "Notes" and the object that we're saving, or the value, is the value of the object's array.
       NSUserDefaults.standardUserDefaults().setObject(objects, forKey: kNotes)
       NSUserDefaults.standardUserDefaults().synchronize()
    }

    func load(){
        if let loadedData = NSUserDefaults.standardUserDefaults().arrayForKey(kNotes) as? [String]{
            objects = loadedData
        }
    }
}

