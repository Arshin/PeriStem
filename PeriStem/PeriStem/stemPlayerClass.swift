//
//  stemPlayerClass.swift
//  PeriStem
//
//  Created by Sogol Moezzi on 2017-01-18.
//  Copyright © 2017 ArashAsh. All rights reserved.
//

import UIKit
import AVFoundation

protocol stemPlayerClassViewControllerDelegate {
    func stemPlayerClassViewControllerDidSelect(value: String)
}

class stemPlayerClass: UIViewController {
    var newSongSelected: Bool = false
    // set parent view controller
    var delegate: SongsLibraryTableViewController?
    var player:AVAudioPlayer = AVAudioPlayer()
    var audioURL:URL? = nil
    var playing:Bool = false
    var selectedSongDict = Dictionary<String,Any>()
    var stems = Dictionary<String,String>()
    var stemList = [String]()
    var stemInPlayer = String()
    
    @IBOutlet var stemLabel: UILabel!
    
    @IBOutlet var songImageView: UIImageView!
    
    @IBOutlet var songBackgroundImageView: UIImageView!
    
    @IBOutlet var scrubSlider: UISlider!
    
    @IBAction func scrub(_ sender: Any) {
        player.currentTime = TimeInterval(scrubSlider.value)
    }
    
    @IBOutlet var volumeSlider: UISlider!
    
    @IBAction func changeVolume(_ sender: Any) {
        player.volume = volumeSlider.value
    }
    
    @IBOutlet var playButton: UIButton!
    
    @IBAction func playButton(_ sender: Any) {
        if self.playing != true{
            //play and update play button image
            player.play()
            playButton.setImage(#imageLiteral(resourceName: "iconPause"), for: UIControlState.normal)
            self.playing = true
        }else{
            //pausing and updating variables/images
            player.pause()
            self.playing = false
            playButton.setImage(#imageLiteral(resourceName: "iconPlay"), for: UIControlState.normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateScrubSlider(){
        scrubSlider.value = Float(player.currentTime)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if newSongSelected{
            //stemLabel.text = self.stemInPlayer
            self.prepareNewSong()
        }
        newSongSelected = false
    }
    
    func prepareNewSong(){
        
        // update song label
        stemLabel.text = self.stemInPlayer
        
        // extract file info
        let fileToPlay:NSString = self.stemInPlayer as NSString
        let fileName = fileToPlay.deletingPathExtension
        let fileExtension = fileToPlay.pathExtension
        print("filename: \(fileName), extention: \(fileExtension)")
        //set audio url
        self.audioURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension)
        //let audioPath = Bundle.main.url(forResource: "piano", withExtension: "mp3")
        //print("audio path is: \(audioURL)")
        // load audion url into player

        // set image for the album
        //print("image should be \(stemDictSelected["image"]!)")
        songImageView.image = UIImage(named: self.selectedSongDict["image"]! as! String)
        songBackgroundImageView.image = UIImage(named: self.selectedSongDict["image"]! as! String)
        
        //print("URL: ", self.audioURL!)
        self.player = AVAudioPlayer()
        do {
            try player = AVAudioPlayer(contentsOf: self.audioURL!)
        }catch{
            print("Some error with setting up the AVAudioPlayer")
        }
        
        
        // update scrub slider as song plays
        var timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateScrubSlider), userInfo: nil, repeats: true)
        
        // update scruber maximum value
        scrubSlider.maximumValue = Float(player.duration)
        

    }
    
    
    func preparePlayerForNewSong(selectedDict:Dictionary<String, Any>){
        self.selectedSongDict =  selectedDict
        print("here")
        newSongSelected = true
        print("selected dict is",selectedDict["stemDict"]!)
        if selectedDict.count > 0 {
            
            if newSongSelected{
                // reseting the self.stems list
                self.stemList = [String]()
            }
            self.stems = selectedSongDict["stemDict"] as! Dictionary<String, String>
            
            for key in self.stems.keys {
                self.stemList.append(key)
            }
            print("here is the stem list: ",self.stemList)
            self.stemInPlayer = self.stems[self.stemList[0]]!
            //self.stemInPlayer = "piano.mp3"
            print("selected \(self.stemInPlayer)")
            
        }
    }
    
    func initializeVCVariables(delegate: SongsLibraryTableViewController) {
        self.delegate = delegate
        //self.inputStemList = inputStems
        //self.selectedSpeaker = speakerID
        //self.checkedStemList = currentSelection
        //print(delegate, inputStems, speakerID, currentSelection)
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
