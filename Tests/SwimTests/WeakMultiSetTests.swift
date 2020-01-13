//
//  WeakMultiSetTests.swift
//  SwimTests
//
//  Created by Tomohiro Kumagai on 2020/01/13.
//

import XCTest
@testable import Swim

fileprivate class MyObject {
    
    var value: Int
    
    init(_ value: Int) {
        
        self.value = value
    }
}

fileprivate class MyObjectEquatable : Equatable {
    
    var value: Int
    
    init(_ value: Int) {
        
        self.value = value
    }
    
    static func == (lhs:MyObjectEquatable, rhs:MyObjectEquatable) -> Bool {
        
        return lhs.value == rhs.value
    }
}

class WeakMultiSetTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testWeakMultiSet() {
        
        var set = WeakMultiSet<MyObject>()
        
        let checklist = { (list: [MyObject], file: StaticString, line: UInt) -> Void in
            
            if set.count == list.count {
                
                var checklist = list
                var count = 0
                
                for    obj in set {
                    
                    count += 1
                    
                    XCTAssertTrue(obj === checklist.first!)
                    checklist.remove(at: 0)
                }
            
                XCTAssertEqual(count, list.count)
            }
            else {
                
                XCTFail("The set's count \(set.count) is not equal to list's count \(list.count).", file:file, line:line)
            }
        }
        
        let obj1: MyObject? = MyObject(1)
        var obj2: MyObject? = MyObject(2)
        var obj3: MyObject? = MyObject(3)
        let obj11: MyObject? = MyObject(1)
        let obj22: MyObject? = MyObject(2)
        let obj33: MyObject? = MyObject(3)
        
        XCTAssertEqual(set.count, 0)
        XCTAssertTrue(set.isEmpty)
        XCTAssertNil(set.first)
        XCTAssertNil(set.last)
        
        set.appendLast(obj1!)
        
        XCTAssertEqual(set.count, 1)
        XCTAssertTrue(!set.isEmpty)
        XCTAssertTrue(set.first! === obj1!)
        XCTAssertTrue(set.last! === obj1!)
        
        set.appendLast(obj2!)
        
        XCTAssertEqual(set.count, 2)
        XCTAssertTrue(!set.isEmpty)
        XCTAssertTrue(set.first! === obj1!)
        XCTAssertTrue(set.last! === obj2!)
        
        set.appendLast(obj3!)
        
        XCTAssertEqual(set.count, 3)
        XCTAssertTrue(!set.isEmpty)
        XCTAssertTrue(set.first! === obj1!)
        XCTAssertTrue(set.last! === obj3!)
        
        set.appendLast(obj1!)
        
        XCTAssertEqual(set.count, 4)
        XCTAssertTrue(!set.isEmpty)
        XCTAssertTrue(set.first! === obj1!)
        XCTAssertTrue(set.last! === obj1!)
        
        set.appendLast(obj11!)
        
        XCTAssertEqual(set.count, 5)
        XCTAssertTrue(!set.isEmpty)
        XCTAssertTrue(set.first! === obj1!)
        XCTAssertTrue(set.last! === obj11!)

        XCTAssertEqual(set.count(of: obj1!), 2)
        XCTAssertEqual(set.count(of: obj2!), 1)
        XCTAssertEqual(set.count(of: obj3!), 1)
        XCTAssertEqual(set.count(of: obj11!), 1)
        XCTAssertEqual(set.count(of: obj22!), 0)
        XCTAssertEqual(set.count(of: obj33!), 0)
        
        XCTAssertTrue(set.contains(obj1!))
        XCTAssertTrue(set.contains(obj2!))
        XCTAssertTrue(set.contains(obj3!))
        XCTAssertTrue(set.contains(obj11!))
        XCTAssertTrue(!set.contains(obj22!))
        XCTAssertTrue(!set.contains(obj33!))
        
        XCTAssertEqual(set.findAll(obj1!).count, 2)
        XCTAssertEqual(set.findAll(obj2!).count, 1)
        XCTAssertEqual(set.findAll(obj3!).count, 1)
        XCTAssertEqual(set.findAll(obj11!).count, 1)
        XCTAssertEqual(set.findAll(obj22!).count, 0)
        XCTAssertEqual(set.findAll(obj33!).count, 0)
        
        set.appendFirst(obj33!)
        
