//
//  PlayerClass.swift
//  PeriStem
//
//  Created by Arash Ashtiani on 2016-11-27.
//  Copyright © 2016 ArashAsh. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerClass: UIViewController {
    
    var player:AVAudioPlayer = AVAudioPlayer()
    var audioURL:URL? = nil
    var playing:Bool = false
    
    @IBOutlet var songImageView: UIImageView!
    
    @IBOutlet var songBackgroundImageView: UIImageView!
    
    @IBOutlet var songLabel: UILabel!
    
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
        if stemInPlayer != nil{
            prepareNewSong()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateScrubSlider(){
        scrubSlider.value = Float(player.currentTime)
    }
    
    func prepareNewSong(){
        
        // update somg label
        songLabel.text = stemInPlayer!
        
        
        // extract file info
        let fileToPlay:NSString = stemInPlayer! as NSString
        let fileName = fileToPlay.deletingPathExtension
        let fileExtension = fileToPlay.pathExtension
        print("filename: \(fileName), extention: \(fileExtension)")
        //set audio url
        self.audioURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension)
        //let audioPath = Bundle.main.url(forResource: "piano", withExtension: "mp3")
        //print("audio path is: \(audioURL)")
        // load audion url into player
        
        do {
            try player = AVAudioPlayer(contentsOf: self.audioURL!)
        }catch{}
        
        // update scrub slider as song plays
        var timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateScrubSlider), userInfo: nil, repeats: true)
        
        // update scruber maximum value
        scrubSlider.maximumValue = Float(player.duration)
        
        // set image for the album
        //let controller = (segue.destination as! UINavigationController).topViewController as! StemTableViewController
        print("image should be \(stemDictSelected["image"]!)")
        songImageView.image = UIImage(named: stemDictSelected["image"]! as! String)
        songBackgroundImageView.image = UIImage(named: stemDictSelected["image"]! as! String)
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
