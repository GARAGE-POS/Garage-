//
//  HardwareViewController.swift
//  Garage
//
//  Created by Amjad on 21/06/1440 AH.
//  Copyright © 1440 Amjad Ali. All rights reserved.
//

import UIKit
import CoreData

enum ButtonType: Int {
    case none = 0
    case uiButton
    case uiSwitch
}

struct PrinterDetailCellUIModel {
    var title: String!
    var subTitle: String!
    var isSubTitleTouchable: Bool!
    var buttonType: ButtonType!
    var buttonTitle: String!
    var isButtonSelected: Bool!
    var isSwitchOn: Bool!
    
    
    init(title: String, subTitle: String, isSubTitleTouchable: Bool = false, buttonType: ButtonType, buttonTitle: String = "", isButtonSelected: Bool = false, isSwitchOn: Bool = false) {
        self.title = title
        self.subTitle = subTitle
        self.isSubTitleTouchable = isSubTitleTouchable
        self.buttonType = buttonType
        self.buttonTitle = buttonTitle
        self.isButtonSelected = isButtonSelected
        self.isSwitchOn = isSwitchOn
    }
}

class HardwareViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, Epos2DiscoveryDelegate {
    
    //var printers = [PrinterDetailsModel]()
     private var manufacturer: String!
     private var macAddress: String!
    var printerDetailsModels: [PrinterDetailsModel]?
    fileprivate var printerList: [Epos2DeviceInfo] = []
    fileprivate var filterOption: Epos2FilterOption = Epos2FilterOption()
    
    @IBOutlet weak var receiptPrinterTableview: UITableView!
    @IBOutlet weak var printertypelabel: UITextField!
    private var availablePrinters = [PrinterDetailsModel]()
    var printerDetailModelUICells: [PrinterDetailCellUIModel]!
    
