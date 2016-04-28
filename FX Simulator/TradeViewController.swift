//
//  TradeViewController.swift
//  FXSimulator
//
//  Created by yuu on 2016/04/27.
//
//

import UIKit

class TradeViewController: UIViewController {

    var chartViewController: ChartViewController!
    var ratePanelViewController: RatePanelViewController!
    var tradeDataViewController: TradeDataViewController!
    
    var market: Market!
    var orderFactory: OrderFactory!
    var orderManager: OrderManager!
    var saveData: SaveData!
    var simulationManager: SimulationManager!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChartViewControllerSeg" {
            chartViewController = segue.destinationViewController as! ChartViewController
            chartViewController.delegate = self
        } else if segue.identifier == "RatePanelViewControllerSeg" {
            ratePanelViewController = segue.destinationViewController as! RatePanelViewController
        } else if segue.identifier == "TradeDataViewControllerSeg" {
            tradeDataViewController = segue.destinationViewController as! TradeDataViewController
            tradeDataViewController.delegate = self
        }
        
        self.saveDataDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !simulationManager.isStartTime {
            self.update()
        } else {
            simulationManager.resumeTime()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !simulationManager.isStartTime {
            simulationManager.startTime()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        simulationManager.pauseTime()
    }
    
    func update() {
        chartViewController.update(market)
        ratePanelViewController.update()
        tradeDataViewController.update()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TradeViewController: SimulationManagerDelegate {
    
    func loadSimulationManager(simulationManager: SimulationManager) {
        self.simulationManager = simulationManager
    }
    
    /**
     1回目は、prepareForSegueの前に呼ばれる
     */
    func loadSaveData(saveData: SaveData) {
        self.saveData = saveData
    }
    
    func loadMarket(market: Market) {
        self.market = market
    }
    
    func loadOrderFactory(orderFactory: OrderFactory) {
        self.orderFactory = orderFactory
    }
    
    func loadOrderManager(orderManager: OrderManager) {
        self.orderManager = orderManager
    }
    
    func saveDataDidLoad() {
        if chartViewController == nil || ratePanelViewController == nil || tradeDataViewController == nil {
            return
        }
        
        chartViewController.setChart(saveData.mainChart)
        
        ratePanelViewController.loadSaveData(saveData)
        ratePanelViewController.loadMarket(market)
        ratePanelViewController.loadOrderFactory(orderFactory)
        ratePanelViewController.loadOrderManager(orderManager)
        
        tradeDataViewController.loadSaveData(saveData)
        tradeDataViewController.loadMarket(market)
    }
    
    func marketDidUpdate() {
        self.update()
    }
    
    func simulationStopped(message: Message) {
        message.showAlertToController(self)
    }
    
    func didOrder(result: Result) {
        result.success(nil, failure: { result.showAlertToController(self) })
        
        tradeDataViewController.didOrder(result)
    }
}

extension TradeViewController: ChartViewControllerDelegate {
    
    func chartViewTouched() {
        simulationManager.addTime()
    }
}

extension TradeViewController: TradeDataViewControllerDelegate {
    
    var isAutoUpdate: Bool { return simulationManager.isAutoUpdate }
    
    func autoUpdateSettingSwitchChanged(isSwitchOn: Bool) {
        simulationManager.isAutoUpdate = isSwitchOn
    }
}
