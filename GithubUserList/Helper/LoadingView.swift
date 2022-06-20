//
//  LoadingView.swift
//  GithubUserList
//

import Foundation
import UIKit

class LoadingView: UIView {

    var indicator: UIActivityIndicatorView!
    
    static let shared = LoadingView(frame: UIScreen.main.bounds)
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setIndicator()
    }
    
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        indicator.center = self.center
    }
    
    func setIndicator() {
        indicator = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        indicator.style = .large
        self.addSubview(indicator)
        indicator.color = .white
        layoutIfNeeded()
    }
    
    func showIndicator() {
        UIApplication.getTopViewController()?.view.addSubview(LoadingView.shared)
        self.isHidden = false
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    func hideIndicator() {
        LoadingView.shared.removeFromSuperview()
        self.isHidden = true
        indicator.isHidden = true
        indicator.stopAnimating()
    }
    
}
