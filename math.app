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