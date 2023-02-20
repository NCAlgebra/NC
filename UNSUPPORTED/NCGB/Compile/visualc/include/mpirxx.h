/* mpirxx.h -- C++ class wrapper for GMP types.  -*- C++ -*-

Copyright 2001, 2002, 2003, 2006 Free Software Foundation, Inc.

Copyright 2009 William Hart

This file is part of the GNU MP Library.

The GNU MP Library is free software; you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation; either version 2.1 of the License, or (at your
option) any later version.

The GNU MP Library is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
License for more details.

You should have received a copy of the GNU Lesser General Public License
along with the GNU MP Library; see the file COPYING.LIB.  If not, write to
the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
MA 02110-1301, USA. */

/* the C++ compiler must implement the following features:
   - member templates
   - partial specialization of templates
   - namespace support
   for g++, this means version 2.91 or higher
   for other compilers, I don't know */
#ifdef __GNUC__
#if __GNUC__ < 2 || (__GNUC__ == 2 && __GNUC_MINOR__ < 91)
#error mpirxx.h requires g++ version 2.91 (egcs 1.1.2) or higher
#endif
#endif

#ifndef __GMP_PLUSPLUS__
#define __GMP_PLUSPLUS__

#include <iosfwd>

#include <cstring>  /* for strlen */
#include <string>
#include <stdexcept>
#include <mpir.h>

/**************** Function objects ****************/
/* Any evaluation of a __gmp_expr ends up calling one of these functions
   all intermediate functions being inline, the evaluation should optimize
   to a direct call to the relevant function, thus yielding no overhead
   over the C interface. */

struct __gmp_unary_plus
{
  static void eval(mpz_ptr z, mpz_srcptr w) { mpz_set(z, w); }
  static void eval(mpq_ptr q, mpq_srcptr r) { mpq_set(q, r); }
  static void eval(mpf_ptr f, mpf_srcptr g) { mpf_set(f, g); }
};

struct __gmp_unary_minus
{
  static void eval(mpz_ptr z, mpz_srcptr w) { mpz_neg(z, w); }
  static void eval(mpq_ptr q, mpq_srcptr r) { mpq_neg(q, r); }
  static void eval(mpf_ptr f, mpf_srcptr g) { mpf_neg(f, g); }
};

struct __gmp_unary_com
{
  static void eval(mpz_ptr z, mpz_srcptr w) { mpz_com(z, w); }
};

struct __gmp_binary_plus
{
  static void eval(mpz_ptr z, mpz_srcptr w, mpz_srcptr v)
  { mpz_add(z, w, v); }

  static void eval(mpz_ptr z, mpz_srcptr w, unsigned long int l)
  { mpz_add_ui(z, w, l); }
  static void eval(mpz_ptr z, unsigned long int l, mpz_srcptr w)
  { mpz_add_ui(z, w, l); }
  static void eval(mpz_ptr z, mpz_srcptr w, signed long int l)
  {
    if (l >= 0)
      mpz_add_ui(z, w, l);
    else
      mpz_sub_ui(z, w, -l);
  }
  static void eval(mpz_ptr z, signed long int l, mpz_srcptr w)
  {
    if (l >= 0)
      mpz_add_ui(z, w, l);
    else
      mpz_sub_ui(z, w, -l);
  }
  static void eval(mpz_ptr z, mpz_srcptr w, double d)
  {
    mpz_t temp;
    mpz_init_set_d(temp, d);
    mpz_add(z, w, temp);
    mpz_clear(temp);
  }
  static void eval(mpz_ptr z, double d, mpz_srcptr w)
  {
    mpz_t temp;
    mpz_init_set_d(temp, d);
    mpz_add(z, temp, w);
    mpz_clear(temp);
  }

  static void eval(mpq_ptr q, mpq_srcptr r, mpq_srcptr s)
  { mpq_add(q, r, s); }

  static void eval(mpq_ptr q, mpq_srcptr r, unsigned long int l)
  { mpq_set(q, r); mpz_addmul_ui(mpq_numref(q), mpq_denref(q), l); }
  static void eval(mpq_ptr q, unsigned long int l, mpq_srcptr r)
  { mpq_set(q, r); mpz_addmul_ui(mpq_numref(q), mpq_denref(q), l); }
  static void eval(mpq_ptr q, mpq_srcptr r, signed long int l)
  {
    mpq_set(q, r);
    if (l >= 0)
      mpz_addmul_ui(mpq_numref(q), mpq_denref(q), l);
    else
      mpz_submul_ui(mpq_numref(q), mpq_denref(q), -l);
  }
  static void eval(mpq_ptr q, signed long int l, mpq_srcptr r)
  {
    mpq_set(q, r);
    if (l >= 0)
      mpz_addmul_ui(mpq_numref(q), mpq_denref(q), l);
    else
      mpz_submul_ui(mpq_numref(q), mpq_denref(q), -l);
  }
  static void eval(mpq_ptr q, mpq_srcptr r, double d)
  {
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    mpq_add(q, r, temp);
    mpq_clear(temp);
  }
  static void eval(mpq_ptr q, double d, mpq_srcptr r)
  {
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    mpq_add(q, temp, r);
    mpq_clear(temp);
  }

  static void eval(mpq_ptr q, mpq_srcptr r, mpz_srcptr z)
  { mpq_set(q, r); mpz_addmul(mpq_numref(q), mpq_denref(q), z); }
  static void eval(mpq_ptr q, mpz_srcptr z, mpq_srcptr r)
  { mpq_set(q, r); mpz_addmul(mpq_numref(q), mpq_denref(q), z); }

  static void eval(mpf_ptr f, mpf_srcptr g, mpf_srcptr h)
  { mpf_add(f, g, h); }

  static void eval(mpf_ptr f, mpf_srcptr g, unsigned long int l)
  { mpf_add_ui(f, g, l); }
  static void eval(mpf_ptr f, unsigned long int l, mpf_srcptr g)
  { mpf_add_ui(f, g, l); }
  static void eval(mpf_ptr f, mpf_srcptr g, signed long int l)
  {
    if (l >= 0)
      mpf_add_ui(f, g, l);
    else
      mpf_sub_ui(f, g, -l);
  }
  static void eval(mpf_ptr f, signed long int l, mpf_srcptr g)
  {
    if (l >= 0)
      mpf_add_ui(f, g, l);
    else
      mpf_sub_ui(f, g, -l);
  }
  static void eval(mpf_ptr f, mpf_srcptr g, double d)
  {
    mpf_t temp;
    mpf_init2(temp, 8*sizeof(double));
    mpf_set_d(temp, d);
    mpf_add(f, g, temp);
    mpf_clear(temp);
  }
  static void eval(mpf_ptr f, double d, mpf_srcptr g)
  {
    mpf_t temp;
    mpf_init2(temp, 8*sizeof(double));
    mpf_set_d(temp, d);
    mpf_add(f, temp, g);
    mpf_clear(temp);
  }
};

struct __gmp_binary_minus
{
  static void eval(mpz_ptr z, mpz_srcptr w, mpz_srcptr v)
  { mpz_sub(z, w, v); }

  static void eval(mpz_ptr z, mpz_srcptr w, unsigned long int l)
  { mpz_sub_ui(z, w, l); }
  static void eval(mpz_ptr z, unsigned long int l, mpz_srcptr w)
  { mpz_ui_sub(z, l, w); }
  static void eval(mpz_ptr z, mpz_srcptr w, signed long int l)
  {
    if (l >= 0)
      mpz_sub_ui(z, w, l);
    else
      mpz_add_ui(z, w, -l);
  }
  static void eval(mpz_ptr z, signed long int l, mpz_srcptr w)
  {
    if (l >= 0)
      mpz_ui_sub(z, l, w);
    else
      {
        mpz_add_ui(z, w, -l);
        mpz_neg(z, z);
      }
  }
  static void eval(mpz_ptr z, mpz_srcptr w, double d)
  {
    mpz_t temp;
    mpz_init_set_d(temp, d);
    mpz_sub(z, w, temp);
    mpz_clear(temp);
  }
  static void eval(mpz_ptr z, double d, mpz_srcptr w)
  {
    mpz_t temp;
    mpz_init_set_d(temp, d);
    mpz_sub(z, temp, w);
    mpz_clear(temp);
  }

  static void eval(mpq_ptr q, mpq_srcptr r, mpq_srcptr s)
  { mpq_sub(q, r, s); }

  static void eval(mpq_ptr q, mpq_srcptr r, unsigned long int l)
  { mpq_set(q, r); mpz_submul_ui(mpq_numref(q), mpq_denref(q), l); }
  static void eval(mpq_ptr q, unsigned long int l, mpq_srcptr r)
  { mpq_neg(q, r); mpz_addmul_ui(mpq_numref(q), mpq_denref(q), l); }
  static void eval(mpq_ptr q, mpq_srcptr r, signed long int l)
  {
    mpq_set(q, r);
    if (l >= 0)
      mpz_submul_ui(mpq_numref(q), mpq_denref(q), l);
    else
      mpz_addmul_ui(mpq_numref(q), mpq_denref(q), -l);
  }
  static void eval(mpq_ptr q, signed long int l, mpq_srcptr r)
  {
    mpq_neg(q, r);
    if (l >= 0)
      mpz_addmul_ui(mpq_numref(q), mpq_denref(q), l);
    else
      mpz_submul_ui(mpq_numref(q), mpq_denref(q), -l);
  }
  static void eval(mpq_ptr q, mpq_srcptr r, double d)
  {
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    mpq_sub(q, r, temp);
    mpq_clear(temp);
  }
  static void eval(mpq_ptr q, double d, mpq_srcptr r)
  {
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    mpq_sub(q, temp, r);
    mpq_clear(temp);
  }

  static void eval(mpq_ptr q, mpq_srcptr r, mpz_srcptr z)
  { mpq_set(q, r); mpz_submul(mpq_numref(q), mpq_denref(q), z); }
  static void eval(mpq_ptr q, mpz_srcptr z, mpq_srcptr r)
  { mpq_neg(q, r); mpz_addmul(mpq_numref(q), mpq_denref(q), z); }

  static void eval(mpf_ptr f, mpf_srcptr g, mpf_srcptr h)
  { mpf_sub(f, g, h); }

  static void eval(mpf_ptr f, mpf_srcptr g, unsigned long int l)
  { mpf_sub_ui(f, g, l); }
  static void eval(mpf_ptr f, unsigned long int l, mpf_srcptr g)
  { mpf_ui_sub(f, l, g); }
  static void eval(mpf_ptr f, mpf_srcptr g, signed long int l)
  {
    if (l >= 0)
      mpf_sub_ui(f, g, l);
    else
      mpf_add_ui(f, g, -l);
  }
  static void eval(mpf_ptr f, signed long int l, mpf_srcptr g)
  {
    if (l >= 0)
      mpf_sub_ui(f, g, l);
    else
      mpf_add_ui(f, g, -l);
    mpf_neg(f, f);
  }
  static void eval(mpf_ptr f, mpf_srcptr g, double d)
  {
    mpf_t temp;
    mpf_init2(temp, 8*sizeof(double));
    mpf_set_d(temp, d);
    mpf_sub(f, g, temp);
    mpf_clear(temp);
  }
  static void eval(mpf_ptr f, double d, mpf_srcptr g)
  {
    mpf_t temp;
    mpf_init2(temp, 8*sizeof(double));
    mpf_set_d(temp, d);
    mpf_sub(f, temp, g);
    mpf_clear(temp);
  }
};

struct __gmp_binary_multiplies
{
  static void eval(mpz_ptr z, mpz_srcptr w, mpz_srcptr v)
  { mpz_mul(z, w, v); }

  static void eval(mpz_ptr z, mpz_srcptr w, unsigned long int l)
  { mpz_mul_ui(z, w, l); }
  static void eval(mpz_ptr z, unsigned long int l, mpz_srcptr w)
  { mpz_mul_ui(z, w, l); }
  static void eval(mpz_ptr z, mpz_srcptr w, signed long int l)
  { mpz_mul_si (z, w, l); }
  static void eval(mpz_ptr z, signed long int l, mpz_srcptr w)
  { mpz_mul_si (z, w, l); }
  static void eval(mpz_ptr z, mpz_srcptr w, double d)
  {
    mpz_t temp;
    mpz_init_set_d(temp, d);
    mpz_mul(z, w, temp);
    mpz_clear(temp);
  }
  static void eval(mpz_ptr z, double d, mpz_srcptr w)
  {
    mpz_t temp;
    mpz_init_set_d(temp, d);
    mpz_mul(z, temp, w);
    mpz_clear(temp);
  }

  static void eval(mpq_ptr q, mpq_srcptr r, mpq_srcptr s)
  { mpq_mul(q, r, s); }

  static void eval(mpq_ptr q, mpq_srcptr r, unsigned long int l)
  {
    mpq_t temp;
    mpq_init(temp);
    mpq_set_ui(temp, l, 1);
    mpq_mul(q, r, temp);
    mpq_clear(temp);
  }
  static void eval(mpq_ptr q, unsigned long int l, mpq_srcptr r)
  {
    mpq_t temp;
    mpq_init(temp);
    mpq_set_ui(temp, l, 1);
    mpq_mul(q, temp, r);
    mpq_clear(temp);
  }
  static void eval(mpq_ptr q, mpq_srcptr r, signed long int l)
  {
    mpq_t temp;
    mpq_init(temp);
    mpq_set_si(temp, l, 1);
    mpq_mul(q, r, temp);
    mpq_clear(temp);
  }
  static void eval(mpq_ptr q, signed long int l, mpq_srcptr r)
  {
    mpq_t temp;
    mpq_init(temp);
    mpq_set_si(temp, l, 1);
    mpq_mul(q, temp, r);
    mpq_clear(temp);
  }
  static void eval(mpq_ptr q, mpq_srcptr r, double d)
  {
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    mpq_mul(q, r, temp);
    mpq_clear(temp);
  }
  static void eval(mpq_ptr q, double d, mpq_srcptr r)
  {
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    mpq_mul(q, temp, r);
    mpq_clear(temp);
  }

  static void eval(mpf_ptr f, mpf_srcptr g, mpf_srcptr h)
  { mpf_mul(f, g, h); }

  static void eval(mpf_ptr f, mpf_srcptr g, unsigned long int l)
  { mpf_mul_ui(f, g, l); }
  static void eval(mpf_ptr f, unsigned long int l, mpf_srcptr g)
  { mpf_mul_ui(f, g, l); }
  static void eval(mpf_ptr f, mpf_srcptr g, signed long int l)
  {
    if (l >= 0)
      mpf_mul_ui(f, g, l);
    else
      {
	mpf_mul_ui(f, g, -l);
	mpf_neg(f, f);
      }
  }
  static void eval(mpf_ptr f, signed long int l, mpf_srcptr g)
  {
    if (l >= 0)
      mpf_mul_ui(f, g, l);
    else
      {
	mpf_mul_ui(f, g, -l);
	mpf_neg(f, f);
      }
  }
  static void eval(mpf_ptr f, mpf_srcptr g, double d)
  {
    mpf_t temp;
    mpf_init2(temp, 8*sizeof(double));
    mpf_set_d(temp, d);
    mpf_mul(f, g, temp);
    mpf_clear(temp);
  }
  static void eval(mpf_ptr f, double d, mpf_srcptr g)
  {
    mpf_t temp;
    mpf_init2(temp, 8*sizeof(double));
    mpf_set_d(temp, d);
    mpf_mul(f, temp, g);
    mpf_clear(temp);
  }
};

struct __gmp_binary_divides
{
  static void eval(mpz_ptr z, mpz_srcptr w, mpz_srcptr v)
  { mpz_tdiv_q(z, w, v); }

