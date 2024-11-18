//
//  ViewController.swift
//  The Inertial Square
//
//  Created by aeroclub on 18.11.2024.
//

import UIKit


//class ViewController: UIViewController {
//    var squareView: UIView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupSquare()
//        setupTapGesture()
//    }
//    
//    func setupSquare() {
//        squareView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
//        squareView.backgroundColor = UIColor.blue
//        view.addSubview(squareView)
//    }
//    
//    func setupTapGesture() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        view.addGestureRecognizer(tapGesture)
//    }
//    
//    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        let touchPoint = sender.location(in: view)
//        moveSquare(to: touchPoint)
//    }
//    
//    func moveSquare(to point: CGPoint) {
//        let distance = hypot(point.x - squareView.center.x, point.y - squareView.center.y)
//        let animationDuration = distance / 500 // Скорость движения
//
//        // Определение угла поворота в зависимости от места касания
//        let screenWidth = view.bounds.width
//        var rotationAngle: CGFloat
//
//        if point.x < screenWidth / 2 {
//            rotationAngle = -(.pi / 18) // Наклон влево
//        } else {
//            rotationAngle = .pi / 18 // Наклон вправо
//        }
//
//        // Установка начального угла поворота
//        squareView.transform = CGAffineTransform(rotationAngle: rotationAngle)
//
//        // Первый этап: перемещение к новой позиции
//        UIView.animate(withDuration: animationDuration, animations: {
//            self.squareView.center = point
//            self.squareView.transform = CGAffineTransform(rotationAngle: rotationAngle).scaledBy(x: 1.1, y: 1.1) // Увеличение во время движения
//        }) { _ in
//            // Этап отскока: легкий отскок вверх-вниз
//            let originalCenter = self.squareView.center
////            UIView.animate(withDuration: 0.15, animations: {
////                self.squareView.center = CGPoint(x: originalCenter.x, y: originalCenter.y - 10) // Отскок вверх
////            }) { _ in
//                UIView.animate(withDuration: 0.15, animations: {
//                    self.squareView.center = originalCenter // Возвращение вниз
//            }) { _ in
//                    UIView.animate(withDuration: 0.15) {
//                        self.squareView.transform = .identity // Возврат к обычному состоянию
////            }
//            }
//            }
//        }
//    }
//}

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
            let rotationAngle: CGFloat
            
            // Определяем, на какую сторону произошло нажатие
            if location.x < screenWidth / 2 {
                rotationAngle = -(.pi / 18) // Наклон влево
            } else {
                rotationAngle = .pi / 18 // Наклон вправо
            }
            
            // Использование метода bounce с вращением
        squareView.bounce(to: location, duration: 1.0, damping: 0.7, initialVelocity: 2.0, rotationAngle: rotationAngle)
        }
}

extension UIView {
    func bounce(to targetPoint: CGPoint, duration: TimeInterval = 0.6, damping: CGFloat = 0.5, initialVelocity: CGFloat = 0.5, rotationAngle: CGFloat) {
        // Сброс трансформации перед началом анимации
        self.transform = .identity
        
        // Создаем преобразование поворота
        let rotateTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        // Запустить анимацию
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: initialVelocity,
                       options: [],
                       animations: {
            self.center = targetPoint // Переместить view в целевую точку
            self.transform = rotateTransform // Применить поворот
        }, completion: { _ in
            // Восстановить оригинальный угол после завершения анимации
            UIView.animate(withDuration: 0.6) {
                self.transform = .identity // Восстановить состояние
            }
        })
    }
}

//class ViewController: UIViewController {
//
//    private lazy var squareView: UIView = {
//        let view = UIView()
//        
//        view.frame = CGRect(x: 100, y: 0, width: 150, height: 150)
//        view.layer.cornerRadius = 8
//        view.backgroundColor = .blue
//        
//        return view
//    }()
//    
//    private lazy var tapGesture: UITapGestureRecognizer = {
//        var tap = UITapGestureRecognizer()
//        
//        tap.addTarget(self, action: #selector(handleTap(_:)))
//        
//        return tap
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setup()
//    }
//    
//    private func setup() {
//        view.addSubview(squareView)
//        view.addGestureRecognizer(tapGesture)
//        
//        squareView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            squareView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            squareView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            squareView.widthAnchor.constraint(equalToConstant: 100),
//            squareView.heightAnchor.constraint(equalToConstant: 100),
//        ])
//    }
//    
//    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//            let location = sender.location(in: view)
//            let screenWidth = view.bounds.width
//            let rotationAngle: CGFloat
//            
//            // Определяем, на какую сторону произошло нажатие
//            if location.x < screenWidth / 2 {
//                rotationAngle = -(.pi / 18) // Наклон влево
//            } else {
//                rotationAngle = .pi / 18 // Наклон вправо
//            }
//            
//            // Использование метода bounce с вращением
//            squareView.bounce(to: location, duration: 0.3, damping: 0.7, initialVelocity: 0.2, rotationAngle: rotationAngle)
//        }
//}
//
//extension UIView {
//    func bounce(to targetPoint: CGPoint, duration: TimeInterval = 0.6, damping: CGFloat = 0.5, initialVelocity: CGFloat = 0.5, rotationAngle: CGFloat) {
//        // Сброс трансформации перед началом анимации
//        self.transform = .identity
//        
//        // Создаем преобразование поворота
//        let rotateTransform = CGAffineTransform(rotationAngle: rotationAngle)
//        
//        // Запустить анимацию
//        UIView.animate(withDuration: duration,
//                       delay: 0,
//                       usingSpringWithDamping: damping,
//                       initialSpringVelocity: initialVelocity,
//                       options: [],
//                       animations: {
//            self.center = targetPoint // Переместить view в целевую точку
//            self.transform = rotateTransform // Применить поворот
//        }, completion: { _ in
//            // Восстановить оригинальный угол после завершения анимации
//            UIView.animate(withDuration: 0.6) {
//                self.transform = .identity // Восстановить состояние
//            }
//        })
//    }
//}
