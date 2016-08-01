import UIKit

private let workerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
private let mainQueue = dispatch_get_main_queue()

// Calculate the harmonic mean of two numbers.
// 2 / (1 / x + 1 / y)
func harmonicMeanAsync(x: Double, y: Double, completion: Double -> Void) {
  dispatch_async(workerQueue) {
    // These two divs are executed in parallel.
    let xinvf = Future(div, 1, x)
    let yinvf = Future(div, 1, y)

    // Invocation of add waits until xinvf and yinvf are fulfilled.
    let invsumf = Future(add, xinvf.get(), yinvf.get())

    let hmeanf = Future(div, 2, invsumf.get())

    // You must retrive the future content before moving to the main queue because
    // get() may block.
    let hmean = hmeanf.get()

    dispatch_async(mainQueue) {
      completion(hmean)
    }
  }
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    harmonicMeanAsync(5, y: 7) { hmean in
      print(hmean)
    }
  }
}