  static void eval(mpz_ptr z, mpz_srcptr w, unsigned long int l)
  { mpz_tdiv_q_ui(z, w, l); }
  static void eval(mpz_ptr z, unsigned long int l, mpz_srcptr w)
  {
    if (mpz_sgn(w) >= 0)
      {
	if (mpz_fits_ulong_p(w))
	  mpz_set_ui(z, l / mpz_get_ui(w));
	else
	  mpz_set_ui(z, 0);
      }
    else
      {
	mpz_neg(z, w);
	if (mpz_fits_ulong_p(z))
	  {
	    mpz_set_ui(z, l / mpz_get_ui(z));
	    mpz_neg(z, z);
	  }
	else
	  mpz_set_ui(z, 0);
      }
  }
  static void eval(mpz_ptr z, mpz_srcptr w, signed long int l)
  {
    if (l >= 0)
      mpz_tdiv_q_ui(z, w, l);
    else
      {
	mpz_tdiv_q_ui(z, w, -l);
	mpz_neg(z, z);
      }
  }
  static void eval(mpz_ptr z, signed long int l, mpz_srcptr w)
  {
    if (mpz_fits_slong_p(w))
      mpz_set_si(z, l / mpz_get_si(w));
    else
      {
        /* if w is bigger than a long then the quotient must be zero, unless
           l==LONG_MIN and w==-LONG_MIN in which case the quotient is -1 */
        mpz_set_si (z, (mpz_cmpabs_ui (w, (l >= 0 ? l : -l)) == 0 ? -1 : 0));
      }
  }
  static void eval(mpz_ptr z, mpz_srcptr w, double d)
  {
    mpz_t temp;
    mpz_init_set_d(temp, d);
    mpz_tdiv_q(z, w, temp);
    mpz_clear(temp);
  }
  static void eval(mpz_ptr z, double d, mpz_srcptr w)
  {
    mpz_t temp;
    mpz_init_set_d(temp, d);
    mpz_tdiv_q(z, temp, w);
    mpz_clear(temp);
  }

  static void eval(mpq_ptr q, mpq_srcptr r, mpq_srcptr s)
  { mpq_div(q, r, s); }

  static void eval(mpq_ptr q, mpq_srcptr r, unsigned long int l)
  {
    mpq_t temp;
    mpq_init(temp);
    mpq_set_ui(temp, l, 1);
    mpq_div(q, r, temp);
    mpq_clear(temp);
  }
  static void eval(mpq_ptr q, unsigned long int l, mpq_srcptr r)
  {
    mpq_t temp;
    mpq_init(temp);
    mpq_set_ui(temp, l, 1);
    mpq_div(q, temp, r);
    mpq_clear(temp);
  }
  static void eval(mpq_ptr q, mpq_srcptr r, signed long int l)
  {
    mpq_t temp;
    mpq_init(temp);
    mpq_set_si(temp, l, 1);
    mpq_div(q, r, temp);
    mpq_clear(temp);
  }
  static void eval(mpq_ptr q, signed long int l, mpq_srcptr r)
  {
    mpq_t temp;
    mpq_init(temp);
    mpq_set_si(temp, l, 1);
    mpq_div(q, temp, r);
    mpq_clear(temp);
  }
  static void eval(mpq_ptr q, mpq_srcptr r, double d)
  {
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    mpq_div(q, r, temp);
    mpq_clear(temp);
  }
  static void eval(mpq_ptr q, double d, mpq_srcptr r)
  {
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    mpq_div(q, temp, r);
    mpq_clear(temp);
  }

  static void eval(mpf_ptr f, mpf_srcptr g, mpf_srcptr h)
  { mpf_div(f, g, h); }

  static void eval(mpf_ptr f, mpf_srcptr g, unsigned long int l)
  { mpf_div_ui(f, g, l); }
  static void eval(mpf_ptr f, unsigned long int l, mpf_srcptr g)
  { mpf_ui_div(f, l, g); }
  static void eval(mpf_ptr f, mpf_srcptr g, signed long int l)
  {
    if (l >= 0)
      mpf_div_ui(f, g, l);
    else
      {
	mpf_div_ui(f, g, -l);
	mpf_neg(f, f);
      }
  }
  static void eval(mpf_ptr f, signed long int l, mpf_srcptr g)
  {
    if (l >= 0)
      mpf_ui_div(f, l, g);
    else
      {
	mpf_ui_div(f, -l, g);
	mpf_neg(f, f);
      }
  }
  static void eval(mpf_ptr f, mpf_srcptr g, double d)
  {
    mpf_t temp;
    mpf_init2(temp, 8*sizeof(double));
    mpf_set_d(temp, d);
    mpf_div(f, g, temp);
    mpf_clear(temp);
  }
  static void eval(mpf_ptr f, double d, mpf_srcptr g)
  {
    mpf_t temp;
    mpf_init2(temp, 8*sizeof(double));
    mpf_set_d(temp, d);
    mpf_div(f, temp, g);
    mpf_clear(temp);
  }
};

struct __gmp_binary_modulus
{
  static void eval(mpz_ptr z, mpz_srcptr w, mpz_srcptr v)
  { mpz_tdiv_r(z, w, v); }

  static void eval(mpz_ptr z, mpz_srcptr w, unsigned long int l)
  { mpz_tdiv_r_ui(z, w, l); }
  static void eval(mpz_ptr z, unsigned long int l, mpz_srcptr w)
  {
    if (mpz_sgn(w) >= 0)
      {
	if (mpz_fits_ulong_p(w))
	  mpz_set_ui(z, l % mpz_get_ui(w));
	else
	  mpz_set_ui(z, l);
      }
    else
      {
	mpz_neg(z, w);
	if (mpz_fits_ulong_p(z))
	  mpz_set_ui(z, l % mpz_get_ui(z));
	else
	  mpz_set_ui(z, l);
      }
  }
  static void eval(mpz_ptr z, mpz_srcptr w, signed long int l)
  {
    mpz_tdiv_r_ui (z, w, (l >= 0 ? l : -l));
  }
  static void eval(mpz_ptr z, signed long int l, mpz_srcptr w)
  {
    if (mpz_fits_slong_p(w))
      mpz_set_si(z, l % mpz_get_si(w));
    else
      {
        /* if w is bigger than a long then the remainder is l unchanged,
           unless l==LONG_MIN and w==-LONG_MIN in which case it's 0 */
        mpz_set_si (z, mpz_cmpabs_ui (w, (l >= 0 ? l : -l)) == 0 ? 0 : l);
      }
  }
  static void eval(mpz_ptr z, mpz_srcptr w, double d)
  {
    mpz_t temp;
    mpz_init_set_d(temp, d);
    mpz_tdiv_r(z, w, temp);
    mpz_clear(temp);
  }
  static void eval(mpz_ptr z, double d, mpz_srcptr w)
  {
    mpz_t temp;
    mpz_init_set_d(temp, d);
    mpz_tdiv_r(z, temp, w);
    mpz_clear(temp);
  }
};

struct __gmp_binary_and
{
  static void eval(mpz_ptr z, mpz_srcptr w, mpz_srcptr v)
  { mpz_and(z, w, v); }
};

struct __gmp_binary_ior
{
  static void eval(mpz_ptr z, mpz_srcptr w, mpz_srcptr v)
  { mpz_ior(z, w, v); }
};

struct __gmp_binary_xor
{
  static void eval(mpz_ptr z, mpz_srcptr w, mpz_srcptr v)
  { mpz_xor(z, w, v); }
};

struct __gmp_binary_lshift
{
  static void eval(mpz_ptr z, mpz_srcptr w, unsigned long int l)
  { mpz_mul_2exp(z, w, l); }
  static void eval(mpq_ptr q, mpq_srcptr r, unsigned long int l)
  { mpq_mul_2exp(q, r, l); }
  static void eval(mpf_ptr f, mpf_srcptr g, unsigned long int l)
  { mpf_mul_2exp(f, g, l); }
};

struct __gmp_binary_rshift
{
  static void eval(mpz_ptr z, mpz_srcptr w, unsigned long int l)
  { mpz_tdiv_q_2exp(z, w, l); }
  static void eval(mpq_ptr q, mpq_srcptr r, unsigned long int l)
  { mpq_div_2exp(q, r, l); }
  static void eval(mpf_ptr f, mpf_srcptr g, unsigned long int l)
  { mpf_div_2exp(f, g, l); }
};

struct __gmp_binary_equal
{
  static bool eval(mpz_srcptr z, mpz_srcptr w) { return mpz_cmp(z, w) == 0; }

  static bool eval(mpz_srcptr z, unsigned long int l)
  { return mpz_cmp_ui(z, l) == 0; }
  static bool eval(unsigned long int l, mpz_srcptr z)
  { return mpz_cmp_ui(z, l) == 0; }
  static bool eval(mpz_srcptr z, signed long int l)
  { return mpz_cmp_si(z, l) == 0; }
  static bool eval(signed long int l, mpz_srcptr z)
  { return mpz_cmp_si(z, l) == 0; }
  static bool eval(mpz_srcptr z, double d)
  { return mpz_cmp_d(z, d) == 0; }
  static bool eval(double d, mpz_srcptr z)
  { return mpz_cmp_d(z, d) == 0; }

  static bool eval(mpq_srcptr q, mpq_srcptr r)
  { return mpq_equal(q, r) != 0; }

  static bool eval(mpq_srcptr q, unsigned long int l)
  { return mpq_cmp_ui(q, l, 1) == 0; }
  static bool eval(unsigned long int l, mpq_srcptr q)
  { return mpq_cmp_ui(q, l, 1) == 0; }
  static bool eval(mpq_srcptr q, signed long int l)
  { return mpq_cmp_si(q, l, 1) == 0; }
  static bool eval(signed long int l, mpq_srcptr q)
  { return mpq_cmp_si(q, l, 1) == 0; }
  static bool eval(mpq_srcptr q, double d)
  {
    bool b;
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    b = (mpq_equal(q, temp) != 0);
    mpq_clear(temp);
    return b;
  }
  static bool eval(double d, mpq_srcptr q)
  {
    bool b;
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    b = (mpq_equal(temp, q) != 0);
    mpq_clear(temp);
    return b;
  }

  static bool eval(mpf_srcptr f, mpf_srcptr g) { return mpf_cmp(f, g) == 0; }

  static bool eval(mpf_srcptr f, unsigned long int l)
  { return mpf_cmp_ui(f, l) == 0; }
  static bool eval(unsigned long int l, mpf_srcptr f)
  { return mpf_cmp_ui(f, l) == 0; }
  static bool eval(mpf_srcptr f, signed long int l)
  { return mpf_cmp_si(f, l) == 0; }
  static bool eval(signed long int l, mpf_srcptr f)
  { return mpf_cmp_si(f, l) == 0; }
  static bool eval(mpf_srcptr f, double d)
  { return mpf_cmp_d(f, d) == 0; }
  static bool eval(double d, mpf_srcptr f)
  { return mpf_cmp_d(f, d) == 0; }
};

struct __gmp_binary_not_equal
{
  static bool eval(mpz_srcptr z, mpz_srcptr w) { return mpz_cmp(z, w) != 0; }

  static bool eval(mpz_srcptr z, unsigned long int l)
  { return mpz_cmp_ui(z, l) != 0; }
  static bool eval(unsigned long int l, mpz_srcptr z)
  { return mpz_cmp_ui(z, l) != 0; }
  static bool eval(mpz_srcptr z, signed long int l)
  { return mpz_cmp_si(z, l) != 0; }
  static bool eval(signed long int l, mpz_srcptr z)
  { return mpz_cmp_si(z, l) != 0; }
  static bool eval(mpz_srcptr z, double d)
  { return mpz_cmp_d(z, d) != 0; }
  static bool eval(double d, mpz_srcptr z)
  { return mpz_cmp_d(z, d) != 0; }

  static bool eval(mpq_srcptr q, mpq_srcptr r)
  { return mpq_equal(q, r) == 0; }

  static bool eval(mpq_srcptr q, unsigned long int l)
  { return mpq_cmp_ui(q, l, 1) != 0; }
  static bool eval(unsigned long int l, mpq_srcptr q)
  { return mpq_cmp_ui(q, l, 1) != 0; }
  static bool eval(mpq_srcptr q, signed long int l)
  { return mpq_cmp_si(q, l, 1) != 0; }
  static bool eval(signed long int l, mpq_srcptr q)
  { return mpq_cmp_si(q, l, 1) != 0; }
  static bool eval(mpq_srcptr q, double d)
  {
    bool b;
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    b = (mpq_equal(q, temp) == 0);
    mpq_clear(temp);
    return b;
  }
  static bool eval(double d, mpq_srcptr q)
  {
    bool b;
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    b = (mpq_equal(temp, q) == 0);
    mpq_clear(temp);
    return b;
  }

  static bool eval(mpf_srcptr f, mpf_srcptr g) { return mpf_cmp(f, g) != 0; }

  static bool eval(mpf_srcptr f, unsigned long int l)
  { return mpf_cmp_ui(f, l) != 0; }
  static bool eval(unsigned long int l, mpf_srcptr f)
  { return mpf_cmp_ui(f, l) != 0; }
  static bool eval(mpf_srcptr f, signed long int l)
  { return mpf_cmp_si(f, l) != 0; }
  static bool eval(signed long int l, mpf_srcptr f)
  { return mpf_cmp_si(f, l) != 0; }
  static bool eval(mpf_srcptr f, double d)
  { return mpf_cmp_d(f, d) != 0; }
  static bool eval(double d, mpf_srcptr f)
  { return mpf_cmp_d(f, d) != 0; }
};

struct __gmp_binary_less
{
  static bool eval(mpz_srcptr z, mpz_srcptr w) { return mpz_cmp(z, w) < 0; }

  static bool eval(mpz_srcptr z, unsigned long int l)
  { return mpz_cmp_ui(z, l) < 0; }
  static bool eval(unsigned long int l, mpz_srcptr z)
  { return mpz_cmp_ui(z, l) > 0; }
  static bool eval(mpz_srcptr z, signed long int l)
  { return mpz_cmp_si(z, l) < 0; }
  static bool eval(signed long int l, mpz_srcptr z)
  { return mpz_cmp_si(z, l) > 0; }
  static bool eval(mpz_srcptr z, double d)
  { return mpz_cmp_d(z, d) < 0; }
  static bool eval(double d, mpz_srcptr z)
  { return mpz_cmp_d(z, d) > 0; }

  static bool eval(mpq_srcptr q, mpq_srcptr r) { return mpq_cmp(q, r) < 0; }

  static bool eval(mpq_srcptr q, unsigned long int l)
  { return mpq_cmp_ui(q, l, 1) < 0; }
  static bool eval(unsigned long int l, mpq_srcptr q)
  { return mpq_cmp_ui(q, l, 1) > 0; }
  static bool eval(mpq_srcptr q, signed long int l)
  { return mpq_cmp_si(q, l, 1) < 0; }
  static bool eval(signed long int l, mpq_srcptr q)
  { return mpq_cmp_si(q, l, 1) > 0; }
  static bool eval(mpq_srcptr q, double d)
  {
    bool b;
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    b = (mpq_cmp(q, temp) < 0);
    mpq_clear(temp);
    return b;
  }
  static bool eval(double d, mpq_srcptr q)
  {
    bool b;
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    b = (mpq_cmp(temp, q) < 0);
    mpq_clear(temp);
    return b;
  }

  static bool eval(mpf_srcptr f, mpf_srcptr g) { return mpf_cmp(f, g) < 0; }

  static bool eval(mpf_srcptr f, unsigned long int l)
  { return mpf_cmp_ui(f, l) < 0; }
  static bool eval(unsigned long int l, mpf_srcptr f)
  { return mpf_cmp_ui(f, l) > 0; }
  static bool eval(mpf_srcptr f, signed long int l)
  { return mpf_cmp_si(f, l) < 0; }
  static bool eval(signed long int l, mpf_srcptr f)
  { return mpf_cmp_si(f, l) > 0; }
  static bool eval(mpf_srcptr f, double d)
  { return mpf_cmp_d(f, d) < 0; }
  static bool eval(double d, mpf_srcptr f)
  { return mpf_cmp_d(f, d) > 0; }
};

struct __gmp_binary_less_equal
{
  static bool eval(mpz_srcptr z, mpz_srcptr w) { return mpz_cmp(z, w) <= 0; }

  static bool eval(mpz_srcptr z, unsigned long int l)
  { return mpz_cmp_ui(z, l) <= 0; }
  static bool eval(unsigned long int l, mpz_srcptr z)
  { return mpz_cmp_ui(z, l) >= 0; }
  static bool eval(mpz_srcptr z, signed long int l)
  { return mpz_cmp_si(z, l) <= 0; }
  static bool eval(signed long int l, mpz_srcptr z)
  { return mpz_cmp_si(z, l) >= 0; }
  static bool eval(mpz_srcptr z, double d)
  { return mpz_cmp_d(z, d) <= 0; }
  static bool eval(double d, mpz_srcptr z)
  { return mpz_cmp_d(z, d) >= 0; }

  static bool eval(mpq_srcptr q, mpq_srcptr r) { return mpq_cmp(q, r) <= 0; }

