//
//  Partial.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-01-25.
//  Copyright © 2020 Spinners. All rights reserved.
//

enum Partial {
    case partial
}

func partial<A, B, C>(_ function: @escaping (A, B) -> C, arg1: A, arg2: Partial) -> (B) -> C {
    return { futurB in
        return function(arg1, futurB)
    }
}

func partial<A, B, C>(_ function: @escaping (A, B) -> C, arg1: Partial, arg2: B) -> (A) -> C {
    return { futurA in
        return function(futurA, arg2)
    }
}

func partial<A, B, C, D>(_ function: @escaping (A, B, C) -> D, arg1: A, arg2: B, arg3: Partial) -> (C) -> D {
    return { futurC in
        return function(arg1, arg2, futurC)
    }
}

func partial<A, B, C, D>(_ function: @escaping (A, B, C) -> D, arg1: A, arg2: Partial, arg3: C) -> (B) -> D {
    return { futurB in
        return function(arg1, futurB, arg3)
    }
}

func partial<A, B, C, D>(_ function: @escaping (A, B, C) -> D, arg1: Partial, arg2: B, arg3: C) -> (A) -> D {
    return { futurA in
        return function(futurA, arg2, arg3)
    }
}

func partial<A, B, C, D, E>(_ function: @escaping (A, B, C, D) -> E, arg1: A, arg2: B, arg3: C, arg4: Partial) -> (D) -> E {
    return { futurD in
        return function(arg1, arg2, arg3, futurD)
    }
}

func partial<A, B, C, D, E>(_ function: @escaping (A, B, C, D) -> E, arg1: A, arg2: B, arg3: Partial, arg4: D) -> (C) -> E {
    return { futurC in
        return function(arg1, arg2, futurC, arg4)
    }
}

func partial<A, B, C, D, E>(_ function: @escaping (A, B, C, D) -> E, arg1: A, arg2: Partial, arg3: C, arg4: D) -> (B) -> E {
    return { futurB in
        return function(arg1, futurB, arg3, arg4)
    }
}

func partial<A, B, C, D, E>(_ function: @escaping (A, B, C, D) -> E, arg1: Partial, arg2: B, arg3: C, arg4: D) -> (A) -> E {
    return { futurA in
        return function(futurA, arg2, arg3, arg4)
    }
}
