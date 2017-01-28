//
//  MasterViewController.swift
//  PeriStem
//
//  Created by Sogol Moezzi on 2016-10-28.
//  Copyright © 2016 ArashAsh. All rights reserved.
//

import UIKit
import CoreData

//var stemInPlayer:String? = nil // this is the name of the stem selected, to be removed in near future
//var stemDictSelected = Dictionary<String,Any>() // this is the dictionary of the selected song
//var stemListforSongs = [Dictionary<String, String>()] // this list is coming form database, eventually

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var speakerPairingViewController: speakerPairingViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var fetchedDict = Dictionary<String, Dictionary<String, Any>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delete core Data
        clearCoreData()
        
        // add songs to the list, in future this is read form the user music library
        stemListforSongs.remove(at: 0) //remove the dummy object
        stemListforSongs.append(["name":"Oddity","Guitar":"TouchType_90_Rim_Dry01.wav", "Strings":"piano.mp3", "Piano": "piano.mp3", "artist":"David", "image":"spaceoddity.jpeg"])
        stemListforSongs.append(["name":"Space","Acoustic Guitar":"TouchType_90_Rim_Dry01.wav", "Lead Vocal":"piano.mp3", "artist":"Bowie", "image":"pianoImage.jpg"])
        
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        //let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewSong(_:)))
        //self.navigationItem.rightBarButtonItem = addButton
        insertNewSong(songDict: stemListforSongs[0] as NSDictionary)
        insertNewSong(songDict: stemListforSongs[1] as NSDictionary)
        
        self.fetchedDict = fetchSongsFromCoreData()
        //print("fetched Dic: ", self.fetchedDict.count)
        
        
        if let split = self.splitViewController {
            print(split.childViewControllers)
        
            
            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            
            //let songVC = songtabBarController.viewControllers[0] as! UITabBarController
            //let controller = songVC.viewControllers?[0] as! UINavigationController
            //print("controller is", controller.splitViewController?.viewControllers[1])
            //let controller = navigationController.topViewController
            //self.speakerPairingViewController = controller.topViewController as? speakerPairingViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clearCoreData(){
        // delete everything in the core data
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let req : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Song")
        req.returnsObjectsAsFaults = false
        do { let results = try context.fetch(req)
            if results.count > 0 {
                for result in results {
                    context.delete(result as! NSManagedObject)
                    do { try context.save()} catch {}
                }
            }
        } catch {}
    }
    
    func insertNewSong(songDict: NSDictionary) {
    //func insertNewSong(_ sender: Any, songDict: NSDictionary) {
            
        let context = self.fetchedResultsController.managedObjectContext
        let newSong = Song(context: context)
        // If appropriate, configure the new managed object.
        newSong.name = (songDict["name"] as! String)
        newSong.artist = (songDict["artist"] as! String)
        newSong.image = (songDict["image"] as! String)
        
        var firstStemAdded = false
        // assign stems in the CoreData
        for file in songDict{
            if file.key as! String != "name" && file.key as! String != "artist" && file.key as! String != "image"{
                let entityStems = NSEntityDescription.entity(forEntityName: "Stems", in: self.managedObjectContext!)
                let newStem = NSManagedObject(entity: entityStems!, insertInto: self.managedObjectContext!)
                newStem.setValue(file.key, forKey: "name")
                newStem.setValue(file.value, forKey: "file")
                if firstStemAdded {
                    // first stem is added so we only need to update the mutable set from core data
                    // Note: No neeed to update relationship, mutable set takes care of it
                    let stemSet = newSong.mutableSetValue(forKey: "songs")
                    stemSet.add(newStem)
                } else {
                    // add first stem to newSong
                    newSong.setValue(NSSet(object:newStem), forKey: "songs")
                    firstStemAdded = true
                }
            }
        }
        // Save the context.
        do {
        try context.save()
        } catch {
         // Replace this implementation with code to handle the error appropriately.
         // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func fetchSongsFromCoreData(artist: String? = nil) -> Dictionary<String, Dictionary<String, Any>> {
        
        // return dictionary variable: Key = songName - ArtistName, Value=Any
        var resultsDictionary = Dictionary<String, Dictionary<String, Any>>()
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
        
        // Predicate
        // Note: You may tell the coreData what data you are looking for
        if artist != nil {
            let predicate = NSPredicate(format: "%K CONTAINS[c] %@", "artist", artist!) // %K for key, %@ for value, operator CONTAINS is for upper case [c] makes lower case
            fetchRequest.predicate = predicate
        }
        
        // Sort fetched results by name of the song first and name of the artist second
        let sortDescriptor1 = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "artist", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        // Execute Fetch Request
        do {
            let result = try self.managedObjectContext!.fetch(fetchRequest)
            for songObject in result {
                //let songID = songObject.objectID.description //create unique key for the results dictionary
                
                if let fetchedSong = songObject.value(forKey: "name"), let fetchedArtist = songObject.value(forKey: "artist"), let fetchedImage = songObject.value(forKey: "image"){
                    
                    var stemDict = Dictionary<String, String>()
                    let allStems = songObject.songs!.allObjects
                    for stem in allStems {
                        stemDict[(stem as! Stems).name!] = (stem as! Stems).file!
                    }
                    let cellID = "\(fetchedSong) - \(fetchedArtist)"
                    //setup the results dictionary
                    resultsDictionary[cellID] = ["name":fetchedSong, "artist":fetchedArtist, "object":songObject, "stemDict":stemDict, "image":fetchedImage]
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    return resultsDictionary
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = self.fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! speakerPairingViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                //controller.stemDict.insert(self.fetchedDict[String(indexPath[1])]!, at: 0)
                // set the stem list to the controller object
                //let selectedSongIndex:Int = indexPath[1]
                if controller.stemDict.count == 0{
                    //print("MVC selected dict", self.fetchedDict[selectedSongIndex])
                    
                    let cell = tableView.cellForRow(at: indexPath)// selected Cell
                    let cellID = cell?.textLabel?.text! //songID = SongName - ArtistName
                    controller.stemDict = self.fetchedDict[cellID!]!

                }
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let event = self.fetchedResultsController.object(at: indexPath)
        self.configureCell(cell, withEvent: event)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.delete(self.fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // set the cell name
    func configureCell(_ cell: UITableViewCell, withEvent event: Song) {
        if event.name?.description != nil{
            cell.textLabel!.text = "\(event.name!.description) - \(event.artist!.description)"
            
        }
    }
    
    // MARK: - Fetched results controller
    var fetchedResultsController: NSFetchedResultsController<Song> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<Song>? = nil
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Song)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
     // In the simplest, most efficient, case, reload the table view.
     self.tableView.reloadData()
     }
     */
    
}

