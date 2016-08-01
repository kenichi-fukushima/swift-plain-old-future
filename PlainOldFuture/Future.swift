import Foundation

private let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

class FutureContainer<T> {
  private let group = dispatch_group_create()
  private var value: T?

  private init() {
    dispatch_group_enter(group)
  }

  private func set(value: T) {
    self.value = value
    dispatch_group_leave(group)
  }

  func get() -> T {
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
    return value!
  }
}

enum Either2<T1, T2> {
  case Case1(value: T1)
  case Case2(value: T2)
}

enum Either3<T1, T2, T3> {
  case Case1(value: T1)
  case Case2(value: T2)
  case Case3(value: T3)
}

func Future<Result, Arg>(f: (Arg, Result -> Void) -> Void, _ arg: Arg) -> FutureContainer<Result> {
  let future = FutureContainer<Result>()
  f(arg) { future.set($0) }
  return future
}

func Future<Result, Arg1, Arg2>(
  f: (Arg1, Arg2, Result -> Void) -> Void,
  _ arg1: Arg1,
    _ arg2: Arg2) -> FutureContainer<Result> {

  let future = FutureContainer<Result>()
  f(arg1, arg2) { future.set($0) }
  return future
}

func Future<Result1, Result2, Arg1, Arg2>(
  f: (Arg1, Arg2, (Result1, Result2) -> Void) -> Void,
  _ arg1: Arg1,
    _ arg2: Arg2) -> (FutureContainer<Result1>, FutureContainer<Result2>) {

  let future1 = FutureContainer<Result1>()
  let future2 = FutureContainer<Result2>()
  f(arg1, arg2) { result1, result2 in
    future1.set(result1)
    future2.set(result2)
  }
  return (future1, future2)
}

func Future<Result1, Result2, Arg>(
  f: (Arg, (Result1) -> Void, (Result2) -> Void) -> Void,
  _ arg: Arg) -> (FutureContainer<Either2<Result1, Result2>>) {

  let future = FutureContainer<Either2<Result1, Result2>>()
  let completion1 = { future.set(Either2.Case1(value: $0)) }
  let completion2 = { future.set(Either2.Case2(value: $0)) }
  f(arg, completion1, completion2)
  return future
}
