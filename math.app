module elib/elib-utils/math

  function iff(a: Bool, b: Bool): Bool {
    return (a && b) || (!a && !b);
  }
  
  function implies(a: Bool, b: Bool): Bool {
    return !a || b;
  }

  function abs(i : Int) : Int {
    return if(i < 0) (0 - i) else i;
  }
  
  function max(i : Int, j : Int) : Int {
    return if(i > j) i else j;
  }

  function max(i : Float, j : Float) : Float {
    return if(i > j) i else j;
  }
  
  function max(i : Double, j : Double) : Double {
    return if(i > j) i else j;
  }
  
  function min(i : Int, j : Int) : Int {
    return if(i > j) j else i;
  }

  function min(i : Float, j : Float) : Float {
    return if(i > j) j else i;
  }
  
  function min(i : Double, j : Double) : Double {
    return if(i > j) j else i;
  }
    
  function mod(i : Int, j : Int) : Int {
    validate(j != 0, "modulo zero undefined");
    return i - (j * (i / j));
  }
  //unlike `mod`, `mod2` will always return the _positive_ remainder
  function mod2(i : Int, j : Int) : Int {
    var m := mod(i,j);
    return if(m < 0) m + j else m;
  }
  
  function inc(i: Int, b: Bool): Int {
    return if(b) i + 1 else i;
  }
  
  function percentage(part: Int, total: Int): Int {
    return if(total == 0) 0 else ((part.floatValue() * 100.0) / total.floatValue()).round();
  }
  
  function round1(f: Float): Float{
    return (10.0 * f).round().floatValue() / 10.0;
  }
  
  native class org.webdsl.tools.MedianList as MedianList {
    insert(Float)
    median():Float
    constructor()
  }
  
  native class org.webdsl.tools.LongToFloat as LongToFloat{
    static longToFloat(Long): Float
  }
  
  function sum(ns: List<Int>): Int {
    var s := 0;
    for(n: Int in ns) { s := s + n; }
    return s;
  }
  
  function sum(ns: List<Float>): Float {
    var s := 0.0;
    for(n: Float in ns) { s := s + n; }
    return s;
  }
  
  function sum(ns: List<Double>): Double {
    var s := Double(0.0);
    for(n: Double in ns) { s := s + n; }
    return s;
  }
  
  function and(bs: List<Bool>): Bool {
    var s := true;
    for(b: Bool in bs) { s := s && b; }
    return s;
  }

  // Greatest common divisor of two numbers
  // time complexity: O(log(n))
  function gcd(a : Int, b : Int) : Int {
    if (a == 0) { return b; }
    return gcd(b % a, a);
  }

  function gcd(elements : [Int]) : Int {
    if (elements.length == 0) { return -1; }
    var result := elements[0];
    for (n in elements) {
      result := gcd(result, n);
      if (result == 1) { return result; }
    }
    return result;
  }

  /*
   * Least common multiple of two numbers
   * time Complexity: O(log(n))
   */
  function lcm(a : Long, b : Long) : Long {
    return lcm([a,b]);
  }

  /*
   * Least common multiple of a collection of numbers
   * "inspired by" *cough* www.geeksforgeeks.org/lcm-of-given-array-elements/
   * time Complexity: O(n * log(n)) where n is the size of the collection
   */
  function lcm(elements : [Long]): Long {
    var lcm := 1L;
    var divisor := 2L;

    while (true) {
      var counter := 0L;
      var divisible := false;

      for (i : Int from 0 to elements.length) {

        if (elements[i] == 0L) {
          return 0L;
        } else if (elements[i] < 0L) {
          elements.set(i, elements[i] * (-1L));
        }

        if (elements[i] == 1L) {
          counter := counter + 1L;
        }

        if (elements[i] % divisor == 0L) {
          divisible := true;
          elements.set(i, elements[i] / divisor);
        }
      }

      if (divisible) {
        lcm := lcm * divisor;
      } else {
        divisor := divisor + 1L;
      }

      if (counter == elements.length) {
        return lcm;
      }
    }
  }

  function lcm(a : Int, b : Int) : Int {
    return lcm(a.toString().parseLong(), b.toString().parseLong()).intValue();
  }

  function lcm(elements : [Int]): Int {
    return lcm([n.toString().parseLong() | n in elements]).intValue();
  }

  // Function to compute the binomial coefficient "n choose k"
  function binomialCoefficient(n : Int, k : Int) : Int {
    if (n < 0 || k < 0 || k > n) {
      // Handle invalid cases
      return 0;
    }
    var k_ := k;
    if (k > n - k) {
      k_ := n - k;
    }
    var result := 1;
    for (i : Int from 0 to k_) {
      result := result * (n - i);
      result := result / (i + 1);
    }

    return result;
  }