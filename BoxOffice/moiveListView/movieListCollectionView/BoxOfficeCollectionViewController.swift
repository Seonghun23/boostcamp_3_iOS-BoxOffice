//
//  BoxOfficeCollectionViewController.swift
//  BoxOffice
//
//  Created by 공지원 on 10/12/2018.
//  Copyright © 2018 공지원. All rights reserved.
//

import UIKit

class BoxOfficeCollectionViewController: BoxOfficeViewController {
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.addSubview(refreshControl)
    }

    //MARK:- Method
    //데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let boxOfficeDetailViewController = segue.destination as? BoxOfficeDetailViewController else { return }

        guard let cell = sender as? BoxOfficeCollectionViewCell else { return }
        
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let selectedIndex = indexPath.row

        boxOfficeDetailViewController.movieId = movies[selectedIndex].id
        boxOfficeDetailViewController.navigationItem.title = movies[selectedIndex].title
    }
}

//MARK:- CollectionView Data Source, Delegate
extension BoxOfficeCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? BoxOfficeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie = movies[indexPath.item]
        
        if let reservationGrade = movie.reservationGrade, let date = movie.date, let userRating = movie.userRating, let reservationRate = movie.reservationRate {
        
        cell.movieTitle.text = movie.title
        cell.movieReservationGrade.text = String(reservationGrade) + "위"
        cell.movieReleaseDate.text = String(date)
        cell.movieUserRating.text = "(" + String(userRating) + ")"
        cell.movieReservationRate.text = String(reservationRate) + "%"
        }
        
        let gradeImageName: String
        
        switch movie.grade {
        case 0:
            gradeImageName = "ic_allages"
        case 12:
            gradeImageName = "ic_12"
        case 15:
            gradeImageName = "ic_15"
        case 19:
            gradeImageName = "ic_19"
        default:
            gradeImageName = "ic_allages"
        }
        
        cell.movieGrade.image = UIImage(named: gradeImageName)
        cell.movieThumb.image = UIImage(named: "img_placeholder")
        
        DispatchQueue.global().async {
            guard let thumb = movie.thumb else { return }
            guard let thumbImageURL = URL(string: thumb) else {
                return
            }
            
            guard let thumbImageData = try? Data(contentsOf: thumbImageURL) else {
                return
            }
            
            DispatchQueue.main.async {
                if let index = collectionView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.movieThumb.image = UIImage(data: thumbImageData)
                    }
                }
            }
        }
        return cell
    }
}

