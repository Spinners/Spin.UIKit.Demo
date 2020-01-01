//
//  Curry.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-01-01.
//  Copyright © 2020 Spinners. All rights reserved.
//

func curry1Extended<A, B>(function:  @escaping (A) -> B) -> (A) -> () -> B {
    return { a in
        return { () in
            return function(a)
        }
    }
}

func curry2<A, B, C>(function: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in
        return { b in
            return function(a, b)
        }
    }
}

func curry2Extended<A, B, C>(function: @escaping (A, B) -> C) -> (A) -> (B) -> () -> C {
    return { a in
        return { b in
            return { () in
                return function(a, b)
            }
        }
    }
}

func curry3<A, B, C, D>(function: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
    return { a in
        return { b in
            return { c in
                return function(a, b, c)
            }
        }
    }
}

func curry3Extended<A, B, C, D>(function: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> () -> D {
    return { a in
        return { b in
            return { c in
                return { () in
                    return function(a, b, c)
                }
            }
        }
    }
}

func curry4<A, B, C, D, E>(function: @escaping (A, B, C, D) -> E) -> (A) -> (B) -> (C) -> (D) -> E {
    return { a in
        return { b in
            return { c in
                return { d in
                    return function(a, b, c, d)
                }
            }
        }
    }
}
