//
//  HomeViewController.swift
//  ionKhaleej
//
//  Created by Mohammad Tariq Shamim on 17/03/23.
//

import UIKit
import AVFoundation
import AVKit
import LanguageManager_iOS

class HomeViewController: UIViewController {
    
    @IBOutlet weak var CDNPlayer: UIView!
    @IBOutlet weak var ChannelNameLabel: UILabel!
    @IBOutlet weak var CategoriesLabel: UILabel!
    @IBOutlet weak var DescLablel: UILabel!
    @IBOutlet weak var favouriteBtnImage: UIImageView!
    @IBOutlet weak var shareBtnImage: UIImageView!
    @IBOutlet weak var labelError: UILabel!
    
    var channel_id: String = ""
    var slide: ImageSlide!
    
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    
    let defaults = UserDefaults.standard
    
    let current_language = LanguageManager.shared.currentLanguage

    override func viewDidLoad() {
        super.viewDidLoad()
        let leftLabel = UILabel()
        let rightLabel = UILabel()
        rightLabel.text = NetworkService.shared.app_name
        rightLabel.textColor = UIColor.gray
        if(current_language.rawValue == "en"){
            leftLabel.text = slide.channel_name
            ChannelNameLabel.text = slide.channel_name
            CategoriesLabel.text = slide.categories
            DescLablel.text = slide.description
        } else {
            rightLabel.text = slide.channel_name_ar
            ChannelNameLabel.text = slide.channel_name_ar
            CategoriesLabel.text = slide.categories_ar
            DescLablel.text = slide.description_ar
        }
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftLabel)
        let rightBarButtonItem = UIBarButtonItem(customView: rightLabel)
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        labelError.isHidden = true
        
        var favourites = defaults.string(forKey: "favourites")
    
        if(favourites == nil){
            favouriteBtnImage.image = UIImage(named: "star_outline")
        } else {
            var fav_array = favourites?.components(separatedBy: ",")
            for fav_id in fav_array!{
                if fav_id == channel_id{
                    favouriteBtnImage.image = UIImage(named: "icon_favorites_blue")
                }
            }
        }

        self.favouriteBtnImage.isUserInteractionEnabled = true
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        tapgesture.numberOfTapsRequired = 1
        self.favouriteBtnImage.addGestureRecognizer(tapgesture)
        
        startVideo()
    }
    
    func startVideo(){
        guard let url = URL(string: slide.cdn!) else {
            labelError.text = "Unable to play video. Please try after sometime"
            labelError.isHidden = false
            return
        }
        //let url = URL(string: "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8")
        player = AVPlayer (url: url)
        avpController.player = player
        avpController.view.frame = CDNPlayer.bounds
        self.addChild(avpController)
        self.CDNPlayer.addSubview(avpController.view)
        avpController.didMove(toParent: self)
        player.play()
    }
    
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        var favourites = defaults.string(forKey: "favourites")
        if(favourites == nil){
            favourites = channel_id + ","
            defaults.set(favourites, forKey: "favourites")
            favouriteBtnImage.image = UIImage(named: "icon_favorites_blue")
        } else {
            let fav_array = favourites?.components(separatedBy: ",")
            var fav_channel: Bool = false
            
            for fav_id in fav_array!{
                if fav_id == channel_id{
                    fav_channel = true
                    break
                }
            }
            
            if fav_channel{
                let favourites2 = defaults.string(forKey: "favourites")
                let fav_array2 = favourites2?.components(separatedBy: ",")
                var new_favorites = ""
                
                for fav_id2 in fav_array2!{
                    if fav_id2 == channel_id{
                        continue
                    } else {
                        if(fav_id2 != ""){
                            new_favorites += fav_id2 + ","
                        }
                    }
                }

                defaults.set("", forKey: "favourites")
                defaults.set(new_favorites, forKey: "favourites")
                favouriteBtnImage.image = UIImage(named: "star_outline")
            } else {
                favourites = favourites! + channel_id + ","
                defaults.set(favourites, forKey: "favourites")
                favouriteBtnImage.image = UIImage(named: "icon_favorites_blue")
            }
            
        }
        
        print(defaults.string(forKey: "favourites"))
    }

}
