---
title: Scala cheatsheet
modify_date: 2021-05-02
---

![Scala-logo](/assets/images/cheatsheets/scala/scala-full-color.svg)


## Principes Functional programming

### Stateless

* Data immutable => no side effects
* Same params => Same result



### Referential Transparency 

An expression is referentially transparent (RT) if it can be replaced by its value.

Pure functions are RT:

* Returns **always** the *same result* for the *same input*
* No side effect (nor output)
* Enables to cache the function result for an input, and then re-use it without executing the function (gain of time)

Examples:

```scala
sin(x)                    // Referentially Transparent
length(s) with s a String // RT
currentTime()             // NOT RT
printf()                  // NOT RT (car écrit sur console => output)
```



### Call-by-value vs Call-by-name

Call-by-value:

* Args are **evaluated before being passed** to the function

* Args are evaluated **once and only once**

  ```scala
  def first(x: Int, y: Int) = x
  ```

Call-by-name:

* Args are **not evaluated if not used**, otherwise **evaluated in each occurrence**

  ```scala
  def first(x: Int, y: => Int) = x
  ```



### Addressing a problem in FP

We can often use one of these solutions to address a problem in functional programing: 

1. Recursion (or tailRecursion) + pattern matching
2. Higher Order Function (HOF)
3. Mix 1 and 2
4. Sequence comprehensions

## Divers

```scala
// import library used for @tailrec notation
import scala.annotation.tailrec
/// ??? can be used for a function not already defined
def myFnct = ???
// Checking predicates
assert(predicate)		// for checking if fct is working correctly
require(predicate)		// for checking precondition
// system fct
sys.error(message: String)
sys.exit()
```


## Definitions

Difference between def and var/val:

```scala
def f = expr		// expr is evaluated every time it is used 
val v = expr		// expr is evaluated only once
```



### Variables

```scala
var x = 1       // mutable
val x = 1       // immutable
val x:Int = 1   // explicit type
```



### Functions

#### std Functions:

```scala
def incr(x: Int) = x + 1
```



#### Recursive functions:

```scala
// Function that recursively sums Ints from 'a' to 'b'
def sumInts(a: Int, b: Int) : Double =
  if(a > b) 0 else a + sumInts(a + 1, b)
```

Call stack:

```scala
sumInts(1, 5)
1 + sumInts(2, 5)
1 + (2 + sumInts(3, 5))
1 + (2 + (3 + sumInts(4, 5)))
1 + (2 + (3 + (4 + sumInts(5, 5))))
1 + (2 + (3 + (4 + (5 + sumInts(6, 5)))))
1 + (2 + (3 + (4 + (5 + 0))))
```



#### Tail-recursive functions:

Recursive functions can be a problem because the call stack becomes bigger and bigger. 

​	=> With Tail Recursive functions, an intermediate result is computed and given in param of the next call. This way, the call stack has a fixed size regardless of the number of recusions.

```scala
def sumIntsTail(a: Int, b: Int) : Double = {
  @tailrec
  def iter(a: Int, b: Int, acc: Double) : Double = {	// acc is the accumulator
    if(a > b) acc else tGeneSum(a+1, b, a + acc)
  }
  tGeneSum(a, b, 0)	// expression of the block. Set the first value of the acc
}
```

Call Stack:

```scala
sumIntsTail(1, 5)
	iter(1, 5, 0)
	iter(2, 5, 1)
	iter(3, 5, 3)
	iter(4, 5, 6)
	iter(5, 5, 10)
	iter(6, 5, 15)
	15
```



#### Anonymous function

```scala
// Forms
(x: Double) => x * x 						// with 1 param
(x: Double, y: Int) => (x+y) * 2.0 			// with 2 params

// Example: a generic function for summing (with function in param that takes an Int)
def geneSum(f: Int => Double, a: Int, b: Int) : Double = {
  if(a > b) 0 else f(a) + geneSum(f, a + 1, b)
}
geneSum((x: Int) => x*x*x, 1, 3)	// 1^3 + 2^3 + 3^3
```



