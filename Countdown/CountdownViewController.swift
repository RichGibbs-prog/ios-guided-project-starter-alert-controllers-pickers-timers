//
//  CountdownViewController.swift
//  Countdown
//
//  Created by Paul Solt on 5/8/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit

class CountdownViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var countdownPicker: UIPickerView!
    
    // MARK: - Properties
    
    lazy private var countdownPickerData: [[String]] = {
        // Create string arrays using numbers wrapped in string values: ["0", "1", ... "60"]
        let minutes: [String] = Array(0...60).map { String($0) }
        let seconds: [String] = Array(0...59).map { String($0) }
        
        // "min" and "sec" are the unit labels
        let data: [[String]] = [minutes, ["min"], seconds, ["sec"]]
        return data
    }()
    
    let countdown = Countdown()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        countdown.delegate = self
        
        countdownPicker.delegate = self
        countdownPicker.dataSource = self
    }
    
    // MARK: - Actions
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        countdown.start()
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        countdown.reset()
    }
    
    // MARK: - Private
    
    private func showAlert() {
        let alert = UIAlertController(title: "Timer Finished!",
                                      message: "Your countdown has ended",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func updateViews() {
        
    }
    
    private func string(from duration: TimeInterval) -> String {
        #warning("return a string value derived from the time interval passed in")
        return ""
    }
}

extension CountdownViewController: CountdownDelegate {
    func countdownDidUpdate(timeRemaining: TimeInterval) {
        
    }
    
    func countdownDidFinish() {
        showAlert()
    }
}

extension CountdownViewController: UIPickerViewDataSource {
    
    // similar to numberOfSections in the tableView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return countdownPickerData.count
    }
    
    // similar to numberOfRows in section
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countdownPickerData[component].count
    }
}

extension CountdownViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        // Get the "section" of the cell
        let componentData = countdownPickerData[component]
        
        // Get the "row" of the cell
        let title = componentData[row] // "0" or "min"
         
        return title
    }
}
