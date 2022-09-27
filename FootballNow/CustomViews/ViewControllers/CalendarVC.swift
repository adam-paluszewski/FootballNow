//
//  CalendarVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 26/09/2022.
//

import UIKit
import FSCalendar

class CalendarVC: UIViewController {
    
    var calendar: FSCalendar!
    let button = FNButton()
    
    var pickedDates: [Date] = []
    var pickedDatesAsString: [String] = []
    
    var vcDismissed: (([String]) -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()

        let calendar = FSCalendar(frame: CGRect(x: 0, y: 100, width: 320, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        self.calendar = calendar
        calendar.backgroundColor = .secondarySystemBackground
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.scrollDirection = .vertical
        calendar.allowsMultipleSelection = true
        calendar.firstWeekday = 2
        calendar.appearance.headerDateFormat = "MMM yyyy"
        calendar.appearance.headerTitleColor = .label
        calendar.appearance.titleDefaultColor = .label
        calendar.appearance.weekdayTextColor = .label
        calendar.appearance.titlePlaceholderColor = .secondaryLabel
        calendar.appearance.selectionColor = UIColor(named: "FNNavigationTint")
        calendar.clipsToBounds = true
        
        button.addTarget(self, action: #selector(changeDateButtonPressed), for: .touchUpInside)
        
        button.configuration?.baseBackgroundColor = .systemGreen
        button.configuration?.title = "Wybierz"
        
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(calendar)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendar.heightAnchor.constraint(equalToConstant: 300),
            
            button.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 10),
            button.leadingAnchor.constraint(equalTo: calendar.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: calendar.trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        calendar.translatesAutoresizingMaskIntoConstraints = false
        
        preferredContentSize = CGSize(width: 320, height: 360)
        
    }
    
    
    @objc func changeDateButtonPressed() {
        pickedDates.sort(by: <)
        for date in pickedDates {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            
            let dateString = dateFormatter.string(from: date)
            pickedDatesAsString.append(dateString)
        }
        dismiss(animated: true) {
            self.vcDismissed(self.pickedDatesAsString)
        }
    }
}




extension CalendarVC: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let newDate = date.addingTimeInterval(7200)
        pickedDates.append(newDate)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let newDate = date.addingTimeInterval(7200)
        pickedDates.removeAll {$0 == newDate}
    }
    
}