  static bool eval(mpq_srcptr q, unsigned long int l)
  { return mpq_cmp_ui(q, l, 1) <= 0; }
  static bool eval(unsigned long int l, mpq_srcptr q)
  { return mpq_cmp_ui(q, l, 1) >= 0; }
  static bool eval(mpq_srcptr q, signed long int l)
  { return mpq_cmp_si(q, l, 1) <= 0; }
  static bool eval(signed long int l, mpq_srcptr q)
  { return mpq_cmp_si(q, l, 1) >= 0; }
  static bool eval(mpq_srcptr q, double d)
  {
    bool b;
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    b = (mpq_cmp(q, temp) <= 0);
    mpq_clear(temp);
    return b;
  }
  static bool eval(double d, mpq_srcptr q)
  {
    bool b;
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    b = (mpq_cmp(temp, q) <= 0);
    mpq_clear(temp);
    return b;
  }

  static bool eval(mpf_srcptr f, mpf_srcptr g) { return mpf_cmp(f, g) <= 0; }

  static bool eval(mpf_srcptr f, unsigned long int l)
  { return mpf_cmp_ui(f, l) <= 0; }
  static bool eval(unsigned long int l, mpf_srcptr f)
  { return mpf_cmp_ui(f, l) >= 0; }
  static bool eval(mpf_srcptr f, signed long int l)
  { return mpf_cmp_si(f, l) <= 0; }
  static bool eval(signed long int l, mpf_srcptr f)
  { return mpf_cmp_si(f, l) >= 0; }
  static bool eval(mpf_srcptr f, double d)
  { return mpf_cmp_d(f, d) <= 0; }
  static bool eval(double d, mpf_srcptr f)
  { return mpf_cmp_d(f, d) >= 0; }
};

struct __gmp_binary_greater
{
  static bool eval(mpz_srcptr z, mpz_srcptr w) { return mpz_cmp(z, w) > 0; }

  static bool eval(mpz_srcptr z, unsigned long int l)
  { return mpz_cmp_ui(z, l) > 0; }
  static bool eval(unsigned long int l, mpz_srcptr z)
  { return mpz_cmp_ui(z, l) < 0; }
  static bool eval(mpz_srcptr z, signed long int l)
  { return mpz_cmp_si(z, l) > 0; }
  static bool eval(signed long int l, mpz_srcptr z)
  { return mpz_cmp_si(z, l) < 0; }
  static bool eval(mpz_srcptr z, double d)
  { return mpz_cmp_d(z, d) > 0; }
  static bool eval(double d, mpz_srcptr z)
  { return mpz_cmp_d(z, d) < 0; }

  static bool eval(mpq_srcptr q, mpq_srcptr r) { return mpq_cmp(q, r) > 0; }

  static bool eval(mpq_srcptr q, unsigned long int l)
  { return mpq_cmp_ui(q, l, 1) > 0; }
  static bool eval(unsigned long int l, mpq_srcptr q)
  { return mpq_cmp_ui(q, l, 1) < 0; }
  static bool eval(mpq_srcptr q, signed long int l)
  { return mpq_cmp_si(q, l, 1) > 0; }
  static bool eval(signed long int l, mpq_srcptr q)
  { return mpq_cmp_si(q, l, 1) < 0; }
  static bool eval(mpq_srcptr q, double d)
  {
    bool b;
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    b = (mpq_cmp(q, temp) > 0);
    mpq_clear(temp);
    return b;
  }
  static bool eval(double d, mpq_srcptr q)
  {
    bool b;
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    b = (mpq_cmp(temp, q) > 0);
    mpq_clear(temp);
    return b;
  }

  static bool eval(mpf_srcptr f, mpf_srcptr g) { return mpf_cmp(f, g) > 0; }

  static bool eval(mpf_srcptr f, unsigned long int l)
  { return mpf_cmp_ui(f, l) > 0; }
  static bool eval(unsigned long int l, mpf_srcptr f)
  { return mpf_cmp_ui(f, l) < 0; }
  static bool eval(mpf_srcptr f, signed long int l)
  { return mpf_cmp_si(f, l) > 0; }
  static bool eval(signed long int l, mpf_srcptr f)
  { return mpf_cmp_si(f, l) < 0; }
  static bool eval(mpf_srcptr f, double d)
  { return mpf_cmp_d(f, d) > 0; }
  static bool eval(double d, mpf_srcptr f)
  { return mpf_cmp_d(f, d) < 0; }
};

struct __gmp_binary_greater_equal
{
  static bool eval(mpz_srcptr z, mpz_srcptr w) { return mpz_cmp(z, w) >= 0; }

  static bool eval(mpz_srcptr z, unsigned long int l)
  { return mpz_cmp_ui(z, l) >= 0; }
  static bool eval(unsigned long int l, mpz_srcptr z)
  { return mpz_cmp_ui(z, l) <= 0; }
  static bool eval(mpz_srcptr z, signed long int l)
  { return mpz_cmp_si(z, l) >= 0; }
  static bool eval(signed long int l, mpz_srcptr z)
  { return mpz_cmp_si(z, l) <= 0; }
  static bool eval(mpz_srcptr z, double d)
  { return mpz_cmp_d(z, d) >= 0; }
  static bool eval(double d, mpz_srcptr z)
  { return mpz_cmp_d(z, d) <= 0; }

  static bool eval(mpq_srcptr q, mpq_srcptr r) { return mpq_cmp(q, r) >= 0; }

  static bool eval(mpq_srcptr q, unsigned long int l)
  { return mpq_cmp_ui(q, l, 1) >= 0; }
  static bool eval(unsigned long int l, mpq_srcptr q)
  { return mpq_cmp_ui(q, l, 1) <= 0; }
  static bool eval(mpq_srcptr q, signed long int l)
  { return mpq_cmp_si(q, l, 1) >= 0; }
  static bool eval(signed long int l, mpq_srcptr q)
  { return mpq_cmp_si(q, l, 1) <= 0; }
  static bool eval(mpq_srcptr q, double d)
  {
    bool b;
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    b = (mpq_cmp(q, temp) >= 0);
    mpq_clear(temp);
    return b;
  }
  static bool eval(double d, mpq_srcptr q)
  {
    bool b;
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    b = (mpq_cmp(temp, q) >= 0);
    mpq_clear(temp);
    return b;
  }

  static bool eval(mpf_srcptr f, mpf_srcptr g) { return mpf_cmp(f, g) >= 0; }

  static bool eval(mpf_srcptr f, unsigned long int l)
  { return mpf_cmp_ui(f, l) >= 0; }
  static bool eval(unsigned long int l, mpf_srcptr f)
  { return mpf_cmp_ui(f, l) <= 0; }
  static bool eval(mpf_srcptr f, signed long int l)
  { return mpf_cmp_si(f, l) >= 0; }
  static bool eval(signed long int l, mpf_srcptr f)
  { return mpf_cmp_si(f, l) <= 0; }
  static bool eval(mpf_srcptr f, double d)
  { return mpf_cmp_d(f, d) >= 0; }
  static bool eval(double d, mpf_srcptr f)
  { return mpf_cmp_d(f, d) <= 0; }
};

struct __gmp_unary_increment
{
  static void eval(mpz_ptr z) { mpz_add_ui(z, z, 1); }
  static void eval(mpq_ptr q)
  { mpz_add(mpq_numref(q), mpq_numref(q), mpq_denref(q)); }
  static void eval(mpf_ptr f) { mpf_add_ui(f, f, 1); }
};

struct __gmp_unary_decrement
{
  static void eval(mpz_ptr z) { mpz_sub_ui(z, z, 1); }
  static void eval(mpq_ptr q)
  { mpz_sub(mpq_numref(q), mpq_numref(q), mpq_denref(q)); }
  static void eval(mpf_ptr f) { mpf_sub_ui(f, f, 1); }
};

struct __gmp_abs_function
{
  static void eval(mpz_ptr z, mpz_srcptr w) { mpz_abs(z, w); }
  static void eval(mpq_ptr q, mpq_srcptr r) { mpq_abs(q, r); }
  static void eval(mpf_ptr f, mpf_srcptr g) { mpf_abs(f, g); }
};

struct __gmp_trunc_function
{
  static void eval(mpf_ptr f, mpf_srcptr g) { mpf_trunc(f, g); }
};

struct __gmp_floor_function
{
  static void eval(mpf_ptr f, mpf_srcptr g) { mpf_floor(f, g); }
};

struct __gmp_ceil_function
{
  static void eval(mpf_ptr f, mpf_srcptr g) { mpf_ceil(f, g); }
};

struct __gmp_sqrt_function
{
  static void eval(mpz_ptr z, mpz_srcptr w) { mpz_sqrt(z, w); }
  static void eval(mpf_ptr f, mpf_srcptr g) { mpf_sqrt(f, g); }
};

struct __gmp_hypot_function
{
  static void eval(mpf_ptr f, mpf_srcptr g, mpf_srcptr h)
  {
    mpf_t temp;
    mpf_init2(temp, mpf_get_prec(f));
    mpf_mul(temp, g, g);
    mpf_mul(f, h, h);
    mpf_add(f, f, temp);
    mpf_sqrt(f, f);
    mpf_clear(temp);
  }

  static void eval(mpf_ptr f, mpf_srcptr g, unsigned long int l)
  {
    mpf_t temp;
    mpf_init2(temp, mpf_get_prec(f));
    mpf_mul(temp, g, g);
    mpf_set_ui(f, l);
    mpf_mul(f, f, f);
    mpf_add(f, f, temp);
    mpf_sqrt(f, f);
    mpf_clear(temp);
  }
  static void eval(mpf_ptr f, unsigned long int l, mpf_srcptr g)
  {
    mpf_t temp;
    mpf_init2(temp, mpf_get_prec(f));
    mpf_mul(temp, g, g);
    mpf_set_ui(f, l);
    mpf_mul(f, f, f);
    mpf_add(f, f, temp);
    mpf_sqrt(f, f);
    mpf_clear(temp);
  }
  static void eval(mpf_ptr f, mpf_srcptr g, signed long int l)
  {
    mpf_t temp;
    mpf_init2(temp, mpf_get_prec(f));
    mpf_mul(temp, g, g);
    mpf_set_si(f, l);
    mpf_mul(f, f, f);
    mpf_add(f, f, temp);
    mpf_sqrt(f, f);
    mpf_clear(temp);
  }
  static void eval(mpf_ptr f, signed long int l, mpf_srcptr g)
  {
    mpf_t temp;
    mpf_init2(temp, mpf_get_prec(f));
    mpf_mul(temp, g, g);
    mpf_set_si(f, l);
    mpf_mul(f, f, f);
    mpf_add(f, f, temp);
    mpf_sqrt(f, f);
    mpf_clear(temp);
  }
  static void eval(mpf_ptr f, mpf_srcptr g, double d)
  {
    mpf_t temp;
    mpf_init2(temp, mpf_get_prec(f));
    mpf_mul(temp, g, g);
    mpf_set_d(f, d);
    mpf_mul(f, f, f);
    mpf_add(f, f, temp);
    mpf_sqrt(f, f);
    mpf_clear(temp);
  }
  static void eval(mpf_ptr f, double d, mpf_srcptr g)
  {
    mpf_t temp;
    mpf_init2(temp, mpf_get_prec(f));
    mpf_mul(temp, g, g);
    mpf_set_d(f, d);
    mpf_mul(f, f, f);
    mpf_add(f, f, temp);
    mpf_sqrt(f, f);
    mpf_clear(temp);
  }
};

struct __gmp_sgn_function
{
  static int eval(mpz_srcptr z) { return mpz_sgn(z); }
  static int eval(mpq_srcptr q) { return mpq_sgn(q); }
  static int eval(mpf_srcptr f) { return mpf_sgn(f); }
};

struct __gmp_cmp_function
{
  static int eval(mpz_srcptr z, mpz_srcptr w) { return mpz_cmp(z, w); }

  static int eval(mpz_srcptr z, unsigned long int l)
  { return mpz_cmp_ui(z, l); }
  static int eval(unsigned long int l, mpz_srcptr z)
  { return -mpz_cmp_ui(z, l); }
  static int eval(mpz_srcptr z, signed long int l)
  { return mpz_cmp_si(z, l); }
  static int eval(signed long int l, mpz_srcptr z)
  { return -mpz_cmp_si(z, l); }
  static int eval(mpz_srcptr z, double d)
  { return mpz_cmp_d(z, d); }
  static int eval(double d, mpz_srcptr z)
  { return -mpz_cmp_d(z, d); }

  static int eval(mpq_srcptr q, mpq_srcptr r) { return mpq_cmp(q, r); }

  static int eval(mpq_srcptr q, unsigned long int l)
  { return mpq_cmp_ui(q, l, 1); }
  static int eval(unsigned long int l, mpq_srcptr q)
  { return -mpq_cmp_ui(q, l, 1); }
  static int eval(mpq_srcptr q, signed long int l)
  { return mpq_cmp_si(q, l, 1); }
  static int eval(signed long int l, mpq_srcptr q)
  { return -mpq_cmp_si(q, l, 1); }
  static int eval(mpq_srcptr q, double d)
  {
    int i;
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    i = mpq_cmp(q, temp);
    mpq_clear(temp);
    return i;
  }
  static int eval(double d, mpq_srcptr q)
  {
    int i;
    mpq_t temp;
    mpq_init(temp);
    mpq_set_d(temp, d);
    i = mpq_cmp(temp, q);
    mpq_clear(temp);
    return i;
  }

  static int eval(mpf_srcptr f, mpf_srcptr g) { return mpf_cmp(f, g); }

  static int eval(mpf_srcptr f, unsigned long int l)
  { return mpf_cmp_ui(f, l); }
  static int eval(unsigned long int l, mpf_srcptr f)
  { return -mpf_cmp_ui(f, l); }
  static int eval(mpf_srcptr f, signed long int l)
  { return mpf_cmp_si(f, l); }
  static int eval(signed long int l, mpf_srcptr f)
  { return -mpf_cmp_si(f, l); }
  static int eval(mpf_srcptr f, double d)
  { return mpf_cmp_d(f, d); }
  static int eval(double d, mpf_srcptr f)
  { return -mpf_cmp_d(f, d); }
};

struct __gmp_rand_function
{
  static void eval(mpz_ptr z, gmp_randstate_t s, unsigned long int l)
  { mpz_urandomb(z, s, l); }
  static void eval(mpz_ptr z, gmp_randstate_t s, mpz_srcptr w)
  { mpz_urandomm(z, s, w); }
  static void eval(mpf_ptr f, gmp_randstate_t s, unsigned long int prec)
  { mpf_urandomb(f, s, prec); }
};


/**************** Auxiliary classes ****************/

/* this is much the same as gmp_allocated_string in gmp-impl.h
   since gmp-impl.h is not publicly available, I redefine it here
   I use a different name to avoid possible clashes */
extern "C" {
struct __gmp_alloc_cstring_c
{
   void (*free_func) (void *, size_t);
};
}

struct __gmp_alloc_cstring : __gmp_alloc_cstring_c
{
  char *str;
  __gmp_alloc_cstring(char *s) { str = s; }
  ~__gmp_alloc_cstring()
  {
    mp_get_memory_functions (NULL, NULL, &free_func);
    (*free_func) (str, std::strlen(str)+1);
  }
};

// general expression template class
template <class T, class U>
class __gmp_expr;


// templates for resolving expression types
template <class T>
struct __gmp_resolve_ref
{
  typedef T ref_type;
};

template <class T, class U>
struct __gmp_resolve_ref<__gmp_expr<T, U> >
{
  typedef const __gmp_expr<T, U> & ref_type;
};


template <class T, class U = T>
struct __gmp_resolve_expr;

template <>
struct __gmp_resolve_expr<mpz_t>
{
  typedef mpz_t value_type;
  typedef mpz_ptr ptr_type;
};

template <>
struct __gmp_resolve_expr<mpq_t>
{
  typedef mpq_t value_type;
  typedef mpq_ptr ptr_type;
};

template <>
struct __gmp_resolve_expr<mpf_t>
{
  typedef mpf_t value_type;
  typedef mpf_ptr ptr_type;
};

template <>
struct __gmp_resolve_expr<mpz_t, mpq_t>
{
  typedef mpq_t value_type;
};

template <>
struct __gmp_resolve_expr<mpq_t, mpz_t>
{
  typedef mpq_t value_type;
};

template <>
struct __gmp_resolve_expr<mpz_t, mpf_t>
{
  typedef mpf_t value_type;
};

template <>
struct __gmp_resolve_expr<mpf_t, mpz_t>
{
  typedef mpf_t value_type;
};

