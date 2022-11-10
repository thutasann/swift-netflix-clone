//
//  ApiCaller.swift
//  Netflix Clone
//
//  Created by Thuta sann on 11/10/22.
//

import Foundation

struct Constants{
    static let API_KEY = "79f686b687070ac3654047c19dcb0875"
    static let baseUrl = "https://api.themoviedb.org"
}

enum APIError: Error {
    case failedTogetData
}


class APICaller{
    static let shared = APICaller()
    
    // Get Trending Movies
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/all/day?api_key=\(Constants.API_KEY)") else {return}
        
        // task in pause status
        let task = URLSession.shared.dataTask(with: URLRequest(url:url)) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            do{
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(error))
            }
        }
        
        // resume the task
        task.resume()
    }
}
