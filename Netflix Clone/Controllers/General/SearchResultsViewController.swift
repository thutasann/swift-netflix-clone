//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by Thuta sann on 11/13/22.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject{
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}


class SearchResultsViewController: UIViewController {
    
    public var titles: [Title] = [Title]()
    
    // Delegate
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    // Search Result Collection View
    public let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout();
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    // View Did Layout SubView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }


}


extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
 
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
    }
    
    // Push to Trailer View
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        collectionView.deselectItem(at: indexPath, animated: true)
        
        
        let title = titles[indexPath.row]
        let titleName = title.original_title ?? "Unknown"
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result{
                case .success(let videoElement):
                    
                
                self?.delegate?.searchResultsViewControllerDidTapItem(TitlePreviewViewModel(title: title.original_title ?? "Unknown", youtubeView: videoElement, titleOverview: title.overview ?? "Unknown"))

                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
}

// AIzaSyCNrE__sZla6ai0d8flY7gQl8cNa-i9DSs