#### High order function (HOF) 

Function that takes a function(s) as **argument(s)** or **returns** a function

```scala
def geneSum(f: Int => Double, a: Int, b: Int) : Double = {...}	// arg1 is a function
```



#### Partial application of functions

* Allow to redefine a function with less args and static args
  * set some values and reduces the arity of the base function
  * partial application evaluates immediately
* Avantages: Reuse already written functions and specialise them

```scala
def adder(x: Int, y: Int) = x + y 
val incr = adder(_ : Int, 1)
val add2 = adder(_ : Int, 2)
incr(18) 	=> 19
add2(5)		=> 7
```



#### Currying :chicken: 

* Transform an n-ary function into a chain of n unary functions (arity = nb of arg of a fct)

```scala
// Currying and partial applications example
def addCurry(a: Int)(b: Int) = a + b
addCurry(3)(4)
val inc = addCurry(1) _
inc(3)
```

## Types

### Types List:

   - **a numerical**              : `Int, Double, Byte, Short, Char, Long, Float`

   - **a boolean**                  : `Boolean` 

   - **a string**                      : `String`

   - **function**                    : `Int => Int; (Double, Int) => Int`   

   - **list** 			     : `List(1,2,4,7)` idem as `1::2::4::7::Nil`

   - **streams**		    :  `Stream(1,2,3)` idem as `1#::2#::3#::Stream.empty`

   - **tuple**			 : `val t = ("John", 23)`. Can make every combination of types

     ​				      Tuple class: `case class Tuple2[T1, T2](_1: +T1, _2: +T2)`

     ​				      Access 

<img src="/assets/images/cheatsheets/scala/scala_types.png" alt="Scala types">

### Genericity 

* Makes the type as a parameter
* Applicable to functions, classes and traits

```scala
// Generic List method:
def length[T](l: List[T]): Int =		// type [T], could have been [A], or [B]
    l match {
        case Nil 		=> 0
        case x :: xs	=> length(xs) + 1
    }
length[Int](intsList: List[Int])
```



#### Type bounds

* Lower bound : `T >: Y`
  * T must be a <u>superclass</u> of Y or Y
* Upper bound: `T <: Y`
  * T must be a <u>subclass</u> of Y or Y
* View bound : `T <% Y`
  * There must exist a conversion from T to Y



### Variance 

* **Covariance** : Enables to use a <u>more specific type</u> (**subclass**) than the originally specified
  * `class Variance[+A]`
* **Contravariance** : Enables to use a <u>more generic type</u> (**superclass**) than originally specified
  - `class Variance[-A]`
* **Invariance** (or **non-variance**): Can only use the type originally specified
  - `class Variance[A]`





## Operators

### Precedence

Precedence of an operator determined by its first characters.

<img src="/assets/images/cheatsheets/scala/precedence_rules.png" alt="operators precedence" class="image image--xl">



## Oriented Object (OO)

### Classes

```scala
class Rational(n: Int, d: Int) {	// n and d are private
    /* Preconditions */
    require(d != 0)			  // predicate that denom isn't 0	
    
    /* Auxiliary constructors */
    def this(a: Int) = this(a, 1)
    
    /* Private methods/variables of the class (not visible outside) */
	private def gcd(x: Int, y: Int) : Int = if(y == 0) x else gcd(y, x % y) 
  	private val g = gcd(n, d) // val = like a constant (executed at construction only)
  	
    /* variables of the class */
    def num = n / g 		// simplification of the fraction by the gcd during the constr
  	def denom = d / g
    
    /* methods of the class */
    def +(that: Rational) = {		// operator '+' redefinition for Rational type
    new Rational(num*that.denom - that.num*denom, denom * that.denom)
  	}
    
    def unary_-() = {          		// neg() function
    	new Rational(-num, denom)
  	}
    
    override def toString: String =	// override means "redefines an existing method"
    	num + "/" + denom
    
    // implicit convertion function, to do 2*(new Rational(3, 5)) for example
    implicit def intToRat(x: Int) = new Rational(x)	
}

val r1 = new Rational(2,3)
```

