//
//  BaseViewController.swift
//  WeatherApplication
//
//  Created by UW-IN-LPT0108 on 4/2/23.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    fileprivate var activityIndicatorOverlayView: ActivityIndicatorOverlayView?
    var alertController : UIAlertController?
    var showActivityIndicatorTimer: Timer?
    fileprivate let delayBeforeShowingActivityIndicator: TimeInterval = 0.2
    typealias ShowActivityIndicatorTimerUserInfoDictionary = [String: NSNumber]
    fileprivate let showActivityIndicatorTimerAnimatedKey = "animated"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    func pushController(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentController(_ controller: UIViewController) {
        self.present(controller, animated: true) {
            controller.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        }
    }
    
    func popController() {
        navigationController?.popViewController(animated: true)
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    /// To show the toast message on screen
    /// - Parameter message: message string
    func showToast(message: String) {
        //Snackbar show
    }
}

// MARK: - Activity Indicator Overlay View Methods
extension BaseViewController {
    
    /// Method for showing activity indicator overlay view
    /// - Parameters:
    ///   - animated: Indicates that animation effect is needed or not
    ///   - completion:  completion handler
    func showActivityIndicatorOverlayViewAnimated(_ animated: Bool = true, completion: (() -> ())? = nil) {
        guard activityIndicatorOverlayView == nil else {
            completion?()
            return
        }

        view.isUserInteractionEnabled = false
        scheduleShowActivityIndicatorTimerWithAnimated(animated)
        completion?()
    }
    
    /// Method for hiding activity indicator overlay view
    /// - Parameters:
    ///   - animated:  Indicates that animation effect is needed or not
    ///   - completion: completion handler
    func hideActivityIndicatorOverlayViewAnimated(_ animated: Bool = true, completion: (() -> ())? = nil) {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            
            // The timer to show the activity indicator should be nil (i.e., the activity indicator should be
            // visible on screen) but, if it is not, cancel the timer and invoke the completion closure
            guard self.showActivityIndicatorTimer == nil else {
                self.cancelShowActivityIndicatorTimer()
                completion?()
                return
            }
            
            // If there is no activity indicator on screen, invoke the completion closure
            guard let activityIndicatorOverlayView = self.activityIndicatorOverlayView else {
                completion?()
                return
            }
            
            activityIndicatorOverlayView.hideAnimated(animated) { [weak self] in
                if let activityIndicatorOverlayView = self?.activityIndicatorOverlayView {
                    activityIndicatorOverlayView.removeFromSuperview()
                    self?.activityIndicatorOverlayView = nil
                }
                
                completion?()
            }
        }
    }
        
    /// Method for scheduling show activity indicator timer
    /// - Parameter animated: Indicates that animation effect is needed or not
    fileprivate func scheduleShowActivityIndicatorTimerWithAnimated(_ animated: Bool) {
        guard showActivityIndicatorTimer == nil else {
            return
        }
        
        let userInfo = [showActivityIndicatorTimerAnimatedKey: NSNumber(value: animated as Bool)]
        showActivityIndicatorTimer = Timer.scheduledTimer(timeInterval: delayBeforeShowingActivityIndicator, target: self, selector: #selector(BaseViewController.handleShowActivityIndicatorTimer(_:)), userInfo: userInfo, repeats: false)
    }
    
    /// Method for handling timer for showing activity indicator
    /// - Parameter timer: timer
    @objc fileprivate func handleShowActivityIndicatorTimer(_ timer: Timer) {
        if let showActivityIndicatorTimer = showActivityIndicatorTimer, showActivityIndicatorTimer == timer {
            let userInfo = timer.userInfo as? ShowActivityIndicatorTimerUserInfoDictionary
            let animated = userInfo?[showActivityIndicatorTimerAnimatedKey]?.boolValue ?? false
            
            activityIndicatorOverlayView = ActivityIndicatorOverlayView()
            activityIndicatorOverlayView?.translatesAutoresizingMaskIntoConstraints = false
            activityIndicatorOverlayView?.showInView(self.view, animated: animated, completion: nil)
            
            self.showActivityIndicatorTimer = nil
        }
    }
    
    /// Method for invalidate the activity indicator timer
    fileprivate func cancelShowActivityIndicatorTimer() {
        showActivityIndicatorTimer?.invalidate()
        showActivityIndicatorTimer = nil
    }
}

// MARK: - Alert View
extension BaseViewController {
    /// To show the alert view
    /// - Parameters:
    ///   - title: Alert title
    ///   - message: Alert message
    ///   - messageWithBoldText: NSAttributedString, message with bold text
    ///   - alertStyle: Alert style
    ///   - actionTitles: Alert button titles
    ///   - actionStyles: Alert button action style
    ///   - actions: Alert button action
    public func showAlertView(title: String? = nil,
                          message: String? = nil,
                          alertStyle: UIAlertController.Style,
                          actionTitles: [String],
                          actionStyles: [UIAlertAction.Style],
                          actions: [((UIAlertAction) -> Void)]) {
        DispatchQueue.main.async {
            self.alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
            if let alertController = self.alertController {
                for (index, indexTitle) in actionTitles.enumerated() {
                    let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
                    alertController.addAction(action)
                }
                self.present(alertController, animated: true)
            }
        }
    }
    
    /// To show the alert view with single ok button without any action
    /// - Parameter alertTitle: Alert title
    /// - Parameter alertMessage: Alert message
    /// - Parameter messageWithBoldText: NSAttributedString, message with bold text
    func showAlertView(alertTitle: String, alertMessage: String) {
        self.showAlertView(title: alertTitle,
                           message: alertMessage,
                           alertStyle: .alert,
                           actionTitles: ["Ok"],
                           actionStyles: [.default],
                           actions: [{_ in }])
    }
    
    /// To dismiss the presented alert controller
    public func dismissAlertView() {
        DispatchQueue.main.async {
            if let alertController = self.alertController {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
}