    @IBOutlet weak var connectOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
      
        
        // Do any additional setup after loading the view, typically from a nib.
        filterOption.deviceType = EPOS2_TYPE_PRINTER.rawValue
//        receiptPrinterTableview.delegate = self
//        receiptPrinterTableview.dataSource = self
        // printertypelabel.text = Constants.Printer
        if Added() {
            printertypelabel.addTarget(self, action: #selector(printertypelabelChange(_:)), for: .editingChanged)
        }  else {
            printertypelabel.addTarget(self, action: #selector(printertypelabelChange(_:)), for: .editingChanged)
            
        }
       print(Constants.Printer)
         configureUI()
    }
    
    
    private func configureUI() {
        availablePrinters.removeAll()
        if let printers = getConnectedPrinters() {
            for printer in printers {
                let myPrinter = PrinterDetailsModel()
                myPrinter.model = printer.model
                myPrinter.ipAddress = printer.ipAddress
                myPrinter.target = printer.target
                myPrinter.isCashPrinter = printer.isCashPrinter
                myPrinter.isKickDrawer = printer.isKickDrawer
                myPrinter.isKitchenPrinter = printer.isKitchenPrinter
                myPrinter.numberOfCopies = printer.numberOfCopies
                myPrinter.alias = printer.alias
                myPrinter.manufacturer = PrinterManufacturer(rawValue: printer.manufacturer)
                myPrinter.isConnected = true
                myPrinter.macAddress = printer.macAddress
                availablePrinters.append(myPrinter)
            }
        }
        
        
        if availablePrinters.count > 0 {
           print(availablePrinters)
        }
        
        
        
        
    }
    
    
    private func getConnectedPrinters()-> [PrinterDetails]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PrinterDetails")
        do {
            let results = try DataController.context.fetch(fetchRequest) as! [PrinterDetails]
            return results
        } catch {
            print("error in retrieving")
            return nil
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    fileprivate func Added() -> Bool {
        printertypelabel.text = UserDefaults.standard.string(forKey: "printer")
        Constants.Printer = printertypelabel.text!
        return UserDefaults.standard.bool(forKey: "printer")
    }
    
    @objc func printertypelabelChange(_ textField: UITextField) {
        
        if printertypelabel.text!.characters.count != 0 {
            print("added")
        }
        else {
            print("deleted")
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let result = Epos2Discovery.start(filterOption, delegate: self)
        if result != EPOS2_SUCCESS.rawValue {
            //ShowMsg showErrorEpos(result, method: "start")
            
        }
        receiptPrinterTableview.reloadData()
        
//        else {
//            Constants.Printer = UserDefaults.standard.string(forKey: "printer")!
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
          //  Constants.Printer = UserDefaults.standard.string(forKey: "printer")!
            
            
        while Epos2Discovery.stop() == EPOS2_ERR_PROCESSING.rawValue {
            // retry stop function
        }
        
        printerList.removeAll()
        
    }
    
    
    @IBAction func discoverBtn(_ sender: Any) {
        print("pressed")
        
        
        selectedMedium(connectionMedium: ConnectionMedium.localAreaNetwork)
        
    }
    
    
    
    @IBAction func disconnectBtn(_ sender: Any) {
 
        
        if printerDetailModelUICells == nil {
            let messageVC = UIAlertController(title: "Alert ", message: "You can select another printer through discover" , preferredStyle: .actionSheet)
            self.present(messageVC, animated: true) {
                Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (_) in
                    messageVC.dismiss(animated: true, completion: nil)})}
        } else {
        
        deletePrinter(printerDetailModelUICell: printerDetailModelUICells)
        if Constants.Printer != "" {
            let prefs = UserDefaults.standard
            printertypelabel.text = prefs.string(forKey:"printer")
            Constants.Printer = ""
            printertypelabel.text = ""
            prefs.removeObject(forKey:"printer")
            //connectOutlet.setTitle("Connect", for: .normal)
          
                }
            //       }
            // Setting kitchen and checkout printers
            PrintJobHelper.setPrinters()
            receiptPrinterTableview.reloadData()
          //  dismiss(animated: true, completion: nil)
            }
    }
    
    
    
    
    @IBAction func connectdisconnect(_ sender: Any) {
        
        if printerDetailModelUICells == nil {
            let messageVC = UIAlertController(title: "Failed ", message: "Please Select Printer First!" , preferredStyle: .actionSheet)
            self.present(messageVC, animated: true) {
                Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (_) in
                    messageVC.dismiss(animated: true, completion: nil)})}
        } else {
 
                addPrinter(printerDetailModelUICell: printerDetailModelUICells)
                printertypelabel.text = "\(Constants.Printer)"
                UserDefaults.standard.set(printertypelabel.text, forKey: "printer")
                UserDefaults.standard.synchronize()
                // selectedPrinter(printer: printerList[indexPath.row])
                NotificationCenter.default.post(name: Notification.Name("printerAdded"), object: nil)
               // connectOutlet.setTitle("Disconnect", for: .normal)
//                connectOutlet.titleLabel?.text = "Disconnect"
//                UserDefaults.standard.set(connectOutlet.titleLabel?.text, forKey: "title")
//                UserDefaults.standard.synchronize()
//                connectOutlet.isSelected = true
          //  } else
                
//                deletePrinter(printerDetailModelUICell: printerDetailModelUICells)
            //                        if C{onstants.Printer != "" {
//                            let prefs = UserDefaults.standard
//                            printertypelabel.text = prefs.string(forKey:"printer")
//                            Constants.Printer = ""
//                            printertypelabel.text = ""
//                            prefs.removeObject(forKey:"printer")
//                           //connectOutlet.setTitle("Connect", for: .normal)
//                            connectOutlet.titleLabel?.text = "Disconnect"
//                            UserDefaults.standard.set(connectOutlet.titleLabel?.text, forKey: "title")
//                            UserDefaults.standard.synchronize()
//                            connectOutlet.isSelected = false
                    //    }
            
            // Setting kitchen and checkout printers
            PrintJobHelper.setPrinters()
           receiptPrinterTableview.reloadData()
         dismiss(animated: true, completion: nil)
        }
    }



 func deletePrinter(printerDetailModelUICell: [PrinterDetailCellUIModel]) {
    let fetchRequest: NSFetchRequest = PrinterDetails.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "ipAddress = %@", printerDetailModelUICell[1].subTitle)
    do {
        let result = try DataController.context.fetch(fetchRequest).first
        if let result = result {
            DataController.context.delete(result)
            DataController.saveContext()
        }
    } catch {
        
    }
}
    
    
    
    
    func selectedMedium(connectionMedium medium: ConnectionMedium) {
        print(medium)
        let searchPrinter = SearchPrinterHelper()
        searchPrinter.delegate = self
        searchPrinter.searchPrinter(on: medium)
    }
    
    
    private func setupPrinterWithUIModel(selectedPrinter: PrinterDetailsModel) {
        
        print(selectedPrinter.model)
        
        let connectButtonTitle = selectedPrinter.isConnected ? "Connected" : "Connect"

        let printerDetailCellUIModels = [
            PrinterDetailCellUIModel(title: "Model", subTitle: selectedPrinter.model, buttonType: ButtonType.uiButton, buttonTitle: connectButtonTitle, isButtonSelected: selectedPrinter.isConnected),
            PrinterDetailCellUIModel(title: "IP Address", subTitle: selectedPrinter.ipAddress, buttonType: ButtonType.none),
            PrinterDetailCellUIModel(title: "Target", subTitle: selectedPrinter.target, buttonType: ButtonType.none),
            PrinterDetailCellUIModel(title: "Cash Printer", subTitle: "", buttonType: ButtonType.uiSwitch, isSwitchOn: selectedPrinter.isCashPrinter),
            PrinterDetailCellUIModel(title: "Cash Drawer", subTitle: "", buttonType: ButtonType.uiSwitch, isSwitchOn: selectedPrinter.isKickDrawer),
            PrinterDetailCellUIModel(title: "Kitchen Printer", subTitle: "", buttonType: ButtonType.uiSwitch, isSwitchOn: selectedPrinter.isKitchenPrinter),
            PrinterDetailCellUIModel(title: "Copies", subTitle: "1", isSubTitleTouchable: true, buttonType: ButtonType.none),
            PrinterDetailCellUIModel(title: "mac Address", subTitle: selectedPrinter.macAddress, buttonType: ButtonType.uiButton, buttonTitle: connectButtonTitle, isButtonSelected: selectedPrinter.isConnected),
            PrinterDetailCellUIModel(title: "Alias", subTitle: selectedPrinter.model, isSubTitleTouchable: true, buttonType: ButtonType.none)]
        
              configureUI(printerDetailCellUIModel: printerDetailCellUIModels, manufacturer: (selectedPrinter.manufacturer?.rawValue)!, macAddress: selectedPrinter.macAddress)
     
        
        //print(printerDetailCellUIModels)
        
    }
    
    
    func selectedPrinter(printer: PrinterDetailsModel) {
        setupPrinterWithUIModel(selectedPrinter: printer)
    }
    
    
    func configureUI(printerDetailCellUIModel: [PrinterDetailCellUIModel], manufacturer: String, macAddress: String) {
        self.manufacturer = manufacturer
        self.macAddress = macAddress
        self.printerDetailModelUICells = printerDetailCellUIModel
        
    }
    
    
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return printerDetailsModels!.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowNumber: Int = 0
        if section == 0 {
            rowNumber =  printerDetailsModels!.count
        }
        else {
            rowNumber = 1
        }
        return rowNumber
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let identifier = "basis-cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
        }

        if indexPath.section == 0 {
            if indexPath.row >= 0 && indexPath.row < printerDetailsModels!.count {
              //  printers = printerList[indexPath.row]
                cell!.textLabel?.text = printerDetailsModels![indexPath.row].model
                cell!.detailTextLabel?.text = printerDetailsModels![indexPath.row].target

            }
        }
        else {
            cell!.textLabel?.text = "other..."
            cell!.detailTextLabel?.text = ""
        }

        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
                Constants.Printer = printerList[indexPath.row].target
