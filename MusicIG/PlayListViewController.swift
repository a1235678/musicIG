//
//  PlayListViewController.swift
//  MusicIG
//
//  Created by Apple Hsiao on 2017/1/3.
//  Copyright © 2017年 zeroplus. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MPMediaPickerControllerDelegate {
    
    @IBOutlet weak var songListTable: UITableView!
    
    var musicPlayer = MPMusicPlayerController.applicationMusicPlayer()
    var selectSong: MPMediaItemCollection?
    var timer: Timer!
    var currentSecond = 0.0

    @IBOutlet weak var Album: UIImageView!
    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var singer: UILabel!
    @IBOutlet weak var currenttime: UISlider!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PlayListViewController.refreshInfo), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var songCnt = 0
        
        if let cnt = selectSong?.count{
            songCnt = cnt
        }
        
        return songCnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "songlist",
                                          for: indexPath)
        let songName = cell.contentView.viewWithTag(1) as! UILabel
        let singer = cell.contentView.viewWithTag(2) as! UILabel
        let picture = cell.contentView.viewWithTag(3) as! UIImageView
        
        songName.text = selectSong?.items[indexPath.row].title
        singer.text = selectSong?.items[indexPath.row].artist
        picture.image = selectSong?.items[indexPath.row].artwork?.image(at: CGSize.init(width: 60, height: 60))
        
        return cell
    }
    
    @IBAction func addSongs(_ sender: Any) {
        let mediaPicker = MPMediaPickerController(mediaTypes: MPMediaType.anyAudio)
        
        mediaPicker.delegate = self
        
        //允許多選
        mediaPicker.allowsPickingMultipleItems = true

        self.present(mediaPicker, animated: true, completion: nil)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
            //離開選歌畫面
            self.dismiss(animated: true, completion: nil)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        //取得選取的歌曲
        selectSong = mediaItemCollection
        
        //放入播放清單
        musicPlayer.setQueue(with: selectSong!)
        musicPlayer.shuffleMode = .off
        
        //離開選歌畫面
        self.dismiss(animated: true, completion: nil)
        songListTable.reloadData()
        
        //開始播放音樂
        musicPlayer.play()
        musicPlayer.beginGeneratingPlaybackNotifications()

        if let timer = timer{
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PlayListViewController.updateTime), userInfo: nil, repeats: true)
    }
    
    //random
    @IBAction func random(_ sender: UIBarButtonItem) {
        if sender.title == "noRandom"{
            musicPlayer.shuffleMode = .off
            sender.title = "Random"
        }else{
            musicPlayer.shuffleMode = .songs
            sender.title = "noRandom"
        }
    }
    
    
    //repeat
    @IBAction func repeatButton(_ sender: UIBarButtonItem) {
        if sender.title == "Repeat"{
            
            musicPlayer.repeatMode = .all
            sender.title = "all"
            
        }
        
        else if sender.title == "all"{
            musicPlayer.repeatMode = .one
            sender.title = "1"
        }else{
            musicPlayer.repeatMode = .none
            sender.title = "Repeat"
        }
    }
    
    
    //選歌播放
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        musicPlayer.nowPlayingItem = (selectSong?.items[indexPath.row])! as MPMediaItem
    }
    
    @IBAction func play(_ sender: UIButton) {
        if sender.title(for: .normal) == "Play"{
            musicPlayer.play()
            sender.setTitle("Pause", for: .normal)
            //timer
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PlayListViewController.updateTime), userInfo: nil, repeats: true)
        }else{
            musicPlayer.pause()
            sender.setTitle("Play", for: .normal)
            timer.invalidate()
        }
    }
    
    @IBAction func next(_ sender: Any) {
        //if musicPlayer.indexOfNowPlayingItem == selectSong.count-1
        musicPlayer.skipToNextItem()
    }
    
    @IBAction func previous(_ sender: Any) {
        musicPlayer.skipToPreviousItem()
    }
    
    //更新資訊
    func refreshInfo(){
        currentSecond = 0.0
        
        songName = musicPlayer.nowPlayingItem?.title
        artist = musicPlayer.nowPlayingItem?.artist
        picture = musicPlayer.nowPlayingItem?.artwork?.image(at: CGSize.init(width: 375, height: 375))
        
        //第一頁資訊
        self.song.text = songName
        self.singer.text = artist
        Album.image = musicPlayer.nowPlayingItem?.artwork?.image(at: CGSize.init(width: Album.frame.width, height: Album.frame.height))
        
        //slider 最大值
        currenttime.maximumValue = Float((musicPlayer.nowPlayingItem?.playbackDuration)!)
        currenttime.setValue(Float(currentSecond), animated: true)
    }
    
    func updateTime(){
        currentSecond += 1
        currenttime.setValue(Float(currentSecond), animated: true)
    }
    
    @IBAction func sliderChange(_ sender: UISlider) {
        musicPlayer.currentPlaybackTime = Double(sender.value)
        currentSecond = Double(sender.value)
    }
}
