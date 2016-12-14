//
//  DetailViewController.swift
//  PeriStem
//
//  Created by Sogol Moezzi on 2016-10-28.
//  Copyright © 2016 ArashAsh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var stemTable: UITableView!
    var stemDict = [Dictionary<String,String>()]
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if stemDict.count > 0 {
                for stem in stemDict[0] {
                    var stemList = [String]()
                    if stem.key != "name"{
                        stemList.append(stem.key)
                    }
                }
            }
            //if let label = self.detailDescriptionLabel {
            //    label.text = detail.timestamp!.description
            //}
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Event? {
        didSet {
            // Update the view.
            stemDict.remove(at: 0) //remove dummy object
            self.configureView()
        }
    }
    // table View controller (Stem List)
    
}

