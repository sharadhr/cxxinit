#if defined(__cpp_modules) && (__cpp_modules >= 202207L)
import std;
#else
#include <print>
#endif

auto main() -> int
{
  std::print("Hello, World!\n");
  return 0;
}
