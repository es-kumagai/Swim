//
//  WeakObjectContainerTests.swift
//  SwimTests
//
//  Created by Tomohiro Kumagai on 2020/01/13.
//

import XCTest
@testable import Swim

class WeakObjectContainerTests: XCTestCase {
    
    var container1: WeakObjectContainer<MyObject>!
    var container2: WeakObjectContainer<MyObject>!
    var container3: WeakObjectContainer<MyObject>!

    class MyObject {
        
        var value: Int
        
        init(_ value: Int) {
            
            self.value = value
        }
    }

    class MyObjectEquatable : Equatable {
        
        var value: Int
        
        init(_ value: Int) {
            
            self.value = value
        }
        
        static func == (lhs:MyObjectEquatable, rhs:MyObjectEquatable) -> Bool {
            
            return lhs.value == rhs.value
        }
    }


    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHasObject() {
        
        let a1:MyObject? = MyObject(10)
        let a2:MyObject? = MyObject(10)
        let a3:MyObject? = MyObject(20)
        var a4:MyObject? = MyObject(30)
        
        let b1:MyObjectEquatable? = MyObjectEquatable(10)
        let b2:MyObjectEquatable? = MyObjectEquatable(10)
        let b3:MyObjectEquatable? = MyObjectEquatable(20)
        var b4:MyObjectEquatable? = MyObjectEquatable(30)
        
        let ca1 = WeakObjectContainer(a1)
        let ca2 = WeakObjectContainer(a2)
        let ca3 = WeakObjectContainer(a3)
        let ca4 = WeakObjectContainer(a4)
        
        let cb1 = WeakObjectContainer(b1, equal: ==)
        let cb2 = WeakObjectContainer(b2, equal: ==)
        let cb3 = WeakObjectContainer(b3, equal: ==)
        let cb4 = WeakObjectContainer(b4, equal: ==)
        
        a4 = nil
        b4 = nil
        
        XCTAssertTrue(ca1.hasObject)
        XCTAssertTrue(ca2.hasObject)
        XCTAssertTrue(ca3.hasObject)
        XCTAssertFalse(ca4.hasObject)
        
        XCTAssertTrue(cb1.hasObject)
        XCTAssertTrue(cb2.hasObject)
        XCTAssertTrue(cb3.hasObject)
        XCTAssertFalse(cb4.hasObject)
        
        XCTAssertTrue(ca1.hasObject(a1!))
        XCTAssertFalse(ca2.hasObject(a1!), "Container using === operator by default.")
        XCTAssertFalse(ca3.hasObject(a1!))
        XCTAssertFalse(ca4.hasObject(a1!))
        
        XCTAssertTrue(cb1.hasObject(b1!))
        XCTAssertTrue(cb2.hasObject(b1!), "Container using Equatable.")
        XCTAssertFalse(cb3.hasObject(b1!))
        XCTAssertFalse(cb4.hasObject(b1!))
    }
    
    func hasObject<T: AnyObject>(_ object: T, equal: (T,T)->Bool = { $0 === $1 }) -> Bool {
        
        return equal(object, object)
    }
    
    func hasObject<T: AnyObject>(_ object: T, equal: (T,T)->Bool = { $0 == $1 }) -> Bool where T:Equatable {
        
        return equal(object, object)
    }
    
    func testWeakReference() {
        
        func makeReleasedContainer(_ value: Int) -> WeakObjectContainer<MyObject> {
            
            let object = MyObject(value)
            let container = WeakObjectContainer(object)
            
            XCTAssertTrue(container.hasObject)
            
            return container
        }
        
        var object1: MyObject? = MyObject(1)
        let object2: MyObject? = MyObject(2)
        
        container1 = WeakObjectContainer(object1)
        container2 = WeakObjectContainer(object2)
        container3 = makeReleasedContainer(100)

        XCTAssertTrue(container1.hasObject)
        XCTAssertTrue(container2.hasObject)
        XCTAssertFalse(container3.hasObject)
        
        XCTAssertFalse(container1.isObjectReleased)
        XCTAssertFalse(container2.isObjectReleased)
        XCTAssertTrue(container3.isObjectReleased)
        
        object1 = nil
            
        XCTAssertNil(container1.object)
        XCTAssertNotNil(container2.object)
        XCTAssertNil(container3.object)

        XCTAssertFalse(container1.hasObject)
        XCTAssertTrue(container2.hasObject)
        XCTAssertFalse(container3.hasObject)
        
        XCTAssertTrue(container1.isObjectReleased)
        XCTAssertFalse(container2.isObjectReleased)
        XCTAssertTrue(container3.isObjectReleased)
    }
    
    static var allTests = [
        ("testHasObject", testHasObject),
        ("testWeakReference", testWeakReference),
    ]
}