        XCTAssertEqual(set.count, 6)
        XCTAssertTrue(!set.isEmpty)
        XCTAssertTrue(set.first! === obj33!)
        XCTAssertTrue(set.last! === obj11!)
        
        
        XCTAssertEqual(set.count(of: obj1!), 2)
        XCTAssertEqual(set.count(of: obj2!), 1)
        XCTAssertEqual(set.count(of: obj3!), 1)
        XCTAssertEqual(set.count(of: obj11!), 1)
        XCTAssertEqual(set.count(of: obj22!), 0)
        XCTAssertEqual(set.count(of: obj33!), 1)
        
        XCTAssertTrue(set.contains(obj1!))
        XCTAssertTrue(set.contains(obj2!))
        XCTAssertTrue(set.contains(obj3!))
        XCTAssertTrue(set.contains(obj11!))
        XCTAssertTrue(!set.contains(obj22!))
        XCTAssertTrue(set.contains(obj33!))
        
        XCTAssertEqual(set.findAll(obj1!).count, 2)
        XCTAssertEqual(set.findAll(obj2!).count, 1)
        XCTAssertEqual(set.findAll(obj3!).count, 1)
        XCTAssertEqual(set.findAll(obj11!).count, 1)
        XCTAssertEqual(set.findAll(obj22!).count, 0)
        XCTAssertEqual(set.findAll(obj33!).count, 1)
        
        obj3 = nil
        
        XCTAssertEqual(set.count, 5)
        XCTAssertTrue(!set.isEmpty)
        XCTAssertTrue(set.first! === obj33!)
        XCTAssertTrue(set.last! === obj11!)
        
        
        XCTAssertEqual(set.count(of: obj1!), 2)
        XCTAssertEqual(set.count(of: obj2!), 1)
        //        XCTAssertEqual(set.count(of: obj3!), 0)
        XCTAssertEqual(set.count(of: obj11!), 1)
        XCTAssertEqual(set.count(of: obj22!), 0)
        XCTAssertEqual(set.count(of: obj33!), 1)
        
        XCTAssertTrue(set.contains(obj1!))
        XCTAssertTrue(set.contains(obj2!))
        //        XCTAssertTrue(!set.contains(obj3!))
        XCTAssertTrue(set.contains(obj11!))
        XCTAssertTrue(!set.contains(obj22!))
        XCTAssertTrue(set.contains(obj33!))
        
        XCTAssertEqual(set.findAll(obj1!).count, 2)
        XCTAssertEqual(set.findAll(obj2!).count, 1)
        //        XCTAssertEqual(set.findAll(obj3!).count, 0)
        XCTAssertEqual(set.findAll(obj11!).count, 1)
        XCTAssertEqual(set.findAll(obj22!).count, 0)
        XCTAssertEqual(set.findAll(obj33!).count, 1)
        
        obj2 = nil
        
