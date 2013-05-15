#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;
use Math::Prime::Util qw/is_prob_prime/;

my $use64 = Math::Prime::Util::prime_get_config->{'maxbits'} > 32;
my $broken64 = (18446744073709550592 == ~0);

my @small_primes = qw/
2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97
101 103 107 109 113 127 131 137 139 149 151 157 163 167 173 179 181 191 193 197
199 211 223 227 229 233 239 241 251 257 263 269 271 277 281 283 293 307 311 313
317 331 337 347 349 353 359 367 373 379 383 389 397 401 409 419 421 431 433 439
443 449 457 461 463 467 479 487 491 499 503 509 521 523 541 547 557 563 569 571
577 587 593 599 601 607 613 617 619 631 641 643 647 653 659 661 673 677 683 691
701 709 719 727 733 739 743 751 757 761 769 773 787 797 809 811 821 823 827 829
839 853 857 859 863 877 881 883 887 907 911 919 929 937 941 947 953 967 971 977
983 991 997
1009 1013 1019 1021 1031 1033 1039 1049 1051 1061 1063 1069 1087 1091 1093 1097
1103 1109 1117 1123 1129 1151 1153 1163 1171 1181 1187 1193 1201 1213 1217 1223
1229 1231 1237 1249 1259 1277 1279 1283 1289 1291 1297 1301 1303 1307 1319 1321
1327 1361 1367 1373 1381 1399 1409 1423 1427 1429 1433 1439 1447 1451 1453 1459
1471 1481 1483 1487 1489 1493 1499 1511 1523 1531 1543 1549 1553 1559 1567 1571
1579 1583 1597 1601 1607 1609 1613 1619 1621 1627 1637 1657 1663 1667 1669 1693
1697 1699 1709 1721 1723 1733 1741 1747 1753 1759 1777 1783 1787 1789 1801 1811
1823 1831 1847 1861 1867 1871 1873 1877 1879 1889 1901 1907 1913 1931 1933 1949
1951 1973 1979 1987 1993 1997 1999 2003 2011 2017 2027 2029 2039 2053 2063 2069
2081 2083 2087 2089 2099 2111 2113 2129 2131 2137 2141 2143 2153 2161 2179 2203
2207 2213 2221 2237 2239 2243 2251 2267 2269 2273 2281 2287 2293 2297 2309 2311
2333 2339 2341 2347 2351 2357 2371 2377 2381 2383 2389 2393 2399 2411 2417 2423
2437 2441 2447 2459 2467 2473 2477 2503 2521 2531 2539 2543 2549 2551 2557 2579
2591 2593 2609 2617 2621 2633 2647 2657 2659 2663 2671 2677 2683 2687 2689 2693
2699 2707 2711 2713 2719 2729 2731 2741 2749 2753 2767 2777 2789 2791 2797 2801
2803 2819 2833 2837 2843 2851 2857 2861 2879 2887 2897 2903 2909 2917 2927 2939
2953 2957 2963 2969 2971 2999 3001 3011 3019 3023 3037 3041 3049 3061 3067 3079
3083 3089 3109 3119 3121 3137 3163 3167 3169 3181 3187 3191 3203 3209 3217 3221
3229 3251 3253 3257 3259 3271 3299 3301 3307 3313 3319 3323 3329 3331 3343 3347
3359 3361 3371 3373 3389 3391 3407 3413 3433 3449 3457 3461 3463 3467 3469 3491
3499 3511 3517 3527 3529 3533 3539 3541 3547 3557 3559 3571 /;

my @composites = (qw/
  9 121 341 561 645 703 781 1105 1387 1541 1729 1891 1905 2047 2465 2701 2821
  3277 3281 4033 4369 4371 4681 5461 5611 6601 7813 7957 8321 8401 8911 10585
  12403 13021 14981 15751 15841 16531 18721 19345 23521 24211 25351 29341
  29539 31621 38081 40501 41041 44287 44801 46657 47197 52633 53971 55969
  62745 63139 63973 74593 75361 79003 79381 82513 87913 88357 88573 97567
  101101 340561 488881 852841 1373653 1857241 6733693 9439201 17236801
  23382529 25326001 34657141 56052361 146843929 216821881 3215031751 /);

push @composites, (qw/
  2152302898747 3474749660383 341550071728321 341550071728321
  3825123056546413051/) if $use64;

my @primes = (qw/
  2 3 7 23 89 113 523 887 1129 1327 9551 15683 19609 31397 155921
  5 11 29 97 127 541 907 1151 1361 9587 15727 19661 31469 156007 360749
  370373 492227 1349651 1357333 2010881 4652507 17051887 20831533 47326913
  122164969 189695893 191913031 387096383 436273291 1294268779 1453168433
  2300942869 3842611109/);

push @primes, (qw/
  4302407713 10726905041 20678048681 22367085353 25056082543 42652618807
  127976334671 182226896239 241160624143 297501075799 303371455241
  304599508537 416608695821 461690510011 614487453523 738832927927
  1346294310749 1408695493609 1968188556461 2614941710599/) if $use64;

# We're checking every integer from 0 to small_primes[-1], so don't bother
# checking them twice.
@composites = grep { $_ > $small_primes[-1] } @composites;
@primes     = grep { $_ > $small_primes[-1] } @primes;


plan tests =>   6   # range
              + 1   # powers of 2
              + 1   # small numbers
              + scalar @composites
              + scalar @primes
              + 1 # 32-bit or 64-bit edge
              + 0;

ok(!eval { is_prob_prime(undef); }, "is_prob_prime(undef)");
ok( is_prob_prime(2),  '2 is prime');
ok(!is_prob_prime(1),  '1 is not prime');
ok(!is_prob_prime(0),  '0 is not prime');
ok(!is_prob_prime(-1), '-1 is not prime');
ok(!is_prob_prime(-2), '-2 is not prime');

{
  my @isprime = map { 0+!!is_prob_prime( int(2**$_) ) } (2..20);
  my @exprime = (0) x (20-2+1);
  is_deeply( \@isprime, \@exprime, "is_prob_prime powers of 2" );
}

{
  my %small_primes = map { $_ => 1; } @small_primes;
  my @isprime = map { is_prob_prime($_) } (0..3572);
  my @exprime = map { $small_primes{$_} ? 2 : 0 } (0..3572);
  is_deeply( \@isprime, \@exprime, "is_prob_prime 0..3572" );
}

foreach my $n (@composites) {
  is( is_prob_prime($n), 0, "$n is composite" );
}
foreach my $n (@primes) {
  is( is_prob_prime($n), 2, "$n is definitely prime" );
}

# Check that we do the right thing near the word-size edge
SKIP: {
  skip "Skipping 64-bit edge case on broken 64-bit Perl", 1 if $use64 && $broken64;
  eval { is_prob_prime( $use64 ? "18446744073709551629" : "4294967306" ); };
  like($@, qr/range/i, "is_prob_prime on ~0 + delta without bigint should croak");
}
