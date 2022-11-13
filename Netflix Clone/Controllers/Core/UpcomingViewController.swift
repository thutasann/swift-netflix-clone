//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Thuta sann on 11/8/22.
//

// Delegate -> control or modify the behavior of another object.
// Override -> when you want to write your own method to replace an existing one in a parent class.

import UIKit

class UpcomingViewController: UIViewController {
    
    // Variable For Title
    private var titles: [Title] = [Title]()
    
    
    // Upcoming Table View
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        // add subView
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        // Call the Fetch Upcomings
        fetchUpcoming()
    }
    
    // View Did Layout SubView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    // Upcoming Movies Fetch Function
    private func fetchUpcoming(){
        APICaller.shared.getUpcomingMovies{ [weak self] result in
            switch result {
                case .success(let titles):
                    self?.titles = titles
                    DispatchQueue.main.async {
                        self?.upcomingTable.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

}


extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource{
        
    // Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return titles.count
    }
    
    // Table View Label
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else{
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.original_title ?? title.original_name ?? "Unknown Title", posterURL: title.poster_path ?? "" ))
        return cell
    }
    

    // Row Height Fix
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}