Class parameters : 

* Private by default : `class Rational(n: Int, d: Int)`
* Public & mutable with var : `class Rational(var n: Int, var d: Int)`
* Public & immutable with val : `class Rational(val n: Int, val d: Int)`



#### Abstract class 

* Class that **MUST** be extends by other classes (no instance can be built with it)
* Classes that extends must define the members of the abstract class

```scala
abstract class IntSet() {
    def add(x: Int) : IntSet
    def contains(x: Int) : Boolean
}
```



#### Singleton

* Single instance of a class at any time
* Exemple: pour un IntSet, il ne devrait y avoir qu'un seul *Empty*

```scala
object Empty extends IntSet {	// 'object' instead of 'class'
    /* ... */
}
val set1 = Empty	// not 'new Empty()'
```



#### Case class & sealed class

Case class:

* no `new`
* implicit `val` in front of parameters (=> params public & immutable)
* methods automatically created (`equals`, `hashCode`, etc)
* Pattern matching on case class constructor!

Sealed class:

* Specializing abstract class:
  * Compiler warns if pattern match not exhaustive (on subclasses) 
  * subclasses MUST be in same file

```scala
sealed abstract class Expr
case class Number(n: Int) extends Expr
case class Product(e1: Expr, e2: Expr) extends Expr
case class Sum(e1: Expr, e2: Expr) extends Expr

def eval(e: Expr) : Int = e match {
  case Number(n) => n
  case Sum(e1, e2) => eval(e1) + eval(e2)
  case Product(e1, e2) => eval(e1) * eval(e2)
}
val n1 = Number(5)		// no 'new' keyword
```



### Traits

* Like Java *Interfaces*, but allows for methods implementation and val declarations
* Defines a new type
* Can contains methods and fields 
* Can't be instantiated
* A Class can mix several traits
  * => Solves the diamond inheritance problem
* `trait` keyword to declare trait
* `extend` keyword to mix a trait into a <u>class that doesn't already extends another class</u>
* `with` keyword to mix a trait into a <u>class that already extends another class</u>, or to <u>mix multiple traits</u> (the rightmost wins => *for diamond-like inheritance problem*)

```scala
trait Logged {
    def log(msg: String)
}

class ConsoleLogger extends Logged {
	override def log(msg: String) = println("[LOG] " + msg)
}

// A trait can also extend a trait, and provide methods implementations
trait ConsoleLoggerTrait extends Logged {
    override def log(msg: String) = println("[LOG] " + msg)
}

class Customer(name: String) extends Person(name) with ConsoleLogger {
    log(s"Person $name created")
}
class Customer(name: String) extends Person(name) with Logged {
	log(s"Person $name created")
}
val x = new Customer("Patrick Jane") with ConsoleLogger
val y = new Customer("Teresa Lisbon") with FileLogger
```





## Pattern matching 

* Switch case on steroids 
* Can match on:
  * **Constants**
  * **Types**
  * **Constructors** (case classes)
  * **Collections**

```scala
// Matching on constants
x match {		// x: Int; returns String
    case 1 => "one"
    case 3 | 4 => "many"
    case _ => "other value"		// default
}
// Matching on types 
x match {		// x: Any; returns String
    case a: Int => "Got an int, " + a
    case b: String if (b.length > 4) => b + " is long"
}
// Matching on constructors 
x match {		// x: Expr
	case Number(n) => n
  	case Sum(e1, e2) => eval(e1) + eval(e2)
  	case Product(e1, e2) => eval(e1) * eval(e2)
}
// Matching on lists
x match {		// x: List[Int] returns Int
    case Nil			=> 0
    case head :: Nil 	=> do_something		// pas obligatoire, si pas là => case suivant
    case x :: xs 		=> 1 + length(xs)	// x matches 'head' and xs matches 'tail'
}
```