template <>
struct __gmp_resolve_expr<mpq_t, mpf_t>
{
  typedef mpf_t value_type;
};

template <>
struct __gmp_resolve_expr<mpf_t, mpq_t>
{
  typedef mpf_t value_type;
};



template <class T, class U, class V>
struct __gmp_resolve_temp
{
  typedef __gmp_expr<T, T> temp_type;
};

template <class T>
struct __gmp_resolve_temp<T, T, T>
{
  typedef const __gmp_expr<T, T> & temp_type;
};


// classes for evaluating unary and binary expressions
template <class T, class Op>
struct __gmp_unary_expr
{
  const T &val;

  __gmp_unary_expr(const T &v) : val(v) { }
private:
  __gmp_unary_expr();
};

template <class T, class U, class Op>
struct __gmp_binary_expr
{
  typename __gmp_resolve_ref<T>::ref_type val1;
  typename __gmp_resolve_ref<U>::ref_type val2;

  __gmp_binary_expr(const T &v1, const U &v2) : val1(v1), val2(v2) { }
private:
  __gmp_binary_expr();
};


// functions for evaluating expressions
template <class T, class U>
void __gmp_set_expr(mpz_ptr, const __gmp_expr<T, U> &);
template <class T, class U>
void __gmp_set_expr(mpq_ptr, const __gmp_expr<T, U> &);
template <class T, class U>
void __gmp_set_expr(mpf_ptr, const __gmp_expr<T, U> &);


/**************** Macros for in-class declarations ****************/
/* This is just repetitive code that is easier to maintain if it's written
   only once */

#define __GMPP_DECLARE_COMPOUND_OPERATOR(fun)                         \
  template <class T, class U>                                         \
  __gmp_expr<value_type, value_type> & fun(const __gmp_expr<T, U> &);

#define __GMPN_DECLARE_COMPOUND_OPERATOR(fun) \
  __gmp_expr & fun(signed char);              \
  __gmp_expr & fun(unsigned char);            \
  __gmp_expr & fun(signed int);               \
  __gmp_expr & fun(unsigned int);             \
  __gmp_expr & fun(signed short int);         \
  __gmp_expr & fun(unsigned short int);       \
  __gmp_expr & fun(signed long int);          \
  __gmp_expr & fun(unsigned long int);        \
  __gmp_expr & fun(float);                    \
  __gmp_expr & fun(double);                   \
  __gmp_expr & fun(long double);

#define __GMP_DECLARE_COMPOUND_OPERATOR(fun) \
__GMPP_DECLARE_COMPOUND_OPERATOR(fun)        \
__GMPN_DECLARE_COMPOUND_OPERATOR(fun)

#define __GMP_DECLARE_COMPOUND_OPERATOR_UI(fun) \
  __gmp_expr & fun(unsigned long int);

#define __GMP_DECLARE_INCREMENT_OPERATOR(fun) \
  inline __gmp_expr & fun();                  \
  inline __gmp_expr fun(int);


/**************** mpz_class -- wrapper for mpz_t ****************/

template <>
class __gmp_expr<mpz_t, mpz_t>
{
private:
  typedef mpz_t value_type;
  value_type mp;
public:
  unsigned long int get_prec() const { return mpf_get_default_prec(); }

  // constructors and destructor
  __gmp_expr() { mpz_init(mp); }

  __gmp_expr(const __gmp_expr &z) { mpz_init_set(mp, z.mp); }
  template <class T, class U>
  __gmp_expr(const __gmp_expr<T, U> &expr)
  { mpz_init(mp); __gmp_set_expr(mp, expr); }

  __gmp_expr(signed char c) { mpz_init_set_si(mp, c); }
  __gmp_expr(unsigned char c) { mpz_init_set_ui(mp, c); }

  __gmp_expr(signed int i) { mpz_init_set_si(mp, i); }
  __gmp_expr(unsigned int i) { mpz_init_set_ui(mp, i); }

  __gmp_expr(signed short int s) { mpz_init_set_si(mp, s); }
  __gmp_expr(unsigned short int s) { mpz_init_set_ui(mp, s); }

  __gmp_expr(signed long int l) { mpz_init_set_si(mp, l); }
  __gmp_expr(unsigned long int l) { mpz_init_set_ui(mp, l); }

  __gmp_expr(float f) { mpz_init_set_d(mp, f); }
  __gmp_expr(double d) { mpz_init_set_d(mp, d); }
  // __gmp_expr(long double ld) { mpz_init_set_d(mp, ld); }

  explicit __gmp_expr(const char *s)
  {
    if (mpz_init_set_str (mp, s, 0) != 0)
      {
        mpz_clear (mp);
        throw std::invalid_argument ("mpz_set_str");
      }
  }
  __gmp_expr(const char *s, int base)
  {
    if (mpz_init_set_str (mp, s, base) != 0)
      {
        mpz_clear (mp);
        throw std::invalid_argument ("mpz_set_str");
      }
  }
  explicit __gmp_expr(const std::string &s)
  {
    if (mpz_init_set_str (mp, s.c_str(), 0) != 0)
      {
        mpz_clear (mp);
        throw std::invalid_argument ("mpz_set_str");
      }
  }
  __gmp_expr(const std::string &s, int base)
  {
    if (mpz_init_set_str(mp, s.c_str(), base) != 0)
      {
        mpz_clear (mp);
        throw std::invalid_argument ("mpz_set_str");
      }
  }

  explicit __gmp_expr(mpz_srcptr z) { mpz_init_set(mp, z); }

  ~__gmp_expr() { mpz_clear(mp); }

  // assignment operators
  __gmp_expr & operator=(const __gmp_expr &z)
  { mpz_set(mp, z.mp); return *this; }
  template <class T, class U>
  __gmp_expr<value_type, value_type> & operator=(const __gmp_expr<T, U> &expr)
  { __gmp_set_expr(mp, expr); return *this; }

  __gmp_expr & operator=(signed char c) { mpz_set_si(mp, c); return *this; }
  __gmp_expr & operator=(unsigned char c) { mpz_set_ui(mp, c); return *this; }

  __gmp_expr & operator=(signed int i) { mpz_set_si(mp, i); return *this; }
  __gmp_expr & operator=(unsigned int i) { mpz_set_ui(mp, i); return *this; }

  __gmp_expr & operator=(signed short int s)
  { mpz_set_si(mp, s); return *this; }
  __gmp_expr & operator=(unsigned short int s)
  { mpz_set_ui(mp, s); return *this; }

  __gmp_expr & operator=(signed long int l)
  { mpz_set_si(mp, l); return *this; }
  __gmp_expr & operator=(unsigned long int l)
  { mpz_set_ui(mp, l); return *this; }

  __gmp_expr & operator=(float f) { mpz_set_d(mp, f); return *this; }
  __gmp_expr & operator=(double d) { mpz_set_d(mp, d); return *this; }
  // __gmp_expr & operator=(long double ld)
  // { mpz_set_ld(mp, ld); return *this; }

  __gmp_expr & operator=(const char *s)
  {
    if (mpz_set_str (mp, s, 0) != 0)
      throw std::invalid_argument ("mpz_set_str");
    return *this;
  }
  __gmp_expr & operator=(const std::string &s)
  {
    if (mpz_set_str(mp, s.c_str(), 0) != 0)
      throw std::invalid_argument ("mpz_set_str");
    return *this;
  }

  // string input/output functions
  int set_str(const char *s, int base)
  { return mpz_set_str(mp, s, base); }
  int set_str(const std::string &s, int base)
  { return mpz_set_str(mp, s.c_str(), base); }
  std::string get_str(int base = 10) const
  {
    __gmp_alloc_cstring temp(mpz_get_str(0, base, mp));
    return std::string(temp.str);
  }

  // conversion functions
  mpz_srcptr __get_mp() const { return mp; }
  mpz_ptr __get_mp() { return mp; }
  mpz_srcptr get_mpz_t() const { return mp; }
  mpz_ptr get_mpz_t() { return mp; }

  signed long int get_si() const { return mpz_get_si(mp); }
  unsigned long int get_ui() const { return mpz_get_ui(mp); }
  double get_d() const { return mpz_get_d(mp); }

  // bool fits_schar_p() const { return mpz_fits_schar_p(mp); }
  // bool fits_uchar_p() const { return mpz_fits_uchar_p(mp); }
  bool fits_sint_p() const { return mpz_fits_sint_p(mp); }
  bool fits_uint_p() const { return mpz_fits_uint_p(mp); }
  bool fits_sshort_p() const { return mpz_fits_sshort_p(mp); }
  bool fits_ushort_p() const { return mpz_fits_ushort_p(mp); }
  bool fits_slong_p() const { return mpz_fits_slong_p(mp); }
  bool fits_ulong_p() const { return mpz_fits_ulong_p(mp); }
  // bool fits_float_p() const { return mpz_fits_float_p(mp); }
  // bool fits_double_p() const { return mpz_fits_double_p(mp); }
  // bool fits_ldouble_p() const { return mpz_fits_ldouble_p(mp); }

  // member operators
  __GMP_DECLARE_COMPOUND_OPERATOR(operator+=)
  __GMP_DECLARE_COMPOUND_OPERATOR(operator-=)
  __GMP_DECLARE_COMPOUND_OPERATOR(operator*=)
  __GMP_DECLARE_COMPOUND_OPERATOR(operator/=)
  __GMP_DECLARE_COMPOUND_OPERATOR(operator%=)

  __GMPP_DECLARE_COMPOUND_OPERATOR(operator&=)
  __GMPP_DECLARE_COMPOUND_OPERATOR(operator|=)
  __GMPP_DECLARE_COMPOUND_OPERATOR(operator^=)

  __GMP_DECLARE_COMPOUND_OPERATOR_UI(operator<<=)
  __GMP_DECLARE_COMPOUND_OPERATOR_UI(operator>>=)

  __GMP_DECLARE_INCREMENT_OPERATOR(operator++)
  __GMP_DECLARE_INCREMENT_OPERATOR(operator--)
};

typedef __gmp_expr<mpz_t, mpz_t> mpz_class;


/**************** mpq_class -- wrapper for mpq_t ****************/

template <>
class __gmp_expr<mpq_t, mpq_t>
{
private:
  typedef mpq_t value_type;
  value_type mp;
public:
  unsigned long int get_prec() const { return mpf_get_default_prec(); }
  void canonicalize() { mpq_canonicalize(mp); }

  // constructors and destructor
  __gmp_expr() { mpq_init(mp); }

  __gmp_expr(const __gmp_expr &q) { mpq_init(mp); mpq_set(mp, q.mp); }
  template <class T, class U>
  __gmp_expr(const __gmp_expr<T, U> &expr)
  { mpq_init(mp); __gmp_set_expr(mp, expr); }

  __gmp_expr(signed char c) { mpq_init(mp); mpq_set_si(mp, c, 1); }
  __gmp_expr(unsigned char c) { mpq_init(mp); mpq_set_ui(mp, c, 1); }

  __gmp_expr(signed int i) { mpq_init(mp); mpq_set_si(mp, i, 1); }
  __gmp_expr(unsigned int i) { mpq_init(mp); mpq_set_ui(mp, i, 1); }

  __gmp_expr(signed short int s) { mpq_init(mp); mpq_set_si(mp, s, 1); }
  __gmp_expr(unsigned short int s) { mpq_init(mp); mpq_set_ui(mp, s, 1); }

  __gmp_expr(signed long int l) { mpq_init(mp); mpq_set_si(mp, l, 1); }
  __gmp_expr(unsigned long int l) { mpq_init(mp); mpq_set_ui(mp, l, 1); }

  __gmp_expr(float f) { mpq_init(mp); mpq_set_d(mp, f); }
  __gmp_expr(double d) { mpq_init(mp); mpq_set_d(mp, d); }
  // __gmp_expr(long double ld) { mpq_init(mp); mpq_set_ld(mp, ld); }

  explicit __gmp_expr(const char *s)
  {
    mpq_init (mp);
    if (mpq_set_str (mp, s, 0) != 0)
      {
        mpq_clear (mp);
        throw std::invalid_argument ("mpq_set_str");
      }
  }
  __gmp_expr(const char *s, int base)
  {
    mpq_init (mp);
    if (mpq_set_str(mp, s, base) != 0)
      {
        mpq_clear (mp);
        throw std::invalid_argument ("mpq_set_str");
      }
  }
  explicit __gmp_expr(const std::string &s)
  {
    mpq_init (mp);
    if (mpq_set_str (mp, s.c_str(), 0) != 0)
      {
        mpq_clear (mp);
        throw std::invalid_argument ("mpq_set_str");
      }
  }
  __gmp_expr(const std::string &s, int base)
  {
    mpq_init(mp);
    if (mpq_set_str (mp, s.c_str(), base) != 0)
      {
        mpq_clear (mp);
        throw std::invalid_argument ("mpq_set_str");
      }
  }
  explicit __gmp_expr(mpq_srcptr q) { mpq_init(mp); mpq_set(mp, q); }

  __gmp_expr(const mpz_class &num, const mpz_class &den)
  {
    mpq_init(mp);
    mpz_set(mpq_numref(mp), num.get_mpz_t());
    mpz_set(mpq_denref(mp), den.get_mpz_t());
  }

  ~__gmp_expr() { mpq_clear(mp); }

  // assignment operators
  __gmp_expr & operator=(const __gmp_expr &q)
  { mpq_set(mp, q.mp); return *this; }
  template <class T, class U>
  __gmp_expr<value_type, value_type> & operator=(const __gmp_expr<T, U> &expr)
  { __gmp_set_expr(mp, expr); return *this; }

  __gmp_expr & operator=(signed char c)
  { mpq_set_si(mp, c, 1); return *this; }
  __gmp_expr & operator=(unsigned char c)
  { mpq_set_ui(mp, c, 1); return *this; }

  __gmp_expr & operator=(signed int i) { mpq_set_si(mp, i, 1); return *this; }
  __gmp_expr & operator=(unsigned int i)
  { mpq_set_ui(mp, i, 1); return *this; }

  __gmp_expr & operator=(signed short int s)
  { mpq_set_si(mp, s, 1); return *this; }
  __gmp_expr & operator=(unsigned short int s)
  { mpq_set_ui(mp, s, 1); return *this; }

  __gmp_expr & operator=(signed long int l)
  { mpq_set_si(mp, l, 1); return *this; }
  __gmp_expr & operator=(unsigned long int l)
  { mpq_set_ui(mp, l, 1); return *this; }

  __gmp_expr & operator=(float f) { mpq_set_d(mp, f); return *this; }
  __gmp_expr & operator=(double d) { mpq_set_d(mp, d); return *this; }
  // __gmp_expr & operator=(long double ld)
  // { mpq_set_ld(mp, ld); return *this; }

  __gmp_expr & operator=(const char *s)
  {
    if (mpq_set_str (mp, s, 0) != 0)
      throw std::invalid_argument ("mpq_set_str");
    return *this;
  }
  __gmp_expr & operator=(const std::string &s)
  {
    if (mpq_set_str(mp, s.c_str(), 0) != 0)
      throw std::invalid_argument ("mpq_set_str");
    return *this;
  }

  // string input/output functions
  int set_str(const char *s, int base)
  { return mpq_set_str(mp, s, base); }
  int set_str(const std::string &s, int base)
  { return mpq_set_str(mp, s.c_str(), base); }
  std::string get_str(int base = 10) const
  {
    __gmp_alloc_cstring temp(mpq_get_str(0, base, mp));
    return std::string(temp.str);
  }

  // conversion functions

  // casting a reference to an mpz_t to mpz_class & is a dirty hack,
  // but works because the internal representation of mpz_class is
  // exactly an mpz_t
  const mpz_class & get_num() const
  { return reinterpret_cast<const mpz_class &>(*mpq_numref(mp)); }
  mpz_class & get_num()
  { return reinterpret_cast<mpz_class &>(*mpq_numref(mp)); }
  const mpz_class & get_den() const
  { return reinterpret_cast<const mpz_class &>(*mpq_denref(mp)); }
  mpz_class & get_den()
  { return reinterpret_cast<mpz_class &>(*mpq_denref(mp)); }

  mpq_srcptr __get_mp() const { return mp; }
  mpq_ptr __get_mp() { return mp; }
  mpq_srcptr get_mpq_t() const { return mp; }
  mpq_ptr get_mpq_t() { return mp; }

  mpz_srcptr get_num_mpz_t() const { return mpq_numref(mp); }
  mpz_ptr get_num_mpz_t() { return mpq_numref(mp); }
  mpz_srcptr get_den_mpz_t() const { return mpq_denref(mp); }
  mpz_ptr get_den_mpz_t() { return mpq_denref(mp); }

