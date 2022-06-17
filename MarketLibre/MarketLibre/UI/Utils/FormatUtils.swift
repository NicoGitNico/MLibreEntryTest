//
//  FormatUtils.swift
//  MarketLibre
//
//  Created by Nicolas Di Santi on 11/6/22.
//

import Foundation


fileprivate let formatter = NumberFormatter()

func formatPrice(value:Double) -> String {
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = "."
    formatter.decimalSeparator = ","
    formatter.maximumFractionDigits = 0
    return formatter.string(from: NSNumber(value: value))!
}
