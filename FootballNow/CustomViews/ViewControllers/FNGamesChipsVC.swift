//
//  FNGamesChipsVC.swift
//  FootballNow
//
//  Created by Adam Paluszewski on 27/09/2022.
//

import UIKit

protocol DatesPassedDelegate {
    func datesPassed(startDate: String, endDate: String)
}


class FNGamesChipsVC: UIViewController {
    
    var delegate: DatesPassedDelegate?
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    var chipRelativeDatesStrings: [String] = []
    var chipDatesStrings: [String] = []
    
    var startDate = FNDateFormatting.getDateYYYYMMDD(for: .current)
    var endDate = FNDateFormatting.getDateYYYYMMDD(for: .oneWeekAhead)
    
    var passedDates: ((String, String) -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        configureViewController()
        configureCollectionView()
    }
    
    
    func configureViewController() {
        getDateStringsForChips()
        
        layoutUI()
    }
    

    func configureCollectionView() {
        collectionView.register(FNChipCell.self, forCellWithReuseIdentifier: FNChipCell.cellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createFlowLayout()
        collectionView.showsHorizontalScrollIndicator = false
        
    }
    
    
    func getDateStringsForChips() {
        let date = Date()
        let yesterday = date.addingTimeInterval(-86400)
        let today = date
        let tomorrow = date.addingTimeInterval(86400)
        let dayAfterTomorrow = date.addingTimeInterval(86400*2)
        
        
        
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.dateFormat = "yyyy-MM-dd"
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.doesRelativeDateFormatting = true
        
        let relativeYesterdayString = relativeDateFormatter.string(from: yesterday)
        let relativeTodayString = relativeDateFormatter.string(from: today)
        let relativeTomorrowString = relativeDateFormatter.string(from: tomorrow)
        let relativedayAfterTomorrowString = relativeDateFormatter.string(from: dayAfterTomorrow)
        chipRelativeDatesStrings = [relativeYesterdayString, relativeTodayString, relativeTomorrowString, relativedayAfterTomorrowString]
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let yesterdayString = dateFormatter.string(from: yesterday)
        let todayString = dateFormatter.string(from: today)
        let tomorrowString = dateFormatter.string(from: tomorrow)
        let dayAfterTomorrowString = dateFormatter.string(from: dayAfterTomorrow)
        chipDatesStrings = [yesterdayString, todayString, tomorrowString, dayAfterTomorrowString]
    }
    
    
    func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
//        layout.itemSize = CGSize(width: 80, height: 40)
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
        layout.scrollDirection = .horizontal
        
        return layout
    }
    
    
    func layoutUI() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}


extension FNGamesChipsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FNChipCell.cellId, for: indexPath) as! FNChipCell
        
        switch indexPath.item {
            case 0...3:
                cell.set(text: chipRelativeDatesStrings[indexPath.item], image: nil)
            case 4:
                cell.set(text: "Kalendarz", image: UIImage(systemName: "calendar"))
            default:
                print()
        }
        if indexPath.row == 1 {
            cell.selected()
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! FNChipCell
        selectedCell.selected()
        
        switch indexPath.item {
            case 0...3:
                startDate = chipDatesStrings[indexPath.item]
                endDate = chipDatesStrings[indexPath.item]
                delegate?.datesPassed(startDate: self.startDate, endDate: self.endDate)
            case 4:
                let calendarVC = CalendarVC()
                calendarVC.modalPresentationStyle = .popover
                calendarVC.popoverPresentationController?.permittedArrowDirections = .up
                calendarVC.popoverPresentationController?.delegate = self
                calendarVC.popoverPresentationController?.sourceView = selectedCell
                calendarVC.popoverPresentationController?.sourceRect = CGRect(x: 65, y: 30, width: 0, height: 0)
                calendarVC.vcDismissed = { [weak self] array in
                    guard let self = self else { return }
                    self.startDate = array.first!
                    self.endDate = array.last!
                    self.delegate?.datesPassed(startDate: self.startDate, endDate: self.endDate)
                }
                present(calendarVC, animated: true, completion: nil)
            default:
                print("button clicked")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let deselectedCell = collectionView.cellForItem(at: indexPath) as! FNChipCell
        deselectedCell.deselected()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.item {
            case 0...3:
                return CGSize(width: 80, height: 40)
            case 4:
                return CGSize(width: 120, height: 40)
            default:
                return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: IndexPath(item: 1, section: 0), animated: true, scrollPosition: [])
    }
}


extension FNGamesChipsVC: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

