//
//  addNewCar.swift
//  Garage
//
//  Created by Amjad Ali on 7/11/18.
//  Copyright © 2018 Amjad Ali. All rights reserved

import UIKit
import IQKeyboardManager
import Alamofire
import NumericKeyboard
import NVActivityIndicatorView


struct Bay {
    static var Baydetails = [popModel]()
}

class addNewCar: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate,NVActivityIndicatorViewable  {
    
    
    @IBOutlet weak var VinNumber: UITextField!
    @IBOutlet weak var carplateNumber: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var check: UITextField!
    @IBOutlet weak var carMake: UITextField!
    @IBOutlet weak var modelNumber: UITextField!
    @IBOutlet weak var yearNumber: UITextField!
    @IBOutlet weak var recommendedAmount: UITextField!
    @IBOutlet weak var staric: UILabel!
    @IBOutlet weak var CarStaric: UILabel!
    @IBOutlet weak var modelStaric: UILabel!
    @IBOutlet weak var engineType: UITextField!
    @IBOutlet weak var phStaric: UILabel!
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var assignBtn: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var Numberpadview: NumberPad!
    @IBOutlet weak var NumberpadViewCheck: NumberPad!
    @IBOutlet weak var reScanBtn: UIButton!
   
    
    @IBOutlet weak var vinLbl: UILabel!
    @IBOutlet weak var plateLbl: UILabel!
    @IBOutlet weak var nmbrLbl: UILabel!
    @IBOutlet weak var checkLbl: UILabel!
    @IBOutlet weak var makLbl: UILabel!
    @IBOutlet weak var modelLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var engineLbl: UILabel!
    @IBOutlet weak var recomLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    
    @IBOutlet weak var GenderView: UIView!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    
    
    
    
    
        let dateFormatter : DateFormatter = DateFormatter()
    private var CarMakeTableView: UITableView!
    private var CarModelTableView: UITableView!
    var MakeCarDetails = [makeCarModel]()
    var ModelCarDetails = [modelCar]()
    var datePicker: UIDatePicker?
    var pickerData = [String]()
    var orderdetails = [ReceiptModel]()
    var Gender:  String = ""
    var GenderID: Int = 1
    
    //Localization
    
    let SelectyourCarMake = NSLocalizedString("SelectyourCarMake", comment: "")
    let SelectyourCarModel = NSLocalizedString("SelectyourCarModel", comment: "")
    let Historyar = NSLocalizedString("History", comment: "")
    let deatilsCar = NSLocalizedString("deatilsCar", comment: "")
    let mendatoryfield = NSLocalizedString("mendatoryfields", comment: "")
    let Numberinvalid = NSLocalizedString("Numberinvalid", comment: "")
    let NumberGreater = NSLocalizedString("NumberGreater", comment: "")
    let rollyear = NSLocalizedString("rollyear", comment: "")
    
