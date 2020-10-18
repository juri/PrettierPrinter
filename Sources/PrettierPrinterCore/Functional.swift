//
//  Functional.swift
//  

func id<A>(_ a: A) -> A { a }

func const<A, B>(_ a: A) -> (B) -> A {
  return { _ in a }
}
