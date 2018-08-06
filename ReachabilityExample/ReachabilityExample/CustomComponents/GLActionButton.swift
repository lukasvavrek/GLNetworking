//
//  GLActionButton.swift
//  ReachabilityExample
//
//  Created by Lukas Vavrek on 13.2.18.
//  Copyright © 2018 Lukas Vavrek. All rights reserved.
//

import UIKit

class GLActionButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        self.titleLabel?.textColor = UIColor.white
        
        self.addTarget(self, action: #selector(touchedDown), for: .touchDown)
        self.addTarget(self, action: #selector(touchedUp), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchedUp), for: .touchUpOutside)
    }
    
    @objc private func touchedDown(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)
        })
    }
    
    @objc private func touchedUp(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform.identity
        })
    }
}
