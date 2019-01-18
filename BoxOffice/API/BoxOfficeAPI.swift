//
//  BoxOfficeAPI.swift
//  BoxOffice
//
//  Created by 공지원 on 13/12/2018.
//  Copyright © 2018 공지원. All rights reserved.
//

import Foundation

class BoxOfficeAPI {
    static var orderType = "0"
    let baseURL = "http://connect-boxoffice.run.goorm.io/"
    let moviesURL = "movies?order_type="
    let movieURL = "movie?id="
    let commentURL = "comments?movie_id="
    
    final func requestMovie(orderType: String, completion: @escaping ([Movie]?, Bool) -> Void) {
        guard let url = URL(string: baseURL + moviesURL + orderType) else { return }
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("error in dataTask: \(error.localizedDescription)")
                completion(nil, false)
                return
            }
            
            guard let data = data else {
                print("data unwrapping error")
                completion(nil, false)
                return
            }
            
            do {
                let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(apiResponse.movies, true)
                
            } catch let error {
                print(error.localizedDescription)
                completion(nil, false)
            }
        }
        dataTask.resume()
    }
    
    //영화 상세정보 서버에 요청
    final func requestMovieDetail(id: String, completion: @escaping (MovieDetail?, Bool) -> Void) {
        guard let url = URL(string: baseURL + movieURL + id) else { return }
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("error in dataTask: \(error.localizedDescription)")
                completion(nil, false)
                return
            }
            
            guard let data = data else {
                print("data unwrapping error")
                completion(nil, false)
                return
            }
            
            do {
                let movieDetailApiResponse: MovieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                completion(movieDetailApiResponse, true)
        
            } catch let error {
                print(error.localizedDescription)
                completion(nil, false)
            }
        }
        dataTask.resume()
    }
    
    final func requestComments(id: String, completion: @escaping ([Comment]?, Bool) -> Void) {
        guard let url = URL(string: baseURL + commentURL + id) else { return }
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("error in dataTask: \(error.localizedDescription)")
                completion(nil, false)
                return
            }
            
            guard let data = data else {
                print("data unwrapping error")
                completion(nil, false)
                return
            }
            
            do {
                let commentsApiResponse: CommentApiResponse = try JSONDecoder().decode(CommentApiResponse.self, from: data)
                completion(commentsApiResponse.comments, true)
                
            } catch let error {
                print(error.localizedDescription)
                completion(nil, false)
            }
        }
        dataTask.resume()
    }
}
