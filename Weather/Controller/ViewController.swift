//
//  ViewController.swift
//  Weather
//
//  Created by Amar Sawant on 18/11/20.
//  Copyright © 2020 atsawant.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: WeatherViewModel?
    var cellSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateViews()
        
        viewModel = WeatherViewModel(interactor: WeatherDataInteractor(), dataHandler: PlaceDataInteractor())
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        reloadView()
    }
    
    func reloadView() {
        viewModel?.fetchWeatherReport(completion: { error in
            
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
            
            if let _ = error {
                self.showAlert(title: "Error", message: "Problem in fetching places.\nplease try again later", action: "Ok")
                return
            }else {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        })
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItems() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath) as! CollectionCell
        if let viewModel = viewModel {
            cell.labelCity.text = viewModel.cityNameForItemAtIndex(index: indexPath.row)
            cell.labelHumidity.text = viewModel.humidityForItemAtIndex(index: indexPath.row)
            cell.labelTemperature.text = viewModel.tempuratureForItemAtIndex(index: indexPath.row)
            cell.labelSunrise.text = viewModel.sunriseTimeForItemAtIndex(index: indexPath.row)
            cell.labelSunset.text = viewModel.sunsetTimeForItemAtIndex(index: indexPath.row)
            cell.backgroundImageView.image = UIImage(named: viewModel.imageForItemAtIndex(index: indexPath.row))
        }
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCellAtIndex(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader{
            sectionHeader.delegate = self
            return sectionHeader
        }
        return UICollectionReusableView()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 0, bottom: 8, right: 0)
    }
}

extension ViewController: SectionHeaderDelegate {
    
    @objc func refresh(_ sender: AnyObject) {
        reloadView()
    }
    
    func addButtonTapped() {
        debugPrint("add button clicked")
        performSegue(withIdentifier: "showCountryList", sender: nil)
    }
    
    func didSelectCellAtIndex(index: Int) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.alert)
        let remove = UIAlertAction(title: "Remove this place", style: .destructive) { UIAlertAction in
            self.viewModel?.removeSelectedPlaceAtIndex(index: index)
            self.reloadView()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(remove)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController {
    @IBAction func unwindToMain(sender: UIStoryboardSegue) {
        reloadView()
    }
}
    
// MARK:- UIViewController Override

extension ViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { context in
            // do while animation
            self.updateViews()
        }, completion:{ context in
            // do after animation completed
        })
    }
    
    func updateViews(){
        let viewSize =  UIApplication.shared.windows.first?.bounds.size ?? CGSize.zero
        let defaultHeight: CGFloat = 300
        
        if let interfaceOrientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation {
            
            if (interfaceOrientation == .portrait || interfaceOrientation == .portraitUpsideDown) { // potrait
                if (UIDevice.current.userInterfaceIdiom == .pad){
                    // iPad
                    let cellLength = (viewSize.width/1.5)
                    cellSize = CGSize(width: cellLength, height: defaultHeight)
                }else if (UIDevice.current.userInterfaceIdiom == .phone){
                    // iPhone
                    let cellLength = (viewSize.width/1.2)
                    cellSize = CGSize(width: cellLength, height: defaultHeight)
                }
            }else { // landscape
                if (UIDevice.current.userInterfaceIdiom == .pad){
                    // iPad
                    let cellLength = (viewSize.width/2)
                    cellSize = CGSize(width: cellLength, height: defaultHeight)
                }else if (UIDevice.current.userInterfaceIdiom == .phone){
                    // iPhone
                    let cellLength = (viewSize.width/2)
                    cellSize = CGSize(width: cellLength, height: defaultHeight)
                }
            }
        }
        
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
}