  double get_d() const { return mpq_get_d(mp); }

  // compound assignments
  __GMP_DECLARE_COMPOUND_OPERATOR(operator+=)
  __GMP_DECLARE_COMPOUND_OPERATOR(operator-=)
  __GMP_DECLARE_COMPOUND_OPERATOR(operator*=)
  __GMP_DECLARE_COMPOUND_OPERATOR(operator/=)

  __GMP_DECLARE_COMPOUND_OPERATOR_UI(operator<<=)
  __GMP_DECLARE_COMPOUND_OPERATOR_UI(operator>>=)

  __GMP_DECLARE_INCREMENT_OPERATOR(operator++)
  __GMP_DECLARE_INCREMENT_OPERATOR(operator--)
};

typedef __gmp_expr<mpq_t, mpq_t> mpq_class;


/**************** mpf_class -- wrapper for mpf_t ****************/

template <>
class __gmp_expr<mpf_t, mpf_t>
{
private:
  typedef mpf_t value_type;
  value_type mp;
public:
  unsigned long int get_prec() const { return mpf_get_prec(mp); }

  void set_prec(unsigned long int prec) { mpf_set_prec(mp, prec); }
  void set_prec_raw(unsigned long int prec) { mpf_set_prec_raw(mp, prec); }

  // constructors and destructor
  __gmp_expr() { mpf_init(mp); }

  __gmp_expr(const __gmp_expr &f)
  { mpf_init2(mp, f.get_prec()); mpf_set(mp, f.mp); }
  __gmp_expr(const __gmp_expr &f, unsigned long int prec)
  { mpf_init2(mp, prec); mpf_set(mp, f.mp); }
  template <class T, class U>
  __gmp_expr(const __gmp_expr<T, U> &expr)
  { mpf_init2(mp, expr.get_prec()); __gmp_set_expr(mp, expr); }
  template <class T, class U>
  __gmp_expr(const __gmp_expr<T, U> &expr, unsigned long int prec)
  { mpf_init2(mp, prec); __gmp_set_expr(mp, expr); }

  __gmp_expr(signed char c) { mpf_init_set_si(mp, c); }
  __gmp_expr(signed char c, unsigned long int prec)
  { mpf_init2(mp, prec); mpf_set_si(mp, c); }
  __gmp_expr(unsigned char c) { mpf_init_set_ui(mp, c); }
  __gmp_expr(unsigned char c, unsigned long int prec)
  { mpf_init2(mp, prec); mpf_set_ui(mp, c); }

  __gmp_expr(signed int i) { mpf_init_set_si(mp, i); }
  __gmp_expr(signed int i, unsigned long int prec)
  { mpf_init2(mp, prec); mpf_set_si(mp, i); }
  __gmp_expr(unsigned int i) { mpf_init_set_ui(mp, i); }
  __gmp_expr(unsigned int i, unsigned long int prec)
  { mpf_init2(mp, prec); mpf_set_ui(mp, i); }

  __gmp_expr(signed short int s) { mpf_init_set_si(mp, s); }
  __gmp_expr(signed short int s, unsigned long int prec)
  { mpf_init2(mp, prec); mpf_set_si(mp, s); }
  __gmp_expr(unsigned short int s) { mpf_init_set_ui(mp, s); }
  __gmp_expr(unsigned short int s, unsigned long int prec)
  { mpf_init2(mp, prec); mpf_set_ui(mp, s); }

  __gmp_expr(signed long int l) { mpf_init_set_si(mp, l); }
  __gmp_expr(signed long int l, unsigned long int prec)
  { mpf_init2(mp, prec); mpf_set_si(mp, l); }
  __gmp_expr(unsigned long int l) { mpf_init_set_ui(mp, l); }
  __gmp_expr(unsigned long int l, unsigned long int prec)
  { mpf_init2(mp, prec); mpf_set_ui(mp, l); }

  __gmp_expr(float f) { mpf_init_set_d(mp, f); }
  __gmp_expr(float f, unsigned long int prec)
  { mpf_init2(mp, prec); mpf_set_d(mp, f); }
  __gmp_expr(double d) { mpf_init_set_d(mp, d); }
  __gmp_expr(double d, unsigned long int prec)
  { mpf_init2(mp, prec); mpf_set_d(mp, d); }
  // __gmp_expr(long double ld) { mpf_init_set_d(mp, ld); }
  // __gmp_expr(long double ld, unsigned long int prec)
  // { mpf_init2(mp, prec); mpf_set_d(mp, ld); }

  explicit __gmp_expr(const char *s)
  {
    if (mpf_init_set_str (mp, s, 0) != 0)
      {
        mpf_clear (mp);
        throw std::invalid_argument ("mpf_set_str");
      }
  }
  __gmp_expr(const char *s, unsigned long int prec, int base = 0)
  {
    mpf_init2(mp, prec);
    if (mpf_set_str(mp, s, base) != 0)
      {
        mpf_clear (mp);
        throw std::invalid_argument ("mpf_set_str");
      }
  }
  explicit __gmp_expr(const std::string &s)
  {
    if (mpf_init_set_str(mp, s.c_str(), 0) != 0)
      {
        mpf_clear (mp);
        throw std::invalid_argument ("mpf_set_str");
      }
  }
  __gmp_expr(const std::string &s, unsigned long int prec, int base = 0)
  {
    mpf_init2(mp, prec);
    if (mpf_set_str(mp, s.c_str(), base) != 0)
      {
        mpf_clear (mp);
        throw std::invalid_argument ("mpf_set_str");
      }
  }

  explicit __gmp_expr(mpf_srcptr f)
  { mpf_init2(mp, mpf_get_prec(f)); mpf_set(mp, f); }
  __gmp_expr(mpf_srcptr f, unsigned long int prec)
  { mpf_init2(mp, prec); mpf_set(mp, f); }

  ~__gmp_expr() { mpf_clear(mp); }

  // assignment operators
  __gmp_expr & operator=(const __gmp_expr &f)
  { mpf_set(mp, f.mp); return *this; }
  template <class T, class U>
  __gmp_expr<value_type, value_type> & operator=(const __gmp_expr<T, U> &expr)
  { __gmp_set_expr(mp, expr); return *this; }

  __gmp_expr & operator=(signed char c) { mpf_set_si(mp, c); return *this; }
  __gmp_expr & operator=(unsigned char c) { mpf_set_ui(mp, c); return *this; }

  __gmp_expr & operator=(signed int i) { mpf_set_si(mp, i); return *this; }
  __gmp_expr & operator=(unsigned int i) { mpf_set_ui(mp, i); return *this; }

  __gmp_expr & operator=(signed short int s)
  { mpf_set_si(mp, s); return *this; }
  __gmp_expr & operator=(unsigned short int s)
  { mpf_set_ui(mp, s); return *this; }

  __gmp_expr & operator=(signed long int l)
  { mpf_set_si(mp, l); return *this; }
  __gmp_expr & operator=(unsigned long int l)
  { mpf_set_ui(mp, l); return *this; }

  __gmp_expr & operator=(float f) { mpf_set_d(mp, f); return *this; }
  __gmp_expr & operator=(double d) { mpf_set_d(mp, d); return *this; }
  // __gmp_expr & operator=(long double ld)
  // { mpf_set_ld(mp, ld); return *this; }

  __gmp_expr & operator=(const char *s)
  {
    if (mpf_set_str (mp, s, 0) != 0)
      throw std::invalid_argument ("mpf_set_str");
    return *this;
  }
  __gmp_expr & operator=(const std::string &s)
  {
    if (mpf_set_str(mp, s.c_str(), 0) != 0)
      throw std::invalid_argument ("mpf_set_str");
    return *this;
  }

  // string input/output functions
  int set_str(const char *s, int base)
  { return mpf_set_str(mp, s, base); }
  int set_str(const std::string &s, int base)
  { return mpf_set_str(mp, s.c_str(), base); }
  std::string get_str(mp_exp_t &expo, int base = 10, size_t size = 0) const
  {
    __gmp_alloc_cstring temp(mpf_get_str(0, &expo, base, size, mp));
    return std::string(temp.str);
  }

  // conversion functions
  mpf_srcptr __get_mp() const { return mp; }
  mpf_ptr __get_mp() { return mp; }
  mpf_srcptr get_mpf_t() const { return mp; }
  mpf_ptr get_mpf_t() { return mp; }

  signed long int get_si() const { return mpf_get_si(mp); }
  unsigned long int get_ui() const { return mpf_get_ui(mp); }
  double get_d() const { return mpf_get_d(mp); }

  // bool fits_schar_p() const { return mpf_fits_schar_p(mp); }
  // bool fits_uchar_p() const { return mpf_fits_uchar_p(mp); }
  bool fits_sint_p() const { return mpf_fits_sint_p(mp); }
  bool fits_uint_p() const { return mpf_fits_uint_p(mp); }
  bool fits_sshort_p() const { return mpf_fits_sshort_p(mp); }
  bool fits_ushort_p() const { return mpf_fits_ushort_p(mp); }
  bool fits_slong_p() const { return mpf_fits_slong_p(mp); }
  bool fits_ulong_p() const { return mpf_fits_ulong_p(mp); }
  // bool fits_float_p() const { return mpf_fits_float_p(mp); }
  // bool fits_double_p() const { return mpf_fits_double_p(mp); }
  // bool fits_ldouble_p() const { return mpf_fits_ldouble_p(mp); }

  // compound assignments
  __GMP_DECLARE_COMPOUND_OPERATOR(operator+=)
  __GMP_DECLARE_COMPOUND_OPERATOR(operator-=)
  __GMP_DECLARE_COMPOUND_OPERATOR(operator*=)
  __GMP_DECLARE_COMPOUND_OPERATOR(operator/=)

  __GMP_DECLARE_COMPOUND_OPERATOR_UI(operator<<=)
  __GMP_DECLARE_COMPOUND_OPERATOR_UI(operator>>=)

  __GMP_DECLARE_INCREMENT_OPERATOR(operator++)
  __GMP_DECLARE_INCREMENT_OPERATOR(operator--)
};

typedef __gmp_expr<mpf_t, mpf_t> mpf_class;



/**************** I/O operators ****************/

// these should (and will) be provided separately

template <class T>
inline std::ostream & operator<<
(std::ostream &o, const __gmp_expr<T, T> &expr)
{
  return o << expr.__get_mp();
}

template <class T, class U>
inline std::ostream & operator<<
(std::ostream &o, const __gmp_expr<T, U> &expr)
{
  __gmp_expr<T, T> temp(expr);
  return o << temp.__get_mp();
}


template <class T>
inline std::istream & operator>>(std::istream &i, __gmp_expr<T, T> &expr)
{
  return i >> expr.__get_mp();
}

inline std::istream & operator>>(std::istream &i, mpq_class &q)
{
  i >> q.get_mpq_t();
  // q.canonicalize(); // you might want to uncomment this
  return i;
}


/**************** Functions for type conversion ****************/

template <>
inline void __gmp_set_expr(mpz_ptr z, const mpz_class &w)
{
  mpz_set(z, w.get_mpz_t());
}

template <class T>
inline void __gmp_set_expr(mpz_ptr z, const __gmp_expr<mpz_t, T> &expr)
{
  expr.eval(z);
}

template <>
inline void __gmp_set_expr(mpz_ptr z, const mpq_class &q)
{
  mpz_set_q(z, q.get_mpq_t());
}

template <class T>
inline void __gmp_set_expr(mpz_ptr z, const __gmp_expr<mpq_t, T> &expr)
{
  mpq_class temp(expr);
  mpz_set_q(z, temp.get_mpq_t());
}

template <class T>
inline void __gmp_set_expr(mpz_ptr z, const mpf_class &f)
{
  mpz_set_f(z, f.get_mpf_t());
}

template <class T>
inline void __gmp_set_expr(mpz_ptr z, const __gmp_expr<mpf_t, T> &expr)
{
  mpf_class temp(expr);
  mpz_set_f(z, temp.get_mpf_t());
}

template <>
inline void __gmp_set_expr(mpq_ptr q, const mpz_class &z)
{
  mpq_set_z(q, z.get_mpz_t());
}

template <class T>
inline void __gmp_set_expr(mpq_ptr q, const __gmp_expr<mpz_t, T> &expr)
{
  mpz_class temp(expr);
  mpq_set_z(q, temp.get_mpz_t());
}

template <>
inline void __gmp_set_expr(mpq_ptr q, const mpq_class &r)
{
  mpq_set(q, r.get_mpq_t());
}

template <class T>
inline void __gmp_set_expr(mpq_ptr q, const __gmp_expr<mpq_t, T> &expr)
{
  expr.eval(q);
}

template <class T>
inline void __gmp_set_expr(mpq_ptr q, const mpf_class &f)
{
  mpq_set_f(q, f.get_mpf_t());
}

template <class T>
inline void __gmp_set_expr(mpq_ptr q, const __gmp_expr<mpf_t, T> &expr)
{
  mpf_class temp(expr);
  mpq_set_f(q, temp.get_mpf_t());
}

template <class T>
inline void __gmp_set_expr(mpf_ptr f, const mpz_class &z)
{
  mpf_set_z(f, z.get_mpz_t());
}

template <class T>
inline void __gmp_set_expr(mpf_ptr f, const __gmp_expr<mpz_t, T> &expr)
{
  mpz_class temp(expr);
  mpf_set_z(f, temp.get_mpz_t());
}

template <class T>
inline void __gmp_set_expr(mpf_ptr f, const mpq_class &q)
{
  mpf_set_q(f, q.get_mpq_t());
}

template <class T>
inline void __gmp_set_expr(mpf_ptr f, const __gmp_expr<mpq_t, T> &expr)
{
  mpq_class temp(expr);
  mpf_set_q(f, temp.get_mpq_t());
}

template <>
inline void __gmp_set_expr(mpf_ptr f, const mpf_class &g)
{
  mpf_set(f, g.get_mpf_t());
}

template <class T>
inline void __gmp_set_expr(mpf_ptr f, const __gmp_expr<mpf_t, T> &expr)
{
  expr.eval(f, mpf_get_prec(f));
}


/**************** Specializations of __gmp_expr ****************/
/* The eval() method of __gmp_expr<T, U> evaluates the corresponding
   expression and assigns the result to its argument, which is either an
   mpz_t, mpq_t, or mpf_t as specified by the T argument.
   Compound expressions are evaluated recursively (temporaries are created
   to hold intermediate values), while for simple expressions the eval()
   method of the appropriate function object (available as the Op argument
   of either __gmp_unary_expr<T, Op> or __gmp_binary_expr<T, U, Op>) is
   called. */


/**************** Unary expressions ****************/
/* cases:
   - simple:   argument is mp*_class, that is, __gmp_expr<T, T>
   - compound: argument is __gmp_expr<T, U> (with U not equal to T) */


// simple expressions

template <class T, class Op>
class __gmp_expr<T, __gmp_unary_expr<__gmp_expr<T, T>, Op> >
{
private:
  typedef __gmp_expr<T, T> val_type;

  __gmp_unary_expr<val_type, Op> expr;
public:
  __gmp_expr(const val_type &val) : expr(val) { }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p,
	    unsigned long int = 0) const
  { Op::eval(p, expr.val.__get_mp()); }
  const val_type & get_val() const { return expr.val; }
  unsigned long int get_prec() const { return expr.val.get_prec(); }
};


// compound expressions

template <class T, class U, class Op>
class __gmp_expr<T, __gmp_unary_expr<__gmp_expr<T, U>, Op> >
{
private:
  typedef __gmp_expr<T, U> val_type;

  __gmp_unary_expr<val_type, Op> expr;
public:
  __gmp_expr(const val_type &val) : expr(val) { }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p) const
  { __gmp_expr<T, T> temp(expr.val); Op::eval(p, temp.__get_mp()); }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p,
	    unsigned long int prec) const
  { __gmp_expr<T, T> temp(expr.val, prec); Op::eval(p, temp.__get_mp()); }
  const val_type & get_val() const { return expr.val; }
  unsigned long int get_prec() const { return expr.val.get_prec(); }
};


/**************** Binary expressions ****************/
/* simple:
   - arguments are both mp*_class
   - one argument is mp*_class, one is a built-in type
   compound:
   - one is mp*_class, one is __gmp_expr<T, U>
   - one is __gmp_expr<T, U>, one is built-in
   - both arguments are __gmp_expr<...> */


// simple expressions

