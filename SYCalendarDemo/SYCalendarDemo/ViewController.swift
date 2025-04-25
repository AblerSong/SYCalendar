//
//  ViewController.swift
//  SYCalendarDemo
//
//  Created by song on 2025/4/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weekLabel.text = weekDays[weekTag - 1]
        shiftWeekdays(by: weekTag - 1)
        setupDate()
        setupCalendarItem()
    }
    
    func setupDate() {
        let dateArr = dateFormatter.string(from: date).components(separatedBy: "-")
        yearLabel.text = dateArr[0]
        monthLabel.text = dateArr[1]
    }
    
    @IBAction func clickReduceYear(_ sender: Any) {
        date = calendar.date(byAdding: .year, value: -1, to: date)!
        setupDate()
        setupCalendarItem()
    }
    
    @IBAction func clickAddYear(_ sender: Any) {
        date = calendar.date(byAdding: .year, value: 1, to: date)!
        setupDate()
        setupCalendarItem()
    }
    
    @IBAction func clickReduceMonth(_ sender: Any) {
        date = calendar.date(byAdding: .month, value: -1, to: date)!
        setupDate()
        setupCalendarItem()
    }
    
    @IBAction func clickAddMonth(_ sender: Any) {
        date = calendar.date(byAdding: .month, value: 1, to: date)!
        setupDate()
        setupCalendarItem()
    }
    
    @IBAction func weekReduce(_ sender: Any) {
        if weekTag > 1 {
            weekTag -= 1
            weekLabel.text = weekDays[weekTag - 1]
            shiftWeekdays(by: weekTag - 1)
            setupCalendarItem()
        }
        
    }
    
    @IBAction func addWeek(_ sender: Any) {
        if weekTag < 7 {
            weekTag += 1
            weekLabel.text = weekDays[weekTag - 1]
            shiftWeekdays(by: weekTag - 1)
            setupCalendarItem()
        }
    }
    
    func setupCalendarItem() {
        items.forEach { item in
            item.removeFromSuperview()
        }
//        let tool = CalendarTool(start: "2025-04-01", startWeek: .sunday)
//        let arr = tool.getDaysInMonthArr()
        let tool = CalendarTool(start: "\(dateFormatter.string(from: date))-01", startWeek: Weekday(rawValue: weekTag)!)
        let arr = tool.getDaysInMonthArr()
        
        let viewCount = arr.count // 可以是28、35或42
        let viewWidth: CGFloat = 50
        let viewHeight: CGFloat = 60
        let spacing: CGFloat = 3
        
        for i in 0..<viewCount {
            let column = i % 7
            let row = i / 7
            let x = CGFloat(column) * (viewWidth + spacing)
            let y = CGFloat(row) * (viewHeight + spacing)
            
            let subView = items[i]
            subView.model = arr[i]
            subView.frame = CGRect(x: x, y: y, width: viewWidth, height: viewHeight)
            wrapView.addSubview(subView)
        }
        
        
    }
    
    func shiftWeekdays(by offset: Int) {
        let count = weekDays.count
        let adjustedOffset = offset % count
        let arr = Array(weekDays.dropFirst(adjustedOffset) + weekDays.prefix(adjustedOffset))
        
        for i in 0..<weekLabels.count {
            let str = arr[i]
            let label = weekLabels[i]
            label.text = String(str.prefix(3))
            weekView.addSubview(label)
        }
    }
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var weekLabel: UILabel!
    
    @IBOutlet weak var wrapView: UIView!
    
    @IBOutlet weak var weekView: UIView!
    let weekLabels = (0...6).map { i in
        let width = 50.0
        let margin = 3.0
        let label = UILabel(frame: CGRect(x: Double(i) * (width + margin), y: 0, width: width, height: 40))
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }
    
    let items = (0...41).map { i in
        return CalendarItem()
    }
    
    var date = Date()
    
    let calendar = Calendar(identifier:.iso8601)
    
    let weekDays = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
    var weekTag = Weekday.sunday.rawValue;
    
    lazy var dateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier:.iso8601)
        f.locale = Locale(identifier: "zh_CN")
        f.timeZone = TimeZone(identifier: "Asia/Shanghai")
        f.dateFormat = "yyyy-MM"
        return f
    }()
}

class CalendarItem: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
    }
    
    var model: CalendarModel! {
        didSet {
            refreshUI()
        }
    }
    
    func refreshUI() {
        titleLabel.text = "\(model.day)"
        subTitleLabel.text = "\(model.chineseDay)"
        if model.chineseDay == "初一" {
            subTitleLabel.text = "\(model.chineseMonth)"
        }
        if model.type == 0 {
            backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        } else {
            backgroundColor = .white
        }
    }
    
    lazy var titleLabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 10, width: 50, height: 18))
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    lazy var subTitleLabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 30, width: 50, height: 20))
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

