//
//  SportRadarTests.swift
//  SportRadarTests
//
//  Created by Oriol Sanz Vericat on 3/11/24.
//

import XCTest
@testable import SportRadar

final class VolumeControlViewTests: XCTestCase {

    func testBarInitialization() {
        let view = VolumeControlView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), numberOfBars: 5, barColor: .red)
        XCTAssertEqual(view.bars.count, 5)
        for bar in view.bars {
            XCTAssertTrue(bar.backgroundColor == .red)
        }
    }

    func testVolumeUpdate() {
        let view = VolumeControlView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), numberOfBars: 5, barColor: .red)
        view.updateBars(volume: 0.5)

        // Assuming a simple implementation where the first half of the bars should be filled
        XCTAssertEqual(view.bars[0].isHidden, false)
        XCTAssertEqual(view.bars[1].isHidden, false)
        XCTAssertEqual(view.bars[2].isHidden, true)
        XCTAssertEqual(view.bars[3].isHidden, true)
        XCTAssertEqual(view.bars[4].isHidden, true)
    }

    func testVolumeChangedCallback() {
        let expectation = expectation(description: "Volume changed")
        let view = VolumeControlView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), numberOfBars: 5, barColor: .red)
        view.volumeChanged = { newVolume in
            XCTAssertEqual(newVolume, 0.75)
            expectation.fulfill()
        }
        view.updateBars(volume: 0.75)
        waitForExpectations(timeout: 1)
    }
    
    func testSetVolume() {
        let view = VolumeControlView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), numberOfBars: 5, barColor: .red)
        view.setVolume(volume: 75)
        
        // Assuming a simple implementation where the first three bars should be filled
        XCTAssertEqual(view.bars[0].isHidden, false)
        XCTAssertEqual(view.bars[1].isHidden, false)
        XCTAssertEqual(view.bars[2].isHidden, false)
        XCTAssertEqual(view.bars[3].isHidden, true)
        XCTAssertEqual(view.bars[4].isHidden, true)
    }
    
    func testSetBarColor() {
        let view = VolumeControlView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), numberOfBars: 5, barColor: .red)
        view.setBarColor(.blue)
        
        for bar in view.bars {
            XCTAssertEqual(bar.backgroundColor, .blue)
        }
    }
    
    func testSetNumberOfBars() {
        let view = VolumeControlView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), numberOfBars: 5, barColor: .red)
        view.setNumberOfBars(3)
        
        XCTAssertEqual(view.bars.count, 3)
    }
}
