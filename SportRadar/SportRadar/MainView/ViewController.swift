//
//  ViewController.swift
//  SportRadar
//
//  Created by Oriol Sanz Vericat on 3/11/24.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var volumeViewContainer: UIView!
    @IBOutlet weak var volumeIndicator: UILabel!
    @IBOutlet weak var volumeTextField: UITextField!
    @IBOutlet weak var linesTextField: UITextField!
    @IBOutlet weak var changeColorButton: UIButton!
    
    var numberOfBars = 20
    var volume = 0.7
    var actualColor: UIColor = .blue
    let colors: [UIColor] = [.black, .gray, .red, .green, .blue, .yellow, .orange, .purple, .brown]
    
    private lazy var menu = UIMenu(title: "Available colors:", children: menuElements)
    private var menuElements: [UIAction] = []
    
    var volumeControl: VolumeControlView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScrollView()
        configureLabels()
        setupVolumeControl()
        configureMenuButton()
    }
    
    deinit {
        // Remove observers when view controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureScrollView() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureLabels() {
               
        volumeTextField.keyboardType = .numberPad
        volumeTextField.delegate = self
        volumeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        volumeTextField.text = "\(Int(volume))"
        
        linesTextField.keyboardType = .numberPad
        linesTextField.delegate = self
        linesTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        linesTextField.text = "\(numberOfBars)"
    }
    
    private func setupVolumeControl() {
        volumeControl = VolumeControlView(frame: CGRect(x: 0, y: 0, width: volumeViewContainer.frame.size.width, height: volumeViewContainer.frame.size.height),
                                              numberOfBars: numberOfBars,
                                              barColor: actualColor)
        volumeControl.volumeChanged = { newVolume in
            self.volumeIndicator.text = "Volume set at: \(Int(newVolume*100))%"
        }
        volumeViewContainer.addSubview(volumeControl)
        volumeControl.setupBars(volume)
    }
    
    private func configureMenuButton() {
        
        for color in colors {
            menuElements.append(UIAction(title: color.name ?? "") { action in
                self.volumeControl.setBarColor(color)
            })
        }
        
        changeColorButton.menu = menu
    }

    @IBAction func setVolumeButtonTapped(_ sender: Any) {
        if volume == 0 {
            volumeTextField.text = "\(Int(volume))"
        }
        volumeControl.setVolume(volume: volume)
    }
    
    @IBAction func setLinesButtonTapped(_ sender: Any) {
        if numberOfBars <= 10 {
            numberOfBars = 10
            linesTextField.text = "\(numberOfBars)"
        }
        volumeControl.setNumberOfBars(numberOfBars)
    }
}

extension ViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text,
        let number = NumberFormatter().number(from: text) {
            if textField == volumeTextField {
                if Int(truncating: number) > 100 {
                    volume = 100
                } else {
                    volume = Double(truncating: number)
                }
                textField.text = "\(Int(volume))"
            }
            if textField == linesTextField {
                if Int(truncating: number) > 300 {
                    numberOfBars = 300
                } else {
                    numberOfBars = Int(truncating: number)
                }
                textField.text = "\(numberOfBars)"
            }
        } else {
            if textField == volumeTextField {
                volume = 0
            }
            if textField == linesTextField {
                numberOfBars = 10
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Scroll to the active text field
        scrollView.scrollRectToVisible(textField.frame, animated: true)
        return true
    }
}

// MARK: -- Keyboard and ScrollView
extension ViewController {
    // Adjust scroll view insets when keyboard appears
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        // Adjust content inset for scroll view
        scrollView.contentInset.bottom = keyboardFrame.height
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height
    }

    // Reset scroll view insets when keyboard hides
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
}

extension UIColor {
    var name: String? {
        switch self {
        case UIColor.black: return "black"
        case UIColor.gray: return "gray"
        case UIColor.red: return "red"
        case UIColor.green: return "green"
        case UIColor.blue: return "blue"
        case UIColor.yellow: return "yellow"
        case UIColor.orange: return "orange"
        case UIColor.purple: return "purple"
        case UIColor.brown: return "brown"
        default: return nil
        }
    }
}
