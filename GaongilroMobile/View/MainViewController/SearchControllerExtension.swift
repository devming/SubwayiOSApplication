//
//  SearchControllerExtension.swift
//  GaongilroMobile
//
//  Created by Minki on 2018. 8. 30..
//  Copyright © 2018년 devming. All rights reserved.
//
import UIKit
import Foundation

extension MainViewController {
    func searchBarIsEmpty() -> Bool {
        return self.searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        guard let lineInfo = SubwayManager.shared.lines, let _ = SubwayManager.shared.filteredLines else {
            return
        }
    
        SubwayManager.shared.filteredLines!.line1 = filterLines(originLines: lineInfo.line1, searchText: searchText)
        SubwayManager.shared.filteredLines!.line2 = filterLines(originLines: lineInfo.line2, searchText: searchText)
        SubwayManager.shared.filteredLines!.line3 = filterLines(originLines: lineInfo.line3, searchText: searchText)
        SubwayManager.shared.filteredLines!.line4 = filterLines(originLines: lineInfo.line4, searchText: searchText)
        SubwayManager.shared.filteredLines!.line5 = filterLines(originLines: lineInfo.line5, searchText: searchText)
        SubwayManager.shared.filteredLines!.line6 = filterLines(originLines: lineInfo.line6, searchText: searchText)
        SubwayManager.shared.filteredLines!.line7 = filterLines(originLines: lineInfo.line7, searchText: searchText)
        SubwayManager.shared.filteredLines!.line8 = filterLines(originLines: lineInfo.line8, searchText: searchText)
        SubwayManager.shared.filteredLines!.line9 = filterLines(originLines: lineInfo.line9, searchText: searchText)
        SubwayManager.shared.filteredLines!.lineA = filterLines(originLines: lineInfo.lineA, searchText: searchText)
        SubwayManager.shared.filteredLines!.lineB = filterLines(originLines: lineInfo.lineB, searchText: searchText)
        SubwayManager.shared.filteredLines!.lineE = filterLines(originLines: lineInfo.lineE, searchText: searchText)
        SubwayManager.shared.filteredLines!.lineG = filterLines(originLines: lineInfo.lineG, searchText: searchText)
        SubwayManager.shared.filteredLines!.lineI = filterLines(originLines: lineInfo.lineI, searchText: searchText)
        SubwayManager.shared.filteredLines!.lineI2 = filterLines(originLines: lineInfo.lineI2, searchText: searchText)
        SubwayManager.shared.filteredLines!.lineK = filterLines(originLines: lineInfo.lineK, searchText: searchText)
        SubwayManager.shared.filteredLines!.lineKK = filterLines(originLines: lineInfo.lineKK, searchText: searchText)
        SubwayManager.shared.filteredLines!.lineS = filterLines(originLines: lineInfo.lineS, searchText: searchText)
        SubwayManager.shared.filteredLines!.lineSU = filterLines(originLines: lineInfo.lineSU, searchText: searchText)
        SubwayManager.shared.filteredLines!.lineU = filterLines(originLines: lineInfo.lineU, searchText: searchText)
        
        self.searchTableView.reloadData()
    }
    
    func filterLines(originLines: [StationInfo], searchText: String, scope: String = "All") -> [StationInfo] {
        return originLines.filter({ (info: StationInfo) -> Bool in
            let doesCategoryMatch = (scope == "All") || (info.lineNumber == scope)
            
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch &&
                    (info.stationName.lowercased().contains(searchText.lowercased()) ||
                        info.frCode.lowercased().contains(searchText.lowercased()) ||
                        info.stationNameEnglish.lowercased().contains(searchText.lowercased()))
            }
        })
    }
    
    func isFiltering() -> Bool {
//        let searchBarScopeIsFiltering = self.searchController.searchBar.selectedScopeButtonIndex != 0
//        return self.searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
        return self.searchController.isActive && !searchBarIsEmpty()
    }
    
    func createSearchBar() {
        // Setup the Search Controller
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Enter your destination here!"
        navigationItem.searchController = self.searchController
        definesPresentationContext = true
        self.searchController.searchBar.delegate = self
        
        //        let searchBar = UISearchBar()
        //        searchBar.showsCancelButton = false
        //        searchBar.placeholder = "Enter your destination here!"
        //        searchBar.delegate = self
        //        self.navigationItem.titleView = searchBar
    }
}

extension MainViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        //        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        if searchController.isActive {
            self.searchView.isHidden = false
            filterContentForSearchText(searchController.searchBar.text!)
        } else {
            self.searchView.isHidden = true
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)//, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