template <class T, class Op>
class __gmp_expr
<T, __gmp_binary_expr<__gmp_expr<T, T>, __gmp_expr<T, T>, Op> >
{
private:
  typedef __gmp_expr<T, T> val1_type;
  typedef __gmp_expr<T, T> val2_type;

  __gmp_binary_expr<val1_type, val2_type, Op> expr;
public:
  __gmp_expr(const val1_type &val1, const val2_type &val2)
    : expr(val1, val2) { }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p,
	    unsigned long int = 0) const
  { Op::eval(p, expr.val1.__get_mp(), expr.val2.__get_mp()); }
  const val1_type & get_val1() const { return expr.val1; }
  const val2_type & get_val2() const { return expr.val2; }
  unsigned long int get_prec() const
  {
    unsigned long int prec1 = expr.val1.get_prec(),
      prec2 = expr.val2.get_prec();
    return (prec1 > prec2) ? prec1 : prec2;
  }
};


// simple expressions, T is a built-in numerical type

template <class T, class U, class Op>
class __gmp_expr<T, __gmp_binary_expr<__gmp_expr<T, T>, U, Op> >
{
private:
  typedef __gmp_expr<T, T> val1_type;
  typedef U val2_type;

  __gmp_binary_expr<val1_type, val2_type, Op> expr;
public:
  __gmp_expr(const val1_type &val1, const val2_type &val2)
    : expr(val1, val2) { }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p,
	    unsigned long int = 0) const
  { Op::eval(p, expr.val1.__get_mp(), expr.val2); }
  const val1_type & get_val1() const { return expr.val1; }
  const val2_type & get_val2() const { return expr.val2; }
  unsigned long int get_prec() const { return expr.val1.get_prec(); }
};

template <class T, class U, class Op>
class __gmp_expr<T, __gmp_binary_expr<U, __gmp_expr<T, T>, Op> >
{
private:
  typedef U val1_type;
  typedef __gmp_expr<T, T> val2_type;

  __gmp_binary_expr<val1_type, val2_type, Op> expr;
public:
  __gmp_expr(const val1_type &val1, const val2_type &val2)
    : expr(val1, val2) { }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p,
	    unsigned long int = 0) const
  { Op::eval(p, expr.val1, expr.val2.__get_mp()); }
  const val1_type & get_val1() const { return expr.val1; }
  const val2_type & get_val2() const { return expr.val2; }
  unsigned long int get_prec() const { return expr.val2.get_prec(); }
};


// compound expressions, one argument is a subexpression

template <class T, class U, class V, class Op>
class __gmp_expr
<T, __gmp_binary_expr<__gmp_expr<T, T>, __gmp_expr<U, V>, Op> >
{
private:
  typedef __gmp_expr<T, T> val1_type;
  typedef __gmp_expr<U, V> val2_type;

  __gmp_binary_expr<val1_type, val2_type, Op> expr;
public:
  __gmp_expr(const val1_type &val1, const val2_type &val2)
    : expr(val1, val2) { }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p) const
  {
    __gmp_expr<T, T> temp(expr.val2);
    Op::eval(p, expr.val1.__get_mp(), temp.__get_mp());
  }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p,
	    unsigned long int prec) const
  {
    __gmp_expr<T, T> temp(expr.val2, prec);
    Op::eval(p, expr.val1.__get_mp(), temp.__get_mp());
  }
  const val1_type & get_val1() const { return expr.val1; }
  const val2_type & get_val2() const { return expr.val2; }
  unsigned long int get_prec() const
  {
    unsigned long int prec1 = expr.val1.get_prec(),
      prec2 = expr.val2.get_prec();
    return (prec1 > prec2) ? prec1 : prec2;
  }
};

template <class T, class U, class V, class Op>
class __gmp_expr
<T, __gmp_binary_expr<__gmp_expr<U, V>, __gmp_expr<T, T>, Op> >
{
private:
  typedef __gmp_expr<U, V> val1_type;
  typedef __gmp_expr<T, T> val2_type;

  __gmp_binary_expr<val1_type, val2_type, Op> expr;
public:
  __gmp_expr(const val1_type &val1, const val2_type &val2)
    : expr(val1, val2) { }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p) const
  {
    __gmp_expr<T, T> temp(expr.val1);
    Op::eval(p, temp.__get_mp(), expr.val2.__get_mp());
  }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p,
	    unsigned long int prec) const
  {
    __gmp_expr<T, T> temp(expr.val1, prec);
    Op::eval(p, temp.__get_mp(), expr.val2.__get_mp());
  }
  const val1_type & get_val1() const { return expr.val1; }
  const val2_type & get_val2() const { return expr.val2; }
  unsigned long int get_prec() const
  {
    unsigned long int prec1 = expr.val1.get_prec(),
      prec2 = expr.val2.get_prec();
    return (prec1 > prec2) ? prec1 : prec2;
  }
};

template <class T, class U, class Op>
class __gmp_expr
<T, __gmp_binary_expr<__gmp_expr<T, T>, __gmp_expr<T, U>, Op> >
{
private:
  typedef __gmp_expr<T, T> val1_type;
  typedef __gmp_expr<T, U> val2_type;

  __gmp_binary_expr<val1_type, val2_type, Op> expr;
public:
  __gmp_expr(const val1_type &val1, const val2_type &val2)
    : expr(val1, val2) { }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p) const
  {
    __gmp_expr<T, T> temp(expr.val2);
    Op::eval(p, expr.val1.__get_mp(), temp.__get_mp());
  }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p,
	    unsigned long int prec) const
  {
    __gmp_expr<T, T> temp(expr.val2, prec);
    Op::eval(p, expr.val1.__get_mp(), temp.__get_mp());
  }
  const val1_type & get_val1() const { return expr.val1; }
  const val2_type & get_val2() const { return expr.val2; }
  unsigned long int get_prec() const
  {
    unsigned long int prec1 = expr.val1.get_prec(),
      prec2 = expr.val2.get_prec();
    return (prec1 > prec2) ? prec1 : prec2;
  }
};

template <class T, class U, class Op>
class __gmp_expr
<T, __gmp_binary_expr<__gmp_expr<T, U>, __gmp_expr<T, T>, Op> >
{
private:
  typedef __gmp_expr<T, U> val1_type;
  typedef __gmp_expr<T, T> val2_type;

  __gmp_binary_expr<val1_type, val2_type, Op> expr;
public:
  __gmp_expr(const val1_type &val1, const val2_type &val2)
    : expr(val1, val2) { }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p) const
  {
    __gmp_expr<T, T> temp(expr.val1);
    Op::eval(p, temp.__get_mp(), expr.val2.__get_mp());
  }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p,
	    unsigned long int prec) const
  {
    __gmp_expr<T, T> temp(expr.val1, prec);
    Op::eval(p, temp.__get_mp(), expr.val2.__get_mp());
  }
  const val1_type & get_val1() const { return expr.val1; }
  const val2_type & get_val2() const { return expr.val2; }
  unsigned long int get_prec() const
  {
    unsigned long int prec1 = expr.val1.get_prec(),
      prec2 = expr.val2.get_prec();
    return (prec1 > prec2) ? prec1 : prec2;
  }
};


// one argument is a subexpression, one is a built-in

template <class T, class U, class V, class Op>
class __gmp_expr<T, __gmp_binary_expr<__gmp_expr<T, U>, V, Op> >
{
private:
  typedef __gmp_expr<T, U> val1_type;
  typedef V val2_type;

  __gmp_binary_expr<val1_type, val2_type, Op> expr;
public:
  __gmp_expr(const val1_type &val1, const val2_type &val2)
    : expr(val1, val2) { }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p) const
  {
    __gmp_expr<T, T> temp(expr.val1);
    Op::eval(p, temp.__get_mp(), expr.val2);
  }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p,
	    unsigned long int prec) const
  {
    __gmp_expr<T, T> temp(expr.val1, prec);
    Op::eval(p, temp.__get_mp(), expr.val2);
  }
  const val1_type & get_val1() const { return expr.val1; }
  const val2_type & get_val2() const { return expr.val2; }
  unsigned long int get_prec() const { return expr.val1.get_prec(); }
};

template <class T, class U, class V, class Op>
class __gmp_expr<T, __gmp_binary_expr<U, __gmp_expr<T, V>, Op> >
{
private:
  typedef U val1_type;
  typedef __gmp_expr<T, V> val2_type;

  __gmp_binary_expr<val1_type, val2_type, Op> expr;
public:
  __gmp_expr(const val1_type &val1, const val2_type &val2)
    : expr(val1, val2) { }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p) const
  {
    __gmp_expr<T, T> temp(expr.val2);
    Op::eval(p, expr.val1, temp.__get_mp());
  }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p,
	    unsigned long int prec) const
  {
    __gmp_expr<T, T> temp(expr.val2, prec);
    Op::eval(p, expr.val1, temp.__get_mp());
  }
  const val1_type & get_val1() const { return expr.val1; }
  const val2_type & get_val2() const { return expr.val2; }
  unsigned long int get_prec() const { return expr.val2.get_prec(); }
};


// both arguments are subexpressions

template <class T, class U, class V, class W, class Op>
class __gmp_expr
<T, __gmp_binary_expr<__gmp_expr<T, U>, __gmp_expr<V, W>, Op> >
{
private:
  typedef __gmp_expr<T, U> val1_type;
  typedef __gmp_expr<V, W> val2_type;

  __gmp_binary_expr<val1_type, val2_type, Op> expr;
public:
  __gmp_expr(const val1_type &val1, const val2_type &val2)
    : expr(val1, val2) { }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p) const
  {
    __gmp_expr<T, T> temp1(expr.val1), temp2(expr.val2);
    Op::eval(p, temp1.__get_mp(), temp2.__get_mp());
  }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p,
	    unsigned long int prec) const
  {
    __gmp_expr<T, T> temp1(expr.val1, prec), temp2(expr.val2, prec);
    Op::eval(p, temp1.__get_mp(), temp2.__get_mp());
  }
  const val1_type & get_val1() const { return expr.val1; }
  const val2_type & get_val2() const { return expr.val2; }
  unsigned long int get_prec() const
  {
    unsigned long int prec1 = expr.val1.get_prec(),
      prec2 = expr.val2.get_prec();
    return (prec1 > prec2) ? prec1 : prec2;
  }
};

template <class T, class U, class V, class W, class Op>
class __gmp_expr
<T, __gmp_binary_expr<__gmp_expr<U, V>, __gmp_expr<T, W>, Op> >
{
private:
  typedef __gmp_expr<U, V> val1_type;
  typedef __gmp_expr<T, W> val2_type;

  __gmp_binary_expr<val1_type, val2_type, Op> expr;
public:
  __gmp_expr(const val1_type &val1, const val2_type &val2)
    : expr(val1, val2) { }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p) const
  {
    __gmp_expr<T, T> temp1(expr.val1), temp2(expr.val2);
    Op::eval(p, temp1.__get_mp(), temp2.__get_mp());
  }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p,
	    unsigned long int prec) const
  {
    __gmp_expr<T, T> temp1(expr.val1, prec), temp2(expr.val2, prec);
    Op::eval(p, temp1.__get_mp(), temp2.__get_mp());
  }
  const val1_type & get_val1() const { return expr.val1; }
  const val2_type & get_val2() const { return expr.val2; }
  unsigned long int get_prec() const
  {
    unsigned long int prec1 = expr.val1.get_prec(),
      prec2 = expr.val2.get_prec();
    return (prec1 > prec2) ? prec1 : prec2;
  }
};

template <class T, class U, class V, class Op>
class __gmp_expr
<T, __gmp_binary_expr<__gmp_expr<T, U>, __gmp_expr<T, V>, Op> >
{
private:
  typedef __gmp_expr<T, U> val1_type;
  typedef __gmp_expr<T, V> val2_type;

  __gmp_binary_expr<val1_type, val2_type, Op> expr;
public:
  __gmp_expr(const val1_type &val1, const val2_type &val2)
    : expr(val1, val2) { }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p) const
  {
    __gmp_expr<T, T> temp1(expr.val1), temp2(expr.val2);
    Op::eval(p, temp1.__get_mp(), temp2.__get_mp());
  }
  void eval(typename __gmp_resolve_expr<T>::ptr_type p,
	    unsigned long int prec) const
  {
    __gmp_expr<T, T> temp1(expr.val1, prec), temp2(expr.val2, prec);
    Op::eval(p, temp1.__get_mp(), temp2.__get_mp());
  }
  const val1_type & get_val1() const { return expr.val1; }
  const val2_type & get_val2() const { return expr.val2; }
  unsigned long int get_prec() const
  {
    unsigned long int prec1 = expr.val1.get_prec(),
      prec2 = expr.val2.get_prec();
    return (prec1 > prec2) ? prec1 : prec2;
  }
};


/**************** Special cases ****************/

/* Some operations (i.e., add and subtract) with mixed mpz/mpq arguments
   can be done directly without first converting the mpz to mpq.
   Appropriate specializations of __gmp_expr are required. */


#define __GMPZQ_DEFINE_EXPR(eval_fun)                                       \
                                                                            \
template <>                                                                 \
class __gmp_expr<mpq_t, __gmp_binary_expr<mpz_class, mpq_class, eval_fun> > \
{                                                                           \
private:                                                                    \
  typedef mpz_class val1_type;                                              \
  typedef mpq_class val2_type;                                              \
                                                                            \
  __gmp_binary_expr<val1_type, val2_type, eval_fun> expr;                   \
public:                                                                     \
  __gmp_expr(const val1_type &val1, const val2_type &val2)                  \
    : expr(val1, val2) { }                                                  \
  void eval(mpq_ptr q) const                                                \
  { eval_fun::eval(q, expr.val1.get_mpz_t(), expr.val2.get_mpq_t()); }      \
  const val1_type & get_val1() const { return expr.val1; }                  \
  const val2_type & get_val2() const { return expr.val2; }                  \
  unsigned long int get_prec() const { return mpf_get_default_prec(); }     \
};                                                                          \
                                                                            \
template <>                                                                 \
class __gmp_expr<mpq_t, __gmp_binary_expr<mpq_class, mpz_class, eval_fun> > \
{                                                                           \
private:                                                                    \
  typedef mpq_class val1_type;                                              \
  typedef mpz_class val2_type;                                              \
                                                                            \
  __gmp_binary_expr<val1_type, val2_type, eval_fun> expr;                   \
public:                                                                     \
  __gmp_expr(const val1_type &val1, const val2_type &val2)                  \
    : expr(val1, val2) { }                                                  \
  void eval(mpq_ptr q) const                                                \
  { eval_fun::eval(q, expr.val1.get_mpq_t(), expr.val2.get_mpz_t()); }      \
  const val1_type & get_val1() const { return expr.val1; }                  \
  const val2_type & get_val2() const { return expr.val2; }                  \
  unsigned long int get_prec() const { return mpf_get_default_prec(); }     \
};                                                                          \
                                                                            \
template <class T>                                                          \
class __gmp_expr                                                            \
<mpq_t, __gmp_binary_expr<mpz_class, __gmp_expr<mpq_t, T>, eval_fun> >      \
{                                                                           \
private:                                                                    \
  typedef mpz_class val1_type;                                              \
  typedef __gmp_expr<mpq_t, T> val2_type;                                   \
                                                                            \
  __gmp_binary_expr<val1_type, val2_type, eval_fun> expr;                   \
public:                                                                     \
  __gmp_expr(const val1_type &val1, const val2_type &val2)                  \
    : expr(val1, val2) { }                                                  \
  void eval(mpq_ptr q) const                                                \
  {                                                                         \
    mpq_class temp(expr.val2);                                              \
    eval_fun::eval(q, expr.val1.get_mpz_t(), temp.get_mpq_t());             \
  }                                                                         \
  const val1_type & get_val1() const { return expr.val1; }                  \
  const val2_type & get_val2() const { return expr.val2; }                  \
  unsigned long int get_prec() const { return mpf_get_default_prec(); }     \
};                                                                          \
                                                                            \