//            printertypelabel.text = "\(Constants.Printer)"
            UserDefaults.standard.set(Constants.Printer, forKey: "printer")
            UserDefaults.standard.synchronize()
           // selectedPrinter(printer: printerList[indexPath.row])
             NotificationCenter.default.post(name: Notification.Name("printerAdded"), object: nil)
            selectedPrinter(printer: printerDetailsModels![indexPath.row])
         
            print(printerDetailsModels as Any)

        }
        else {
            performSelector(onMainThread: #selector(HardwareViewController.connectDevice), with:self, waitUntilDone:false)
        }

    }
    
    
    // Save data to coredata
    
    fileprivate func addPrinter(printerDetailModelUICell: [PrinterDetailCellUIModel]) {
        let context = DataController.context
        guard let entity =  NSEntityDescription.entity(forEntityName: "PrinterDetails", in: context) else { return }
        let object = PrinterDetails(entity: entity, insertInto: context)
        object.model = printerDetailModelUICell[0].subTitle
        object.ipAddress = printerDetailModelUICell[1].subTitle
        object.target = printerDetailModelUICell[2].subTitle
        object.isCashPrinter = printerDetailModelUICell[3].isSwitchOn
        object.isKickDrawer = printerDetailModelUICell[4].isSwitchOn
        object.isKitchenPrinter = printerDetailModelUICell[5].isSwitchOn
        object.numberOfCopies = Int16(printerDetailModelUICell[6].subTitle)!
        object.alias = printerDetailModelUICell[7].subTitle
       // object.macAddress = self.macAddress
        DataController.saveContext()
    }
    
    
    
    @objc func connectDevice() {
        Epos2Discovery.stop()
        printerList.removeAll()
        
        let btConnection = Epos2BluetoothConnection()
        let BDAddress = NSMutableString()
        let result = btConnection?.connectDevice(BDAddress)
        if result == EPOS2_SUCCESS.rawValue {
           
            self.navigationController?.popToRootViewController(animated: true)
        }
        else {
            Epos2Discovery.start(filterOption, delegate:self)
            receiptPrinterTableview.reloadData()
        }
      //  PrinterDetailsModel
    }
