//
//  StemTableViewController.swift
//  PeriStem
//
//  Created by Sogol Moezzi on 2016-10-28.
//  Copyright © 2016 ArashAsh. All rights reserved.
//

import UIKit

class speakerPairingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var stemDict = Dictionary<String,Any>()
    var stems = Dictionary<String,String>()
    var stemList = [String]()
    // speaker IDs are hard coded, to be replaced with searchForSpeaker method
    var speakerList = ["Speaker 1", "Speaker 2", "Speaker 3"]
    var speakerDict = Dictionary<String, Any>()
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if stemDict.count > 0 {
                //for stem in stemDict[0] {
                let selectedSongDict:Dictionary = stemDict
                stemDictSelected = stemDict // everytime StemTableViewController is populated this dictionary gets updated, at least I hope so!
                //print("STV transfered Dict", selectedSongDict)
                self.stems = selectedSongDict["stemDict"] as! Dictionary<String, String>
                for key in self.stems.keys {
                    self.stemList.append(key)
                }
            //print("stemList: \(stemList), speakerList: \(speakerList)")
            initializeSpeakerDict(stemList: stemList, speakerList: speakerList)
                
            }
            //if let label = self.detailDescriptionLabel {
            //    label.text = detail.timestamp!.description
            //}
            
            // initializing speaker dictionary
            
            
        }
    }
    
    func initializeSpeakerDict(stemList:[String], speakerList:[String]){
        
        for speaker in speakerList {
            
            self.speakerDict[speaker] = [Bool](repeating:false, count:stemList.count)
        }
        //print("initialized Speaker Dictionary \(self.speakerDict)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // prepare stemList and speakerDict
        self.configureView()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Song? {
        didSet {
            // Update the view.
            //print("myprint in detailItem")
            self.configureView()
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if stemDict.count > 0 {
            return speakerList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // define a tableViewCell from our costumTableViewCell Subclass
        let cell = tableView.dequeueReusableCell(withIdentifier: "stemCell", for: indexPath) as! costumTableViewCell
        // set stem song title
        cell.stemSongTitleLabel?.text = speakerList[indexPath[1]]
        // tag pairButton so that we now which one is selected
        cell.pairButton.tag = indexPath.row
        // add a target to the button
        cell.pairButton.addTarget(self, action: #selector(pairButtonAction), for: .touchUpInside)
        
        return cell
    }
    
    /*
    // first I was using table view to get to the player no longer applicable
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        stemInPlayer = self.stems[stemList[indexPath.row]]!
        print("will select \(stemInPlayer)")
        return indexPath
    }
    */
    
    // MARK: - pair button
    
    func pairButtonAction(sender: UIButton){
        
        let speakerID:String = speakerList[sender.tag]
        print("Pair for Speaker: \(speakerID) is pushed")
        
        // create popUp viewcontroller
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! popUpViewController
        
        self.addChildViewController(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        popUpVC.didMove(toParentViewController: self)
    
        // Initialize popUpVC Class Variables
        popUpVC.initializePopUpVCVariables(delegate: self, inputStems: self.stemList, speakerID: speakerID, currentSelection: self.speakerDict[speakerID] as! [Bool])

    }

    @IBAction func goToPlayerHandler(_ sender: Any) {
        //stemInPlayer = self.stems[stemList[indexPath.row]]!
        //stemInPlayer = self.stems[stemList[0]]! // should change to the collection of stems selected
        //print("will select \(stemInPlayer)")
    }
    
    func popUpViewControllerDidSelect(speakerID: String, selection: [Bool])  {
        //print("this is from the popup: ", speakerID)
        self.speakerDict[speakerID] = selection // selection from the popup is saved
    }
    
    @IBAction func resetAutoStemAssignmentButtonHandler(_ sender: Any) {
        print("Current speaker configureation is \(self.speakerDict)")
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