    //Localization
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Numberpadview.isHidden = true
        NumberpadViewCheck.isHidden = true
        makeCardetails()
        if let button = GenderView.viewWithTag(GenderID) as? UIButton {
            TabMaleFmale(button)
        }
//        first.addTarget(self, action: "textFieldDidChange:", for: UIControlEvents.EditingChanged)
//        second.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        carplateNumber.defaultTextAttributes.updateValue(15.0, forKey: NSAttributedString.Key(rawValue: NSAttributedString.Key.kern.rawValue))
        check.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: UIControl.Event.touchDown)
        carplateNumber.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        phoneNumber.addTarget(self, action: #selector(phoneNumberDidChange(_:)), for: UIControl.Event.touchDown)
         phoneNumber.addTarget(self, action: #selector(phoneNumberediting(_:)), for: .editingChanged)
        VinNumber.addTarget(self, action: #selector(VinNumberDidChange(_:)), for: UIControl.Event.editingChanged)
        carMake.addTarget(self, action: #selector(CarmakeFunction), for: .touchDown)
        modelNumber.addTarget(self, action: #selector(CarmodeltFunction), for: .touchDown)
        CardetailsData()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        Constants.currentdate = dateString
        CustomCarMaketableview()
        CustomCarModeltableview()
        modelNumber.isUserInteractionEnabled = false
        phoneNumber.text = "+966"
        self.picker.delegate = self
        self.picker.dataSource = self
        currentTime()
        historyBtn.layer.shadowColor = UIColor.white.cgColor   
        historyBtn.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        if L102Language.currentAppleLanguage() == "ar" {
        LanguageUIUpdate()
        }
        baylist()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        CarMakeTableView.isHidden = true
        CarModelTableView.isHidden = true
        Numberpadview.isHidden = true
        NumberpadViewCheck.isHidden = true
    }
    
    
    
    func numberPad() {
        phoneNumber.inputView = UIView()
        phoneNumber.inputAccessoryView = UIView()
        Numberpadview.isHidden = false
        Numberpadview.backgroundColor = .BlackApp
        Numberpadview.clearKeyBackgroundColor = .BlackApp
        Numberpadview.clearKeyHighlightColor = .BlackApp
        Numberpadview.clearKeyTintColor = .BlackApp
        Numberpadview.keyScale = 0.8
        Numberpadview.customKeyText = "+"
        Numberpadview.customKeyBackgroundColor = .BlackApp
        Numberpadview .customKeyTitleColor = .DefaultApp
        Numberpadview.clearKeyIcon = UIImage.init(named: "x")
        Numberpadview.delegate = self
        
    }
    
    func numberPadCheck() {
        check.inputView = UIView()
        check.inputAccessoryView = UIView()
        NumberpadViewCheck.isHidden = false
        NumberpadViewCheck.backgroundColor = .BlackApp
        NumberpadViewCheck.clearKeyBackgroundColor = .BlackApp
        NumberpadViewCheck.clearKeyHighlightColor = .BlackApp
        NumberpadViewCheck.clearKeyTintColor = .BlackApp
        NumberpadViewCheck.keyScale = 0.8
        NumberpadViewCheck.customKeyText = "."
        NumberpadViewCheck.customKeyBackgroundColor = .BlackApp
        NumberpadViewCheck .customKeyTitleColor = .DefaultApp
        NumberpadViewCheck.clearKeyIcon = UIImage.init(named: "x")
        NumberpadViewCheck.delegate = self
        
    }
    
    
    
    func LanguageUIUpdate() {
        
        reScanBtn.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 25)
        assignBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left:20, bottom: 0, right: 0)
        reScanBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left:12, bottom: 0, right: 0)
        historyBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left:12, bottom: 0, right: 0)
        vinLbl.textAlignment = NSTextAlignment.right
         plateLbl.textAlignment = NSTextAlignment.right
         nmbrLbl.textAlignment = NSTextAlignment.right
         checkLbl.textAlignment = NSTextAlignment.right
         makLbl.textAlignment = NSTextAlignment.right
         modelLbl.textAlignment = NSTextAlignment.right
         yearLbl.textAlignment = NSTextAlignment.right
         engineLbl.textAlignment = NSTextAlignment.right
        recomLbl.textAlignment = NSTextAlignment.right
        genderLbl.textAlignment = NSTextAlignment.right
    }
    
    
    
    
    func currentTime(){
        
        let date = Date()
        let calendar = Calendar.current
        var year = calendar.component(.year, from: date)
        year = year + 1
        let pastyear = year - 100
        for _ in pastyear...year  {
            print("\(year) ")
            pickerData.append("\(year) ")
            year -= 1
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) ->  Int {
        return 1
        
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)  ->  Int {
        return pickerData.count
        
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) ->  String? {
        return pickerData[row]
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        
        ///  attributedString = NSAttributedString(string: pickerData[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.,.font: UIFont.boldSystemFont(ofSize: 17.0)])
        return attributedString
    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 65
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let valueSelected = pickerData[row] as String
        self.yearNumber.text = valueSelected
        pickerView.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        
        if pickerView.selectedRow(inComponent: component) == row {
            label.backgroundColor = UIColor.clear
            label.frame = CGRect(x: 0, y: 0, width: 46, height: 36)
            label.layer.cornerRadius = 18
            label.layer.masksToBounds = true
            label.textColor = .clear
            label.text = String(pickerData[row])
            label.textAlignment = .center
        }else {
            label.layer.cornerRadius = 25
            label.frame = CGRect(x: 0, y: 0, width: 46, height: 36)
            label.layer.cornerRadius = 18
            label.layer.masksToBounds = true
            label.textColor = .white
            label.text = String(pickerData[row])
            label.textAlignment = .center
        }
        return label
    }
    
    
    func CustomCarMaketableview()  {
        
        self.view.layoutIfNeeded()
        CarMakeTableView = UITableView(frame: CGRect(x: self.carMake.frame.origin.x, y: self.carMake.frame.origin.y, width: self.carMake.frame.width, height: 300))
        CarMakeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        CarMakeTableView.dataSource = self
        CarMakeTableView.delegate = self
        CarMakeTableView.backgroundColor = UIColor.darkGray
        view.addSubview(CarMakeTableView)
        CarMakeTableView.isHidden = true
        
    }
    
    
    func CustomCarModeltableview()  {
    
        self.view.layoutIfNeeded()
        CarModelTableView = UITableView(frame: CGRect(x: self.modelNumber.frame.origin.x, y: self.modelNumber.frame.origin.y, width: self.modelNumber.frame.width, height: 300))
        CarModelTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell2")
        CarModelTableView.dataSource = self
        CarModelTableView.delegate = self
        // view.superview?.layoutIfNeeded()
        CarModelTableView.backgroundColor = UIColor.darkGray
        view.addSubview(CarModelTableView)
        CarModelTableView.isHidden = true
        
    }
    
    
    override func viewDidLayoutSubviews() {
        carplateNumber.attributedPlaceholder = NSAttributedString(string: "XXX-0000", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,.font: UIFont.boldSystemFont(ofSize: 16.0)])
        VinNumber.attributedPlaceholder = NSAttributedString(string: "XXXXXXXXXXXXXXXXX", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,.font: UIFont.boldSystemFont(ofSize: 16.0)])
        phoneNumber.attributedPlaceholder = NSAttributedString(string: "+966XXXXXXXXX", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,.font: UIFont.boldSystemFont(ofSize: 16.0)])
        check.attributedPlaceholder = NSAttributedString(string: "0000", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,.font: UIFont.boldSystemFont(ofSize: 16.0)])
        carMake.attributedPlaceholder = NSAttributedString(string: SelectyourCarMake, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,.font: UIFont.boldSystemFont(ofSize: 16.0)])
        modelNumber.attributedPlaceholder = NSAttributedString(string: SelectyourCarModel, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,.font: UIFont.boldSystemFont(ofSize: 16.0)])
        recommendedAmount.attributedPlaceholder = NSAttributedString(string: "00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,.font: UIFont.boldSystemFont(ofSize: 16.0)])
        engineType.attributedPlaceholder = NSAttributedString(string: "00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,.font: UIFont.boldSystemFont(ofSize: 16.0)])
        yearNumber.attributedPlaceholder = NSAttributedString(string: rollyear, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,.font: UIFont.boldSystemFont(ofSize: 16.0)])
   
    }

    func background(string: String)-> NSMutableAttributedString {
        return NSMutableAttributedString(string: string, attributes:
            [NSAttributedString.Key.backgroundColor : UIColor.red ])
    }
    
    @objc func CarmakeFunction() {
        NumberpadViewCheck.isHidden = true
        carMake.inputView = UIView()
        carMake.inputAccessoryView = UIView()
        carMake.resignFirstResponder()
        CarMakeTableView.isHidden = false
        CarModelTableView.isHidden = true
        self.modelNumber.text  = ""
//        self.yearNumber.text  = ""
//        self.recommendedAmount.text  = ""
//        self.engineType.text  = ""
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == CarMakeTableView {
            
            Constants.MakeIDData = MakeCarDetails[indexPath.row].MakeID ?? 0
            self.carMake.text = MakeCarDetails[indexPath.row].Name
            CarMakeTableView.isHidden = true
            modelNumber.isUserInteractionEnabled = true
            modelCardetails()
        } else if  tableView == CarModelTableView {
            Constants.ModelIDData = ModelCarDetails[indexPath.row].ModelID ?? 0
            self.modelNumber.text = ModelCarDetails[indexPath.row].Name
//          let year: Int = ModelCarDetails[indexPath.row].Year ?? 0
//            self.yearNumber.text = String(year)
//            self.engineType.text = ModelCarDetails[indexPath.row].EngineNo
//            self.recommendedAmount.text = ModelCarDetails[indexPath.row].RecommendedLitres
            
            CarModelTableView.isHidden = true
            yearNumber.isUserInteractionEnabled = true
            recommendedAmount.isUserInteractionEnabled = true
            engineType.isUserInteractionEnabled = true
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView  == CarMakeTableView) {
            return  MakeCarDetails.count
            
        } else if (tableView  == CarModelTableView) {
            return ModelCarDetails.count
        }
        else {
            return 0 
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == CarMakeTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
            cell.textLabel!.text = MakeCarDetails[indexPath.row].Name
            cell.backgroundColor = UIColor.darkGray
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 18.0)
            cell.textLabel?.textAlignment = .left
            return cell
        }
        else if tableView == CarModelTableView {
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "MyCell2", for: indexPath as IndexPath)
            cell2.textLabel!.text = ModelCarDetails[indexPath.row].Name
            cell2.backgroundColor = UIColor.darkGray
            cell2.textLabel?.textColor = UIColor.white
            cell2.textLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 18.0)
            cell2.textLabel?.textAlignment = .left
            return cell2
            
            
        }
        return UITableViewCell()
        
    }
    
    
    @objc func CarmodeltFunction() {
        modelNumber.inputView = UIView()
        modelNumber.inputAccessoryView = UIView()
        //  modelCardetails()
        DispatchQueue.main.async {
            self.CarModelTableView.isHidden = false
            self.CarMakeTableView.isHidden = true
        }
        
    }
    
    
    func makeCardetails() {
        guard let url = URL(string: "\(CallEngine.baseURL)\(CallEngine.MakelistApi)\(Constants.sessions)") else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response,  error) in
            if response == nil {
                DispatchQueue.main.async {
                    ToastView.show(message: LocalizedString.interneterror, controller: self)
                }
            }
            if let data = data {
                do {
                    guard  let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return}
                    print(json)
                    let discript = json[Constants.Description] as? String
                    if let status = json[Constants.Status] as? Int {
                        if (status == 1) {
                            
                            if let order = json["MakeList"] as? [[String: Any]] {
                                self.MakeCarDetails.removeAll()
                                for Makedetails in order {
                                    let neworder =  makeCarModel(Makedetails: Makedetails)
                                    self.MakeCarDetails.append(neworder!)
                                    
                                }
                                
                            }
                            
                        }
                        else if (status == 0) {
                            ToastView.show(message: discript!, controller: self)
                        }
                            
                        else if (status == 1000) {
                            ToastView.show(message: LocalizedString.wrong, controller: self)
                        }
                            
                        else if (status == 1001) {
                            ToastView.show(message: LocalizedString.invalid, controller: self)
                        }
                            
                        else {
                            ToastView.show(message: LocalizedString.occured, controller: self)
                        }
                    }
                    DispatchQueue.main.async {
                        self.CarMakeTableView.reloadData()
                        
                    }
                    
                } catch let error as NSError {
                    print(error)
                    ToastView.show(message: "Failed! Try Again", controller: self)
                }
                
            }
            }.resume()
        
    }
    
    
    
    func modelCardetails() {
        
        guard let url = URL(string: "\(CallEngine.baseURL)\(CallEngine.ModellistApi)\(Constants.MakeIDData)/\(Constants.sessions)") else { return }
        print("\(url)")
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response,  error) in
            if response == nil {
                DispatchQueue.main.async {
                    ToastView.show(message: LocalizedString.interneterror, controller: self)
                }
            }
            if let data = data {
                do {
                    guard  let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return}
                    print(json)
                    let discript = json[Constants.Description] as? String
                    if let status = json[Constants.Status] as? Int {
                        if (status == 1) {
                            print(status)
                            if let order = json["ModelList"] as? [[String: Any]] {
                                self.ModelCarDetails.removeAll()
                                for Modeldetails in order {
                                    let models =  modelCar(DetailsModel: Modeldetails)
                                    self.ModelCarDetails.append(models)
                                }
                            }
                        }
                        else if (status == 0) {
                            ToastView.show(message: discript!, controller: self)
                        }
                        
                        else if (status == 1000) {
                            ToastView.show(message: LocalizedString.wrong, controller: self)
                        }
                        
                        else if (status == 1001) {
                            ToastView.show(message: LocalizedString.invalid, controller: self)
                        }
                        
                        else {
                            ToastView.show(message: LocalizedString.occured, controller: self)
                        }
                        
                    }
                    DispatchQueue.main.async {
                        self.CarModelTableView.reloadData()
                    }
                    
                } catch let error as NSError {
                    print(error)
                    ToastView.show(message: "failed! Try Again", controller: self)
                }
                
            }
            }.resume()
        
    }
    
    
    func  baylist()  {
        
        let url = URL(string: "\(CallEngine.baseURL)\(CallEngine.BayAssignApi)\(Constants.sessions)")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                if let bay = json["BaysList"] as? [[String: Any]] {
                     Bay.Baydetails.removeAll()
                    for Baylist in bay {
                        
                        let baylist = popModel(Baylist: Baylist)
                            Bay.Baydetails.append(baylist!)
                    }
                    
                }
                
                
            } catch let error as NSError {
                print(error)
            }
        }).resume()
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //        if let vc = self.parent as? ReceptionalistView {
        //            vc.removeFooterView()
        //
        //        }
    }
    
    
    @IBAction func assignBtn(_ sender: Any) {
        var storyboard: UIStoryboard!
        var popController: UIViewController!
        
        storyboard = UIStoryboard(name: Constants.PopOver, bundle: nil)
        popController = storyboard.instantiateViewController(withIdentifier: Constants.PopOverVc) as! PopOver
        let nav = UINavigationController(rootViewController: popController)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let heightForPopOver = 80*3
        let popover = nav.popoverPresentationController
        popController.preferredContentSize = CGSize(width: 200 , height: heightForPopOver)
        popover?.permittedArrowDirections = .up
        popover?.backgroundColor = UIColor.white
        popover?.sourceView = self.assignBtn
        popover?.sourceRect = self.assignBtn.bounds//CGRect(x: self.assignBtn.bounds.midX, y: self.assignBtn.bounds.midY, width: 0, height: 0)
        self.present(nav, animated: true, completion: nil)
    }
    
    
    
    

    
