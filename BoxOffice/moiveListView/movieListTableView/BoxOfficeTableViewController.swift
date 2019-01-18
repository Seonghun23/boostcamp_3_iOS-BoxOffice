//
//  BoxOfficeTableViewController.swift
//  BoxOffice
//
//  Created by 공지원 on 10/12/2018.
//  Copyright © 2018 공지원. All rights reserved.
//

import UIKit

class BoxOfficeTableViewController: BoxOfficeViewController {
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.addSubview(refreshControl)
    }

    //MARK:- Method
    //데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let boxOfficeDetailViewController = segue.destination as? BoxOfficeDetailViewController else {
            return
        }

        guard let selectedRowIndex = tableView.indexPathForSelectedRow?.row else { return }
        
        boxOfficeDetailViewController.movieId = movies[selectedRowIndex].id
        boxOfficeDetailViewController.navigationItem.title = movies[selectedRowIndex].title
    }
}

//MARK:- TableView Data Source, Delegate
extension BoxOfficeTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BoxOfficeTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = movies[indexPath.row]
        
        if let reservationGrade = movie.reservationGrade, let date = movie.date, let userRating = movie.userRating, let reservationRate = movie.reservationRate {
        
        cell.movieTitle.text = movie.title
        cell.movieReservationGrade.text = String(reservationGrade)
        cell.movieReleaseDate.text = String(date)
        cell.movieUserRating.text = String(userRating)
        cell.movieReservationRate.text = String(reservationRate)
        
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
                if let index = tableView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.movieThumb.image = UIImage(data: thumbImageData)
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.isSelected = false
    }
}
