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
    
    @IBOutlet weak var pauseTrackButton: UIButton!
    @IBOutlet weak var playOrPauseMusic: UIButton!
    @IBOutlet weak var nextTrackButton: UIButton!
    
    @IBOutlet weak var notesField: UITextView!

    // Notes functionality
    // *******************
    @IBAction func doneText(_ sender: Any) {
        self.view.endEditing(true)
    }

    // Stopwatch functionality
    // ***********************
    @objc func updateTimer() {
        counter = counter + 0.1
        let minutes = Int(counter / 60)
        let seconds = Int(counter / 1) % 60
        let milliseconds = Int(counter.truncatingRemainder(dividingBy: 1) * 10)
        timeLabel.text = String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds)
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
    
    // Music player functionality
    // **************************
    @objc func updatePlayingTimer() {
        let currentTime = Int(musicPlayer.currentPlaybackTime)
        let minutes = currentTime/60
        let seconds = currentTime - minutes * 60
        
        playedTime.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    // This is really just a Play button, too lazy to rename atm
    @IBAction func playOrPauseMusicButton(_ sender: Any) {
        playerTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatePlayingTimer), userInfo: nil, repeats: true)
        musicPlayer.play()
        isPlaying = true
        nowPlaying = musicPlayer.nowPlayingItem
        trackTitle.text = nowPlaying?.title
        
        playOrPauseMusic.isEnabled = false
        pauseTrackButton.isEnabled = true
    }
    
    @IBAction func pauseTrack(_ sender: Any) {
        if isPlaying {
            musicPlayer.pause()
            playerTimer.invalidate()
            isPlaying = false

            playOrPauseMusic.isEnabled = true
            pauseTrackButton.isEnabled = false
        }
    }
    
    @IBAction func nextTrack(_ sender: Any) {
        print("isPlaying: \(isPlaying)")
        musicPlayer.skipToNextItem()
        nowPlaying = musicPlayer.nowPlayingItem
        trackTitle.text = songTitleArtistFormatted(track: nowPlaying)
        
        playerTimer.invalidate()
        playedTime.text = "00:00"

        if (isPlaying) {
            playerTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatePlayingTimer), userInfo: nil, repeats: true)
        }
    }
    
    func songTitleArtistFormatted(track: MPMediaItem?) -> String? {
        if track != nil {
            let title = track!.title
            let artist = track!.artist
            return "\(title) - \(artist)"
        } else {
            return "not playing"
        }
    }
    let musicPlayer = MPMusicPlayerApplicationController.systemMusicPlayer
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

