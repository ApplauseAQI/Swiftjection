//
//  Copyright © 2017 Applause Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

public extension Injecting {
    public func getObject<T>(withType type: T.Type) -> T? where T: Any {
        if let object = bindings[type]?.getObject(withInjector: self) as? T {
            return object
        }
        return nil
    }
    
    public func getObject<T>(withType type: T.Type) -> T? where T: NSObject {
        if let object = bindings[type]?.getObject(withInjector: self) as? T {
            return object
        }
        return type.init()
    }
    
    public func getObject<T>(withType type: T.Type) -> T? where T: Injectable {
        if let object = bindings[type]?.getObject(withInjector: self) as? T {
            return object
        }
        if let object = type.init(injector: self) {
            object.injectDependencies(injector: self)
            return object
        }
        return nil
    }
    
    public func getObject<T>(withType type: T.Type) -> T? where T: NSObject, T: Injectable {
        if let object = bindings[type]?.getObject(withInjector: self) as? T {
            return object
        }
        if let object = type.init(injector: self) {
            object.injectDependencies(injector: self)
            return object
        }
        return nil
    }
    
    public subscript(type: Any.Type) -> Any? {
        if let object = bindings[type]?.getObject(withInjector: self) {
            return object
        }
        return nil
    }
    
    public subscript(type: NSObject.Type) -> NSObject? {
        if let object = bindings[type]?.getObject(withInjector: self) as? NSObject {
            if let injectable = object as? Injectable {
                injectable.injectDependencies(injector: self)
            }
            return object
        }
        return type.init()
    }
    
    public subscript(type: Injectable.Type) -> Injectable? {
        if let object = bindings[type]?.getObject(withInjector: self) as? Injectable {
            return object
        }
        if let object = type.init(injector: self) {
            object.injectDependencies(injector: self)
            return object
        }
        return nil
    }
}
