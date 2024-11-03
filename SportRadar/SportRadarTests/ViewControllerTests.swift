//
//  ViewControllerTests.swift
//  SportRadarTests
//
//  Created by Oriol Sanz Vericat on 3/11/24.
//

import XCTest

final class ViewControllerTests: XCTestCase {
    
    func testSetupVolumeControl() {
        let mockVolumeControl = VolumeControlView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), numberOfBars: 5, barColor: .red)
        let vc = ViewController()
        vc.volumeControl = mockVolumeControl
        vc.numberOfBars = 10
        vc.actualColor = .red
        
        XCTAssertEqual(mockVolumeControl.numberOfBars, 5)
        XCTAssertEqual(mockVolumeControl.barColor, .red)
        XCTAssertEqual(mockVolumeControl.initialVolume, 0.5)
    }
    
    func testSetLinesButtonTapped() {
        let mockVolumeControl = VolumeControlView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), numberOfBars: 5, barColor: .red)
        let vc = ViewController()
        vc.volumeControl = mockVolumeControl
        vc.numberOfBars = 25
        
        vc.setLinesButtonTapped(self)
        
        XCTAssertEqual(mockVolumeControl.numberOfBars, vc.numberOfBars)
    }
}
