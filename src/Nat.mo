/// Natural numbers with infinite precision.
///
/// Most operations on natural numbers (e.g. addition) are available as built-in operators (e.g. `1 + 1`).
/// This module provides equivalent functions and `Text` conversion.
///
/// Import from the base library to use this module.
/// ```motoko name=import
/// import Nat "mo:base/Nat";
/// ```

import Int "Int";
import Prim "mo:⛔";
import Char "Char";
import Iter "Iter";
import Runtime "Runtime";
import Order "Order";

module {

  /// Infinite precision natural numbers.
  public type Nat = Prim.Types.Nat;

  /// Converts a natural number to its textual representation. Textual
  /// representation _do not_ contain underscores to represent commas.
  ///
  /// Example:
  /// ```motoko include=import
  /// Nat.toText(1234) // => "1234"
  /// ```
  public func toText(n : Nat) : Text = Int.toText n;

  /// Creates a natural number from its textual representation. Returns `null`
  /// if the input is not a valid natural number.
  ///
  /// The textual representation _must not_ contain underscores.
  ///
  /// Example:
  /// ```motoko include=import
  /// Nat.fromText("1234") // => ?1234
  /// ```
  public func fromText(text : Text) : ?Nat {
    if (text == "") {
      return null
    };
    var n = 0;
    for (c in text.chars()) {
      if (Char.isDigit(c)) {
        let charAsNat = Prim.nat32ToNat(Prim.charToNat32(c) -% Prim.charToNat32('0'));
        n := n * 10 + charAsNat
      } else {
        return null
      }
    };
    ?n
  };

  /// Converts an integer to a natural number. Returns `null` if the integer is negative.
  ///
  /// Example:
  /// ```motoko include=import
  /// Nat.fromInt(1234) // => 1234 : Nat
  /// ```
  public func fromInt(int : Int) : Nat {
    if (int < 0) {
      Runtime.trap("Nat.fromInt(): negative input value")
    } else {
      Int.abs(int)
    }
  };

  /// Converts a natural number to an integer.
  ///
  /// Example:
  /// ```motoko include=import
  /// assert Nat.toInt(1234) == 1234
  /// ```
  public func toInt(nat : Nat) : Int {
    nat : Int
  };

  /// Returns the minimum of `x` and `y`.
  ///
  /// Example:
  /// ```motoko include=import
  /// Nat.min(1, 2) // => 1
  /// ```
  public func min(x : Nat, y : Nat) : Nat {
    if (x < y) { x } else { y }
  };

  /// Returns the maximum of `x` and `y`.
  ///
  /// Example:
  /// ```motoko include=import
  /// Nat.max(1, 2) // => 2
  /// ```
  public func max(x : Nat, y : Nat) : Nat {
    if (x < y) { y } else { x }
  };

  /// Equality function for Nat types.
  /// This is equivalent to `x == y`.
  ///
  /// Example:
  /// ```motoko include=import
  /// ignore Nat.equal(1, 1); // => true
  /// 1 == 1 // => true
  /// ```
  ///
  /// Note: The reason why this function is defined in this library (in addition
  /// to the existing `==` operator) is so that you can use it as a function
  /// value to pass to a higher order function. It is not possible to use `==`
  /// as a function value at the moment.
  ///
  /// Example:
  /// ```motoko include=import
  /// let a = 111;
  /// let b = 222;
  /// Nat.equal(a, b) // => false
  /// ```
  public func equal(x : Nat, y : Nat) : Bool { x == y };

  /// Inequality function for Nat types.
  /// This is equivalent to `x != y`.
  ///
  /// Example:
  /// ```motoko include=import
  /// ignore Nat.notEqual(1, 2); // => true
  /// 1 != 2 // => true
  /// ```
  ///
  /// Note: The reason why this function is defined in this library (in addition
  /// to the existing `!=` operator) is so that you can use it as a function
  /// value to pass to a higher order function. It is not possible to use `!=`
  /// as a function value at the moment.
  public func notEqual(x : Nat, y : Nat) : Bool { x != y };

  /// "Less than" function for Nat types.
  /// This is equivalent to `x < y`.
  ///
  /// Example:
  /// ```motoko include=import
  /// ignore Nat.less(1, 2); // => true
  /// 1 < 2 // => true
  /// ```
  ///
  /// Note: The reason why this function is defined in this library (in addition
  /// to the existing `<` operator) is so that you can use it as a function
  /// value to pass to a higher order function. It is not possible to use `<`
  /// as a function value at the moment.
  public func less(x : Nat, y : Nat) : Bool { x < y };

  /// "Less than or equal" function for Nat types.
  /// This is equivalent to `x <= y`.
  ///
  /// Example:
  /// ```motoko include=import
  /// ignore Nat.lessOrEqual(1, 2); // => true
  /// 1 <= 2 // => true
  /// ```
  ///
  /// Note: The reason why this function is defined in this library (in addition
  /// to the existing `<=` operator) is so that you can use it as a function
  /// value to pass to a higher order function. It is not possible to use `<=`
  /// as a function value at the moment.
  public func lessOrEqual(x : Nat, y : Nat) : Bool { x <= y };

  /// "Greater than" function for Nat types.
  /// This is equivalent to `x > y`.
  ///
  /// Example:
  /// ```motoko include=import
  /// ignore Nat.greater(2, 1); // => true
  /// 2 > 1 // => true
  /// ```
  ///
  /// Note: The reason why this function is defined in this library (in addition
  /// to the existing `>` operator) is so that you can use it as a function
  /// value to pass to a higher order function. It is not possible to use `>`
  /// as a function value at the moment.
  public func greater(x : Nat, y : Nat) : Bool { x > y };

  /// "Greater than or equal" function for Nat types.
  /// This is equivalent to `x >= y`.
  ///
  /// Example:
  /// ```motoko include=import
  /// ignore Nat.greaterOrEqual(2, 1); // => true
  /// 2 >= 1 // => true
  /// ```
  ///
  /// Note: The reason why this function is defined in this library (in addition
  /// to the existing `>=` operator) is so that you can use it as a function
  /// value to pass to a higher order function. It is not possible to use `>=`
  /// as a function value at the moment.
  public func greaterOrEqual(x : Nat, y : Nat) : Bool { x >= y };

  /// General purpose comparison function for `Nat`. Returns the `Order` (
  /// either `#less`, `#equal`, or `#greater`) of comparing `x` with `y`.
  ///
  /// Example:
  /// ```motoko include=import
  /// Nat.compare(2, 3) // => #less
  /// ```
  ///
  /// This function can be used as value for a high order function, such as a sort function.
  ///
  /// Example:
  /// ```motoko include=import
  /// import Array "mo:base/Array";
  /// Array.sort([2, 3, 1], Nat.compare) // => [1, 2, 3]
  /// ```
  public func compare(x : Nat, y : Nat) : Order.Order {
    if (x < y) { #less } else if (x == y) { #equal } else { #greater }
  };

  /// Returns the sum of `x` and `y`, `x + y`. This operator will never overflow
  /// because `Nat` is infinite precision.
  ///
  /// Example:
  /// ```motoko include=import
  /// ignore Nat.add(1, 2); // => 3
  /// 1 + 2 // => 3
  /// ```
  ///
  /// Note: The reason why this function is defined in this library (in addition
  /// to the existing `+` operator) is so that you can use it as a function
  /// value to pass to a higher order function. It is not possible to use `+`
  /// as a function value at the moment.
  ///
  /// Example:
  /// ```motoko include=import
  /// import Array "mo:base/Array";
  /// Array.foldLeft([2, 3, 1], 0, Nat.add) // => 6
  /// ```
  public func add(x : Nat, y : Nat) : Nat { x + y };

  /// Returns the difference of `x` and `y`, `x - y`.
  /// Traps on underflow below `0`.
  ///
  /// Example:
  /// ```motoko include=import
  /// ignore Nat.sub(2, 1); // => 1
  /// // Add a type annotation to avoid a warning about the subtraction
  /// 2 - 1 : Nat // => 1
  /// ```
  ///
  /// Note: The reason why this function is defined in this library (in addition
  /// to the existing `-` operator) is so that you can use it as a function
  /// value to pass to a higher order function. It is not possible to use `-`
  /// as a function value at the moment.
  ///
  /// Example:
  /// ```motoko include=import
  /// import Array "mo:base/Array";
  /// Array.foldLeft([2, 3, 1], 10, Nat.sub) // => 4
  /// ```
  public func sub(x : Nat, y : Nat) : Nat { x - y };

  /// Returns the product of `x` and `y`, `x * y`. This operator will never
  /// overflow because `Nat` is infinite precision.
  ///
  /// Example:
  /// ```motoko include=import
  /// ignore Nat.mul(2, 3); // => 6
  /// 2 * 3 // => 6
  /// ```
  ///
  /// Note: The reason why this function is defined in this library (in addition
  /// to the existing `*` operator) is so that you can use it as a function
  /// value to pass to a higher order function. It is not possible to use `*`
  /// as a function value at the moment.
  ///
  /// Example:
  /// ```motoko include=import
  /// import Array "mo:base/Array";
  /// Array.foldLeft([2, 3, 1], 1, Nat.mul) // => 6
  /// ```
  public func mul(x : Nat, y : Nat) : Nat { x * y };

  /// Returns the unsigned integer division of `x` by `y`,  `x / y`.
  /// Traps when `y` is zero.
  ///
  /// The quotient is rounded down, which is equivalent to truncating the
  /// decimal places of the quotient.
  ///
  /// Example:
  /// ```motoko include=import
  /// ignore Nat.div(6, 2); // => 3
  /// 6 / 2 // => 3
  /// ```
  ///
  /// Note: The reason why this function is defined in this library (in addition
  /// to the existing `/` operator) is so that you can use it as a function
  /// value to pass to a higher order function. It is not possible to use `/`
  /// as a function value at the moment.
  public func div(x : Nat, y : Nat) : Nat { x / y };

  /// Returns the remainder of unsigned integer division of `x` by `y`,  `x % y`.
  /// Traps when `y` is zero.
  ///
  /// Example:
  /// ```motoko include=import
  /// ignore Nat.rem(6, 4); // => 2
  /// 6 % 4 // => 2
  /// ```
  ///
  /// Note: The reason why this function is defined in this library (in addition
  /// to the existing `%` operator) is so that you can use it as a function
  /// value to pass to a higher order function. It is not possible to use `%`
  /// as a function value at the moment.
  public func rem(x : Nat, y : Nat) : Nat { x % y };

  /// Returns `x` to the power of `y`, `x ** y`. Traps when `y > 2^32`. This operator
  /// will never overflow because `Nat` is infinite precision.
  ///
  /// Example:
  /// ```motoko include=import
  /// ignore Nat.pow(2, 3); // => 8
  /// 2 ** 3 // => 8
  /// ```
  ///
  /// Note: The reason why this function is defined in this library (in addition
  /// to the existing `**` operator) is so that you can use it as a function
  /// value to pass to a higher order function. It is not possible to use `**`
  /// as a function value at the moment.
  public func pow(x : Nat, y : Nat) : Nat { x ** y };

  /// Returns the (conceptual) bitwise shift left of `x` by `y`, `x * (2 ** y)`.
  ///
  /// Example:
  /// ```motoko include=import
  /// Nat.bitshiftLeft(1, 3); // => 8
  /// ```
  ///
  /// Note: The reason why this function is defined in this library (in absence
  /// of the `<<` operator) is so that you can use it as a function
  /// value to pass to a higher order function. While `Nat` is not defined in terms
  /// of bit patterns, conceptually it can be regarded as such, and the operation
  /// is provided as a high-performance version of the corresponding arithmetic
  /// rule.
  public func bitshiftLeft(x : Nat, y : Nat32) : Nat { Prim.shiftLeft(x, y) };

  /// Returns the (conceptual) bitwise shift right of `x` by `y`, `x / (2 ** y)`.
  ///
  /// Example:
  /// ```motoko include=import
  /// Nat.bitshiftRight(8, 3); // => 1
  /// ```
  ///
  /// Note: The reason why this function is defined in this library (in absence
  /// of the `>>` operator) is so that you can use it as a function
  /// value to pass to a higher order function. While `Nat` is not defined in terms
  /// of bit patterns, conceptually it can be regarded as such, and the operation
  /// is provided as a high-performance version of the corresponding arithmetic
  /// rule.
  public func bitshiftRight(x : Nat, y : Nat32) : Nat { Prim.shiftRight(x, y) };

  /// Returns an iterator over `Nat` values from the first to second argument with an exclusive upper bound.
  /// ```motoko include=import
  /// import Iter "mo:base/Iter";
  ///
  /// let iter = Nat.range(1, 4);
  /// assert(?1 == iter.next());
  /// assert(?2 == iter.next());
  /// assert(?3 == iter.next());
  /// assert(null == iter.next());
  /// ```
  ///
  /// If the first argument is greater than the second argument, the function returns an empty iterator.
  /// ```motoko include=import
  /// import Iter "mo:base/Iter";
  ///
  /// let iter = Nat.range(4, 1);
  /// assert(null == iter.next()); // empty iterator
  /// ```
  public func range(fromInclusive : Nat, toExclusive : Nat) : Iter.Iter<Nat> = object {
    var n = fromInclusive;
    public func next() : ?Nat {
      if (n >= toExclusive) {
        return null
      };
      let current = n;
      n += 1;
      ?current
    }
  };

  /// Returns an iterator over `Nat` values from the first to second argument with an exclusive upper bound,
  /// incrementing by the specified step size. The step can be positive or negative.
  /// ```motoko include=import
  /// import Iter "mo:base/Iter";
  ///
  /// // Positive step
  /// let iter1 = Nat.rangeBy(1, 7, 2);
  /// assert(?1 == iter1.next());
  /// assert(?3 == iter1.next());
  /// assert(?5 == iter1.next());
  /// assert(null == iter1.next());
  ///
  /// // Negative step
  /// let iter2 = Nat.rangeBy(7, 1, -2);
  /// assert(?7 == iter2.next());
  /// assert(?5 == iter2.next());
  /// assert(?3 == iter2.next());
  /// assert(null == iter2.next());
  /// ```
  ///
  /// If `step` is 0 or if the iteration would not progress towards the bound, returns an empty iterator.
  public func rangeBy(fromInclusive : Nat, toExclusive : Nat, step : Int) : Iter.Iter<Nat> {
    if (step == 0) {
      Iter.empty()
    } else if (step > 0) {
      object {
        let stepMagnitude = Int.abs(step);
        var n = fromInclusive;
        public func next() : ?Nat {
          if (n >= toExclusive) {
            return null
          };
          let current = n;
          n += stepMagnitude;
          ?current
        }
      }
    } else {
      object {
        let stepMagnitude = Int.abs(step);
        var n = fromInclusive;
        public func next() : ?Nat {
          if (n <= toExclusive) {
            return null
          };
          let current = n;
          if (stepMagnitude > n) {
            n := 0
          } else {
            n -= stepMagnitude
          };
          ?current
        }
      }
    }
  };

  /// Returns an iterator over the integers from the first to second argument, inclusive.
  /// ```motoko include=import
  /// import Iter "mo:base/Iter";
  ///
  /// let iter = Nat.rangeInclusive(1, 3);
  /// assert(?1 == iter.next());
  /// assert(?2 == iter.next());
  /// assert(?3 == iter.next());
  /// assert(null == iter.next());
  /// ```
  ///
  /// If the first argument is greater than the second argument, the function returns an empty iterator.
  /// ```motoko include=import
  /// import Iter "mo:base/Iter";
  ///
  /// let iter = Nat.rangeInclusive(3, 1);
  /// assert(null == iter.next()); // empty iterator
  /// ```
  public func rangeInclusive(from : Nat, to : Nat) : Iter.Iter<Nat> = object {
    var n = from;
    public func next() : ?Nat {
      if (n > to) {
        return null
      };
      let current = n;
      n += 1;
      ?current
    }
  };

  /// Returns an iterator over the integers from the first to second argument, inclusive,
  /// incrementing by the specified step size. The step can be positive or negative.
  /// ```motoko include=import
  /// import Iter "mo:base/Iter";
  ///
  /// // Positive step
  /// let iter1 = Nat.rangeByInclusive(1, 7, 2);
  /// assert(?1 == iter1.next());
  /// assert(?3 == iter1.next());
  /// assert(?5 == iter1.next());
  /// assert(?7 == iter1.next());
  /// assert(null == iter1.next());
  ///
  /// // Negative step
  /// let iter2 = Nat.rangeByInclusive(7, 1, -2);
  /// assert(?7 == iter2.next());
  /// assert(?5 == iter2.next());
  /// assert(?3 == iter2.next());
  /// assert(?1 == iter2.next());
  /// assert(null == iter2.next());
  /// ```
  ///
  /// If `from == to`, return an iterator which only
  ///
  /// Otherwise, if `step` is 0 or if the iteration would not progress towards the bound, returns an empty iterator.
  public func rangeByInclusive(from : Nat, to : Nat, step : Int) : Iter.Iter<Nat> {
    if (from == to) {
      Iter.singleton(from)
    } else if (step > 0) {
      object {
        let stepMagnitude = Int.abs(step);
        var n = from;
        public func next() : ?Nat {
          if (n >= to + 1) {
            return null
          };
          let current = n;
          n += stepMagnitude;
          ?current
        }
      }
    } else {
      object {
        let stepMagnitude = Int.abs(step);
        var n = from;
        public func next() : ?Nat {
          if (n + 1 <= to) {
            return null
          };
          let current = n;
          if (stepMagnitude > n) {
            n := 0
          } else {
            n -= stepMagnitude
          };
          ?current
        }
      }
    }
  };

  /// Returns an infinite iterator over all possible `Nat` values.
  /// ```motoko include=import
  /// import Iter "mo:base/Iter";
  ///
  /// let iter = Nat.allValues();
  /// assert(?0 == iter.next());
  /// assert(?1 == iter.next());
  /// assert(?2 == iter.next());
  /// // ...
  /// ```
  public func allValues() : Iter.Iter<Nat> = object {
    var n = 0;
    public func next() : ?Nat {
      let current = n;
      n += 1;
      ?current
    }
  };

}