## Lists

### Basics

* Lists are **homogeneous** (all elt have same type)
* **Nil** is the empty list, and a case class => pattern matching ! :ghost: 
* Every list operation can be expressed with three operations: **tail**, **head** and **isEmpty**

```scala
// List declarations
val stringList = List("do", "you", "like", "lists?")
val otherList = 2::5::8::9::Nil
val rangeList = (1 to 10).toList()
// Basic lists operations
stringList.head		// => first elt: "do"
otherList.tail		// => list without first elt: 5::8::9::Nil
```



### Lists methods

The List type has lot of useful methods:

```scala
// List methods
val emptyIntList = List.empty[Int]		// empty
val fillFiveList = List.fill(3)(5)		// fill
val intervalList = List.range(0,10,2)	// List(0, 2, 4, 6, 8)
val l = List(1,3,4,6,7,9)
l.length				// returns the number of elts
l.last					// returns the last elt
l.init					// returns all the elt but the last
l.reverse
l.apply(3)				// returns the third elt
l.concat(fillFiveList)	// could be written 'l concat fillFiveList' or 'l ++ fillFiveList'
l.indexOf(4)			// 2
l.contains
l.distinct				// remove duplicates elt
l.sum					// returns an Int of the sum
l.mkString("-")			// 1-3-4-6-7-9
l.union(fillFiveList)	// or intersection or diff
l.indices				// returns a list of the indices of the list
```



### HOF on Lists

Most used HOF on lists : 

* **map** : builds a new list by applying a function to every elt

  ```scala
  def map[B](f: (A) => B): List[B]		// A is the type of the starting list
  										// B is the type of the resulting list
  val l = List(1,2,3,4,5)
  l.map((x: Int) => if(x%2 == 0) true else false)	// A: Int, B: Boolean
  ```

* **filter** : selects all the elements of the list which satisfy the predicate

  ```scala
  def filter(p: (A) => Boolean) : List[A]
  l.filter((x: Int) => x%2 == 0)			// a predicate is a boolean expression
  ```

* **reduceLeft, reduceRight**: 

  * applies a binary operator to every elt of a List, going left to right (reduceLeft) or right to left (reduceRight)
  * returns the result of inserting `op` between consecutive elt of the list, left to right (reduceLeft) or right to left (reduceRight)

  ```scala
  def reduceLeft[B >: A](op: (B, A) => B): B	// A is the type of starting list
  											// B is the type of the resulting list
  											// '>:' means A is a subtype of B or B
  											// takes a fct 'op' with 2 params
  def reduceRight[B >: A](op: (A, B) => B): B
  List(1,2,3,4).reduceLeft((x: Int, y: Int) => x - y)
  -(-(-(1,2),3),4)
  -(-(-1,3),4)
  -(-4, 4)
  -8
  List(1,2,3,4).reduceRight((x: Int, y: Int) => x - y)
  -(-(-(4,3),2),1)
  -(-(1, 2), 1)
  -(-1, 1)
  -2
  ```

* **foldLeft, foldRight**:

  * Apply binary operator to all elements, going left to right (foldLeft) or right to left (foldRight), starting with an initial result (z)

  ```scala
  def foldLeft[B](z: B)(f: (B, A) => B) : B	// A is the type of starting list
  											// B is the type of resulting list
  											// z is the initial value of type B
  											// takes a fct 'f' with 2 params
  def foldRight[B](z: B)(f: (A, B) => B) : B
  List(1,2,3).foldLeft(2)((x, y) => x - y)
  List(1,2,3).foldRigh(2)((x, y) => x - y)
  ```

<img src="/assets/images/cheatsheets/scala/foldright-foldleft.png" alt="foldright-foldleft">

* **flatten**: flatten a `List(List()...)` into a `List()`

* **flatMap**: maps and flatten

* **zip:** returns a list formed from this list and another list by combining elts in tuples 

  ```scala
  val l1 = List(2,4,6,8)
  val l2 = List(1,2,3)
  l1.zip(l2)		// => List[(Int,Int)] : List((2,1),(4,2)(6,3))
  ```

