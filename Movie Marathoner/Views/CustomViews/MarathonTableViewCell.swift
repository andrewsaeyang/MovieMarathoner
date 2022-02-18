//
//  MarathonTableViewCell.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 2/14/22.
//

import UIKit

class MarathonTableViewCell: UITableViewCell {
static let cellIdentifier = "marathonListCell"
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var contentConfig = defaultContentConfiguration().updated(for: state)
        
    }

}

/*
 
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? MarathonTableViewCell else { return UITableViewCell()}
     return cell// TODO: MAKE A CELL
 }
 */
