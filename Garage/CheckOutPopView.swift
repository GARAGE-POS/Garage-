//
//  CheckOutPopView.swift
//  Garage
//
//  Created by Amjad Ali on 8/5/18.
//  Copyright © 2018 Amjad Ali. All rights reserved.
//

import UIKit

class CheckOutPopView: UIViewController {

    
    
    @IBOutlet weak var PopUpView: UIView!
    @IBOutlet weak var containerPop: UIView!
    
    @IBOutlet weak var voucherBtn: UIButton!
    @IBOutlet weak var loyalityBtn: UIButton!
    @IBOutlet weak var giftcardBtn: UIButton!
    @IBOutlet weak var cardBtn: UIButton!
    @IBOutlet weak var cashBtn: UIButton!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

  
    @IBAction func tabButtonaction(_ sender: UIButton) {
    
       var voucherNibView:  VoucherView!
       var loyalityNibView: LoyaltyView!
       var giftCardNibView: GiftCardView!
       var cardNibView:     CardView!
       var cashNibView:     CashView!

        removeNibViews()    
        
        switch sender.tag {
            
        case 1:
            
            voucherNibView = Bundle.main.loadNibNamed("VoucherView", owner: self, options: nil)?[0] as! VoucherView
            voucherNibView.frame.size = containerPop.frame.size
            self.containerPop.addSubview(voucherNibView)
          
        case 2:
            loyalityNibView = Bundle.main.loadNibNamed("LoyaltyView", owner: self, options: nil)?[0] as! LoyaltyView
            loyalityNibView.frame.size = containerPop.frame.size
            self.containerPop.addSubview(loyalityNibView)
            break
            
        case 3:
            giftCardNibView = Bundle.main.loadNibNamed("GiftCardView", owner: self, options: nil)?[0] as! GiftCardView
            giftCardNibView.frame.size = containerPop.frame.size
            self.containerPop.addSubview(giftCardNibView)
            break
            
        case 4:
            cardNibView = Bundle.main.loadNibNamed("CardView", owner: self, options: nil)?[0] as! CardView
            cardNibView.frame.size = containerPop.frame.size
            self.containerPop.addSubview(cardNibView)
            break

        case 5:
            cashNibView = Bundle.main.loadNibNamed("CashView", owner: self, options: nil)?[0] as! CashView
            cashNibView.frame.size = containerPop.frame.size
            self.containerPop.addSubview(cashNibView)
            break
        default:
            break
        }
        
       }
    
    
    func checkboxDidTap(sender: UIButton){
        let tag = sender.tag
        if tag == 1 {
          voucherBtn.isSelected = true
            
    
}
    }
    
    
    
    
    func removeNibViews() {
        if containerPop.subviews.count > 0  {
            let views:[UIView] = containerPop.subviews
            for view in views  {
                view.removeFromSuperview()
                
            }
            
        }

        
    }
    
    
    @IBAction func CheckoutBtn(_ sender: Any) {
         if let parentVC = self.parent as? ReceptionalistView {
            print("Hellow")
       
            }
    }
    
    
  
    override func viewWillAppear(_ animated: Bool) {
//        if let vc = (self.parent as? CheckoutView)?.parent as? ReceptionalistView {
//        vc.removeFooterView()
//
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension UIView {
    
    class func fromNib <T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    
}






