//
//  Cafe.swift
//  AAonecup
//
//  Created by dohankim on 2022/09/21.
//

import Foundation

// MARK: - Cafe
struct Cafe: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let link: String
    let category, itemDescription, telephone, address: String
    let roadAddress, mapx, mapy: String

    enum CodingKeys: String, CodingKey {
        case title, link, category
        case itemDescription = "description"
        case telephone, address, roadAddress, mapx, mapy
    }
}
