//
//  Utility.swift
//  Contacts
//
//  Created by Harikrishnan S R on 23/09/21.
//

import UIKit
import Network

public enum NetworkErrors: Error {
    
    case wrongUrl
    case unKnownResponse
    case parseError
    
}

protocol IUtility {
    
    static var baseColor: UIColor { get }
    
    func getStackView(axis: NSLayoutConstraint.Axis,
                             alignment: UIStackView.Alignment,
                             distribution: UIStackView.Distribution,
                             spacing: CGFloat) -> UIStackView
    
    func getLabel(_ font: UIFont,
                         color: UIColor,
                         numberOfLines: Int) -> UILabel
    
    func getIconWithLabelView(_ font: UIFont,
                                      color: UIColor,
                                      iconName: String,
                                      labelName: String,
                                      size: CGFloat,
                                      isImageLeftAligned: Bool ) -> UIStackView
    
    func getIconView(name: String,
                             size: CGFloat,
                             color: UIColor) -> UIView
    
}

public struct Utility: IUtility {
    
    static let baseColor: UIColor = UIColor(red:0.49, green:0.49, blue:1.00, alpha:1.0)
    
    public func getStackView(axis: NSLayoutConstraint.Axis,
                             alignment: UIStackView.Alignment,
                             distribution: UIStackView.Distribution,
                             spacing: CGFloat) -> UIStackView {
        
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        
        return stackView
        
    }
    
    public func getLabel(_ font: UIFont,
                         color: UIColor,
                         numberOfLines: Int = 0) -> UILabel {
        
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = numberOfLines
        label.font = font
        label.textColor = color
        return label
        
        
    }
    
    public func getIconWithLabelView(_ font: UIFont,
                                      color: UIColor,
                                      iconName: String,
                                      labelName: String,
                                      size: CGFloat, isImageLeftAligned: Bool = true) -> UIStackView {
        
        let iconView = getIconView(name: iconName, size: size, color: color)
        let label = getLabel(font, color: color, numberOfLines: 1)
        label.text = labelName
        
        let stackView = getStackView(axis: .horizontal, alignment: .center, distribution: .fill, spacing: 5)
        
        if isImageLeftAligned {
            
            stackView.addArrangedSubview(iconView)
            stackView.addArrangedSubview(label)
            
        } else {
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(iconView)
           
        }
        
        return stackView
        
    }
    
    public func getIconView(name: String,
                             size: CGFloat,
                             color: UIColor) -> UIView {
        
        let image = UIImage(named: name)!
        image.withTintColor(color)
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            imageView.heightAnchor.constraint(equalToConstant: size),
            imageView.widthAnchor.constraint(equalToConstant: size)
        
        ])
       
        return imageView
        
    }
    
}

extension UIView {
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
    
}

extension UIImage {
 
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}

class NetworkMonitor {
    static let shared = NetworkMonitor()

    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive

            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
            }
            print(path.isExpensive)
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
    
}

extension UIViewController {
    
    var window: UIWindow? {
        if #available(iOS 13, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return nil }
            return window
        }
        return nil
        
    }
    
}