template <class T>                                                          \
class __gmp_expr                                                            \
<mpq_t, __gmp_binary_expr<mpq_class, __gmp_expr<mpz_t, T>, eval_fun> >      \
{                                                                           \
private:                                                                    \
  typedef mpq_class val1_type;                                              \
  typedef __gmp_expr<mpz_t, T> val2_type;                                   \
                                                                            \
  __gmp_binary_expr<val1_type, val2_type, eval_fun> expr;                   \
public:                                                                     \
  __gmp_expr(const val1_type &val1, const val2_type &val2)                  \
    : expr(val1, val2) { }                                                  \
  void eval(mpq_ptr q) const                                                \
  {                                                                         \
    mpz_class temp(expr.val2);                                              \
    eval_fun::eval(q, expr.val1.get_mpq_t(), temp.get_mpz_t());             \
  }                                                                         \
  const val1_type & get_val1() const { return expr.val1; }                  \
  const val2_type & get_val2() const { return expr.val2; }                  \
  unsigned long int get_prec() const { return mpf_get_default_prec(); }     \
};                                                                          \
                                                                            \
template <class T>                                                          \
class __gmp_expr                                                            \
<mpq_t, __gmp_binary_expr<__gmp_expr<mpz_t, T>, mpq_class, eval_fun> >      \
{                                                                           \
private:                                                                    \
  typedef __gmp_expr<mpz_t, T> val1_type;                                   \
  typedef mpq_class val2_type;                                              \
                                                                            \
  __gmp_binary_expr<val1_type, val2_type, eval_fun> expr;                   \
public:                                                                     \
  __gmp_expr(const val1_type &val1, const val2_type &val2)                  \
    : expr(val1, val2) { }                                                  \
  void eval(mpq_ptr q) const                                                \
  {                                                                         \
    mpz_class temp(expr.val1);                                              \
    eval_fun::eval(q, temp.get_mpz_t(), expr.val2.get_mpq_t());             \
  }                                                                         \
  const val1_type & get_val1() const { return expr.val1; }                  \
  const val2_type & get_val2() const { return expr.val2; }                  \
  unsigned long int get_prec() const { return mpf_get_default_prec(); }     \
};                                                                          \
                                                                            \
template <class T>                                                          \
class __gmp_expr                                                            \
<mpq_t, __gmp_binary_expr<__gmp_expr<mpq_t, T>, mpz_class, eval_fun> >      \
{                                                                           \
private:                                                                    \
  typedef __gmp_expr<mpq_t, T> val1_type;                                   \
  typedef mpz_class val2_type;                                              \
                                                                            \
  __gmp_binary_expr<val1_type, val2_type, eval_fun> expr;                   \
public:                                                                     \
  __gmp_expr(const val1_type &val1, const val2_type &val2)                  \
    : expr(val1, val2) { }                                                  \
  void eval(mpq_ptr q) const                                                \
  {                                                                         \
    mpq_class temp(expr.val1);                                              \
    eval_fun::eval(q, temp.get_mpq_t(), expr.val2.get_mpz_t());             \
  }                                                                         \
  const val1_type & get_val1() const { return expr.val1; }                  \
  const val2_type & get_val2() const { return expr.val2; }                  \
  unsigned long int get_prec() const { return mpf_get_default_prec(); }     \
};                                                                          \
                                                                            \
template <class T, class U>                                                 \
class __gmp_expr<mpq_t, __gmp_binary_expr                                   \
<__gmp_expr<mpz_t, T>, __gmp_expr<mpq_t, U>, eval_fun> >                    \
{                                                                           \
private:                                                                    \
  typedef __gmp_expr<mpz_t, T> val1_type;                                   \
  typedef __gmp_expr<mpq_t, U> val2_type;                                   \
                                                                            \
  __gmp_binary_expr<val1_type, val2_type, eval_fun> expr;                   \
public:                                                                     \
  __gmp_expr(const val1_type &val1, const val2_type &val2)                  \
    : expr(val1, val2) { }                                                  \
  void eval(mpq_ptr q) const                                                \
  {                                                                         \
    mpz_class temp1(expr.val1);                                             \
    mpq_class temp2(expr.val2);                                             \
    eval_fun::eval(q, temp1.get_mpz_t(), temp2.get_mpq_t());                \
  }                                                                         \
  const val1_type & get_val1() const { return expr.val1; }                  \
  const val2_type & get_val2() const { return expr.val2; }                  \
  unsigned long int get_prec() const { return mpf_get_default_prec(); }     \
};                                                                          \
                                                                            \
template <class T, class U>                                                 \
class __gmp_expr<mpq_t, __gmp_binary_expr                                   \
<__gmp_expr<mpq_t, T>, __gmp_expr<mpz_t, U>, eval_fun> >                    \
{                                                                           \
private:                                                                    \
  typedef __gmp_expr<mpq_t, T> val1_type;                                   \
  typedef __gmp_expr<mpz_t, U> val2_type;                                   \
                                                                            \
  __gmp_binary_expr<val1_type, val2_type, eval_fun> expr;                   \
public:                                                                     \
  __gmp_expr(const val1_type &val1, const val2_type &val2)                  \
    : expr(val1, val2) { }                                                  \
  void eval(mpq_ptr q) const                                                \
  {                                                                         \
    mpq_class temp1(expr.val1);                                             \
    mpz_class temp2(expr.val2);                                             \
    eval_fun::eval(q, temp1.get_mpq_t(), temp2.get_mpz_t());                \
  }                                                                         \
  const val1_type & get_val1() const { return expr.val1; }                  \
  const val2_type & get_val2() const { return expr.val2; }                  \
  unsigned long int get_prec() const { return mpf_get_default_prec(); }     \
};


__GMPZQ_DEFINE_EXPR(__gmp_binary_plus)
__GMPZQ_DEFINE_EXPR(__gmp_binary_minus)

/**************** Macros for defining functions ****************/
/* Results of operators and functions are instances of __gmp_expr<T, U>.
   T determines the numerical type of the expression: it can be either
   mpz_t, mpq_t, or mpf_t.  When the arguments of a binary
   expression have different numerical types, __gmp_resolve_expr is used
   to determine the "larger" type.
   U is either __gmp_unary_expr<V, Op> or __gmp_binary_expr<V, W, Op>,
   where V and W are the arguments' types -- they can in turn be
   expressions, thus allowing to build compound expressions to any
   degree of complexity.
   Op is a function object that must have an eval() method accepting
   appropriate arguments.
   Actual evaluation of a __gmp_expr<T, U> object is done when it gets
   assigned to an mp*_class ("lazy" evaluation): this is done by calling
   its eval() method. */


// non-member unary operators and functions

#define __GMP_DEFINE_UNARY_FUNCTION(fun, eval_fun)                           \
                                                                             \
template <class T, class U>                                                  \
inline __gmp_expr<T, __gmp_unary_expr<__gmp_expr<T, U>, eval_fun> >          \
fun(const __gmp_expr<T, U> &expr)                                            \
{                                                                            \
  return __gmp_expr<T, __gmp_unary_expr<__gmp_expr<T, U>, eval_fun> >(expr); \
}

#define __GMP_DEFINE_UNARY_TYPE_FUNCTION(type, fun, eval_fun) \
                                                              \
template <class T, class U>                                   \
inline type fun(const __gmp_expr<T, U> &expr)                 \
{                                                             \
  typename __gmp_resolve_temp<T, T, U>::temp_type temp(expr); \
  return eval_fun::eval(temp.__get_mp());                     \
}


// non-member binary operators and functions

#define __GMPP_DEFINE_BINARY_FUNCTION(fun, eval_fun)                   \
                                                                       \
template <class T, class U, class V, class W>                          \
inline __gmp_expr<typename __gmp_resolve_expr<T, V>::value_type,       \
__gmp_binary_expr<__gmp_expr<T, U>, __gmp_expr<V, W>, eval_fun> >      \
fun(const __gmp_expr<T, U> &expr1, const __gmp_expr<V, W> &expr2)      \
{                                                                      \
  return __gmp_expr<typename __gmp_resolve_expr<T, V>::value_type,     \
     __gmp_binary_expr<__gmp_expr<T, U>, __gmp_expr<V, W>, eval_fun> > \
    (expr1, expr2);                                                    \
}

#define __GMPNN_DEFINE_BINARY_FUNCTION(fun, eval_fun, type, bigtype)       \
                                                                           \
template <class T, class U>                                                \
inline __gmp_expr                                                          \
<T, __gmp_binary_expr<__gmp_expr<T, U>, bigtype, eval_fun> >               \
fun(const __gmp_expr<T, U> &expr, type t)                                  \
{                                                                          \
  return __gmp_expr                                                        \
    <T, __gmp_binary_expr<__gmp_expr<T, U>, bigtype, eval_fun> >(expr, t); \
}                                                                          \
                                                                           \
template <class T, class U>                                                \
inline __gmp_expr                                                          \
<T, __gmp_binary_expr<bigtype, __gmp_expr<T, U>, eval_fun> >               \
fun(type t, const __gmp_expr<T, U> &expr)                                  \
{                                                                          \
  return __gmp_expr                                                        \
    <T, __gmp_binary_expr<bigtype, __gmp_expr<T, U>, eval_fun> >(t, expr); \
}

#define __GMPNS_DEFINE_BINARY_FUNCTION(fun, eval_fun, type)          \
__GMPNN_DEFINE_BINARY_FUNCTION(fun, eval_fun, type, signed long int)

#define __GMPNU_DEFINE_BINARY_FUNCTION(fun, eval_fun, type)            \
__GMPNN_DEFINE_BINARY_FUNCTION(fun, eval_fun, type, unsigned long int)

#define __GMPND_DEFINE_BINARY_FUNCTION(fun, eval_fun, type) \
__GMPNN_DEFINE_BINARY_FUNCTION(fun, eval_fun, type, double)

#define __GMPNLD_DEFINE_BINARY_FUNCTION(fun, eval_fun, type)     \
__GMPNN_DEFINE_BINARY_FUNCTION(fun, eval_fun, type, long double)

#define __GMPN_DEFINE_BINARY_FUNCTION(fun, eval_fun)              \
__GMPNS_DEFINE_BINARY_FUNCTION(fun, eval_fun, signed char)        \
__GMPNU_DEFINE_BINARY_FUNCTION(fun, eval_fun, unsigned char)      \
__GMPNS_DEFINE_BINARY_FUNCTION(fun, eval_fun, signed int)         \
__GMPNU_DEFINE_BINARY_FUNCTION(fun, eval_fun, unsigned int)       \
__GMPNS_DEFINE_BINARY_FUNCTION(fun, eval_fun, signed short int)   \
__GMPNU_DEFINE_BINARY_FUNCTION(fun, eval_fun, unsigned short int) \
__GMPNS_DEFINE_BINARY_FUNCTION(fun, eval_fun, signed long int)    \
__GMPNU_DEFINE_BINARY_FUNCTION(fun, eval_fun, unsigned long int)  \
__GMPND_DEFINE_BINARY_FUNCTION(fun, eval_fun, float)              \
__GMPND_DEFINE_BINARY_FUNCTION(fun, eval_fun, double)             \
__GMPNLD_DEFINE_BINARY_FUNCTION(fun, eval_fun, long double)

#define __GMP_DEFINE_BINARY_FUNCTION(fun, eval_fun) \
__GMPP_DEFINE_BINARY_FUNCTION(fun, eval_fun)        \
__GMPN_DEFINE_BINARY_FUNCTION(fun, eval_fun)


#define __GMP_DEFINE_BINARY_FUNCTION_UI(fun, eval_fun)                 \
                                                                       \
template <class T, class U>                                            \
inline __gmp_expr                                                      \
<T, __gmp_binary_expr<__gmp_expr<T, U>, unsigned long int, eval_fun> > \
fun(const __gmp_expr<T, U> &expr, unsigned long int l)                 \
{                                                                      \
  return __gmp_expr<T, __gmp_binary_expr                               \
    <__gmp_expr<T, U>, unsigned long int, eval_fun> >(expr, l);        \
}


#define __GMPP_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun)         \
                                                                        \
template <class T, class U, class V, class W>                           \
inline type fun(const __gmp_expr<T, U> &expr1,                          \
		const __gmp_expr<V, W> &expr2)                          \
{                                                                       \
  typedef typename __gmp_resolve_expr<T, V>::value_type eval_type;      \
  typename __gmp_resolve_temp<eval_type, T, U>::temp_type temp1(expr1); \
  typename __gmp_resolve_temp<eval_type, V, W>::temp_type temp2(expr2); \
  return eval_fun::eval(temp1.__get_mp(), temp2.__get_mp());            \
}

#define __GMPNN_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun,   \
					    type2, bigtype)        \
                                                                   \
template <class T, class U>                                        \
inline type fun(const __gmp_expr<T, U> &expr, type2 t)             \
{                                                                  \
  typename __gmp_resolve_temp<T, T, U>::temp_type temp(expr);      \
  return eval_fun::eval(temp.__get_mp(), static_cast<bigtype>(t)); \
}                                                                  \
                                                                   \
template <class T, class U>                                        \
inline type fun(type2 t, const __gmp_expr<T, U> &expr)             \
{                                                                  \
  typename __gmp_resolve_temp<T, T, U>::temp_type temp(expr);      \
  return eval_fun::eval(static_cast<bigtype>(t), temp.__get_mp()); \
}

#define __GMPNS_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun, type2) \
__GMPNN_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun,                \
				    type2, signed long int)

#define __GMPNU_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun, type2) \
__GMPNN_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun,                \
				    type2, unsigned long int)

#define __GMPND_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun, type2) \
__GMPNN_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun, type2, double)

#define __GMPNLD_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun, type2)     \
__GMPNN_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun, type2, long double)

#define __GMPN_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun)              \
__GMPNS_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun, signed char)        \
__GMPNU_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun, unsigned char)      \
__GMPNS_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun, signed int)         \
__GMPNU_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun, unsigned int)       \
__GMPNS_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun, signed short int)   \
__GMPNU_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun, unsigned short int) \
__GMPNS_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun, signed long int)    \
__GMPNU_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun, unsigned long int)  \
__GMPND_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun, float)              \
__GMPND_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun, double)             \
__GMPNLD_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun, long double)

#define __GMP_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun) \
__GMPP_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun)        \
__GMPN_DEFINE_BINARY_TYPE_FUNCTION(type, fun, eval_fun)


// member operators

#define __GMPP_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun)                 \
                                                                             \
template <class T, class U>                                                  \
inline type##_class & type##_class::fun(const __gmp_expr<T, U> &expr)        \
{                                                                            \
  __gmp_set_expr(mp, __gmp_expr<type##_t, __gmp_binary_expr                  \
		 <type##_class, __gmp_expr<T, U>, eval_fun> >(*this, expr)); \
  return *this;                                                              \
}

#define __GMPNN_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun,    \
					 type2, bigtype)         \
                                                                 \
inline type##_class & type##_class::fun(type2 t)                 \
{                                                                \
  __gmp_set_expr(mp, __gmp_expr<type##_t, __gmp_binary_expr      \
		 <type##_class, bigtype, eval_fun> >(*this, t)); \
  return *this;                                                  \
}

#define __GMPNS_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun, type2) \
__GMPNN_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun,                \
				 type2, signed long int)

#define __GMPNU_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun, type2) \
__GMPNN_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun,                \
				 type2, unsigned long int)

#define __GMPND_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun, type2) \
__GMPNN_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun, type2, double)

#define __GMPNLD_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun, type2)     \
__GMPNN_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun, type2, long double)

#define __GMPN_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun)              \
__GMPNS_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun, signed char)        \
__GMPNU_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun, unsigned char)      \
__GMPNS_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun, signed int)         \
__GMPNU_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun, unsigned int)       \
__GMPNS_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun, signed short int)   \
__GMPNU_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun, unsigned short int) \
__GMPNS_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun, signed long int)    \
__GMPNU_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun, unsigned long int)  \
__GMPND_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun, float)              \
__GMPND_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun, double)             \
/* __GMPNLD_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun, long double) */

#define __GMP_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun) \
__GMPP_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun)        \
__GMPN_DEFINE_COMPOUND_OPERATOR(type, fun, eval_fun)

#define __GMPZ_DEFINE_COMPOUND_OPERATOR(fun, eval_fun) \
__GMP_DEFINE_COMPOUND_OPERATOR(mpz, fun, eval_fun)

#define __GMPZZ_DEFINE_COMPOUND_OPERATOR(fun, eval_fun) \
__GMPP_DEFINE_COMPOUND_OPERATOR(mpz, fun, eval_fun)

#define __GMPQ_DEFINE_COMPOUND_OPERATOR(fun, eval_fun) \
__GMP_DEFINE_COMPOUND_OPERATOR(mpq, fun, eval_fun)

#define __GMPF_DEFINE_COMPOUND_OPERATOR(fun, eval_fun) \
__GMP_DEFINE_COMPOUND_OPERATOR(mpf, fun, eval_fun)