//    func lockPlateImage() {
//
//        carplateNumber.rightViewMode = .always
//        let emailImgContainer = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
//        let emailImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
//        emailImg.image = UIImage(named: "locked")
//        emailImg.center = emailImgContainer.center
//        emailImgContainer.addSubview(emailImg)
//        carplateNumber.rightView = emailImgContainer
//
//
//    }
    func lockvinImage() {
        
        VinNumber.rightViewMode = .always
        let emailImgContainer = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
        let emailImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        emailImg.image = UIImage(named: "locked")
        emailImg.center = emailImgContainer.center
        emailImgContainer.addSubview(emailImg)
        VinNumber.rightView = emailImgContainer
        
        
    }
    
    
    
    
    
    @IBAction func TabMaleFmale(_ sender: UIButton) {
        
        checkboxDidTap(sender: sender)
        
        switch sender.tag {
            
        case 1:
        maleBtn.layer.borderWidth = 2.0
        maleBtn.layer.borderColor = UIColor.DefaultApp.cgColor
        maleBtn.setTitleColor(.DefaultApp, for: .normal)
        femaleBtn.layer.borderWidth = 2.0
        femaleBtn.layer.borderColor = UIColor.clear.cgColor
        femaleBtn.setTitleColor(.white, for: .normal)
            print("Male")
            Gender = "Male"
            
        case 2:
            femaleBtn.layer.borderWidth = 2.0
            femaleBtn.layer.borderColor = UIColor.DefaultApp.cgColor
            femaleBtn.setTitleColor(.DefaultApp, for: .normal)
            maleBtn.layer.borderWidth = 2.0
            maleBtn.layer.borderColor = UIColor.clear.cgColor
            maleBtn.setTitleColor(.white, for: .normal)
            print("Female")
            Gender = "Female"
            break
       
        default:
            break
        }
        
    }
    
    
    
    
    func checkboxDidTap(sender: UIButton) {
        
        for i in 1...2 {
            if let btn = GenderView.viewWithTag(i) as? UIButton {
                btn.isSelected = false
                
            }
        }
        sender.isSelected = true
        
    }
    
 
    
    
    func CardetailsData() {
        
        if Constants.platenmb != "0" || Constants.vinnmb != "0" {
            
            SearchApiDeatils()
            
            // ToastView.show(message: "Please Add deatils of Car", controller: self)
        }
            
            
        else if Constants.flagEdit != 0 {
            
            editOrder()
            
            
        }
            
            
        else {
            
            ToastView.show(message: deatilsCar, controller: self)
            
            
            
        }
        
    }
    
    
    func  SearchApiDeatils()  {
        
        print(Constants.platenmb)
        print(Constants.vinnmb)
        Items.Product.removeAll()
        Constants.totalprice = 0.0
        
        
        
        guard let addcarapi = URL(string: "\(CallEngine.baseURL)\(CallEngine.SearchCarApi)\(Constants.platenmb)/\(Constants.vinnmb)/\(Constants.sessions)" ) else { return }
        let session = URLSession.shared
        session.dataTask(with: addcarapi){ (data, response, error) in
            
            if response == nil {
                DispatchQueue.main.async {
                    ToastView.show(message: LocalizedString.interneterror, controller: self)
                    
                }
            }
            if let data = data {
                print(data)
                
                
                do {
                     self.startAnimating(message: Constants.wait, messageFont: UIFont(name:"SFProDisplay-Bold", size: 18.0), type: .ballPulse, color: UIColor.DefaultApp)
                    guard  let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return}
                    print(json)
                    Constants.history = json["OrderHistoryCount"] as? Int  ?? 0
                    DispatchQueue.main.async {
                        self.historyBtn.titleLabel?.text = "\(self.Historyar) (\(Constants.history))"
                    }
                    let details = Cardetails(json: json)
                    if (details.status == 1) {
                        
                        if let cars = json[Constants.Cars] as? [[String: Any]] {
                            for items in cars {
                                print("\(items)")
                                if  let maker = items[Constants.MakerName] as? String {
                                    DispatchQueue.main.async {
                                        self.carMake.text = maker
                                    }
                                }
                                if  let VinNo = items[Constants.VinNo] as? String {
                                    DispatchQueue.main.async {
                                        self.VinNumber.text = VinNo
                                    }
                                }
                                if  let Customernmb = items[Constants.CustomerContact] as? String {
                                    DispatchQueue.main.async {
                                        self.phoneNumber.text =  Customernmb
                                    }
                                }
                                if  let CheckLitre = items[Constants.CheckLitre] as? String {
                                    DispatchQueue.main.async {
                                        self.check.text = CheckLitre
                                    }
                                }
                                
                                if let model = items[Constants.ModelName] as? String {
                                    DispatchQueue.main.async {
                                        self.modelNumber.text = model
                                    }
                                }
                                if let RegistrationNo = items[Constants.RegistrationNo] as? String {
                                    DispatchQueue.main.async {
                                        self.carplateNumber.text = RegistrationNo
                                    }
                                }
                                
                                if  let Year = items[Constants.Year] as? Int {
                                    DispatchQueue.main.async {
                                        self.yearNumber.text = String (Year)
                                    }
                                }
                                if  let RecommendedAmount = items[Constants.RecommendedAmount] as? String {
                                    DispatchQueue.main.async {
                                        self.recommendedAmount.text =  RecommendedAmount
                                    }
                                }
                                if  let EngineType = items[Constants.EngineType] as? String {
                                    DispatchQueue.main.async {
                                        self.engineType.text = EngineType
                                    }
                                    
                                }
                                if  let CarID = items[Constants.CarID] as? Int {
                                    DispatchQueue.main.async {
                                        Constants.CarIDData = CarID
                                    }
                                    
                                }
                                if  let CarName = items[Constants.CarName] as? String {
                                    DispatchQueue.main.async {
                                        Constants.CarNameData = CarName
                                    }
                                    
                                }
                                if  let ModelID = items[Constants.ModelID] as? Int {
                                    DispatchQueue.main.async {
                                        Constants.ModelIDData = ModelID
                                    }
                                    
                                }
                                if  let MakeID = items[Constants.MakeID] as? Int {
                                    DispatchQueue.main.async {
                                        Constants.MakeIDData = MakeID
                                    }
                                    
                                }
                                if  let Color = items[Constants.Color] as? String {
                                    DispatchQueue.main.async {
                                        Constants.ColorData = Color
                                    }
                                    
                                }
                                if  let CustomerID = items[Constants.CustomerID] as? Int {
                                    DispatchQueue.main.async {
                                        Constants.CustomerIDData = String (CustomerID)
                                    }
                                    
                                }
                                if  let OrderID = items[Constants.OrderID] as? Int {
                                    DispatchQueue.main.async {
                                        Constants.OrderIDData = OrderID
                                    }
                                    
                                }
                                if  let Orderno = items[Constants.OrderNo] as? Int {
                                    DispatchQueue.main.async {
                                        Constants.OrderNoData =  Orderno
                                    }
                                    
                                }
                                
                                if  let Gender = items[Constants.Gender] as? String {
                                    DispatchQueue.main.async {
                                        if Gender == "Female" {
                                            self.GenderID = 2
                                        } else {
                                            self.GenderID = 1
                                        }
                                        if let button = self.GenderView.viewWithTag(self.GenderID) as? UIButton {
                                        self.TabMaleFmale(button)
                                        }
                            
                                      
                                     }
                                    
                                }
                                
                              
                            }
                            
                        }
                        
                        DispatchQueue.main.async {
                           self.stopAnimating()
                            if self.carplateNumber.text != "" {
                              //  self.carplateNumber.isUserInteractionEnabled = false
                               // self.lockPlateImage()
                            }
                            if self.VinNumber.text != "" {
                                self.VinNumber.isUserInteractionEnabled = false
                                self.lockvinImage()
                            }
                        }//)
                        
                    }
                        
                    else if (details.status == 0) {
                        
                        DispatchQueue.main.async {
                            ToastView.show(message: details.description, controller: self)
                            self.stopAnimating()
                            if self.carplateNumber.text != "" {
//                                self.carplateNumber.isUserInteractionEnabled = false
//                                self.lockPlateImage()
                            }
                            if self.VinNumber.text != "" {
                                self.VinNumber.isUserInteractionEnabled = false
                                self.lockvinImage()
                            }
                        }
                    }
                    
                    else if (details.status == 1000) {
                        
                        DispatchQueue.main.async {
                            ToastView.show(message:LocalizedString.wrong, controller: self)
                            self.stopAnimating()
                            if self.carplateNumber.text != "" {
//                                self.carplateNumber.isUserInteractionEnabled = false
//                                self.lockPlateImage()
                            }
                            if self.VinNumber.text != "" {
                                self.VinNumber.isUserInteractionEnabled = false
                                self.lockvinImage()
                            }
                        }
                    }
                    
                    else if (details.status == 1001) {
                        
                        DispatchQueue.main.async {
                            ToastView.show(message:LocalizedString.invalid, controller: self)
                            self.stopAnimating()
                            if self.carplateNumber.text != "" {
//                                self.carplateNumber.isUserInteractionEnabled = false
//                                self.lockPlateImage()
                            }
                            if self.VinNumber.text != "" {
                                self.VinNumber.isUserInteractionEnabled = false
                                self.lockvinImage()
                            }
                        }
                    }
                        
                    else if (details.status == 1002) {
                        
                        DispatchQueue.main.async {
                            ToastView.show(message:LocalizedString.incorrectVin, controller: self)
                            self.stopAnimating()
                            if self.carplateNumber.text != "" {
                                //                                self.carplateNumber.isUserInteractionEnabled = false
                                //                                self.lockPlateImage()
                            }
                            if self.VinNumber.text != "" {
                                self.VinNumber.isUserInteractionEnabled = false
                                self.lockvinImage()
                            }
                        }
                    }
                        
            
                        
                    else {
                        
                        DispatchQueue.main.async {
                            ToastView.show(message:LocalizedString.occured, controller: self)
                            self.stopAnimating()
                            if self.carplateNumber.text != "" {
//                                self.carplateNumber.isUserInteractionEnabled = false
//                                self.lockPlateImage()
                            }
                            if self.VinNumber.text != "" {
                                self.VinNumber.isUserInteractionEnabled = false
                                self.lockvinImage()
                            }
                        }
                    }
                    
                } catch {
                    
                    DispatchQueue.main.async {
                        ToastView.show(message: LocalizedString.occured, controller: self)
                        self.stopAnimating()
                        if self.carplateNumber.text != "" {
//                            self.carplateNumber.isUserInteractionEnabled = false
//                            self.lockPlateImage()
                        }
                        if self.VinNumber.text != "" {
                            self.VinNumber.isUserInteractionEnabled = false
                            self.lockvinImage()
                        }
                    }
                    
                }
                
            }
            
            }.resume()
        
    }
    
    
    
    func editOrder() {
        
        guard let orderdetails = URL(string: "\(CallEngine.baseURL)\(CallEngine.OrderDetails)/\(Constants.editOrderid)/\(Constants.sessions)" ) else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: orderdetails){ (data, response, error) in
            if response == nil {
                DispatchQueue.main.async {
                    ToastView.show(message: LocalizedString.interneterror, controller: self)
                }
            }
            if let data = data {
                print(data)
                
                do {
                    self.startAnimating(message: Constants.wait, messageFont: UIFont(name:"SFProDisplay-Bold", size: 18.0), type: .ballPulse, color: UIColor.DefaultApp)
                    guard  let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return}
                    print(json)
                    let details = Cardetails(json: json)
                    if (details.status == 1) {
                        
                        Constants.history = json["OrderHistoryCount"] as? Int  ?? 0
                        DispatchQueue.main.async {
                            self.historyBtn.titleLabel?.text = "\(self.Historyar) (\(Constants.history))"
                        }
                        if  let OrderID = json[Constants.OrderID] as? Int {
                            DispatchQueue.main.async {
                                Constants.OrderIDData = OrderID
                                print(Constants.OrderIDData)
                            }
                        }
                        
                        if  let OrderID = json["TransactionNo"] as? Int {
                            DispatchQueue.main.async {
                                Constants.transedit = OrderID
                                
                            }
                        }
                        
                        if let cars = json[Constants.Cars] as? [[String: Any]] {
                            for items in cars {
                                print("\(items)")
                                if  let maker = items[Constants.MakerName] as? String {
                                    DispatchQueue.main.async {
                                        self.carMake.text = maker
                                    }
                                }
                                if  let VinNo = items[Constants.VinNo] as? String {
                                    DispatchQueue.main.async {
                                        self.VinNumber.text = VinNo
                                    }
                                }
                                if  let Customernmb = items[Constants.CustomerContact] as? String {
                                    DispatchQueue.main.async {
                                        self.phoneNumber.text =  Customernmb
                                    }
                                }
                                if  let CheckLitre = items[Constants.CheckLitre] as? String {
                                    DispatchQueue.main.async {
                                        self.check.text = CheckLitre
                                    }
                                }
                                
                                if let model = items[Constants.ModelName] as? String {
                                    DispatchQueue.main.async {
                                        self.modelNumber.text = model
                                    }
                                }
                                if let RegistrationNo = items[Constants.RegistrationNo] as? String {
                                    DispatchQueue.main.async {
                                        self.carplateNumber.text = RegistrationNo
                                    }
                                }
                                
                                if  let Year = items[Constants.Year] as? Int {
                                    DispatchQueue.main.async {
                                        self.yearNumber.text = String (Year)
                                    }
                                }
                                if  let RecommendedAmount = items[Constants.RecommendedAmount] as? String {
                                    DispatchQueue.main.async {
                                        self.recommendedAmount.text =  RecommendedAmount
                                    }
                                }
                                if  let EngineType = items[Constants.EngineType] as? String {
                                    DispatchQueue.main.async {
                                        self.engineType.text = EngineType
                                    }
                                    
                                }
                                if  let CarID = items[Constants.CarID] as? Int {
                                    DispatchQueue.main.async {
                                        Constants.CarIDData = CarID
                                    }
                                    
                                }
                                if  let CarName = items[Constants.CarName] as? String {
                                    DispatchQueue.main.async {
                                        Constants.CarNameData = CarName
                                    }
                                    
                                }
                                if  let ModelID = items[Constants.ModelID] as? Int {
                                    DispatchQueue.main.async {
                                        Constants.ModelIDData = ModelID
                                    }
                                    
                                }
                                if  let MakeID = items[Constants.MakeID] as? Int {
                                    DispatchQueue.main.async {
                                        Constants.MakeIDData = MakeID
                                    }
                                    
                                }
                                if  let Color = items[Constants.Color] as? String {
                                    DispatchQueue.main.async {
                                        Constants.ColorData = Color
                                    }
                                    
                                }
                                if  let CustomerID = items[Constants.CustomerID] as? Int {
                                    DispatchQueue.main.async {
                                        Constants.CustomerIDData = String (CustomerID)
                                    }
                                    
                                }
                                if  let Gender = items[Constants.Gender] as? String {
                                    DispatchQueue.main.async {
                                        if Gender == "Female" {
                                            self.GenderID = 2
                                        } else {
                                            self.GenderID = 1
                                        }
                                        if let button = self.GenderView.viewWithTag(self.GenderID) as? UIButton {
                                            self.TabMaleFmale(button)
                                        }
                                        
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                        if let order = json["Orderdetail"] as? [[String: Any]] {
                            for orders in order {
                                print(orders)
                                let Name = orders["ItemName"] as? String  ?? ""
                                let AlternateName = orders["AlternateName"] as? String  ?? ""
                                let Price = orders["Price"] as? Double  ?? 0.0
                                let ItemID = orders["ItemID"] as? Int  ?? 0
                                let Quantity = orders["Quantity"] as? Int  ?? 0
                                let OrderDetails = orders["OrderDetailID"] as? Int  ?? 0
                                let products = ReceiptModel(Name: Name, AlternateName: AlternateName, Price: Price, ItemID: ItemID, Quantity: Quantity, Mode: Constants.modeupdate,OrderDetailID: OrderDetails, Status: 202)
                                Items.Product.append(products)
                                let price = Price *  Double(Constants.counterQTY)
                                Constants.totalprice = Constants.totalprice + Double(price)
                                //                                let newDict = [
                                //                                    "Name": Name, "Price":Price, "Quantity": Quantity, "ItemID": ItemID, "Mode": Constants.modeupdate,"OrderDetailID": OrderDetails, "Status": 202] as [String : Any]
                                //                                Items.nameArray.append(newDict)
                            }
                        }
                        DispatchQueue.main.async {
                             self.stopAnimating()
                            if self.carplateNumber.text != "" {
//                                self.carplateNumber.isUserInteractionEnabled = false
//                                self.lockPlateImage()
                            }
                            if self.VinNumber.text != "" {
                                self.VinNumber.isUserInteractionEnabled = false
                                self.lockvinImage()
                            }
                        }//)
                        
                    }
                        
                    else if (details.status == 0) {
                        
                        DispatchQueue.main.async {
                            self.stopAnimating()
                            ToastView.show(message: details.description, controller: self)
                        }
                    }
                    
                    else if (details.status == 1000) {
                        
                        DispatchQueue.main.async {
                            self.stopAnimating()
                            ToastView.show(message: LocalizedString.wrong, controller: self)
                        }
                    }
                    
                    else if (details.status == 1001) {
                        
                        DispatchQueue.main.async {
                            self.stopAnimating()
                            ToastView.show(message: LocalizedString.invalid, controller: self)
                        }
                    }
                    
                    else {
                        
                        DispatchQueue.main.async {
                            self.stopAnimating()
                            ToastView.show(message: LocalizedString.occured, controller: self)
                        }
                    }
                   
                    
                } catch {
                    
                    DispatchQueue.main.async {
                        self.stopAnimating()
                        ToastView.show(message: LocalizedString.occured, controller: self)
                    }
                    
                }
                
            }
            
            
            }.resume()
        
    }
    
    
    @IBAction func reScannerBtn(_ sender: Any) {
        
        if let parentVC = self.parent as? ReceptionalistView {
            let storyboard = UIStoryboard(name: Constants.CarScan, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: Constants.carScannerVc) as? CarScannerView
            parentVC.switchViewController(vc: vc!, showFooter: false)
        }
    }
    
    
    @IBAction func continueBtnServiceCart(_ sender: Any) {
        
        
            editDetails()
        
    }
    
    
//    func punchOrder() {
//
//        let parameters = [ Constants.SessionID: Constants.sessions,
//                           Constants.CarID:Constants.CarIDData,
//                           Constants.OrderTakerID: Constants.ordertracker,
//                           Constants.BayID: Constants.bayid,
//                           Constants.OrderID:  Constants.OrderIDData,
//                           Constants.OrderPunchDt: Constants.currentdate ] as [String : Any]
//
//        guard let url = URL(string: "http://garageapi.isalespos.com/api/order/new") else { return }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
//        request.httpBody = httpBody
//
//        let session = URLSession.shared
//        session.dataTask(with: request) { (data, response, error) in
//            if response == nil {
//                DispatchQueue.main.async {
//                    ToastView.show(message: "Login failed! Check internet", controller: self)
//
//                }
//            }
//            if let response = response {
//                print(response)
//            }
//
//            if let data = data {
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print(json)
//                } catch {
//                    print(error)
//                }
//            }
//
//            }.resume()
//
//
//    }
    
 
    func editDetails() {
        
        print(check.text!)
        
        
        if carplateNumber.text != "" {
            Constants.platenmb = carplateNumber.text!
        }
        
        if check.text != "" {
            Constants.carliterID =  Int(check.text!)!
        }
        
        
        
        
        
        

        if Constants.CarIDData != 0 {
            let parameters = [    Constants.MakeID: Constants.MakeIDData,
                                  Constants.ModelID: Constants.ModelIDData,
                                  Constants.CarID: Constants.CarIDData,
                                   Constants.CustomerID: Constants.CustomerIDData,
                                  Constants.CustomerContact: phoneNumber.text!,
                                  Constants.VinNo: VinNumber.text!,
                                  Constants.MakerName: carMake.text!,
                                  Constants.ModelName: modelNumber.text!,
                                  Constants.CarName: Constants.CarNameData,
                                  Constants.CarDescription: "",
                                  Constants.Year: yearNumber.text!,
                                  Constants.Color: "white",
                                  Constants.RegistrationNo: carplateNumber.text!,
                                  Constants.ImagePath: "",
                                  Constants.SessionID: Constants.sessions,
                                  Constants.CheckLitre: check.text!,
                                  Constants.EngineType: engineType.text!,
                                  Constants.RecommendedAmount: recommendedAmount.text!,
                                  Constants.Gender: Gender] as [String : Any]
            if (carplateNumber.text == "")  || (phoneNumber.text == "" || modelNumber.text == "") {
                
                DispatchQueue.main.async {
                    ToastView.show(message: self.mendatoryfield, controller: self)
                  //   self.staric.textColor = UIColor.red // here
                    self.phStaric.textColor = UIColor.red
                    self.CarStaric.textColor = UIColor.red
                    self.modelStaric.textColor = UIColor.red
                }
                    
                } else if phoneNumber.text!.count < 13 {
                    ToastView.show(message: Numberinvalid, controller: self)
                } else if phoneNumber.text!.count > 13 {
                    ToastView.show(message: NumberGreater, controller: self)
                
            }
            else {
                
                guard let url = URL(string: "\(CallEngine.baseURL)\(CallEngine.editCar)") else { return }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
                request.httpBody = httpBody
                if let JSONString = String(data: httpBody, encoding: .utf8) {
                    
                    print(JSONString)
                }
                let session = URLSession.shared
                session.dataTask(with: request) { (data, response, error) in
                    if response == nil {
                        DispatchQueue.main.async {
                            ToastView.show(message: LocalizedString.interneterror, controller: self)
                        }
                        
                    }
                    if let response = response {
                        print(response)
                    }
                    
                    if let data = data {
                        print(data)
                        do {
                            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {return}
                            print(json)
                            
                            let status = json[Constants.Status] as? Int
                            let newmessage = json[Constants.Description] as? String
                            if (status == 1) {
                                if  let carid = json[Constants.CarID] as? Int {
                                    DispatchQueue.main.async {
                                        Constants.CarIDData = carid
                                    }
                                }
                                ToastView.show(message: newmessage!, controller: self)
                                //DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                    DispatchQueue.main.async {
                                    if let parentVC = self.parent as? ReceptionalistView {
                                        let storyboard = UIStoryboard(name: Constants.ServiceCart, bundle: nil)
                                        let vc = storyboard.instantiateViewController(withIdentifier: Constants.ServiceCartVc) as? ServiceCartView
                                        parentVC.switchViewController(vc: vc!, showFooter: false)
                                        
                                    }
                               // })
                            }
                                
                                
                            }
                            else if (status == 0) {
                                
                                print(status!)
                                DispatchQueue.main.async {
                                    ToastView.show(message: newmessage!, controller: self)
                                }
                            }
                            else if (status == 1000) {
                                
                                print(status!)
                                DispatchQueue.main.async {
                                    ToastView.show(message: LocalizedString.wrong, controller: self)
                                }
                            }
                            else if (status == 1001) {
                                
                                print(status!)
                                DispatchQueue.main.async {
                                    ToastView.show(message: LocalizedString.invalid, controller: self)
                                }
                            }
                            else  {
                                
                                print(status!)
                                DispatchQueue.main.async {
                                    ToastView.show(message: LocalizedString.occured, controller: self)
                                }
                            }
                            
                        } catch {
                            print(error)
                            ToastView.show(message: LocalizedString.occured, controller: self)
                            
                        }
                        
                    }
                    
                    
                    }.resume()
            }
            
        } else {
            
            let parameters = [    Constants.MakeID: Constants.MakeIDData,
                                  Constants.ModelID: Constants.ModelIDData,
                                  Constants.CarID: Constants.CarIDData,
                                  Constants.CustomerID: Constants.CustomerIDData,
                                  Constants.CustomerContact: phoneNumber.text!,
                                  Constants.VinNo: VinNumber.text!,
                                  Constants.MakerName: carMake.text!,
                                  Constants.ModelName: modelNumber.text!,
                                  Constants.CarName: Constants.CarNameData,
                                  Constants.CarDescription: "",
                                  Constants.Year: yearNumber.text!,
                                  Constants.Color: "white",
                                  Constants.RegistrationNo: carplateNumber.text!,
                                  Constants.ImagePath: "",
                                  Constants.SessionID: Constants.sessions,
                                  Constants.CheckLitre: check.text!,
                                  Constants.EngineType: engineType.text!,
                                  Constants.RecommendedAmount: recommendedAmount.text!,
                                  Constants.Gender: Gender ] as [String : Any]
            if (carplateNumber.text == "")  || (phoneNumber.text == "" || modelNumber.text == "") {
                
                DispatchQueue.main.async {
                    ToastView.show(message: self.mendatoryfield, controller: self)
                    //  self.staric.textColor = UIColor.red
                    self.phStaric.textColor = UIColor.red
                    self.CarStaric.textColor = UIColor.red
                    self.modelStaric.textColor = UIColor.red
                    
                }
                
            } else if phoneNumber.text!.count < 13 {
                ToastView.show(message: Numberinvalid, controller: self)
            } else if phoneNumber.text!.count > 13 {
                ToastView.show(message: NumberGreater, controller: self)
                
            }
                
            else {
                
                guard let url = URL(string: "\(CallEngine.baseURL)\(CallEngine.addCar)") else { return }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
                request.httpBody = httpBody
                if let JSONString = String(data: httpBody, encoding: .utf8) {
                    
                    print(JSONString)
                }
                let session = URLSession.shared
                session.dataTask(with: request) { (data, response, error) in
                    if response == nil {
                        DispatchQueue.main.async {
                            ToastView.show(message: LocalizedString.interneterror, controller: self)
                        }
                    }
                    if let response = response {
                        print(response)
                    }
                    
                    if let data = data {
                        print(data)
                        do {
                            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {return}
                            print(json)
                            let status = json[Constants.Status] as? Int
                            let message = json[Constants.Description] as? String
                            if (status == 1) {
                                if  let carid = json[Constants.CarID] as? Int {
                                    DispatchQueue.main.async {
                                        Constants.CarIDData = carid
                                    }
                                }
                                ToastView.show(message: message!, controller: self)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                    if let parentVC = self.parent as? ReceptionalistView {
                                        let storyboard = UIStoryboard(name: Constants.ServiceCart, bundle: nil)
                                        let vc = storyboard.instantiateViewController(withIdentifier: Constants.ServiceCartVc) as? ServiceCartView
                                        parentVC.switchViewController(vc: vc!, showFooter: false)
                                    }
                                })
                                
                                
                            }
                            else if (status == 0) {
                                
                                DispatchQueue.main.async {
                                    ToastView.show(message: message!, controller: self)
                                }
                            }
                            else if (status == 1000) {
                                
                                print(status!)
                                DispatchQueue.main.async {
                                    ToastView.show(message: LocalizedString.wrong, controller: self)
                                }
                            }
                            else if (status == 1001) {
                                
                                print(status!)
                                DispatchQueue.main.async {
                                    ToastView.show(message: LocalizedString.invalid, controller: self)
                                }
                            }
                            else  {
                                
                                print(status!)
                                DispatchQueue.main.async {
                                    ToastView.show(message: LocalizedString.occured, controller: self)
                                }
                            }
                            
                            
                        } catch {
                            print(error)
                            ToastView.show(message: LocalizedString.occured, controller: self)
                            
                        }
                    }
                    
                    }.resume()
                
            }
        }
    }
    
    
    
    @IBAction func CancelDataBtn(_ sender: Any) {
        removefield()
    }
    
    func removefield() {
        
        self.carMake.text = ""
        self.carplateNumber.text  = ""
        self.phoneNumber.text  = "+966"
        self.check.text  = ""
        self.modelNumber.text  = ""
        self.yearNumber.text  = ""
        self.recommendedAmount.text  = ""
        self.engineType.text  = ""
        self.VinNumber.text = ""
        self.carplateNumber.isUserInteractionEnabled = true
        self.VinNumber.isUserInteractionEnabled = true
        
    }
    
    
    
    @IBAction func historyCar(_ sender: Any) {
        if let parentVC = self.parent as? ReceptionalistView {
            let storyboard = UIStoryboard(name: Constants.HistoryCar, bundle: nil)
            let history = storyboard.instantiateViewController(withIdentifier: Constants.historycarVc) as? HistoryCar
            parentVC.switchViewController(vc: history!, showFooter: false)
            
        }
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        Constants.platenmb = "0"
        Constants.vinnmb = "0"
        Constants.CarIDData = 0
        
        if let parentVC = self.parent as? ReceptionalistView {
            let storyboard = UIStoryboard(name: Constants.WelcomeView, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: Constants.WelcomeVc) as? WelcomeView
            parentVC.switchViewController(vc: vc!, showFooter: true)
            
        }
        
    }
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        
        
        var currentText = textField.text!.replacingOccurrences(of: "-", with: "")
        if currentText.count >= 4 {
            currentText.insert("-", at: currentText.index(currentText.startIndex, offsetBy: 3))
            
        }
        textField.text = currentText
        if textField.text!.count  == 8 {
            carplateNumber.resignFirstResponder()
            
        }
        else if textField.text!.count  > 8  {
            let alert = UIAlertController(title: LocalizedString.Alert, message: LocalizedString.limitExceeded, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizedString.OK, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        
        Numberpadview.isHidden = true
        self.numberPadCheck()
        
    }
    
    @objc func phoneNumberDidChange(_ textField: UITextField) {
        // phoneNumber.resignFirstResponder()
        NumberpadViewCheck.isHidden = true
        self.numberPad()
        
        
    }
    
    
    @objc func phoneNumberediting(_ textField: UITextField) {
       print("Pressed")
        if phoneNumber.text!.count == 13 {
            let alert = UIAlertController(title: LocalizedString.Alert, message: LocalizedString.limitExceeded, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizedString.OK, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            //            return false
        }
        
        
        
    }
    
    
    
    @objc func VinNumberDidChange(_ textField: UITextField) {
        
        
        if textField.text!.count  == 17  {
            
            VinNumber.resignFirstResponder()
        }
        else if textField.text!.count  > 17  {
            let alert = UIAlertController(title: LocalizedString.Alert, message: LocalizedString.limitExceeded, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizedString.OK, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension addNewCar: NumberPadDelegate {
    
    
    
    func keyPressed(key: NumberKey?) {
        if Numberpadview.isHidden == false {
            guard let number = key else {
                return
            }
            switch number {
            case .clear:
                guard !(phoneNumber.text?.isEmpty ?? true) else {
                    return
                }
                phoneNumber.text?.removeLast()
            case .custom:
                phoneNumber.text? = "+"
            default:
                phoneNumber.text?.append("\(number.rawValue)")
            }
        }
        else {
            guard let number = key else {
                return
            }
            switch number {
            case .clear:
                guard !(check.text?.isEmpty ?? true) else {
                    return
                }
                check.text?.removeLast()
            case .custom:
                check.text? = "."
            default:
                check.text?.append("\(number.rawValue)")
            }
            
        }
        
    }
    
}




