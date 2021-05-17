//
//  TrackingCases.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 17/05/2021.
//

import Foundation

struct CovidCases: Codable {
    var dates: Dates
    var total: CasesCount
}

struct Countries: Codable {
    var countries: CountriesData
}

struct CasesCount: Codable {
    let today_confirmed: Double
    let today_deaths: Double
    let today_new_confirmed: Double
    let today_new_deaths: Double
    let today_new_open_cases: Double
    let today_new_recovered: Double
    let today_open_cases: Double
    let today_recovered: Double
    let today_vs_yesterday_confirmed: Double
    let today_vs_yesterday_deaths: Double
    let today_vs_yesterday_open_cases: Double
    let today_vs_yesterday_recovered: Double
    let yesterday_confirmed: Double
    let yesterday_deaths: Double
    let yesterday_open_cases: Double
    let yesterday_recovered: Double
}

typealias Dates = [String: Countries]
typealias CountriesData = [String: CasesCount]

//for country and date range
//https://api.covid19tracking.narrativa.com/api/country/\(spain)?date_from=\(2020-03-20)&date_to=\(2020-03-22)
//without range
//https://api.covid19tracking.narrativa.com/api/2020-03-22/country/spain
//
