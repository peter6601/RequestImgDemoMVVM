//
//  ListViewController.swift
//  RequestIImgDemo
//
//  Created by PeterDing on 2018/3/19.
//  Copyright © 2018年 DinDin. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var mainTableView: UITableView!  {
        didSet {
            mainTableView.dataSource = self
            mainTableView.delegate = self
            mainTableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
            mainTableView.estimatedRowHeight = 300
            mainTableView.rowHeight = 300
        }
    }
    
    private var listType: PhotoListType = .People
    
    lazy var viewModel = ListViewModel(type: listType)
    
    func bind(type: PhotoListType? ) {
        guard let tempType = type else { return }
        self.listType = tempType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()

    }

}


extension ListViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as! ImageTableViewCell
        let photo = viewModel[indexPath.row]
            cell.bind(photo: photo )
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == viewModel.count - 2  else { return }
        requestData()
    }
}

extension ListViewController {
    
    func requestData() {
        viewModel.updateData = { [weak self] in
            DispatchQueue.main.async {
                self?.mainTableView.reloadData()
            }
        }
        
        viewModel.requestAPI(completion: {
            print("request sucess")
        }) {
            print("fail")
        }
    }
}