        checklist([obj33!, obj1!, obj1!, obj11!], #file, #line)
        
        XCTAssertEqual(set.count, 4)
        XCTAssertTrue(!set.isEmpty)
        XCTAssertTrue(set.first! === obj33!)
        XCTAssertTrue(set.last! === obj11!)
        
        
        XCTAssertEqual(set.count(of: obj1!), 2)
        //        XCTAssertEqual(set.count(of: obj2!), 1)
        //        XCTAssertEqual(set.count(of: obj3!), 0)
        XCTAssertEqual(set.count(of: obj11!), 1)
        XCTAssertEqual(set.count(of: obj22!), 0)
        XCTAssertEqual(set.count(of: obj33!), 1)
        
        XCTAssertTrue(set.contains(obj1!))
        //        XCTAssertTrue(set.contains(obj2!))
        //        XCTAssertTrue(!set.contains(obj3!))
        XCTAssertTrue(set.contains(obj11!))
        XCTAssertTrue(!set.contains(obj22!))
        XCTAssertTrue(set.contains(obj33!))
        
        XCTAssertEqual(set.findAll(obj1!).count, 2)
        //        XCTAssertEqual(set.findAll(obj2!).count, 1)
        //        XCTAssertEqual(set.findAll(obj3!).count, 0)
        XCTAssertEqual(set.findAll(obj11!).count, 1)
        XCTAssertEqual(set.findAll(obj22!).count, 0)
        XCTAssertEqual(set.findAll(obj33!).count, 1)
        
        set.appendLast(obj33!)
        set.appendLast(obj1!)
        
        checklist([obj33!, obj1!, obj1!, obj11!, obj33!, obj1!], #file, #line)
        
        XCTAssertEqual(set.count(of: obj1!), 3)
        XCTAssertEqual(set.count(of: obj11!), 1)
        XCTAssertEqual(set.count(of: obj22!), 0)
        XCTAssertEqual(set.count(of: obj33!), 2)
        
        set.removeOneFromFirst(obj33!)
        checklist([obj1!, obj1!, obj11!, obj33!, obj1!], #file, #line)
        
        XCTAssertEqual(set.count(of: obj1!), 3)
        XCTAssertEqual(set.count(of: obj11!), 1)
        XCTAssertEqual(set.count(of: obj22!), 0)
        XCTAssertEqual(set.count(of: obj33!), 1)
        
        set.removeOneFromLast(obj1!)
        checklist([obj1!, obj1!, obj11!, obj33!], #file, #line)
        
        XCTAssertEqual(set.count(of: obj1!), 2)
        XCTAssertEqual(set.count(of: obj11!), 1)
        XCTAssertEqual(set.count(of: obj22!), 0)
        XCTAssertEqual(set.count(of: obj33!), 1)
        
        set.removeAll(obj1!)
        checklist([obj11!, obj33!], #file, #line)
        
        XCTAssertEqual(set.count(of: obj1!), 0)
        XCTAssertEqual(set.count(of: obj11!), 1)
        XCTAssertEqual(set.count(of: obj22!), 0)
        XCTAssertEqual(set.count(of: obj33!), 1)
        
        set.appendLast(obj22!)
        checklist([obj11!, obj33!, obj22!], #file, #line)
        
        XCTAssertEqual(set.count(of: obj1!), 0)
        XCTAssertEqual(set.count(of: obj11!), 1)
        XCTAssertEqual(set.count(of: obj22!), 1)
        XCTAssertEqual(set.count(of: obj33!), 1)
        
        set.removeFirst()
        checklist([obj33!, obj22!], #file, #line)
        
        XCTAssertEqual(set.count(of: obj1!), 0)
        XCTAssertEqual(set.count(of: obj11!), 0)
        XCTAssertEqual(set.count(of: obj22!), 1)
        XCTAssertEqual(set.count(of: obj33!), 1)
        
        set.removeLast()
        checklist([obj33!], #file, #line)
        
        
        XCTAssertEqual(set.count(of: obj1!), 0)
        XCTAssertEqual(set.count(of: obj11!), 0)
        XCTAssertEqual(set.count(of: obj22!), 0)
        XCTAssertEqual(set.count(of: obj33!), 1)
        
        set.appendLast(obj1!)
        checklist([obj33!, obj1!], #file, #line)
        
        set.removeAll()
        checklist([], #file, #line)
    }
    
    func testWeakMultiSetWithEquatableObject() {
        
        var set = WeakMultiSet<MyObjectEquatable>(equal: ==)
        
        let checklist = { (list:[MyObjectEquatable], file:StaticString, line:UInt) -> Void in
            
            if set.count == list.count {
                
                var checklist = list
                var count = 0
                
                for    obj in set {
                    
                    count += 1
                    
                    XCTAssertTrue(obj === checklist.first!)
                    checklist.remove(at: 0)
                }
                
                XCTAssertEqual(count, list.count)
            }
            else {
                
                XCTFail("The set's count \(set.count) is not equal to list's count \(list.count).", file:file, line:line)
            }
        }
        
        let obj1:MyObjectEquatable? = MyObjectEquatable(1)
        var obj2:MyObjectEquatable? = MyObjectEquatable(2)
        var obj3:MyObjectEquatable? = MyObjectEquatable(3)
        let obj11:MyObjectEquatable? = MyObjectEquatable(1)
        let obj22:MyObjectEquatable? = MyObjectEquatable(2)
        let obj33:MyObjectEquatable? = MyObjectEquatable(3)
        
        XCTAssertEqual(set.count, 0)
        XCTAssertTrue(set.isEmpty)
        XCTAssertNil(set.first)
        XCTAssertNil(set.last)
        
        set.appendLast(obj1!)
        
        XCTAssertEqual(set.count, 1)
        XCTAssertTrue(!set.isEmpty)
        XCTAssertTrue(set.first! == obj1!)
        XCTAssertTrue(set.last! == obj1!)
        
        set.appendLast(obj2!)
        
        XCTAssertEqual(set.count, 2)
        XCTAssertTrue(!set.isEmpty)
        XCTAssertTrue(set.first! == obj1!)
        XCTAssertTrue(set.last! == obj2!)
        
        set.appendLast(obj3!)
        
        XCTAssertEqual(set.count, 3)
        XCTAssertTrue(!set.isEmpty)
        XCTAssertTrue(set.first! == obj1!)
        XCTAssertTrue(set.last! == obj3!)
        
        set.appendLast(obj1!)
        
        XCTAssertEqual(set.count, 4)
        XCTAssertTrue(!set.isEmpty)
        XCTAssertTrue(set.first! == obj1!)
        XCTAssertTrue(set.last! == obj1!)
        
        set.appendLast(obj11!)
        
        XCTAssertEqual(set.count, 5)
        XCTAssertTrue(!set.isEmpty)
        XCTAssertTrue(set.first! == obj1!)
        XCTAssertTrue(set.last! == obj11!)
        
        
        XCTAssertEqual(set.count(of: obj1!), 3)
        XCTAssertEqual(set.count(of: obj2!), 1)
        XCTAssertEqual(set.count(of: obj3!), 1)
        XCTAssertEqual(set.count(of: obj11!), 3)
        XCTAssertEqual(set.count(of: obj22!), 1)
        XCTAssertEqual(set.count(of: obj33!), 1)
        
        XCTAssertTrue(set.contains(obj1!))
        XCTAssertTrue(set.contains(obj2!))
        XCTAssertTrue(set.contains(obj3!))
        XCTAssertTrue(set.contains(obj11!))
        XCTAssertTrue(set.contains(obj22!))
        XCTAssertTrue(set.contains(obj33!))
        
        XCTAssertEqual(set.findAll(obj1!).count, 3)
        XCTAssertEqual(set.findAll(obj2!).count, 1)
        XCTAssertEqual(set.findAll(obj3!).count, 1)
        XCTAssertEqual(set.findAll(obj11!).count, 3)
        XCTAssertEqual(set.findAll(obj22!).count, 1)
        XCTAssertEqual(set.findAll(obj33!).count, 1)
        
        set.appendFirst(obj33!)
        
        XCTAssertEqual(set.count, 6)
        XCTAssertTrue(!set.isEmpty)
        XCTAssertTrue(set.first! == obj33!)
        XCTAssertTrue(set.last! == obj11!)
        
        
        XCTAssertEqual(set.count(of: obj1!), 3)
        XCTAssertEqual(set.count(of: obj2!), 1)
        XCTAssertEqual(set.count(of: obj3!), 2)
        XCTAssertEqual(set.count(of: obj11!), 3)
        XCTAssertEqual(set.count(of: obj22!), 1)
        XCTAssertEqual(set.count(of: obj33!), 2)
        
        XCTAssertTrue(set.contains(obj1!))
        XCTAssertTrue(set.contains(obj2!))
        XCTAssertTrue(set.contains(obj3!))
        XCTAssertTrue(set.contains(obj11!))
        XCTAssertTrue(set.contains(obj22!))
        XCTAssertTrue(set.contains(obj33!))
        
        XCTAssertEqual(set.findAll(obj1!).count, 3)
        XCTAssertEqual(set.findAll(obj2!).count, 1)
        XCTAssertEqual(set.findAll(obj3!).count, 2)
        XCTAssertEqual(set.findAll(obj11!).count, 3)
        XCTAssertEqual(set.findAll(obj22!).count, 1)
        XCTAssertEqual(set.findAll(obj33!).count, 2)
        
        obj3 = nil
        
        XCTAssertEqual(set.count, 5)
        XCTAssertTrue(!set.isEmpty)
        XCTAssertTrue(set.first! == obj33!)
        XCTAssertTrue(set.last! == obj11!)
        
        
        XCTAssertEqual(set.count(of: obj1!), 3)
        XCTAssertEqual(set.count(of: obj2!), 1)
        //        XCTAssertEqual(set.count(of: obj3!), 0)
        XCTAssertEqual(set.count(of: obj11!), 3)
        XCTAssertEqual(set.count(of: obj22!), 1)
        XCTAssertEqual(set.count(of: obj33!), 1)
        
        XCTAssertTrue(set.contains(obj1!))
        XCTAssertTrue(set.contains(obj2!))
        //        XCTAssertTrue(!set.contains(obj3!))
        XCTAssertTrue(set.contains(obj11!))
        XCTAssertTrue(set.contains(obj22!))
        XCTAssertTrue(set.contains(obj33!))
        
        XCTAssertEqual(set.findAll(obj1!).count, 3)
        XCTAssertEqual(set.findAll(obj2!).count, 1)
        //        XCTAssertEqual(set.findAll(obj3!).count, 0)
        XCTAssertEqual(set.findAll(obj11!).count, 3)
        XCTAssertEqual(set.findAll(obj22!).count, 1)
        XCTAssertEqual(set.findAll(obj33!).count, 1)
        
        obj2 = nil
        
        checklist([obj33!, obj1!, obj1!, obj11!], #file, #line)
        
        XCTAssertEqual(set.count, 4)
        XCTAssertTrue(!set.isEmpty)
        XCTAssertTrue(set.first! === obj33!)
        XCTAssertTrue(set.last! === obj11!)
        
        
        XCTAssertEqual(set.count(of: obj1!), 3)
        //        XCTAssertEqual(set.count(of: obj2!), 1)
        //        XCTAssertEqual(set.count(of: obj3!), 0)
        XCTAssertEqual(set.count(of: obj11!), 3)
        XCTAssertEqual(set.count(of: obj22!), 0)
        XCTAssertEqual(set.count(of: obj33!), 1)
        
        XCTAssertTrue(set.contains(obj1!))
        //        XCTAssertTrue(set.contains(obj2!))
        //        XCTAssertTrue(!set.contains(obj3!))
        XCTAssertTrue(set.contains(obj11!))
        XCTAssertTrue(!set.contains(obj22!))
        XCTAssertTrue(set.contains(obj33!))
        
        XCTAssertEqual(set.findAll(obj1!).count, 3)
        //        XCTAssertEqual(set.findAll(obj2!).count, 1)
        //        XCTAssertEqual(set.findAll(obj3!).count, 0)
        XCTAssertEqual(set.findAll(obj11!).count, 3)
        XCTAssertEqual(set.findAll(obj22!).count, 0)
        XCTAssertEqual(set.findAll(obj33!).count, 1)
        
        set.appendLast(obj33!)
        set.appendLast(obj1!)
        
        checklist([obj33!, obj1!, obj1!, obj11!, obj33!, obj1!], #file, #line)
        
        XCTAssertEqual(set.count(of: obj1!), 4)
        XCTAssertEqual(set.count(of: obj11!), 4)
        XCTAssertEqual(set.count(of: obj22!), 0)
        XCTAssertEqual(set.count(of: obj33!), 2)
        
        set.removeOneFromFirst(obj33!)
        checklist([obj1!, obj1!, obj11!, obj33!, obj1!], #file, #line)
        
        XCTAssertEqual(set.count(of: obj1!), 4)
        XCTAssertEqual(set.count(of: obj11!), 4)
        XCTAssertEqual(set.count(of: obj22!), 0)
        XCTAssertEqual(set.count(of: obj33!), 1)
        
        set.removeOneFromLast(obj1!)
        checklist([obj1!, obj1!, obj11!, obj33!], #file, #line)
        
        XCTAssertEqual(set.count(of: obj1!), 3)
        XCTAssertEqual(set.count(of: obj11!), 3)
        XCTAssertEqual(set.count(of: obj22!), 0)
        XCTAssertEqual(set.count(of: obj33!), 1)
        
        set.removeAll(obj1!)
        checklist([obj33!], #file, #line)
        
        XCTAssertEqual(set.count(of: obj1!), 0)
        XCTAssertEqual(set.count(of: obj11!), 0)
        XCTAssertEqual(set.count(of: obj22!), 0)
        XCTAssertEqual(set.count(of: obj33!), 1)
        
        set.appendLast(obj22!)
        checklist([obj33!, obj22!], #file, #line)
        
        XCTAssertEqual(set.count(of: obj1!), 0)
        XCTAssertEqual(set.count(of: obj11!), 0)
        XCTAssertEqual(set.count(of: obj22!), 1)
        XCTAssertEqual(set.count(of: obj33!), 1)
        
        set.removeFirst()
        checklist([obj22!], #file, #line)
        
        XCTAssertEqual(set.count(of: obj1!), 0)
        XCTAssertEqual(set.count(of: obj11!), 0)
        XCTAssertEqual(set.count(of: obj22!), 1)
        XCTAssertEqual(set.count(of: obj33!), 0)
        
        set.removeLast()
        checklist([], #file, #line)
        
        XCTAssertEqual(set.count(of: obj1!), 0)
        XCTAssertEqual(set.count(of: obj11!), 0)
        XCTAssertEqual(set.count(of: obj22!), 0)
        XCTAssertEqual(set.count(of: obj33!), 0)
        
        set.appendLast(obj1!)
        checklist([obj1!], #file, #line)
        
        set.removeAll()
        checklist([], #file, #line)
    }
}
