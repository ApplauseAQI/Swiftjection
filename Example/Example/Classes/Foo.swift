//
//  Copyright © 2017 Applause Inc. All rights reserved.
//

import Foundation
import Swifjection

class Foo: Injectable {
    convenience required init?(injector: Injecting) {
        self.init()
    }    
}
