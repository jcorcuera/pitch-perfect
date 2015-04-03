//
//  RecordAudio.swift
//  Pitch Perfect
//
//  Created by José Corcuera on 3/26/15.
//  Copyright (c) 2015 Jose Corcuera. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(title: String!, filePathUrl:NSURL!) {
        self.title = title
        self.filePathUrl = filePathUrl
    }
    
    
}