#define __GMP_DEFINE_COMPOUND_OPERATOR_UI(type, fun, eval_fun)  \
                                                                \
inline type##_class & type##_class::fun(unsigned long int l)    \
{                                                               \
  __gmp_set_expr(mp, __gmp_expr<type##_t, __gmp_binary_expr     \
    <type##_class, unsigned long int, eval_fun> >(*this, l));   \
  return *this;                                                 \
}

#define __GMPZ_DEFINE_COMPOUND_OPERATOR_UI(fun, eval_fun) \
__GMP_DEFINE_COMPOUND_OPERATOR_UI(mpz, fun, eval_fun)

#define __GMPQ_DEFINE_COMPOUND_OPERATOR_UI(fun, eval_fun) \
__GMP_DEFINE_COMPOUND_OPERATOR_UI(mpq, fun, eval_fun)

#define __GMPF_DEFINE_COMPOUND_OPERATOR_UI(fun, eval_fun) \
__GMP_DEFINE_COMPOUND_OPERATOR_UI(mpf, fun, eval_fun)



#define __GMP_DEFINE_INCREMENT_OPERATOR(type, fun, eval_fun) \
                                                             \
inline type##_class & type##_class::fun()                    \
{                                                            \
  eval_fun::eval(mp);                                        \
  return *this;                                              \
}                                                            \
                                                             \
inline type##_class type##_class::fun(int)                   \
{                                                            \
  type##_class temp(*this);                                  \
  eval_fun::eval(mp);                                        \
  return temp;                                               \
}

#define __GMPZ_DEFINE_INCREMENT_OPERATOR(fun, eval_fun) \
__GMP_DEFINE_INCREMENT_OPERATOR(mpz, fun, eval_fun)

#define __GMPQ_DEFINE_INCREMENT_OPERATOR(fun, eval_fun) \
__GMP_DEFINE_INCREMENT_OPERATOR(mpq, fun, eval_fun)

#define __GMPF_DEFINE_INCREMENT_OPERATOR(fun, eval_fun) \
__GMP_DEFINE_INCREMENT_OPERATOR(mpf, fun, eval_fun)



/**************** Arithmetic operators and functions ****************/

// non-member operators and functions

__GMP_DEFINE_UNARY_FUNCTION(operator+, __gmp_unary_plus)
__GMP_DEFINE_UNARY_FUNCTION(operator-, __gmp_unary_minus)
__GMP_DEFINE_UNARY_FUNCTION(operator~, __gmp_unary_com)

__GMP_DEFINE_BINARY_FUNCTION(operator+, __gmp_binary_plus)
__GMP_DEFINE_BINARY_FUNCTION(operator-, __gmp_binary_minus)
__GMP_DEFINE_BINARY_FUNCTION(operator*, __gmp_binary_multiplies)
__GMP_DEFINE_BINARY_FUNCTION(operator/, __gmp_binary_divides)
__GMP_DEFINE_BINARY_FUNCTION(operator%, __gmp_binary_modulus)
__GMP_DEFINE_BINARY_FUNCTION(operator&, __gmp_binary_and)
__GMP_DEFINE_BINARY_FUNCTION(operator|, __gmp_binary_ior)
__GMP_DEFINE_BINARY_FUNCTION(operator^, __gmp_binary_xor)

__GMP_DEFINE_BINARY_FUNCTION_UI(operator<<, __gmp_binary_lshift)
__GMP_DEFINE_BINARY_FUNCTION_UI(operator>>, __gmp_binary_rshift)

__GMP_DEFINE_BINARY_TYPE_FUNCTION(bool, operator==, __gmp_binary_equal)
__GMP_DEFINE_BINARY_TYPE_FUNCTION(bool, operator!=, __gmp_binary_not_equal)
__GMP_DEFINE_BINARY_TYPE_FUNCTION(bool, operator<, __gmp_binary_less)
__GMP_DEFINE_BINARY_TYPE_FUNCTION(bool, operator<=, __gmp_binary_less_equal)
__GMP_DEFINE_BINARY_TYPE_FUNCTION(bool, operator>, __gmp_binary_greater)
__GMP_DEFINE_BINARY_TYPE_FUNCTION(bool, operator>=, \
                                  __gmp_binary_greater_equal)

__GMP_DEFINE_UNARY_FUNCTION(abs, __gmp_abs_function)
__GMP_DEFINE_UNARY_FUNCTION(trunc, __gmp_trunc_function)
__GMP_DEFINE_UNARY_FUNCTION(floor, __gmp_floor_function)
__GMP_DEFINE_UNARY_FUNCTION(ceil, __gmp_ceil_function)
__GMP_DEFINE_UNARY_FUNCTION(sqrt, __gmp_sqrt_function)
__GMP_DEFINE_BINARY_FUNCTION(hypot, __gmp_hypot_function)

__GMP_DEFINE_UNARY_TYPE_FUNCTION(int, sgn, __gmp_sgn_function)
__GMP_DEFINE_BINARY_TYPE_FUNCTION(int, cmp, __gmp_cmp_function)

// member operators for mpz_class

__GMPZ_DEFINE_COMPOUND_OPERATOR(operator+=, __gmp_binary_plus)
__GMPZ_DEFINE_COMPOUND_OPERATOR(operator-=, __gmp_binary_minus)
__GMPZ_DEFINE_COMPOUND_OPERATOR(operator*=, __gmp_binary_multiplies)
__GMPZ_DEFINE_COMPOUND_OPERATOR(operator/=, __gmp_binary_divides)
__GMPZ_DEFINE_COMPOUND_OPERATOR(operator%=, __gmp_binary_modulus)

__GMPZZ_DEFINE_COMPOUND_OPERATOR(operator&=, __gmp_binary_and)
__GMPZZ_DEFINE_COMPOUND_OPERATOR(operator|=, __gmp_binary_ior)
__GMPZZ_DEFINE_COMPOUND_OPERATOR(operator^=, __gmp_binary_xor)

__GMPZ_DEFINE_COMPOUND_OPERATOR_UI(operator<<=, __gmp_binary_lshift)
__GMPZ_DEFINE_COMPOUND_OPERATOR_UI(operator>>=, __gmp_binary_rshift)

__GMPZ_DEFINE_INCREMENT_OPERATOR(operator++, __gmp_unary_increment)
__GMPZ_DEFINE_INCREMENT_OPERATOR(operator--, __gmp_unary_decrement)

// member operators for mpq_class

__GMPQ_DEFINE_COMPOUND_OPERATOR(operator+=, __gmp_binary_plus)
__GMPQ_DEFINE_COMPOUND_OPERATOR(operator-=, __gmp_binary_minus)
__GMPQ_DEFINE_COMPOUND_OPERATOR(operator*=, __gmp_binary_multiplies)
__GMPQ_DEFINE_COMPOUND_OPERATOR(operator/=, __gmp_binary_divides)

__GMPQ_DEFINE_COMPOUND_OPERATOR_UI(operator<<=, __gmp_binary_lshift)
__GMPQ_DEFINE_COMPOUND_OPERATOR_UI(operator>>=, __gmp_binary_rshift)

__GMPQ_DEFINE_INCREMENT_OPERATOR(operator++, __gmp_unary_increment)
__GMPQ_DEFINE_INCREMENT_OPERATOR(operator--, __gmp_unary_decrement)

// member operators for mpf_class

__GMPF_DEFINE_COMPOUND_OPERATOR(operator+=, __gmp_binary_plus)
__GMPF_DEFINE_COMPOUND_OPERATOR(operator-=, __gmp_binary_minus)
__GMPF_DEFINE_COMPOUND_OPERATOR(operator*=, __gmp_binary_multiplies)
__GMPF_DEFINE_COMPOUND_OPERATOR(operator/=, __gmp_binary_divides)

__GMPF_DEFINE_COMPOUND_OPERATOR_UI(operator<<=, __gmp_binary_lshift)
__GMPF_DEFINE_COMPOUND_OPERATOR_UI(operator>>=, __gmp_binary_rshift)

__GMPF_DEFINE_INCREMENT_OPERATOR(operator++, __gmp_unary_increment)
__GMPF_DEFINE_INCREMENT_OPERATOR(operator--, __gmp_unary_decrement)



/**************** Class wrapper for gmp_randstate_t ****************/

class __gmp_urandomb_value { };
class __gmp_urandomm_value { };

template <>
class __gmp_expr<mpz_t, __gmp_urandomb_value>
{
private:
  __gmp_randstate_struct *state;
  unsigned long int bits;
public:
  __gmp_expr(gmp_randstate_t s, unsigned long int l) : state(s), bits(l) { }
  void eval(mpz_ptr z) const { __gmp_rand_function::eval(z, state, bits); }
  unsigned long int get_prec() const { return mpf_get_default_prec(); }
};

template <>
class __gmp_expr<mpz_t, __gmp_urandomm_value>
{
private:
  __gmp_randstate_struct *state;
  mpz_class range;
public:
  __gmp_expr(gmp_randstate_t s, const mpz_class &z) : state(s), range(z) { }
  void eval(mpz_ptr z) const
  { __gmp_rand_function::eval(z, state, range.get_mpz_t()); }
  unsigned long int get_prec() const { return mpf_get_default_prec(); }
};

template <>
class __gmp_expr<mpf_t, __gmp_urandomb_value>
{
private:
  __gmp_randstate_struct *state;
  unsigned long int bits;
public:
  __gmp_expr(gmp_randstate_t s, unsigned long int l) : state(s), bits(l) { }
  void eval(mpf_ptr f, unsigned long int prec) const
  { __gmp_rand_function::eval(f, state, (bits>0) ? get_prec() : prec); }
  unsigned long int get_prec() const
  {
    if (bits == 0)
      return mpf_get_default_prec();
    else
      return bits;
  }
};

extern "C" {
  typedef void __gmp_randinit_default_t (gmp_randstate_t);
  typedef void __gmp_randinit_lc_2exp_t (gmp_randstate_t, mpz_srcptr, unsigned long int, unsigned long int);
  typedef int __gmp_randinit_lc_2exp_size_t (gmp_randstate_t, unsigned long int);
}

class gmp_randclass
{
private:
  gmp_randstate_t state;

  // copy construction and assignment not allowed
  gmp_randclass(const gmp_randclass &);
  void operator=(const gmp_randclass &);
public:
  // constructors and destructor
  gmp_randclass(gmp_randalg_t alg, unsigned long int size)
  {
    switch (alg)
      {
      case GMP_RAND_ALG_LC: // no other cases for now
      default:
	gmp_randinit(state, alg, size);
	break;
      }
  }

  // gmp_randinit_default
  gmp_randclass(__gmp_randinit_default_t* f) { f(state); }

  // gmp_randinit_lc_2exp
  gmp_randclass(__gmp_randinit_lc_2exp_t* f,
		mpz_class z, unsigned long int l1, unsigned long int l2)
  { f(state, z.get_mpz_t(), l1, l2); }

  // gmp_randinit_lc_2exp_size
  gmp_randclass(__gmp_randinit_lc_2exp_size_t* f,
		unsigned long int size)
  {
    if (f (state, size) == 0)
      throw std::length_error ("gmp_randinit_lc_2exp_size");
  }

  ~gmp_randclass() { gmp_randclear(state); }

  // initialize
  void seed(); // choose a random seed some way (?)
  void seed(unsigned long int s) { gmp_randseed_ui(state, s); }
  void seed(const mpz_class &z) { gmp_randseed(state, z.get_mpz_t()); }

  // get random number
  __gmp_expr<mpz_t, __gmp_urandomb_value> get_z_bits(unsigned long int l)
  { return __gmp_expr<mpz_t, __gmp_urandomb_value>(state, l); }
  __gmp_expr<mpz_t, __gmp_urandomb_value> get_z_bits(const mpz_class &z)
  { return get_z_bits(z.get_ui()); }

  __gmp_expr<mpz_t, __gmp_urandomm_value> get_z_range(const mpz_class &z)
  { return __gmp_expr<mpz_t, __gmp_urandomm_value>(state, z); }

  __gmp_expr<mpf_t, __gmp_urandomb_value> get_f(unsigned long int prec = 0)
  { return __gmp_expr<mpf_t, __gmp_urandomb_value>(state, prec); }
};


/**************** #undef all private macros ****************/

#undef __GMPP_DECLARE_COMPOUND_OPERATOR
#undef __GMPN_DECLARE_COMPOUND_OPERATOR
#undef __GMP_DECLARE_COMPOUND_OPERATOR
#undef __GMP_DECLARE_COMPOUND_OPERATOR_UI
#undef __GMP_DECLARE_INCREMENT_OPERATOR

#undef __GMPZQ_DEFINE_EXPR
#undef __GMP_DEFINE_TERNARY_EXPR

#undef __GMP_DEFINE_UNARY_FUNCTION
#undef __GMP_DEFINE_UNARY_TYPE_FUNCTION

#undef __GMPP_DEFINE_BINARY_FUNCTION
#undef __GMPNN_DEFINE_BINARY_FUNCTION
#undef __GMPNS_DEFINE_BINARY_FUNCTION
#undef __GMPNU_DEFINE_BINARY_FUNCTION
#undef __GMPND_DEFINE_BINARY_FUNCTION
#undef __GMPNLD_DEFINE_BINARY_FUNCTION
#undef __GMPN_DEFINE_BINARY_FUNCTION
#undef __GMP_DEFINE_BINARY_FUNCTION

#undef __GMP_DEFINE_BINARY_FUNCTION_UI

#undef __GMPP_DEFINE_BINARY_TYPE_FUNCTION
#undef __GMPNN_DEFINE_BINARY_TYPE_FUNCTION
#undef __GMPNS_DEFINE_BINARY_TYPE_FUNCTION
#undef __GMPNU_DEFINE_BINARY_TYPE_FUNCTION
#undef __GMPND_DEFINE_BINARY_TYPE_FUNCTION
#undef __GMPNLD_DEFINE_BINARY_TYPE_FUNCTION
#undef __GMPN_DEFINE_BINARY_TYPE_FUNCTION
#undef __GMP_DEFINE_BINARY_TYPE_FUNCTION

#undef __GMPP_DECLARE_COMPOUND_OPERATOR
#undef __GMPN_DECLARE_COMPOUND_OPERATOR
#undef __GMP_DECLARE_COMPOUND_OPERATOR

#undef __GMP_DECLARE_COMPOUND_OPERATOR_UI
#undef __GMP_DECLARE_INCREMENT_OPERATOR

#undef __GMPZ_DEFINE_COMPOUND_OPERATOR
#undef __GMPZZ_DEFINE_COMPOUND_OPERATOR
#undef __GMPZN_DEFINE_COMPOUND_OPERATOR
#undef __GMPZNN_DEFINE_COMPOUND_OPERATOR
#undef __GMPZNS_DEFINE_COMPOUND_OPERATOR
#undef __GMPZNU_DEFINE_COMPOUND_OPERATOR
#undef __GMPZND_DEFINE_COMPOUND_OPERATOR
#undef __GMPZNLD_DEFINE_COMPOUND_OPERATOR

#undef __GMPP_DEFINE_COMPOUND_OPERATOR
#undef __GMPNN_DEFINE_COMPOUND_OPERATOR
#undef __GMPNS_DEFINE_COMPOUND_OPERATOR
#undef __GMPNU_DEFINE_COMPOUND_OPERATOR
#undef __GMPND_DEFINE_COMPOUND_OPERATOR
#undef __GMPNLD_DEFINE_COMPOUND_OPERATOR
#undef __GMPN_DEFINE_COMPOUND_OPERATOR
#undef __GMP_DEFINE_COMPOUND_OPERATOR

#undef __GMPZ_DEFINE_COMPOUND_OPERATOR
#undef __GMPZZ_DEFINE_COMPOUND_OPERATOR
#undef __GMPQ_DEFINE_COMPOUND_OPERATOR
#undef __GMPF_DEFINE_COMPOUND_OPERATOR

#undef __GMP_DEFINE_COMPOUND_OPERATOR_UI
#undef __GMPZ_DEFINE_COMPOUND_OPERATOR_UI
#undef __GMPQ_DEFINE_COMPOUND_OPERATOR_UI
#undef __GMPF_DEFINE_COMPOUND_OPERATOR_UI

#undef __GMP_DEFINE_INCREMENT_OPERATOR
#undef __GMPZ_DEFINE_INCREMENT_OPERATOR
#undef __GMPQ_DEFINE_INCREMENT_OPERATOR
#undef __GMPF_DEFINE_INCREMENT_OPERATOR

#endif /* __GMP_PLUSPLUS__ */
