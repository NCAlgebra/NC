// gcd.c

long gcd(long m,long n) {
  while (n != 0L) {
    long t = m % n;
    m = n;
    n = t;
  }
  return m;
};
