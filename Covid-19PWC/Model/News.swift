//
//  News.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 17/05/2021.
//

import Foundation

struct News: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Source: Codable {
    let id: String?
    let name: String?
}
// API KEY = 5a7083e0091a4ecd8f56525c564d0e0d
//https://newsapi.org/v2/top-headlines?country=us&apiKey=5a7083e0091a4ecd8f56525c564d0e0d
