//
//  MainViewController.swift
//  FXSimulator
//
//  Created by yuu on 2016/04/27.
//
//

import UIKit

class MainViewController: UITabBarController {
    
    let simulationManager: SimulationManager
    var tradeViewController: TradeViewController!
    
    required init?(coder aDecoder: NSCoder) {
        simulationManager = SimulationManager()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(didBecomeActive), name: UIApplicationDidBecomeActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(willEnterBackground), name: UIApplicationWillResignActiveNotification, object: nil)
        
        self.customizableViewControllers = nil;
        
        self.viewControllers?.forEach { viewController in
            var topViewController: UIViewController
            
            if let navigationController = viewController as? UINavigationController {
                topViewController = navigationController.topViewController!
            } else {
                topViewController = viewController
            }
            
            if let topViewController = topViewController as? SimulationManagerDelegate {
                simulationManager.addDelegate(topViewController)
            }
            
            if let tradeViewController = topViewController as? TradeViewController {
                self.tradeViewController = tradeViewController
            } else if let newStartViewController = topViewController as? NewStartViewController {
                newStartViewController.delegate = self
            }
            
        }
        
        simulationManager.startSimulation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.moreNavigationController.navigationBar.backgroundColor = UIColor.blackColor()
        self.moreNavigationController.navigationBar.barTintColor = UIColor.blackColor()
        
        self.moreNavigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        if let tableView = self.moreNavigationController.viewControllers.first?.view as? UITableView {
            tableView.backgroundColor = UIColor.blackColor()
            
            tableView.visibleCells.forEach { tableViewCell in
                tableViewCell.backgroundColor = UIColor.blackColor()
                tableViewCell.textLabel?.textColor = UIColor.whiteColor()
            }
        }
    }
    
    func didBecomeActive() {
        simulationManager.resumeTime()
    }
    
    func willEnterBackground() {
        simulationManager.pauseTime()
        simulationManager.save()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
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

extension MainViewController: NewStartViewControllerDelegate {
    func didStartSimulationWithNewData() {
        self.selectedViewController = tradeViewController
    }
}
