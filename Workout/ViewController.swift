//
//  ViewController.swift
//  Workout
//
//  Created by Brian Murphy on 6/26/18.
//  Copyright © 2018 Brian Murphy. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var playedTime: UILabel!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var playOrPauseMusic: UIButton!
    @IBOutlet weak var nextTrackButton: UIButton!
    
    @IBOutlet weak var notesField: UITextView!
    @IBAction func doneText(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc func updateTimer() {
        counter = counter + 0.1
        timeLabel.text = String(format: "%.1f", counter)
    }
    @objc func updatePlayingTimer() {
        counter = counter + 0.1
        playedTime.text = String(format: "%.1f", counter)
        
//        var currentTime = Int(audioPlayer.currentTime)
//        var minutes = currentTime/60
//        var seconds = currentTime - minutes * 60
//
//        playedTime.text = NSString(format: "%02d:%02d", minutes,seconds) as String
    }
    
    var counter = 0.0
    var timer = Timer()
    var isRunning = false
    
    @IBAction func startTimer(_ sender: Any) {
        if(isRunning) {
            return
        }
        startButton.isEnabled = false
        pauseButton.isEnabled = true
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isPlaying = true
    }
    @IBAction func pauseTimer(_ sender: Any) {
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        
        timer.invalidate()
        isPlaying = false
    }
    @IBAction func resetTImer(_ sender: Any) {
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        
        timer.invalidate()
        isRunning = false
        counter = 0.0
        timeLabel.text = String(counter)
    }
    
    @IBAction func playOrPauseMusicButton(_ sender: Any) {
        if (isPlaying) {
            musicPlayer.pause()
            isPlaying = false
        } else {
            playerTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatePlayingTimer), userInfo: nil, repeats: true)
            musicPlayer.play()
            isPlaying = true
            nowPlaying = musicPlayer.nowPlayingItem
            trackTitle.text = nowPlaying?.title
        }
    }
    
    @IBAction func nextTrack(_ sender: Any) {
        print("isPlaying: \(isPlaying)")
        if (isPlaying) {
            musicPlayer.skipToNextItem()
        } else {
            print("no track playing")
        }
    }
    
    let musicPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
    var isPlaying = false
    var playerTimer: Timer!
    var nowPlaying: MPMediaItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        timeLabel.text = String(counter)
        pauseButton.isEnabled = false
        let musicQueue = MPMediaQuery.songs()
        musicPlayer.setQueue(with: musicQueue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

