//
//  ReceptionalistView.swift
//  Garage
//  Created by Amjad Ali on 6/13/18.
//  Copyright © 2018 Amjad Ali. All rights reserved.
//

import UIKit
import Kingfisher


class ReceptionalistView: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var footerViewContainer: UIView!
    @IBOutlet weak var footerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var offlibebtn: UIButton!
    @IBOutlet weak var profileBtnOutlet: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var footerViewheight: CGFloat = 0.0
    var orginalHeight: CGFloat = 0.0
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // GeneralNibView.frame.size = settingContianerPop.frame.size
        profileBtnOutlet.setTitle(Constants.FirstName,for: .normal)
        if self.profileImage.image == nil {
            if let url = URL(string: Constants.userImage) {
                print(Constants.userImage)
                self.profileImage.kf.indicatorType = .activity
                self.profileImage.kf.setImage(with: url)
                
            }}
        
        if L102Language.currentAppleLanguage() == "ar" {

            profileBtnOutlet.imageEdgeInsets = UIEdgeInsets(top: 0, left:10, bottom: 0, right: 0)
        }
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        footerViewHeightConstraint.constant = headerView.frame.size.height
        if footerViewHeightConstraint.multiplier > 0 {
            footerViewheight = footerViewHeightConstraint.constant
        }
        orginalHeight = UIScreen.main.bounds.height
        showView(index: 1)
    }
    
    
    
    
    
    @IBAction func profileBtn(_ sender: Any) {
        //    showLocationTable ()
        //   self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    
    @IBAction func logoutButton(_ sender: Any) {
        
        
        //        Constants.platenmb = "0"
        //        Constants.vinnmb = "0"
        //        Constants.CarIDData = 0
        //        Constants.sessions = ""
        //        dismiss(animated: true, completion: nil)
        
        var storyboard: UIStoryboard!
        var popController: UIViewController!
        storyboard = UIStoryboard(name: Constants.XZReportViewController, bundle: nil)
        popController = storyboard.instantiateViewController(withIdentifier: Constants.XZReportViewControllerVc) as! XZReportViewController
        let nav = UINavigationController(rootViewController: popController)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let heightForPopOver = 20*4
        let popover = nav.popoverPresentationController
        popController.preferredContentSize = CGSize(width: 500 , height: heightForPopOver)
        popover?.permittedArrowDirections = .up
        popover?.backgroundColor = UIColor.white
        popover?.sourceView = self.offlibebtn
        popover?.sourceRect = self.offlibebtn.bounds
        self.present(nav, animated: true, completion: nil)
        
    }
    
    
    
    func showLocationTable () {
        var storyboard: UIStoryboard!
        var popController: UIViewController!
        storyboard = UIStoryboard(name: Constants.profilepop, bundle: nil)
        popController = storyboard.instantiateViewController(withIdentifier: Constants.profilepop) as! profilePOpViewController
        let nav = UINavigationController(rootViewController: popController)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let heightForPopOver = 70*3
        let popover = nav.popoverPresentationController
        popController.preferredContentSize = CGSize(width: 300 , height: heightForPopOver)
        popover?.permittedArrowDirections = .up
        popover?.backgroundColor = UIColor.white
        popover?.sourceView = self.profileBtnOutlet
        popover?.sourceRect = self.profileBtnOutlet.bounds
        self.present(nav, animated: true, completion: nil)
    }
    
    
    func showView(index: Int) {
        
        var storyboard: UIStoryboard!
        var vc: UIViewController!
        switch index {
        case 1:
            storyboard = UIStoryboard(name: Constants.WelcomeView, bundle: nil)
            vc = storyboard.instantiateViewController(withIdentifier: Constants.WelcomeVc) as! WelcomeView
            break
            
        case 2:
            storyboard = UIStoryboard(name: Constants.MechanicView, bundle: nil)
            vc = storyboard.instantiateViewController(withIdentifier: Constants.MechanicVc) as! MechanicView
            break
        case 3:
            storyboard = UIStoryboard(name: Constants.CheckoutView, bundle: nil)
            vc = storyboard.instantiateViewController(withIdentifier: Constants.CheckoutVc) as! CheckoutView
            break
        default:
            break
            //            let url = URL(string: "https://www.marnpos.com/#/home")
            //            let requestObj = URLRequest(url: url! as URL)
            //            WebView.loadRequest(requestObj)
        }
        
        if vc != nil {
            switchViewController(vc: vc, showFooter: true)
            UIView.transition(with: containerView, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            }) { (completed) in
            }
        }
    }
    
    
    
    func removeAllChildViewControllers() {
        
        
        if children.count > 0 {
            let viewControllers:[UIViewController] = children
            for viewContoller in viewControllers  {
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
                
            }
        }
    }
    
    
    
    func switchViewController(vc: UIViewController, showFooter: Bool) {
        removeAllChildViewControllers()
        var height: CGFloat = 0.0
        
        if showFooter {
            self.view.layoutIfNeeded()
            height = orginalHeight - headerView.frame.size.height - footerViewheight
            footerViewHeightConstraint.constant = footerViewheight
            
        } else {
            self.view.layoutIfNeeded()
            height = orginalHeight - headerView.frame.size.height
            footerViewHeightConstraint.constant = 0
        }
        
        self.view.layoutIfNeeded()
        vc.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: height)
        self.addChild(vc)
        self.containerView.addSubview(vc.view)
        vc.didMove(toParent: self)
        
    }
    
    
    
    
    
    
    
    
    func removeFooterView() {
        for subView in footerViewContainer.subviews {
            subView.removeFromSuperview()
        }
        footerViewHeightConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
    
    
    
    
    func addFooterView1(selected: Int) {
        removeFooterView()
        footerViewHeightConstraint.constant = footerViewheight
        self.view.layoutIfNeeded()
        let footerViewWithTabs = Bundle.main.loadNibNamed(Constants.FooterView, owner: self, options: nil)?[0] as! FooterViewWithTabs
        footerViewWithTabs.tabButtons_action(footerViewWithTabs.buttons[selected])
        footerViewWithTabs.delegate = self
        footerViewWithTabs.frame = CGRect(x: 0, y: 0, width: footerViewContainer.frame.size.width, height: footerViewContainer.frame.size.height)
        footerViewContainer.addSubview(footerViewWithTabs)
    }
    
    
    
    func addFooterView2() {
        removeFooterView()
        footerViewHeightConstraint.constant = footerViewheight
        self.view.layoutIfNeeded()
        let footerViewWithTabs = Bundle.main.loadNibNamed(Constants.FooterView, owner: self, options: nil)?[0] as! FooterViewWithTabs
        footerViewWithTabs.tabButtons_action(footerViewWithTabs.btnWelcome)
        footerViewWithTabs.delegate = self
        footerViewWithTabs.frame = CGRect(x: 0, y: 0, width: footerViewContainer.frame.size.width, height: footerViewContainer.frame.size.height)
        footerViewContainer.addSubview(footerViewWithTabs)
    }
    
}


extension ReceptionalistView: FooterViewWithTabsDelegate {
    func selectedButtonIndex(index: Int) {
        showView(index: index)
    }
}











