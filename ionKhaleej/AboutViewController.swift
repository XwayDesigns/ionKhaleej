//
//  AboutViewController.swift
//  ionKhaleej
//
//  Created by Mohammad Tariq Shamim on 17/04/23.
//

import UIKit
import LanguageManager_iOS

class AboutViewController: UIViewController {

    @IBOutlet weak var labelCompany: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelMobile: UILabel!
    @IBOutlet weak var TVAbout: UITextView!
    @IBOutlet weak var labelAboutHeading: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    var logo: String = ""
    var customer_name: String = ""
    var email: String = ""
    var mobile: String = ""
    var about: String = ""
    
    let current_language = LanguageManager.shared.currentLanguage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftLabel = UILabel()
        let rightLabel = UILabel()
        rightLabel.text = NetworkService.shared.app_name
        rightLabel.textColor = UIColor.gray
        
        if(current_language.rawValue == "en"){
            leftLabel.text = "About Us"
            TVAbout.textAlignment = .left
        } else {
            leftLabel.text = "من نحن"
            TVAbout.textAlignment = .right
        }
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftLabel)
        let rightBarButtonItem = UIBarButtonItem(customView: rightLabel)
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        labelCompany.text = customer_name
        labelEmail.text = "Email: " + email
        labelMobile.text = "Mobile: " + mobile
        TVAbout.text = about
        
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
