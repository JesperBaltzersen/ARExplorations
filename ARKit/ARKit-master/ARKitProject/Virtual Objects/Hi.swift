//
//  HI.swift
//  ARKitProject
//
//  Created by jbaltzersen on 03/12/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class Hi: VirtualObject {

    override init() {
        super.init(modelName: "hi", fileExtension: "scn", thumbImageFilename: "vase", title: "hi")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
