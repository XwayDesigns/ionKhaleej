//
//  InfoDetailsViewController.swift
//  ionKhaleej
//
//  Created by Mohammad Tariq Shamim on 17/04/23.
//

import UIKit
import LanguageManager_iOS

class InfoDetailsViewController: UIViewController {

    @IBOutlet weak var TVDesc: UITextView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    var logo: String = ""
    var type: String = ""
    var desc: String = ""
    
    let current_language = LanguageManager.shared.currentLanguage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftLabel = UILabel()
        let rightLabel = UILabel()
        
        rightLabel.text = NetworkService.shared.app_name
        rightLabel.textColor = UIColor.gray
        
        leftLabel.text = type
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftLabel)
        let rightBarButtonItem = UIBarButtonItem(customView: rightLabel)
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        if(current_language.rawValue == "en"){
            TVDesc.textAlignment = .left
        } else {
            TVDesc.textAlignment = .right
        }
        
        TVDesc.text = desc
        let url = URL(string: logo)!
        NetworkService.shared.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.imgLogo.image = UIImage(data: data)
            }
        }
    }

}
