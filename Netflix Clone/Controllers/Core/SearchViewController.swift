//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Thuta sann on 11/8/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    // DISCOVER TABLE
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    // For Serach Result View Controlelr
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search For a Movie or a TV show"; // Inputbox label
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top Search"
        navigationController?.navigationBar.prefersLargeTitles = true;
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        // Search Bar
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white // set Searchbar Cancel Button color white
        
        fetchDiscoverMovies()
        
        // Search Result Update
        searchController.searchResultsUpdater = self
       
    }
    
    // Fetch Discover Movies
    private func fetchDiscoverMovies(){
        APICaller.shared.getDiscoverMovices { [weak self] result in
            switch result{
                case .success(let titles):
                    self?.titles = titles
                    DispatchQueue.main.async {
                        self?.discoverTable.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        discoverTable.frame = view.bounds
    }
    

}


extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
            
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.original_name ?? title.original_title ?? "Unknown Name", posterURL: title.poster_path ?? "")
        cell.configure(with: model)
        
        return cell;
    }
    
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 140
    }
    
    
}


// UI Search Result Updating Extension
extension SearchViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else{ return
                }
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async{
                switch result{
                    case .success(let titles):
                    resultsController.titles = titles
                        resultsController.searchResultsCollectionView.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    }
    
}