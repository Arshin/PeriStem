//
//  StemTableViewController.swift
//  PeriStem
//
//  Created by Sogol Moezzi on 2016-10-28.
//  Copyright © 2016 ArashAsh. All rights reserved.
//

import UIKit

class StemTableViewController: UITableViewController {

    var stemDict = Dictionary<String,Any>()
    var stems = Dictionary<String,String>()
    var stemList = [String]()
    
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
            }
            //if let label = self.detailDescriptionLabel {
            //    label.text = detail.timestamp!.description
            //}
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("myprint in viewdidload")
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if stemDict.count > 0 {
            return stemList.count
        } else {
            return 0
        }
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

/*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stemCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = String(describing: indexPath)
        return cell
    }
 */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "stemCell", for: indexPath)
        cell.textLabel?.text = String(describing: stemList[indexPath[1]])
        return cell
        */
        
        // define a tableViewCell from our costumTableViewCell Subclass
        let cell = tableView.dequeueReusableCell(withIdentifier: "stemCell", for: indexPath) as! costumTableViewCell
        // set stem song title
        cell.stemSongTitleLabel?.text = stemList[indexPath[1]]
        // tag pairButton so that we now which one is selected
        cell.pairButton.tag = indexPath.row
        // add a target to the button
        cell.pairButton.addTarget(self, action: #selector(pairButtonAction), for: .touchUpInside)
        
        return cell
        
    }

    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        stemInPlayer = self.stems[stemList[indexPath.row]]!
        print("will select \(stemInPlayer)")
        return indexPath
    }
    
    func pairButtonAction(sender: UIButton){
        print("Pair Button is pushed for stem: \(stemList[sender.tag])")
        
        //let firstActivityItem = "\(stemList[sender.tag])"
        
        // creat a pop-up menu of the stems OR speakers depending on chosen design, i.e. Stem Vs Speaker importance
        /*
        let activiyViewController: UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        
        self.present(activiyViewController, animated: true, completion: nil)
        
        */
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! popUpViewController
        self.addChildViewController(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        popUpVC.didMove(toParentViewController: self)
        
        
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
