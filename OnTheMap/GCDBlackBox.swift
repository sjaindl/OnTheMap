//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Stefan Jaindl on 22.05.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
