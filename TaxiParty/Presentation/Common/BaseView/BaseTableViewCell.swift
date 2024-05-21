//
//  BaseTableViewCell.swift
//  TaxiParty
//
//  Created by Greed on 4/29/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        setConstraints()
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }
    
    func configureView() { }
    
    func setConstraints() { }
    
    func convertToTextDateFormat(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: dateString)
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.dateFormat = "a h시 mm분"
        
        return outputFormatter.string(from: date ?? Date())
    }
    
}
