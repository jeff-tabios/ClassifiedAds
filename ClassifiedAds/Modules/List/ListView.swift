//
//  ListView.swift
//  ClassifiedAds
//
//  Created by Jeffrey Tabios on 12/20/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ListView: UIViewController {
    
    let disposeBag = DisposeBag()
    var presenter: ListPresenter?
    var ads: [Ad]?
    
    //MARK: Views
    lazy var adsView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = true
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identity)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.title = "Listing"
        addSubviews()
        bind()
    }

    func bind() {

        presenter?.ads
            .subscribe(onNext: { [weak self] ads in
                self?.ads = ads.results
                DispatchQueue.main.async {
                    self?.adsView.reloadData()
                }
                
            }).disposed(by: disposeBag)

        presenter?.viewLoadedTrigger.onNext(())
    }

    func addSubviews() {
        view.addSubview(adsView)
        self.view.setNeedsUpdateConstraints()
    }

    override func updateViewConstraints() {
        adsView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        super.updateViewConstraints()
    }
}


extension ListView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ads?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ListCell = collectionView.dequeueCellAtIndexPath(indexPath: indexPath)
        if let adImageUrl = ads?[indexPath.row].imageUrlsThumbnails?[0],
           let adImageId = ads?[indexPath.row].imageIDS[0] {
            cell.image.loadImage(from: URL(string: adImageUrl)!, cacheId: adImageId)
        }
        
        if let adTitle = ads?[indexPath.row].name,
           let adPrice = ads?[indexPath.row].price {
            cell.title.text = adTitle.capitalized
            cell.price.text = adPrice
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let ad = ads?[indexPath.row] {
            presenter?.showDetail(ad: ad)
        }
    }

}

extension ListView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let usableWidth = collectionView.frame.width - 8 * 3
        let width = usableWidth / 2
        return CGSize(width: width, height: width + width / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}
