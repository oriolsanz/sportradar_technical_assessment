//
//  VolumeControlView.swift
//  SportRadar
//
//  Created by Oriol Sanz Vericat on 3/11/24.
//

import UIKit

class VolumeControlView: UIView {

    // Customizable properties
    var numberOfBars: Int = 10
    var barColor: UIColor = .blue
    var initialVolume: CGFloat = 0.5
    var barSpacing: CGFloat = 2.0
    
    var clampedVolume: CGFloat = 0.5

    // Callback for volume changes
    var volumeChanged: ((CGFloat) -> Void)?

    var bars: [UIView] = []

    init(frame: CGRect, numberOfBars: Int, barColor: UIColor) {
        self.numberOfBars = numberOfBars
        self.barColor = barColor
        super.init(frame: frame)
        setupBars(initialVolume)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupBars(_ volume: CGFloat) {
        for _ in 0..<numberOfBars {
            let bar = UIView()
            bar.backgroundColor = barColor
            addSubview(bar)
            bars.append(bar)
        }
        updateBars(volume: volume)
    }
    
    func updateBars(volume: CGFloat) {
        clampedVolume = max(0, min(1, volume))
        
        // Calculate the height of each individual bar based on the number of bars
        let totalHeight = frame.height
        let barHeight = (totalHeight / CGFloat(numberOfBars)) - barSpacing
        
        // Calculate the number of bars that should be "filled"
        let filledBarsCount = Int(clampedVolume * CGFloat(numberOfBars))
        
        // Iterate over the bars and set their frames
        for (index, bar) in bars.enumerated() {
            if index < filledBarsCount {
                // Filled bars
                let barOriginY = totalHeight - (barHeight + barSpacing) * CGFloat(index + 1)
                bar.frame = CGRect(x: 0, y: barOriginY, width: frame.width, height: barHeight)
                bar.isHidden = false
            } else {
                // Hide or set frames of unfilled bars to avoid overflow
                bar.isHidden = true
            }
        }
        
        // Call the volume changed callback with the clamped volume
        volumeChanged?(clampedVolume)
    }


    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let newVolume = 1 - (location.y / frame.height)
        updateBars(volume: newVolume)
    }
    
    // MARK: - Edit Methods
    func setBarColor(_ color: UIColor) {
        self.barColor = color
        for bar in bars {
            bar.backgroundColor = color
        }
    }
    
    func setNumberOfBars(_ count: Int) {
        self.numberOfBars = count
        
        for bar in bars {
            bar.removeFromSuperview()
        }
        bars.removeAll()
        
        setupBars(clampedVolume)
    }
    
    public func setVolume(volume: CGFloat) {
        updateBars(volume: volume/100)
    }
}
