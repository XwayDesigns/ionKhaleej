//
//  InfoViewController.swift
//  ionKhaleej
//
//  Created by Mohammad Tariq Shamim on 17/04/23.
//

import UIKit
import LanguageManager_iOS

class InfoViewController: UIViewController {

    @IBOutlet weak var ButtonEnglish: UIButton!
    @IBOutlet weak var ButtonArabic: UIButton!
    
    var customer: CustomerModel!
    var customer_name = ""
    var customer_name_ar = ""
    var logo = ""
    var email = ""
    var mobile = ""
    var disclaimer = ""
    var disclaimer_ar = ""
    var about = ""
    var about_ar = ""
    var terms = ""
    var terms_ar = ""
    var privacy = ""
    var privacy_ar = ""
    
    let current_language = LanguageManager.shared.currentLanguage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButton

        // Do any additional setup after loading the view.
        NetworkService.shared.customer() { [weak self] (result) in
            switch result {
            case .success(let customer):
                self?.customer_name = customer.customer_name ?? ""
                self?.customer_name_ar = customer.customer_name_ar ?? ""
                self?.logo = customer.logo ?? ""
                self?.email = customer.email ?? ""
                self?.mobile = customer.mobile ?? ""
                self?.disclaimer = customer.disclaimer ?? ""
                self?.disclaimer_ar = customer.disclaimer_ar ?? ""
                self?.about = customer.about ?? ""
                self?.about_ar = customer.about_ar ?? ""
                self?.terms = customer.terms ?? ""
                self?.terms_ar = customer.terms_ar ?? ""
                self?.privacy = customer.privacy ?? ""
                self?.privacy_ar = customer.privacy_ar ?? ""
            case .failure(let error):
                print(error)
            }
        }
        
        if(current_language.rawValue == "en"){
            ButtonEnglish.isSelected = true
        } else {
            ButtonArabic.isSelected = true
        }
    }
    
    @IBAction func btnAbout(_ sender: Any) {
        let aboutVC = storyboard?.instantiateViewController(withIdentifier: "aboutVC") as! AboutViewController
        aboutVC.logo = logo
        if(current_language.rawValue == "en"){
            aboutVC.customer_name = customer_name
            aboutVC.about = about
        } else {
            aboutVC.customer_name = customer_name_ar
            aboutVC.about = about_ar
        }
        aboutVC.email = email
        aboutVC.mobile = mobile
        self.navigationController?.pushViewController(aboutVC, animated: true)
    }
    
    @IBAction func btnDisclaimer(_ sender: Any) {
        let infoDetailsVC = storyboard?.instantiateViewController(withIdentifier: "infoDetailsVC") as! InfoDetailsViewController
        infoDetailsVC.logo = logo
        if(current_language.rawValue == "en"){
            infoDetailsVC.type = "Disclaimer"
            infoDetailsVC.desc = disclaimer
        } else {
            infoDetailsVC.type = "تنصل"
            infoDetailsVC.desc = disclaimer_ar
        }
        self.navigationController?.pushViewController(infoDetailsVC, animated: true)
    }
    
    @IBAction func btnPrivacy(_ sender: Any) {
        let infoDetailsVC = storyboard?.instantiateViewController(withIdentifier: "infoDetailsVC") as! InfoDetailsViewController
        infoDetailsVC.logo = logo
        if(current_language.rawValue == "en"){
            infoDetailsVC.type = "Privacy Policy"
            infoDetailsVC.desc = privacy
        } else {
            infoDetailsVC.type = "سياسة الخصوصية"
            infoDetailsVC.desc = privacy_ar
        }
        self.navigationController?.pushViewController(infoDetailsVC, animated: true)
    }
    
    @IBAction func btnTerms(_ sender: Any) {
        let infoDetailsVC = storyboard?.instantiateViewController(withIdentifier: "infoDetailsVC") as! InfoDetailsViewController
        infoDetailsVC.logo = logo
        if(current_language.rawValue == "en"){
            infoDetailsVC.type = "Terms & Conditions"
            infoDetailsVC.desc = terms
        } else {
            infoDetailsVC.type = "الأحكام والشروط"
            infoDetailsVC.desc = terms_ar
        }
        self.navigationController?.pushViewController(infoDetailsVC, animated: true)
    }
    
    @IBAction func btnEnglish(_ sender: Any) {
        LanguageManager.shared.setLanguage(language: .en)
            { title -> UIViewController in
              let storyboard = UIStoryboard(name: "Main", bundle: nil)
              // the view controller that you want to show after changing the language
              return storyboard.instantiateInitialViewController()!
            } animation: { view in
              // do custom animation
              view.transform = CGAffineTransform(scaleX: 2, y: 2)
              view.alpha = 0
            }
    }
    @IBAction func btnArabic(_ sender: Any) {
        LanguageManager.shared.setLanguage(language: .ar)
            { title -> UIViewController in
              let storyboard = UIStoryboard(name: "Main", bundle: nil)
              // the view controller that you want to show after changing the language
              return storyboard.instantiateInitialViewController()!
            } animation: { view in
              // do custom animation
              view.transform = CGAffineTransform(scaleX: 2, y: 2)
              view.alpha = 0
            }
    }
    
}
