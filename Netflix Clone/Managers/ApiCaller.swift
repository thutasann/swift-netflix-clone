//
//  ApiCaller.swift
//  Netflix Clone
//
//  Created by Thuta sann on 11/10/22.
//

import Foundation

struct Constants{
    static let API_KEY = "79f686b687070ac3654047c19dcb0875"
    static let URL = "https://api.themoviedb.org/3/trending/all/day?api_key="
}

class APICaller{
    static let shared = APICaller()
}
