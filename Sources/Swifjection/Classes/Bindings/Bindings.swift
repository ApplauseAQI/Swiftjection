//
//  Copyright © 2016 Applause Inc. All rights reserved.
//

import Foundation

open class Bindings {
    /**
     The `injector` used for creating new instances of objects in certain bindings.
     
     Injector will be passed to `getObject(withInjector injector: Injecting)` function.
     */
    weak var injector: Injecting?
    
    /**
     Dictionary of binding objects bound to type names.
     */
    var bindings: [String: Binding] = [:]
    
    /**
     Initializes `Bindings` object.
     
     - Returns: An initialized `Bindings` object.
     */
    public init() { }
    
    /**
     Looks for the `Binding` assigned to provided `type`, and returns object returned by calling `getObject(withInjector injector: Injecting)`, or nil if no binding found.
     
     - Parameter type: Function will search for `Binding` object assigned to this `type`.
     
     - Returns: Object returned from binding, or nil.
     */
    public func findBinding(type: Any.Type) -> Any? {
        let typeName = "\(type)"
        if let injector = self.injector, let binding = bindings[typeName] {
            return binding.getObject(withInjector: injector)
        }
        return nil
    }

    /**
     Binds provided `object` using `ObjectBinding` to the `type`.
     
     - Parameter object: An instance that should be bound to provided `type`.
     - Parameter type: The `type` to which the `object` should be bound.
     */
    public func bind(object: Any, toType type: Any.Type) {
        let typeName = "\(type)"
        bindings[typeName] = ObjectBinding(withObject: object)
    }
    
    /**
     Binds provided `closure` using `ClosureBinding` to the `type`.
     
     - Parameter closure: A `closure` which should return an instance of provided `type` when called.
     - Parameter type: The `type` to which the `closure` should be bound.
     */
    public func bind(type: Any.Type, with closure: @escaping ((Injecting) -> Any)) {
        let typeName = "\(type)"
        bindings[typeName] = ClosureBinding(withClosure: closure)
    }
    
    /**
     Binds provided `type` in singleton scope using `SingletonBinding`.
     
     This function works properly with `Injectable` or `NSObject` types.
     In case when non `NSObject` and non `Injectable` `type` is bound as singleton, the binding will return `nil`.
     
     - Parameter type: The `type` which should be bound as singleton.
     */
    public func bindSingleton(forType type: Any.Type) {
        let typeName = "\(type)"
        bindings[typeName] = SingletonBinding(withType: type)
    }
    
    /**
     Binds provided `boundType` using `TypeBinding` to the `type`.
     
     When there is no other `Binding` bound to `boundType`, this function will return nil, as non `NSObject` and non `Injectable` type cannot be initialized.
     
     - Parameter boundType: Injector will look for another `Binding`, bound to `boundType` when asked for creating `type` object.
     - Parameter type: The `type` to which the `boundType` should be bound.
     
     - Returns: Instance of `boundType`, or nil.
     */
    public func bind<T>(type boundType: T.Type, toType type: Any.Type) {
        let typeName = "\(type)"
        bindings[typeName] = TypeBinding(withType: boundType)
    }
    
    /**
     Binds provided `boundType` using `TypeBinding` to the `type`.
     
     - Parameter boundType: Injector will try to initialize object of `boundType` when asked for creating `type` object.
     - Parameter type: The `type` to which the `boundType` should be bound.
     
     - Returns: Instance of `boundType`, or nil.
     */
    public func bind<T>(type boundType: T.Type, toType type: Any.Type) where T: Injectable {
        let typeName = "\(type)"
        bindings[typeName] = TypeBinding(withType: boundType)
    }
    
    /**
     Binds provided `boundType` using `TypeBinding` to the `type`.
     
     - Parameter boundType: Injector will try to initialize object of `boundType` when asked for creating `type` object.
     - Parameter type: The `type` to which the `boundType` should be bound.
     
     - Returns: Instance of `boundType`, or nil.
     */
    public func bind<T>(type boundType: T.Type, toType type: Any.Type) where T: NSObject {
        let typeName = "\(type)"
        bindings[typeName] = TypeBinding(withType: boundType)
    }
    
    /**
     Binds provided `boundType` using `TypeBinding` to the `type`.
     
     - Parameter boundType: Injector will try to initialize object of `boundType` when asked for creating `type` object.
     - Parameter type: The `type` to which the `boundType` should be bound.
     
     - Returns: Instance of `boundType`, or nil.
     */
    public func bind<T>(type boundType: T.Type, toType type: Any.Type) where T: NSObject, T: Injectable {
        let typeName = "\(type)"
        bindings[typeName] = TypeBinding(withType: boundType)
    }
}
