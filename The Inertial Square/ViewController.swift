//
//  ViewController.swift
//  The Inertial Square
//
//  Created by aeroclub on 18.11.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var squareView: UIView = {
        let view = UIView()
        
        view.frame = CGRect(x: 100, y: 0, width: 150, height: 150)
        view.layer.cornerRadius = 8
        view.backgroundColor = .blue
        
        return view
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        var tap = UITapGestureRecognizer()
        
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(handleTap(_:)))
        
        return tap
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        view.addSubview(squareView)
        view.addGestureRecognizer(tapGesture)
        
        squareView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            squareView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            squareView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            squareView.widthAnchor.constraint(equalToConstant: 100),
            squareView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
           let location = sender.location(in: view)
           let screenWidth = view.bounds.width
           let screenHeight = view.bounds.height
           let halfWidth = squareView.bounds.width / 2
           let halfHeight = squareView.bounds.height / 2

           var targetPoint = location
           if targetPoint.x < halfWidth {
               targetPoint.x = halfWidth
           } else if targetPoint.x > screenWidth - halfWidth {
               targetPoint.x = screenWidth - halfWidth
           }

           if targetPoint.y < halfHeight {
               targetPoint.y = halfHeight
           } else if targetPoint.y > screenHeight - halfHeight {
               targetPoint.y = screenHeight - halfHeight
           }

           let center = squareView.center
           let distance = sqrt(pow(targetPoint.x - center.x, 2) + pow(targetPoint.y - center.y, 2))
           let initialVelocity: CGFloat = min(distance / 30.0, 6.0)

           let rotationAngle: CGFloat = location.x < screenWidth / 2 ? -(.pi / 18) : (.pi / 18)

           squareView.bounce(to: targetPoint, duration: 0.8, damping: 0.5, initialVelocity: initialVelocity, rotationAngle: rotationAngle)
    }
}

extension UIView {
    func bounce(to targetPoint: CGPoint, duration: TimeInterval = 0.6, damping: CGFloat = 0.5, initialVelocity: CGFloat = 0.5, rotationAngle: CGFloat) {
        self.transform = .identity

        let rotateTransform = CGAffineTransform(rotationAngle: rotationAngle)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: initialVelocity,
                       options: [],
                       animations: {
            self.center = targetPoint
            self.transform = rotateTransform
        }, completion: { _ in
            
            UIView.animate(withDuration: 0.4, animations: {
                self.transform = .identity
            })
        })
    }
}

