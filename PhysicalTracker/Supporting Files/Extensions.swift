//
//  Extensions.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 06/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit
import AVKit

//MARK: - AVPlayerViewController
extension AVPlayerViewController {
    func disableGestureRecognition(view: UIView) {
        let contentView = view.value(forKey: "contentView") as? UIView
        contentView?.gestureRecognizers = contentView?.gestureRecognizers?.filter { $0 is UITapGestureRecognizer }
    }
    
}

//MARK: NSMutableAttributedString
extension NSMutableAttributedString {
    public func setAsLink(textToFind: String, linkURL: String) -> Bool {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            
            self.addAttribute(.link, value: linkURL, range: foundRange)
            
            return true
        }
        
        return false
    }
    
}

//MARK: - String
extension String {
    func convertStringIntoListOfString(_ text: String) -> String {
        var description = ""
        let textArray = text.components(separatedBy: ";")
        for t in textArray {
            description += "- " + t + "\n"
        }
        
        return description
    }
    
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        
        guard let characterSpacing = characterSpacing else { return attributedString }
        
        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
    
}

extension TimeInterval {
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        
        return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",minutes,seconds)
    }
    
}

//MARK: - UIColor
extension UIColor {
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
}

//MARK: - UIButton
extension UIButton {
    func setupIsEnabled(_ button: UIButton, isEnabled: Bool) {
        if isEnabled == false {
            button.isEnabled = false
            button.backgroundColor = .lightGray
            button.setTitleColor(.black, for: .disabled)
        } else {
            button.isEnabled = true
            button.backgroundColor = Constants.Colors.redUIColor
            button.setTitleColor(.white, for: .normal)
        }
    }
    
}

//MARK: - UITableViewCell
extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
}

//MARK: - UIView
extension UIView {
    // Captures view and subviews in an image
    func snapshotViewHierarchy(scrollView: UIScrollView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, false, UIScreen.main.scale)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    
    func setupBMIValue() -> String {
        return String(ResultsManager.shared.calculationBMI())
    }
    
    func setupPhysicalLevelLabel() -> String{
        let ricciResult = UserManager.shared.currentUser.ricciResult
        
        if ricciResult == 0 {
            return "À faire"
        } else {
            return String(ricciResult)
        }
    }
    
    func setupPhysicalLevelText() -> String {
        let ricciResult = UserManager.shared.currentUser.ricciResult
        let evaluation = ResultsManager.shared.evaluationRicci()
        let evalutionPhysicalLevelGradingTexts = NSLocalizedString(Constants.RessourcesStrings.ricciGrading, comment: "").split(separator: "|").map(String.init)
        
        if ricciResult == 0 {
            return "À faire"
        } else {
            return evalutionPhysicalLevelGradingTexts[evaluation]
        }
    }
    
    func setupPhysicalLevelGradingAdvice() -> String {
        let ricciResult = UserManager.shared.currentUser.ricciResult
        let evaluation = ResultsManager.shared.evaluationRicci()
        let evaluationPhysicalLevelGradingAdvices = NSLocalizedString(Constants.RessourcesStrings.ricciGradingAdvices, comment: "").split(separator: "|").map(String.init)
        
        if ricciResult == 0 {
            return "À déterminer"
        } else {
            return evaluationPhysicalLevelGradingAdvices[evaluation]
        }
    }
    
    func setupGradingTextBMI() -> String {
        let evaluation = ResultsManager.shared.evaluationBMI()
        let evaluationBMIGradingTexts = NSLocalizedString(Constants.RessourcesStrings.bmiGrading, comment: "").split(separator: "|").map(String.init)
        
        return evaluationBMIGradingTexts[evaluationBMIGradingTexts.count - evaluation - 1]
    }
    
    func setupGradingAdviceBMI() -> String {
        let evaluation = ResultsManager.shared.evaluationBMI()
        let evaluationBMIGradingAdvices = NSLocalizedString(Constants.RessourcesStrings.bmiGradingAdvices, comment: "").split(separator: "|").map(String.init)
        
        return evaluationBMIGradingAdvices[evaluationBMIGradingAdvices.count - evaluation - 1]
    }
    
    func setupGradingScaleColorBMI(view: UIView) {
        let evaluation = ResultsManager.shared.evaluationBMI()
        var evaluationColors = NSLocalizedString(Constants.RessourcesStrings.gradeScaleColor, comment: "").split(separator: "|").map(String.init)
        
        evaluationColors.append("#ffffff")
        
        view.backgroundColor = ResultsManager.shared.hexStringToUIColor(hex: evaluationColors[evaluation])
    }
    
    func setupGradingScaleColorRicci(view: UIView){
        let evaluation = ResultsManager.shared.evaluationRicci()
        let evaluationColors = NSLocalizedString(Constants.RessourcesStrings.gradeScaleColor, comment: "").split(separator: "|").map(String.init)
        
        view.backgroundColor = ResultsManager.shared.hexStringToUIColor(hex: evaluationColors[evaluation])
    }
    
}

//MARK - UIViewController
extension UIViewController {
    // Setup alert's messages
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: Constants.Labels.ok, style: .cancel, handler: nil))
        alertVC.view.tintColor = Constants.Colors.redUIColor
        
        present(alertVC, animated: true, completion: nil)
    }
    
    // Setup alert's messages with multiple actions
    func setupAlert(title: String, message: String, actionsTitles: [String], alertAction: ((UIAlertAction) -> Void)?) {
        let actionsTitles = actionsTitles
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for actionTitle in actionsTitles {
            alertVC.addAction(UIAlertAction(title: actionTitle, style: .default, handler: alertAction))
        }
        
        alertVC.view.tintColor = Constants.Colors.redUIColor
        
        present(alertVC, animated: true, completion: nil)
    }
    
    // Setup navigation bar tintColor
    func setupNavigationBarTintColor(_ tintColor: UIColor) {
        navigationController?.navigationBar.tintColor = Constants.Colors.redUIColor
    }
    
    // Setup navigation bar isHidden
    func setupNavigationBarIsHidden(_ isHidden: Bool, _ isAnimated: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: isAnimated)
    }
    
    // Setup navigation item title
    func setupNavigationControllerTitle(_ title: String) {
        navigationItem.title = title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: Constants.Fonts.rubikMedium, size: 18)!]
    }
    
    // Setup back button isHidden
    func setupBackButton(isHidden: Bool, isAnimated: Bool) {
        self.navigationItem.setHidesBackButton(isHidden, animated: isAnimated)
    }
    
    // Setup back button title
    open override func awakeFromNib() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
}

//MARK: - UINavigationController
extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
    
}
