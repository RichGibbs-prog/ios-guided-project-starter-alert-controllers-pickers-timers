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
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    lazy private var countdownPickerData: [[String]] = {
        // Create string arrays using numbers wrapped in string values: ["0", "1", ... "60"]
        let minutes: [String] = Array(0...60).map { String($0) }
        let seconds: [String] = Array(0...59).map { String($0) }
        
        // "min" and "sec" are the unit labels
        let data: [[String]] = [minutes, ["min"], seconds, ["sec"]]
        return data
    }()
    
    var duration: TimeInterval {
        
        // Get the amount of time from the picker view's selected rows
        let minutes = countdownPicker.selectedRow(inComponent: 0)
        let seconds = countdownPicker.selectedRow(inComponent: 2)
        
        let totalSeconds = minutes * 60 + seconds
        
        return TimeInterval(totalSeconds)
    }
    
    let countdown = Countdown()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        countdown.delegate = self
        
        countdownPicker.delegate = self
        countdownPicker.dataSource = self
        
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeLabel.font.pointSize,
        weight: .medium)
        
        countdownPicker.selectRow(1, inComponent: 0, animated: false)
        countdownPicker.selectRow(30, inComponent: 2, animated: false)
        
        countdown.duration = duration
    }
    
    // MARK: - Actions
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        countdown.start()
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        countdown.reset()
        updateViews()
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
        switch countdown.state {
        case .started:
            let timeRemainingString = string(from: countdown.timeRemaining)
            timeLabel.text = timeRemainingString
            startButton.isEnabled = false
            
        case .finished:
            timeLabel.text = string(from: 0)
            startButton.isEnabled = true
            
        case .reset:
            timeLabel.text = string(from: duration)
            startButton.isEnabled = true
        }
        
    }
    
    private func string(from duration: TimeInterval) -> String {
        let date = Date(timeIntervalSinceReferenceDate: duration)
        
        // 00:00:01:30
        let formattedString = dateFormatter.string(from: date)
        
        return  formattedString
    }
}

extension CountdownViewController: CountdownDelegate {
    func countdownDidUpdate(timeRemaining: TimeInterval) {
        updateViews()
    }
    
    func countdownDidFinish() {
        showAlert()
        updateViews()
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // Set the countdown's duration to the duration shown in the picker view
        countdown.duration = duration
        updateViews()
    }
}
