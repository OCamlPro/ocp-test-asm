
#include <sys/types.h>

__int64_t imulh(int64_t x, int64_t y)
{
  __int128_t r = (__int128_t)x * (__int128_t)y;
  return (int64_t)(r >> 64);
}
