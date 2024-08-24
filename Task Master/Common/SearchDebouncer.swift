//
//  SearchDebouncer.swift
//  Task Master
//
//  Created by Rahul Anand on 18/08/24.
//

import Foundation

class SearchDebouncer {
    private let delay: TimeInterval
    private var timer: Timer?
    
    init(delay: TimeInterval) {
        self.delay = delay
    }
    
    func debounce(action: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            action()
        }
    }
}
