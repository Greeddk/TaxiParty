//
//  UIView+Extension.swift
//  TaxiParty
//
//  Created by Greed on 4/15/24.
//

import UIKit

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
    
    func addSubViews(views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    func calculateLeftTime(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let convertDate = dateFormatter.date(from: dateString)
        
        let targetFormatter = DateFormatter()
        targetFormatter.dateFormat = "yyyy/MM/dd ahh:mm"
        targetFormatter.locale = Locale(identifier: "ko_KR")
        
        return targetFormatter.string(from: convertDate ?? Date())
    }
}
