//
//  popUpViewController.swift
//  PeriStem
//
//  Created by Sogol Moezzi on 2017-01-07.
//  Copyright © 2017 ArashAsh. All rights reserved.
//

import UIKit

class popUpViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var popUpStemTable: UITableView!
    // Input and output Stem List
    var inputStemList:Array = [String]()
    var checkedStemList:Array = [Bool]()
    var outputStemList:Array = [String]()
    var selectedSpeaker:String?
    // set parent view controller
    var parentVC: StemTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let parent  = self.parent?.view as! UITableViewController
        //let parentViewControllerSpeakerDict = (self.parent as! StemTableViewController).speakerDict
        //print(parentViewControllerSpeakerDict)
        
        
        // tint the background color
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        self.showAnimate()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        //check if each stem is checked and return the stems in output stem list
        for (ind, val) in self.checkedStemList.enumerated() {
            if val{
                self.outputStemList.append(self.inputStemList[ind])
            }
        }
        print("checked stems are: \(self.outputStemList)")
        parentVC?.speakerDict[selectedSpeaker!] = checkedStemList
        // execute removing view animation
        self.removeAnimate()
    }

    
    // add some animation to the popup VC
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.2, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
            
        })
    }
    
    // function to initiate checked array based on the stem input list count
    func initiatCheckedArray(stemNumber:Int) {
        let checkedArray = [Bool](repeating:false, count:stemNumber)
        self.checkedStemList = checkedArray
        //print("checked array initiated as: \(checkedArray)")
    }
    
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.inputStemList.count > 0{
            initiatCheckedArray(stemNumber: self.inputStemList.count)
            return inputStemList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.popUpStemTable.dequeueReusableCell(withIdentifier: "popUpCell", for: indexPath) 
        cell.textLabel?.text = inputStemList[indexPath.row]
        cell.accessoryType = .none //set cell defualt state as unchecked
        return cell
    }
    
    // Implement CheckBox
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.popUpStemTable.cellForRow(at: indexPath){
            //handle checked and unchecked cells
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                self.checkedStemList[indexPath.row] = true
                //print("selected \(self.inputStemList[indexPath.row])")
            } else {
                cell.accessoryType = .none
                //print("deselected \(self.inputStemList[indexPath.row])")
                self.checkedStemList[indexPath.row] = false
            }
        }
    }
 
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
