import Foundation

private let workerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
private let mainQueue = dispatch_get_main_queue()

func div(x x: Double, y: Double, completion: Double -> Void) {
  dispatch_async(workerQueue) {
    sleep(1)
    dispatch_async(mainQueue) {
      completion(x / y)
    }
  }
}

func add(x x: Double, y: Double, completion: Double -> Void) {
  dispatch_async(workerQueue) {
    sleep(1)
    dispatch_async(mainQueue) {
      completion(x + y)
    }
  }
}

func divAndMod(n n: Int, m: Int, completion: (Int, Int) -> Void) {
  dispatch_async(workerQueue) {
    sleep(1)
    dispatch_async(mainQueue) {
      completion(n / m, n % m)
    }
  }
}

func primeTest(n: Int, success: Void -> Void, failure: Void ->Void) {
  dispatch_async(workerQueue) {
    sleep(1)
    var isPrime = true
    for a in 2 ..< n {
      if n % a == 0 {
        isPrime = false
        break
      }
    }
    let completion = isPrime ? success : failure
    dispatch_async(mainQueue, completion)
  }
}
