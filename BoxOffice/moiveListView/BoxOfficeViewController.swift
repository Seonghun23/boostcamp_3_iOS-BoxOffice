//
//  BoxOfficeViewController.swift
//  BoxOffice
//
//  Created by Seonghun Kim on 18/01/2019.
//  Copyright © 2019 공지원. All rights reserved.
//

import UIKit

class BoxOfficeViewController: UIViewController {
    
    // MARK:- Properties
    public var movies: [Movie] = []
    public let boxOfficeAPI = BoxOfficeAPI()
    public let cellIdentifier = "movieCell"
    
    public lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK:- IBOutlet
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- IBAction
    @IBAction func settingsTapped(_ sender: Any) {
        //설정 버튼이 눌리면 영화 정렬방식을 선택할 수 있도록 액션시트 띄움
        showOrderTypeSettingActionSheet(style: .actionSheet)
    }
    
    //MARK:- Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetAndFetchMovies(orderType: BoxOfficeAPI.orderType)
    }
    
    // MARK:- Method
    public func fetchMovies() {
        boxOfficeAPI.requestMovie(orderType: BoxOfficeAPI.orderType) { [weak self]  result, isSucceed in
            guard let self = self else {
                return
            }
            
            if !isSucceed {
                self.alert("해당 영화에 대한 데이터가 없습니다.")
                return
            }
            
            guard let result = result else {
                self.alert("해당 영화에 대한 데이터가 없습니다.")
                return
            }
            
            self.movies = result
            
            DispatchQueue.main.async {
                if self.tableView != nil {
                    self.tableView.reloadData()
                }
                if self.collectionView != nil {
                    self.collectionView.reloadData()
                }
                self.indicator.stopAnimating()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc public func handleRefreshControl(_ sender: UIRefreshControl) {
        indicator.startAnimating()

        fetchMovies()
    }
    
    public func showOrderTypeSettingActionSheet(style: UIAlertController.Style) {
        let orderSettingAlertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: style)
        
        let sortByRateAction = UIAlertAction(title: "예매율", style: .default) { _ in
            self.resetAndFetchMovies(orderType: "0")
        }
        
        let sortByCurationAction = UIAlertAction(title: "큐레이션", style: .default) { _ in
            self.resetAndFetchMovies(orderType: "1")
        }
        
        let sortByDateAction = UIAlertAction(title: "개봉일순", style: .default) { _ in
            self.resetAndFetchMovies(orderType: "2")
        }
        
        let cancleAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            BoxOfficeAPI.orderType = "0"
            print("cancel")
        }
        
        orderSettingAlertController.addAction(sortByRateAction)
        orderSettingAlertController.addAction(sortByCurationAction)
        orderSettingAlertController.addAction(sortByDateAction)
        orderSettingAlertController.addAction(cancleAction)
        
        present(orderSettingAlertController, animated: true, completion: nil)
    }
    
    //settings버튼을 통해 영화 정렬타입을 변경했을 경우
    public func resetAndFetchMovies(orderType: String) {
        let navigationTitle: String
        BoxOfficeAPI.orderType = orderType
        
        switch orderType {
        case "0":
            navigationTitle = "예매율순"
        case "1":
            navigationTitle = "큐레이션"
        case "2":
            navigationTitle = "개봉일순"
        default:
            navigationTitle = "예매율순"
        }
        
        navigationController?.navigationBar.topItem?.title = navigationTitle
        
        indicator.startAnimating()
        
        //orderType에 맞게 영화목록 다시 가져오기
        fetchMovies()
    }
}
