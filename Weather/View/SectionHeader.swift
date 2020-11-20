//
//  SectionHeader.swift
//  Weather
//
//  Created by Amar Sawant on 20/11/20.
//  Copyright © 2020 atsawant.com. All rights reserved.
//

import UIKit

protocol SectionHeaderDelegate: class {
    func addButtonTapped()
}

class SectionHeader: UICollectionReusableView {
    weak var delegate: SectionHeaderDelegate?
    
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.addButtonTapped()
    }
}