//    @IBAction func restartDiscovery(_ sender: AnyObject) {
//        var result = EPOS2_SUCCESS.rawValue;
//
//        while true {
//            result = Epos2Discovery.stop()
//
//            if result != EPOS2_ERR_PROCESSING.rawValue {
//                if (result == EPOS2_SUCCESS.rawValue) {
//                    break;
//                }
//                else {
//                    MessageView.showErrorEpos(result, method:"stop")
//                    return;
//                }
//            }
//        }
//
//        printerList.removeAll()
//        printerView.reloadData()
//
//        result = Epos2Discovery.start(filterOption, delegate:self)
//        if result != EPOS2_SUCCESS.rawValue {
//            MessageView.showErrorEpos(result, method:"start")
//        }
//    }
    
    
    func onDiscovery(_ deviceInfo: Epos2DeviceInfo!) {
        printerList.append(deviceInfo)
        receiptPrinterTableview.reloadData()
    }
    
    func setupTableView(printerDetailsModels: [PrinterDetailsModel]) {
        self.printerDetailsModels = printerDetailsModels
        receiptPrinterTableview.reloadData()
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension HardwareViewController: SearchPrinterHelperDelegate {
    func discoverdPrinters(printers: Set<PrinterDetailsModel>?) {
        if let printers = printers {
            var discoverdPrinters = Array(printers)
         //   receiptPrinterTableview.reloadData()
            /// Remove redundant printers
            DispatchQueue.main.async {
                for availablePrinter in self.availablePrinters {
                
                for i in 0..<discoverdPrinters.count {
                    self.receiptPrinterTableview.reloadData()
                    print("aaae \(i)")
                    print("discoverdPrinters[i]: \(discoverdPrinters)")
                    print("discoverdPrinters[i]: \(discoverdPrinters[i])")
                    print("availablePrinter: \(availablePrinter)")
                    
                    
                    
                    if availablePrinter.ipAddress == discoverdPrinters[i].ipAddress {
                        discoverdPrinters.remove(at: i)
                    }
                    
                }
               Epos2Discovery.stop()
            }
            }
            
           
            
            if discoverdPrinters.count > 0 {
                print(discoverdPrinters)
               setupTableView(printerDetailsModels: discoverdPrinters)
                receiptPrinterTableview.delegate = self
                receiptPrinterTableview.dataSource = self
//                if !isPrinterViewExpanded {
//                    isPrinterViewExpanded = true
//                    addPrinterViewBottomConstraint = addPrinterViewBottomConstraint.setMultiplier(multiplier: 1.1)
//                    addConstraintsToFitInside(parentView: addPrinterContainerView, childView: addPrinterDialogueView!, spacingFromAllSides: 12)
//                    UIView.animate(withDuration: 0.5) {
//                        self.view.layoutIfNeeded()
//                    }
//                }
            } else {
                 UIUtility.showAlertInController(title: "Alert", message: "NO new Printers Found", viewController: self)
            }
        }
       
        Loader.stopLoading()

    }
   
}
extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
