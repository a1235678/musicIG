//
//  NowPlayingViewController.swift
//  MusicIG
//
//  Created by Apple Hsiao on 2017/1/3.
//  Copyright © 2017年 zeroplus. All rights reserved.
//

import UIKit

var songName: String?
var artist: String?
var picture: UIImage?

class NowPlayingViewController: UIViewController {
    
    
    @IBOutlet weak var album: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        songLabel.text = songName
        singerLabel.text = artist
        album.image = picture
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")

        // Do any additional setup after loading the view.
    }
    
    func getUpdateNoti(noti:Notification) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
