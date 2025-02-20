///|
type Memory[_]

///|
pub fn Memory::to_int[T](self : Memory[T]) -> Int {
  let _ = self
  panic()
}

///|
fn _array_to_memory[T](ptr : FixedArray[T]) -> Memory[T] = "%identity"

///|
fn _array_of_memory[T](value : Memory[T]) -> FixedArray[T] = "%identity"

///|
fn _string_to_memory(ptr : String) -> Memory[Byte] = "%identity"

///|
fn _string_of_memory(value : Memory[Byte]) -> String = "%identity"

///|
fn Memory::cast[T, U](self : Memory[T]) -> Memory[U] = "%identity"

///|
/// This will be compiled as `+` and will be inlined. This way we can bypass the
/// typecheck on the C side.
fn _array_add[T](array : FixedArray[T], offset : Int) -> FixedArray[T] = "%u64.add"

///|
fn _array_sub[T](array : FixedArray[T], offset : Int) -> FixedArray[T] = "%u64.sub"

///|
fn _string_add(string : String, offset : Int) -> String = "%u64.add"

///|
fn _string_sub(string : String, offset : Int) -> String = "%u64.sub"

///|
pub fn Memory::to_array[T : Sized + Default + Get + Set](
  self : Memory[T]
) -> FixedArray[T] {
  _array_sub(_array_of_memory(self), 1)
}

///|
pub fn Memory::of_array[T : Sized + Default + Set](
  array : FixedArray[T]
) -> Memory[T] {
  _array_to_memory(_array_add(array, 1))
}

///|
pub fn Memory::to_string(self : Memory[Byte]) -> String {
  _string_sub(_string_of_memory(self), 1)
}

///|
pub fn Memory::of_string(string : String) -> Memory[Byte] {
  _string_to_memory(_string_add(string, 1))
}

///|
pub fn Memory::length[T : Sized + Default + Get + Set](self : Memory[T]) -> Int {
  let array = self.to_array()
  let length = array.length()
  _moonbit_incref(array)
  length
}
