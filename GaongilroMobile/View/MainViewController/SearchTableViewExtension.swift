//
//  SearchTableViewExtension.swift
//  GaongilroMobile
//
//  Created by Minki on 2018. 8. 30..
//  Copyright © 2018년 devming. All rights reserved.
//

import UIKit
import Foundation

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let lines: SubwayLine
        if isFiltering() {
            guard let temp = SubwayManager.shared.filteredLines else {
                return 0
            }
            lines = temp
        } else {
            
            guard let temp = SubwayManager.shared.lines else {
                return 0
            }
            lines = temp
        }
        
        if section == 0 {
            return lines.line1.count
        } else if section == 1 {
            return lines.line2.count
        } else if section == 2 {
            return lines.line3.count
        } else if section == 3 {
            return lines.line4.count
        } else if section == 4 {
            return lines.line5.count
        } else if section == 5 {
            return lines.line6.count
        } else if section == 6 {
            return lines.line7.count
        } else if section == 7 {
            return lines.line8.count
        } else if section == 8 {
            return lines.line9.count
        } else if section == 9 {
            return lines.lineA.count
        } else if section == 10 {
            return lines.lineB.count
        } else if section == 11 {
            return lines.lineE.count
        } else if section == 12 {
            return lines.lineG.count
        } else if section == 13 {
            return lines.lineI.count
        } else if section == 14 {
            return lines.lineI2.count
        } else if section == 15 {
            return lines.lineK.count
        } else if section == 16 {
            return lines.lineKK.count
        } else if section == 17 {
            return lines.lineS.count
        } else if section == 18 {
            return lines.lineSU.count
        } else if section == 19 {
            return lines.lineU.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.cellName) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        let subwayInfo: SubwayLine
        if isFiltering() {
            guard let filteredInfo = SubwayManager.shared.filteredLines else {
                return cell
            }
            subwayInfo = filteredInfo
        } else {
            guard let info = SubwayManager.shared.lines else {
                return cell
            }
            subwayInfo = info
        }
        if indexPath.section == 0 {
            cell.koreanStaionNameLabel.text = subwayInfo.line1[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.line1[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.line1[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.line1[indexPath.row].frCode
        } else if indexPath.section == 1 {
            cell.koreanStaionNameLabel.text = subwayInfo.line2[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.line2[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.line2[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.line2[indexPath.row].frCode
        } else if indexPath.section == 2 {
            cell.koreanStaionNameLabel.text = subwayInfo.line3[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.line3[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.line3[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.line3[indexPath.row].frCode
        } else if indexPath.section == 3 {
            cell.koreanStaionNameLabel.text = subwayInfo.line4[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.line4[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.line4[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.line4[indexPath.row].frCode
        } else if indexPath.section == 4 {
            cell.koreanStaionNameLabel.text = subwayInfo.line5[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.line5[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.line5[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.line5[indexPath.row].frCode
        } else if indexPath.section == 5 {
            cell.koreanStaionNameLabel.text = subwayInfo.line6[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.line6[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.line6[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.line6[indexPath.row].frCode
        } else if indexPath.section == 6 {
            cell.koreanStaionNameLabel.text = subwayInfo.line7[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.line7[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.line7[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.line7[indexPath.row].frCode
        } else if indexPath.section == 7 {
            cell.koreanStaionNameLabel.text = subwayInfo.line8[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.line8[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.line8[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.line8[indexPath.row].frCode
        } else if indexPath.section == 8 {
            cell.koreanStaionNameLabel.text = subwayInfo.line9[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.line9[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.line9[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.line9[indexPath.row].frCode
        } else if indexPath.section == 9 {
            cell.koreanStaionNameLabel.text = subwayInfo.lineA[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.lineA[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.lineA[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.lineA[indexPath.row].frCode
        } else if indexPath.section == 10 {
            cell.koreanStaionNameLabel.text = subwayInfo.lineB[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.lineB[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.lineB[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.lineB[indexPath.row].frCode
        } else if indexPath.section == 11 {
            cell.koreanStaionNameLabel.text = subwayInfo.lineE[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.lineE[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.lineE[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.lineE[indexPath.row].frCode
        } else if indexPath.section == 12 {
            cell.koreanStaionNameLabel.text = subwayInfo.lineG[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.lineG[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.lineG[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.lineG[indexPath.row].frCode
        } else if indexPath.section == 13 {
            cell.koreanStaionNameLabel.text = subwayInfo.lineI[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.lineI[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.lineI[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.lineI[indexPath.row].frCode
        } else if indexPath.section == 14 {
            cell.koreanStaionNameLabel.text = subwayInfo.lineI2[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.lineI2[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.lineI2[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.lineI2[indexPath.row].frCode
        } else if indexPath.section == 15 {
            cell.koreanStaionNameLabel.text = subwayInfo.lineK[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.lineK[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.lineK[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.lineK[indexPath.row].frCode
        } else if indexPath.section == 16 {
            cell.koreanStaionNameLabel.text = subwayInfo.lineKK[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.lineKK[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.lineKK[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.lineKK[indexPath.row].frCode
        } else if indexPath.section == 17 {
            cell.koreanStaionNameLabel.text = subwayInfo.lineS[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.lineS[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.lineS[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.lineS[indexPath.row].frCode
        } else if indexPath.section == 18 {
            cell.koreanStaionNameLabel.text = subwayInfo.lineSU[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.lineSU[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.lineSU[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.lineSU[indexPath.row].frCode
        } else if indexPath.section == 19 {
            cell.koreanStaionNameLabel.text = subwayInfo.lineU[indexPath.row].stationName
            cell.englishStaionNameLabel.text = subwayInfo.lineU[indexPath.row].stationNameEnglish
            cell.lineImageView.image = UIImage(named: "ic_line\(subwayInfo.lineU[indexPath.row].lineNumber)")
            cell.frCodeLabel.text = subwayInfo.lineU[indexPath.row].frCode
        }
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchTableViewCell, let stationName = cell.koreanStaionNameLabel.text, let stationNameEnglish = cell.englishStaionNameLabel.text else {
            return
        }
        self.destinationStationName = "\(stationName)"
        
        self.destinationLabel.text = "To: \(stationName)(\(stationNameEnglish))"
        
        self.cameraEnablingButton.isEnabled = true
        self.searchController.isActive = false
        self.searchView.isHidden = true
    }
}
