//
//  ActivityIndicatorOverlayView.swift
//  WeatherApplication
//
//  Created by UW-IN-LPT0108 on 4/2/23.
//

import UIKit

import UIKit

private let kActivityIndicatorOverlayViewCornerRadius: CGFloat = 10
private let kActivityIndicatorOverlayViewWidth: CGFloat = 100
private let kActivityIndicatorOverlayViewHeight: CGFloat = 100

private let kActivityIndicatorOverlayViewAnimationDuration: TimeInterval = 0.25
private let kActivityIndicatorOverlayViewAlphaWhenHidden: CGFloat = 0
private let kActivityIndicatorOverlayViewAlphaWhenVisible: CGFloat = 1

class ActivityIndicatorOverlayView: UIView {
    var isAnimating: Bool {
        guard let activityIndicatorView = activityIndicatorView else { return false }
        return activityIndicatorView.isAnimating
    }
    
    fileprivate var activityIndicatorView: UIActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    fileprivate func commonInit() {
        self.alpha = kActivityIndicatorOverlayViewAlphaWhenHidden
        self.backgroundColor = UIColor(white: 0.25, alpha: 0.5)
        self.layer.cornerRadius = kActivityIndicatorOverlayViewCornerRadius
        
        activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicatorView!)
        
        let widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: kActivityIndicatorOverlayViewWidth)
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: kActivityIndicatorOverlayViewHeight)
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicatorView!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let verticalConstraint = NSLayoutConstraint(item: activityIndicatorView!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        self.addConstraints([widthConstraint, heightConstraint, horizontalConstraint, verticalConstraint])
    }
    
    func showInView(_ newSuperview: UIView, animated: Bool = true, completion: (() -> ())? = nil) {
        guard self.superview == nil else {
            print("Warning: An attempt was made to show \(String(describing: type(of: self))) in a new view while visible in another view. The attempt was ignored.")
            return
        }
        
        guard self.alpha == kActivityIndicatorOverlayViewAlphaWhenHidden else {
            completion?()
            return
        }
        
        newSuperview.addSubview(self)
        
        let horizontalConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: newSuperview, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let verticalConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: newSuperview, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        newSuperview.addConstraints([horizontalConstraint, verticalConstraint])
        
        activityIndicatorView?.startAnimating()
        
        let currentAnimationDuration = animated ? kActivityIndicatorOverlayViewAnimationDuration : 0.0
        UIView.animate(withDuration: currentAnimationDuration, animations: {
            self.alpha = kActivityIndicatorOverlayViewAlphaWhenVisible
        }, completion: { _ in
            completion?()
        })
    }
    
    func hideAnimated(_ animated: Bool = true, completion: (() -> ())? = nil) {
        DispatchQueue.main.async {
            guard self.alpha == kActivityIndicatorOverlayViewAlphaWhenVisible else {
                completion?()
                return
            }
            
            let currentAnimationDuration = animated ? kActivityIndicatorOverlayViewAnimationDuration : 0.0
            UIView.animate(withDuration: currentAnimationDuration, animations: {
                self.alpha = kActivityIndicatorOverlayViewAlphaWhenHidden
            }, completion: { [weak self] _ in
                self?.activityIndicatorView?.stopAnimating()
                completion?()
            })
        }
    }
}