* **sortWith:** sorts the elts given a comparison function



## Streams

* Similar to *List*
  * Tail evaluation **only on demand**
* Uses `lazy val` for its tail
  * computation only if required

```scala
Stream(1,2,3)
(1 to 1000).toStream
1#::6#::19#::Stream.empty
Stream.cons(1, Stream.cons(6, Stream.cons(19, Stream.empty)))
```



## 'For' comprehensions

* For loops
* Sequence `s` 
  * must start with a generator
  * Can have filters like 'if cond'. Loop omits values for which the 'cond' is false
  * if several generators, later ones vary more rapidly than earlier ones (comme boucle imbriquée)
* Expression `e` 
  * executed for each element generated from the sequence of generators and filters s
* Always translated into `foreach` by compiler
* when `yield` keyword used, makes a List

```scala
for (s) e yield e		
				// s is a sequence of 
				// - generator(s), in the form of 'x <- e' (x=elt, e=list[x])
				// - definitions, in the form of 'val x = e'
				// - filter, expression 'if cond'; omits all for which cond is false
				// e is an expression
val persons = List(Person("John",23), Person("Mary",30), Person("Alex", 22))
for (p <- persons	// (s)
    if p.age > 25)
	yield p.name	// e => List("Mary")
```

### for-comprehension conversion

Conversion of `map`, `flatmap` and `filter` into `for-comprehension` :

Conversion examples:

```scala
for (x <- e) yield e'				==>	e.map(x => e')

for(x <- e if f; s) yield e’		==> for (x <- e.filter(x => f); s) yield e'

for{ i <- range(1, n)				==> range(1, n).flatMap(i =>
    j <- range(1, i)				==> 	range(1, i)
    if isPrime(i+j)					==> 		.filter(j => isPrime(i+j))
} yield {i, j}						==> 		.map(j => (i, j)))
```



## Expressions

An expression can be:

   - **an identifier**  			: x, sqrt 
   - **literal**                     		  : 0, 0.1, "Hello"
   - **a function application**        : sqrt(x) 
   - **operator application**   	: -x, y+3 
   - **a selection**                   	   : math.abs 
   - **conditional expression**      : if(x > 0) y else x 
   - **a block** 				   : {x * 2}
      - Last element is an expression that defines the value of the block (**Block is an expression!**)
   - **anonymous function**         : (x => x + 1) 



## Parallelism paradigms



### Parallel collections

* Add `.par` to the collection to run the code on parallel (on multiple cores)
* Useful on big collections (because of the overhead added)

```scala
val myParList = (1 to 100000).toList.par		// parallel collection
println(myList.map(x => x/2).map(x => x+1).sum)	// functions done on multiple cores 

/* each map and sum methods will re-create a new List => not good for stack.
 		==> Lazy Collection with the method '.view'	*/
val myParViewList = (1 to 100000).toList.par.view
```



### Futures

* Is a handle for a value not yet available 
* Does not wait for a result before returning 
* Usage example: Asynchronous API

```scala
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future
import scala.util.{Failure, Success}

/* Async computation */
def longComputation(x: Int): Future[Int] = {
    Future {
       Thread.sleep(500)	// simule de longs calculs
    	5 
    }
}
val f = longComputation(2)

/* Future callbacks */
f onComplete {
    case Success(r)		=> println("Computation result is " + r)
    case Failure(t)		=> println("Error during compuration: " + t.getMessage)
}

/* Blocking for completion (we want to wait for Future to be resolved before continuing) */
val result : Int = Await.result(f, 3 seconds) 	// wait for f result or max 3sec
```


### Actor model 

* **Message passing** approach
  * Actors ~= process
  * Messages
    * Encapsulate shared information
    * Used to communicate between process

```scala
import akka.actor.{Actor, ActorLogging, ActorSystem, Props, actorRef2Scala}
```
