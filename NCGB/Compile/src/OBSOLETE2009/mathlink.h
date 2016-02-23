/*************************************************************************

        Copyright 1986 through 1996 by Wolfram Research Inc.
        All rights reserved

$Id: mathlink.h,v 1.6 1996/07/12 04:27:09 shawn Exp $

*************************************************************************/

#ifndef _MATHLINK_H
#define _MATHLINK_H

#if __BORLANDC__ && ! __BCPLUSPLUS__
#pragma warn -stu
#endif

#ifndef MLVERSION
#	define MLVERSION 3
#endif


/* The current revision number.
 * Incremented every time a change is made to the source and MathLink is rebuilt and distributed.
 * (Bug fixes or performance improvements increment _only_ this number.)
 * Compiled into client applications and the MathLink shared library.
 */
#define MLREVISION 5


/* The oldest library implementation that can be used identically in place of this one by clients that link with this one.
 * synchronized to MLREVISION when when existing functions change behavior or new functions are added.
 * copied into app when the app is built
 */
#define MLAPIREVISION 1


/* The oldest clients that this library still supports.
 * synchronized to MLREVISION when existing functions change behavior or go away.
 * copied into the MathLink shared library and used at runtime-bind time.
 */
#define MLOLDDEFINITION 1


/* The oldest revision whose API is still supported by this revision.
 * If MLOLDREVISION < MLAPIREVISION, the client app must be aware of the differences
 */
#define MLOLDREVISION 1 





#if 0
MLParameters s;
MLNewParameters( s, MLREVISION, MLAPIREVISION);
MLSetAllocParameter( s, allocator, deallocator);
MLIntialize(s);
#endif

#ifndef ML_EXTERN_C

#if defined(__cplusplus)
#	define ML_EXTERN_C extern "C" {
#	define ML_END_EXTERN_C }
#else
#	define ML_EXTERN_C
#	define ML_END_EXTERN_C
#endif

#endif



#if ! MACINTOSH_MATHLINK && ! WINDOWS_MATHLINK && ! UNIX_MATHLINK && ! OS2_MATHLINK
#	define UNIX_MATHLINK 1
#endif

#if MACINTOSH_MATHLINK
#	if (powerc || __powerc || __powerc__)
#		define POWERMACINTOSH_MATHLINK 1
#	else
#		define M68KMACINTOSH_MATHLINK 1
#		if defined(__CFM68K__)
#			define CFM68K_MACINTOSH_MATHLINK 1
#		else
#			define CLASSIC68K_MACINTOSH_MATHLINK 1
#		endif
#	endif
#endif


#if WINDOWS_MATHLINK
#	if defined(WIN32) || defined(__WIN32__) || defined(__NT__) || defined(_WIN32)
#		define WIN32_MATHLINK 1
#	else
#		define WIN16_MATHLINK 1
#	endif
#endif


#ifndef NO_GLOBAL_DATA
#	if M68KMACINTOSH_MATHLINK
#		define NO_GLOBAL_DATA 1
#	else
#		define NO_GLOBAL_DATA 0
#	endif
#endif

#if UNIX_MATHLINK
#	if (__sun || __sun__ || sun) && !defined(SUN_MATHLINK)
#		define SUN_MATHLINK 1
#	endif
#endif

#ifndef _MLCFM_H
#define _MLCFM_H


#ifndef GENERATINGCFM
#	ifdef USESROUTINEDESCRIPTORS
#		define GENERATINGCFM USESROUTINEDESCRIPTORS
#	elif MACINTOSH_MATHLINK
#		include <ConditionalMacros.h>
#		ifndef GENERATINGCFM
#			define GENERATINGCFM USESROUTINEDESCRIPTORS
#		endif
#	else
#		define GENERATINGCFM 0
#	endif
#endif


#if MACINTOSH_MATHLINK
#	include <MixedMode.h>
#else
	enum {
		kPascalStackBased = 0,
		kCStackBased = 0,
		kThinkCStackBased = 0
	};
#	define SIZE_CODE(size) (0)
#	define RESULT_SIZE(sizeCode) (0)
#	define STACK_ROUTINE_PARAMETER(whichParam, sizeCode) (0)
#endif



#endif /* _MLCFM_H */


#ifdef __CFM68K__
#pragma import on
#endif


#ifndef _MLDEVICE_H
#define _MLDEVICE_H


#ifndef P

#  ifndef MLPROTOTYPES
#    define MLPROTOTYPES 1
#  endif

#  if MLPROTOTYPES || __STDC__ || defined(__cplusplus) || ! UNIX_MATHLINK
#    define P(s) s
#	 undef MLPROTOTYPES
#	 define MLPROTOTYPES 1
#  else
#    define P(s) ()
#	 undef MLPROTOTYPES
#	 define MLPROTOTYPES 0
#  endif
#endif

#ifndef FAR

#if WINDOWS_MATHLINK

#if defined(WIN32_LEAN_AND_MEAN) && defined(WIN32_EXTRA_LEAN)
#	include <windows.h>
#elif defined( WIN32_LEAN_AND_MEAN)
#	define WIN32_EXTRA_LEAN
#	include <windows.h>
#	undef WIN32_EXTRA_LEAN
#elif defined( WIN32_EXTRA_LEAN)
#	define WIN32_LEAN_AND_MEAN
#	include <windows.h>
#	undef WIN32_LEAN_AND_MEAN
#else
#	define WIN32_EXTRA_LEAN
#	define WIN32_LEAN_AND_MEAN
#	include <windows.h>
#	undef WIN32_EXTRA_LEAN
#	undef WIN32_LEAN_AND_MEAN
#endif

#	ifndef FAR
#	define UNIX_MATHLINK 1
#	endif
#else
#	define FAR
#endif


#endif

/* //rename this file mlfarhuge.h */

#ifndef MLHUGE
#  if WINDOWS_MATHLINK && ! WIN32_MATHLINK
#    define MLHUGE huge
#  else
#    define MLHUGE
#  endif
#endif

#ifndef _MLTYPES_H
#define _MLTYPES_H


#if WINDOWS_MATHLINK
#	ifndef	APIENTRY
#		define APIENTRY far pascal
#	endif
#	if WIN32_MATHLINK
 /* try this #define MLEXPORT __declspec(dllexport) */
#		define MLEXPORT
#	else
#		define MLEXPORT __export
#	endif
#	define MLCB APIENTRY MLEXPORT
#	define MLAPI APIENTRY
#endif

#define MLAPI_ MLAPI



#if ! WINDOWS_MATHLINK
#	define MLCB
#	define MLAPI
#	define MLEXPORT
#endif


#ifndef MLDEFN
#	define MLDEFN( rtype, name, params) extern rtype MLAPI MLEXPORT name params
#endif
#ifndef MLDECL
#	define MLDECL( rtype, name, params) extern rtype MLAPI name P(params)
#endif

#ifndef ML_DEFN
#	define ML_DEFN( rtype, name, params) extern rtype MLAPI_ MLEXPORT name params
#endif
#ifndef ML_DECL
#	define ML_DECL( rtype, name, params) extern rtype MLAPI_ name P(params)
#endif



#if MACINTOSH_MATHLINK

#ifndef MLCBPROC
#	define MLCBPROC( rtype, name, params) typedef pascal rtype (* name) P(params)
#endif
#ifndef MLCBDECL
#	define MLCBDECL( rtype, name, params) extern pascal rtype name P(params)
#endif
#ifndef MLCBDEFN
#	define MLCBDEFN( rtype, name, params) extern pascal rtype name params
#endif

#else

#ifndef MLCBPROC
#	define MLCBPROC( rtype, name, params) typedef rtype (MLCB * name) P(params)
#endif
#ifndef MLCBDECL
#	define MLCBDECL( rtype, name, params) extern rtype MLCB name P(params)
#endif
#ifndef MLCBDEFN
#	define MLCBDEFN( rtype, name, params) extern rtype MLCB name params
#endif

#endif




/* move into mlalert.h */
#ifndef MLDPROC
#	define MLDPROC MLCBPROC
#endif
#ifndef MLDDECL
#	define MLDDECL MLCBDECL
#endif
#ifndef MLDDEFN
#	define MLDDEFN MLCBDEFN
#endif




/* move into ml3state.h or mlstrenv.h */
#ifndef MLTPROC
#	define MLTPROC MLCBPROC
#endif
#ifndef MLTDECL
#	define MLTDECL MLCBDECL
#endif
#ifndef MLTDEFN
#	define MLTDEFN MLCBDEFN
#endif


/* move into mlnumenv.h */
#ifndef MLNPROC
#	define MLNPROC MLCBPROC
#endif
#ifndef MLNDECL
#	define MLNDECL MLCBDECL
#endif
#ifndef MLNDEFN
#	define MLNDEFN MLCBDEFN
#endif


/* move into mlalloc.h */
#ifndef MLAPROC
#	define MLAPROC MLCBPROC
#endif
#ifndef MLADECL
#	define MLADECL MLCBDECL
#endif
#ifndef MLADEFN
#	define MLADEFN MLCBDEFN
#endif
#ifndef MLFPROC
#	define MLFPROC MLCBPROC
#endif
#ifndef MLFDECL
#	define MLFDECL MLCBDECL
#endif
#ifndef MLFDEFN
#	define MLFDEFN MLCBDEFN
#endif




/* move into mlstddev.h */
#ifndef MLYPROC
#	define MLYPROC MLCBPROC
#endif
#ifndef MLYDECL
#	define MLYDECL MLCBDECL
#endif
#ifndef MLYDEFN
#	define MLYDEFN MLCBDEFN
#endif
#ifndef MLMPROC
#	define MLMPROC MLCBPROC
#endif
#ifndef MLMDECL
#	define MLMDECL MLCBDECL
#endif
#ifndef MLMDEFN
#	define MLMDEFN MLCBDEFN
#endif


/* move into mlmake.h */
#ifndef MLUPROC
#	define MLUPROC MLCBPROC
#endif
#ifndef MLUDECL
#	define MLUDECL MLCBDECL
#endif
#ifndef MLUDEFN
#	define MLUDEFN MLCBDEFN
#endif


/* move into mlmake.h */
#ifndef MLBPROC
#	define MLBPROC MLCBPROC
#endif
#ifndef MLBDECL
#	define MLBDECL MLCBDECL
#endif
#ifndef MLBDEFN
#	define MLBDEFN MLCBDEFN
#endif

#ifndef MLDMPROC
#	define MLDMPROC MLCBPROC
#endif
#ifndef MLDMDECL
#	define MLDMDECL MLCBDECL
#endif
#ifndef MLDMDEFN
#	define MLDMDEFN MLCBDEFN
#endif


#ifndef __uint_ct__
#define __uint_ct__ unsigned int
#endif
#ifndef __int_ct__
#define __int_ct__ int
#endif


typedef unsigned char        uchar_ct;
typedef uchar_ct       FAR * ucharp_ct;
typedef ucharp_ct      FAR * ucharpp_ct;
typedef ucharpp_ct     FAR * ucharppp_ct;
typedef unsigned short       ushort_ct;
typedef ushort_ct      FAR * ushortp_ct;
typedef ushortp_ct     FAR * ushortpp_ct;
typedef ushortpp_ct    FAR * ushortppp_ct;
typedef __uint_ct__          uint_ct;
typedef __int_ct__           int_ct;
typedef void           FAR * voidp_ct;
typedef voidp_ct       FAR * voidpp_ct;
typedef char           FAR * charp_ct;
typedef charp_ct       FAR * charpp_ct;
typedef charpp_ct      FAR * charppp_ct;
typedef long           FAR * longp_ct;
typedef longp_ct       FAR * longpp_ct;
typedef unsigned long        ulong_ct;
typedef ulong_ct       FAR * ulongp_ct;




#ifndef MLCONST
#	if MLPROTOTYPES
#		define MLCONST const
#	else
#		define MLCONST
#	endif
#endif

typedef MLCONST unsigned short FAR * kushortp_ct;
typedef MLCONST unsigned short FAR * FAR * kushortpp_ct;
typedef MLCONST unsigned char FAR * kucharp_ct;
typedef MLCONST unsigned char FAR * FAR * kucharpp_ct;
typedef MLCONST char FAR * kcharp_ct;
typedef MLCONST char FAR * FAR * kcharpp_ct;
typedef MLCONST void FAR * kvoidp_ct;


typedef void FAR * MLPointer;

#ifndef __MLENV__
	typedef struct ml_environment FAR *MLENV;
	typedef MLENV MLEnvironment;
#	define __MLENV__
#endif

#ifndef __MLINK__
	typedef struct MLink FAR *MLINK;
#	define __MLINK__
#endif

#ifndef __MLMARK__
	typedef struct MLinkMark FAR *MLMARK;
	typedef MLMARK MLINKMark;
#	define __MLMARK__
#endif

#ifndef __mlapi_token__
#define __mlapi_token__ int_ct
#endif
typedef __mlapi_token__   mlapi_token;


typedef unsigned long      mlapi__token;
typedef mlapi__token FAR * mlapi__tokenp;

#ifndef __mlapi_packet__
#define __mlapi_packet__ int_ct
#endif
typedef __mlapi_packet__  mlapi_packet;


typedef long mlapi_error;
typedef long mlapi__error;

typedef long      long_st;
typedef longp_ct  longp_st;
typedef longpp_ct longpp_st;

typedef long long_et;


#ifndef __mlapi_result__
#define __mlapi_result__ int_ct
#endif
typedef __mlapi_result__ mlapi_result;


#define MLSUCCESS (1) /*bugcheck:  this stuff doesnt belong where it can be seen at MLAPI_ layer */
#define MLFAILURE (0)

ML_EXTERN_C

#if WINDOWS_MATHLINK
typedef FARPROC __MLProcPtr__;
#else
typedef long (*__MLProcPtr__)();
#endif

ML_END_EXTERN_C

#endif /* _MLTYPES_H */


#if WINDOWS_MATHLINK
#	ifndef	APIENTRY
#		define	APIENTRY far pascal
#	endif
#	define MLBN APIENTRY /* bottleneck function: upper layer calls lower layer */
#else
#	define MLBN
#endif

#define BN MLBN



ML_EXTERN_C



typedef void FAR * dev_voidp;
#if WINDOWS_MATHLINK
typedef DWORD dev_type;
#else
typedef dev_voidp dev_type;
#endif
typedef dev_type FAR * dev_typep;
typedef long devproc_error;
typedef unsigned long devproc_selector;


#define MLDEV_WRITE_WINDOW  0
#define MLDEV_WRITE         1
#define MLDEV_HAS_DATA      2
#define MLDEV_READ          3
#define MLDEV_READ_COMPLETE 4
#define MLDEV_ACKNOWLEDGE   5

#define T_DEV_WRITE_WINDOW  MLDEV_WRITE_WINDOW
#define T_DEV_WRITE         MLDEV_WRITE
#define T_DEV_HAS_DATA      MLDEV_HAS_DATA
#define T_DEV_READ          MLDEV_READ
#define T_DEV_READ_COMPLETE MLDEV_READ_COMPLETE


#ifndef SCATTERED
#define SCATTERED 0
#undef NOT_SCATTERED
#define NOT_SCATTERED 1
#endif


#if powerc
#pragma options align=mac68k
#endif

typedef struct read_buf {
	unsigned short length;
	unsigned char* ptr;
} read_buf;

typedef read_buf FAR * read_bufp;
typedef read_bufp FAR * read_bufpp;

#if powerc
#pragma options align=reset
#endif



MLDMPROC( devproc_error, MLDeviceProcPtr, ( dev_type dev, devproc_selector selector, dev_voidp p1, dev_voidp p2));
MLDMDECL( devproc_error, MLDeviceMain, ( dev_type dev, devproc_selector selector, dev_voidp p1, dev_voidp p2));

enum {
	uppMLDeviceProcInfo = kPascalStackBased
		 | RESULT_SIZE(SIZE_CODE(sizeof(devproc_error)))
		 | STACK_ROUTINE_PARAMETER(1, SIZE_CODE(sizeof(dev_type)))
		 | STACK_ROUTINE_PARAMETER(2, SIZE_CODE(sizeof(devproc_selector)))
		 | STACK_ROUTINE_PARAMETER(3, SIZE_CODE(sizeof(dev_voidp)))
		 | STACK_ROUTINE_PARAMETER(4, SIZE_CODE(sizeof(dev_voidp)))
};

#if GENERATINGCFM

	typedef UniversalProcPtr MLDeviceUPP;
#	define CallMLDeviceProc(userRoutine, thing, selector, p1, p2) \
		CallUniversalProc((userRoutine), uppMLDeviceProcInfo, (thing), (selector), (p1), (p2))
#	define NewMLDeviceProc(userRoutine) \
		NewRoutineDescriptor((ProcPtr)(userRoutine), uppMLDeviceProcInfo, GetCurrentArchitecture())

#else

	typedef MLDeviceProcPtr MLDeviceUPP;
#	define CallMLDeviceProc(userRoutine, thing, selector, p1, p2) (*(userRoutine))((thing), (selector), (dev_voidp)(p1), (dev_voidp)(p2))
#	define NewMLDeviceProc(userRoutine) (userRoutine)

#endif

typedef MLDeviceUPP dev_main_type;
typedef dev_main_type FAR * dev_main_typep;

ML_END_EXTERN_C


#endif /* _MLDEVICE_H */


#ifndef _MLAPI_H
#define _MLAPI_H


ML_EXTERN_C

#ifndef _MLALLOC_H
#define _MLALLOC_H




MLAPROC( MLPointer, MLAllocatorProcPtr, (unsigned long));

enum {
	uppMLAllocatorProcInfo = kPascalStackBased
		 | RESULT_SIZE(SIZE_CODE(sizeof(MLPointer)))
		 | STACK_ROUTINE_PARAMETER(1, SIZE_CODE(sizeof(unsigned long)))
};

#if GENERATINGCFM
	typedef UniversalProcPtr MLAllocatorUPP;
#	define CallMLAllocatorProc(userRoutine, size) \
		(MLPointer)CallUniversalProc((userRoutine), uppMLAllocatorProcInfo, (size))
#	define NewMLAllocatorProc(userRoutine) \
		NewRoutineDescriptor(MLAllocatorCast((userRoutine)), uppMLAllocatorProcInfo, GetCurrentArchitecture())
#else
	typedef MLAllocatorProcPtr MLAllocatorUPP;
#	define CallMLAllocatorProc(userRoutine, size) (*(userRoutine))((size))
#	define NewMLAllocatorProc(userRoutine) (userRoutine)
#endif




MLFPROC( void, MLDeallocatorProcPtr, (MLPointer));

enum {
	uppMLDeallocatorProcInfo = kPascalStackBased
		 | STACK_ROUTINE_PARAMETER(1, SIZE_CODE(sizeof(MLPointer)))
};

#if GENERATINGCFM
	typedef UniversalProcPtr MLDeallocatorUPP;
#	define CallMLDeallocatorProc(userRoutine, p) \
		CallUniversalProc((userRoutine), uppMLDeallocatorProcInfo, (p))
#	define NewMLDeallocatorProc(userRoutine) \
		NewRoutineDescriptor(MLDeallocatorCast((userRoutine)), uppMLDeallocatorProcInfo, GetCurrentArchitecture())
#else
	typedef MLDeallocatorProcPtr MLDeallocatorUPP;
#	define CallMLDeallocatorProc(userRoutine, p) (*(userRoutine))((p))
#	define NewMLDeallocatorProc(userRoutine) (userRoutine)
#endif



#endif /* _MLALLOC_H */


/* eplicitly not protected by _MLALLOC_H in case MLDECL is redefined for multiple inclusion */


/* just some type-safe casts */
MLDECL( __MLProcPtr__, MLAllocatorCast,   ( MLAllocatorProcPtr f));
MLDECL( __MLProcPtr__, MLDeallocatorCast, ( MLDeallocatorProcPtr f));

ML_END_EXTERN_C

typedef MLAllocatorUPP MLAllocator;
#define MLCallAllocator CallMLAllocatorProc
#define MLNewAllocator NewMLAllocatorProc

typedef MLDeallocatorUPP MLDeallocator;
#define MLCallDeallocator CallMLDeallocatorProc
#define MLNewDeallocator NewMLDeallocatorProc

#define MLallocator MLAllocator
#define MLdeallocator MLDeallocator

#endif /* _MLAPI_H */

#ifndef _ML0TYPES_H
#define _ML0TYPES_H


#ifndef _MLNTYPES_H
#define _MLNTYPES_H


#ifndef __extended_ct__
#define __extended_ct__


#ifndef _MLCTK_H
#define _MLCTK_H



#ifndef _MLNUMENV_H
#define _MLNUMENV_H


/* mlne__s2 must convert empty strings to zero */



ML_EXTERN_C


#define REALBIT 4
#define REAL_MASK (1 << REALBIT)
#define XDRBIT 5
#define XDR_MASK (1 << XDRBIT)
#define BINARYBIT 7
#define BINARY_MASK (1 << BINARYBIT)
#define SIZEVARIANTBIT 6
#define SIZEVARIANT_MASK (1 << SIZEVARIANTBIT)



#define MLNE__IMPLIED_SIZE( tok, num_dispatch) ((tok) & XDR_MASK || !((tok) & SIZEVARIANT_MASK) \
		? (tok) & 0x08 ? (tok) & (0x0E + 2) : (1 << ((tok)>>1 & 0x03)) \
		: call_num_dispatch( (num_dispatch), MLNE__SIZESELECTOR((tok)), 0,0,0))

/* Range[-128, 127] */
#define	MLTK_8BIT_SIGNED_2sCOMPLEMENT_INTEGER                 160 /* ((unsigned char)'\240') */
/* Range[0, 255] */
#define	MLTK_8BIT_UNSIGNED_2sCOMPLEMENT_INTEGER               161 /* ((unsigned char)'\241') */
/* Range[-32768, 32767] */
#define	MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER      162 /* ((unsigned char)'\242') */
/* Range[0, 65535] */
#define	MLTK_16BIT_UNSIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER    163 /* ((unsigned char)'\243') */
/* Range[-2147483648, 2147483647] */
#define	MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER      164 /* ((unsigned char)'\244') */
/* Range[0, 4294967295] */
#define	MLTK_32BIT_UNSIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER    165 /* ((unsigned char)'\245') */

/* Range[-32768, 32767] */
#define	MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER   226 /* ((unsigned char)'\342') */
/* Range[0, 65535] */
#define	MLTK_16BIT_UNSIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER 227 /* ((unsigned char)'\343') */
/* Range[-2147483648, 2147483647] */
#define	MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER   228 /* ((unsigned char)'\344') */
/* Range[0, 4294967295] */
#define	MLTK_32BIT_UNSIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER 229 /* ((unsigned char)'\345') */

/* Interval[{-3.402823e+38, 3.402823e+38}] */
#define	MLTK_BIGENDIAN_IEEE754_SINGLE	                      180 /* ((unsigned char)'\264') */
/* Interval[{-1.79769313486232e+308, 1.79769313486232e+308}] */
#define	MLTK_BIGENDIAN_IEEE754_DOUBLE	                      182 /* ((unsigned char)'\266') */

/* Interval[{-3.402823e+38, 3.402823e+38}] */
#define	MLTK_LITTLEENDIAN_IEEE754_SINGLE	                  244 /* ((unsigned char)'\364') */
/* Interval[{-1.79769313486232e+308, 1.79769313486232e+308}] */
#define	MLTK_LITTLEENDIAN_IEEE754_DOUBLE	                  246 /* ((unsigned char)'\366') */

/* Note, if the future brings...
 * #define MLTK_128BIT_UNSIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER   ((unsigned char)'\257')
 * with  Range[0, 340282366920938463463374607431768211456 (*approximately 3.40282e+38*)]
 * the dynamic range is still a monotonically increasing function of the token value.
 * An implementation might choose to set the high varient bit to mainain this property
 * and dispatch more efficiently by avoiding overflow checks
 */

#define MLNE__SELECTOR( dtok, stok) \
	(((dtok) << 8) | (stok)) /* maybe should mask of high word and cast stok */

#define MLNE__SIZESELECTOR( tok) MLNE__SELECTOR( 0, tok) 
#define MLNE__INITSELECTOR (0)
#define MLNE__TOSTRINGSELECTOR( tok) MLNE__SELECTOR( MLNE__IS_REAL(tok) ? MLTKREAL : MLTKINT, tok)
#define MLNE__FROMSTRINGSELECTOR( dtok, stok) MLNE__SELECTOR( dtok, stok) 

#define MLNE__STOK( selector) ( (selector) & 0x000000FF)
#define MLNE__DTOK( selector) ( ((selector) & 0x0000FF00)>>8)

#define MLNE__IS_BINARY( tok) ((tok) & BINARY_MASK)
#define MLNE__IS_REAL( tok) ((tok) & REAL_MASK)
#define MLNE__TEXT_TOKEN( tok) (MLNE__IS_REAL( tok) ? MLTKREAL : MLTKINT)



MLNDECL( long_et, mlne__dispatch, ( unsigned long selector, void* dptr, void* sptr, long* countp));
MLNPROC( long_et, dispatch_procptr_mlnet, ( unsigned long selector, void* dptr, void* sptr, long* countp));

/* will null terminate  strings only if countp is null */

enum {
	uppNumDispatchProcInfo = kPascalStackBased
		 | RESULT_SIZE(SIZE_CODE(sizeof(long_et)))
		 | STACK_ROUTINE_PARAMETER(1, SIZE_CODE(sizeof(unsigned long)))
		 | STACK_ROUTINE_PARAMETER(2, SIZE_CODE(sizeof(void*)))
		 | STACK_ROUTINE_PARAMETER(3, SIZE_CODE(sizeof(void*)))
		 | STACK_ROUTINE_PARAMETER(4, SIZE_CODE(sizeof(long*)))
};


#if GENERATINGCFM && GENERATING68K /* on the powerpc use standard native shared library calling conventions */
	typedef UniversalProcPtr dispatch_function_mlnet;
#	define call_num_dispatch( num_dispatch, selector, dptr, sptr, countp) \
		(long_et)CallUniversalProc( (num_dispatch), uppNumDispatchProcInfo, (selector), (dptr), (sptr), (countp))
#	define new_num_dispatch(num_dispatch) \
		NewRoutineDescriptor((ProcPtr)(num_dispatch), uppNumDispatchProcInfo, GetCurrentArchitecture())
#else
	typedef dispatch_procptr_mlnet dispatch_function_mlnet;
#	define call_num_dispatch(num_dispatch, selector, dptr, sptr, countp) \
		((*(num_dispatch))( (selector), (dptr), (sptr), (countp)))
#	define new_num_dispatch(num_dispatch) (num_dispatch)
#endif



ML_END_EXTERN_C


#endif /* _MLNUMENV_H */


#define MLTK_CUCHAR MLTK_8BIT_UNSIGNED_2sCOMPLEMENT_INTEGER

#if MACINTOSH_MATHLINK
	/* two private tokens */
	/* Interval[{-1.189731495357231765e+4932, 1.189731495357231765e+4932}] */
#	define MLTK_80BIT_SANE_EXTENDED  152 /* ((unsigned char)'\230') */
#	define MLTK_96BIT_68881_EXTENDED 154 /* ((unsigned char)'\232') */
#endif

#if M68KMACINTOSH_MATHLINK

//is this correct for cfm68k?

#	define MLTK_CSHORT MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#	define MLTK_CLONG  MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER

#	define MLTK_CFLOAT MLTK_BIGENDIAN_IEEE754_SINGLE

#	if defined(__MWERKS__)
#		if __fourbyteints__
#			define MLTK_CINT MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		else
#			define MLTK_CINT MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		endif
#		if __MC68881__
#			define MLTK_CLONGDOUBLE  MLTK_96BIT_68881_EXTENDED
#		else
#			define MLTK_CLONGDOUBLE  MLTK_80BIT_SANE_EXTENDED
#		endif
#		if __IEEEdoubles__ || __ieeedoubles__
#			define MLTK_CDOUBLE  MLTK_BIGENDIAN_IEEE754_DOUBLE
#		else
#			define MLTK_CDOUBLE  MLTK_CLONGDOUBLE
#		endif
#	elif defined(THINK_C) || defined(SYMANTEC_C) || defined(SYMANTEC_CPLUS)
#		if __option(int_4)
#			define MLTK_CINT MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		else
#			define MLTK_CINT MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		endif
#		if __option(native_fp) && !__option(mc68881)
#			define MLTK_CLONGDOUBLE  MLTK_80BIT_SANE_EXTENDED
#		else
#			define MLTK_CLONGDOUBLE  MLTK_96BIT_68881_EXTENDED
#		endif
#		if __option(double_8)
#			define MLTK_CDOUBLE  MLTK_BIGENDIAN_IEEE754_DOUBLE
#		else
#			define MLTK_CDOUBLE  MLTK_CLONGDOUBLE
#		endif
#	else /* applec */
#		define MLTK_CINT MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CDOUBLE  MLTK_BIGENDIAN_IEEE754_DOUBLE
#		if mc68881
#			define MLTK_CLONGDOUBLE  MLTK_96BIT_68881_EXTENDED
#		else
#			define MLTK_CLONGDOUBLE  MLTK_80BIT_SANE_EXTENDED
#		endif
#	endif

#elif POWERMACINTOSH_MATHLINK

/* one private token */
#	define MLTK_128BIT_LONGDOUBLE  158 /* ((unsigned char)'\236') */

#	define MLTK_CSHORT MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#	define MLTK_CINT   MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#	define MLTK_CLONG  MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER

#	define MLTK_CFLOAT MLTK_BIGENDIAN_IEEE754_SINGLE
#	define MLTK_CDOUBLE  MLTK_BIGENDIAN_IEEE754_DOUBLE


#	ifndef MLTK_CLONGDOUBLE
#		if defined(__MWERKS__) || defined(SYMANTEC_C) || defined(SYMANTEC_CPLUS)
#			define MLTK_CLONGDOUBLE  MLTK_BIGENDIAN_IEEE754_DOUBLE
#		else
#			define MLTK_CLONGDOUBLE  MLTK_128BIT_LONGDOUBLE
#		endif
#	endif


#elif SUN_MATHLINK


#	if __sparc || __sparc__ || sparc

#		define MLTK_CSHORT       MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CINT         MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CLONG        MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CFLOAT       MLTK_BIGENDIAN_IEEE754_SINGLE
#		define MLTK_CDOUBLE      MLTK_BIGENDIAN_IEEE754_DOUBLE
#		ifndef MLTK_CLONGDOUBLE
#			if __SUNPRO_C >= 0x301
				/* one private token */
#				define MLTK_128BIT_LONGDOUBLE  158 /* ((unsigned char)'\236') */
#				define MLTK_CLONGDOUBLE  MLTK_128BIT_LONGDOUBLE
#			elif defined(__GNUC__) || defined(__GNUG__)
#				define MLTK_CLONGDOUBLE  MLTK_CDOUBLE
#			else
				/* no error directive here as the user may be
				 * using a different compiler.  Some macros
				 * simply won't be available.
				 */
#			endif
#		endif


#	elif __i386 || __i386__ || i386


#		if __SUNPRO_C >= 0x301
			/* one private token */
			/* Interval[{-1.189731495357231765e+4932, 1.189731495357231765e+4932}] */
#			define MLTK_96BIT_HIGHPADDED_INTEL_80BIT_EXTENDED 218 /* ((unsigned char)'\332') */
#			define MLTK_CSHORT       MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#			define MLTK_CINT         MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#			define MLTK_CLONG        MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#			define MLTK_CFLOAT       MLTK_LITTLEENDIAN_IEEE754_SINGLE
#			define MLTK_CDOUBLE      MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#			define MLTK_CLONGDOUBLE  MLTK_96BIT_HIGHPADDED_INTEL_80BIT_EXTENDED
#		elif defined(__GNUC__) || defined(__GNUG__)
			/* no error directive here as the user may be
			 * using a different compiler.  Some macros
			 * simply won't be available.
			 */
#		else
			/* no error directive here as the user may be
			 * using a different compiler.  Some macros
			 * simply won't be available.
			 */
#		endif


#	else
#	define UNIX_MATHLINK 1
#	endif


#else

#	define MLTK_CSHORT       (( BINARY_MASK | SIZEVARIANT_MASK | 1))
#	define MLTK_CINT         (( BINARY_MASK | SIZEVARIANT_MASK | 2))
#	define MLTK_CLONG        (( BINARY_MASK | SIZEVARIANT_MASK | 3))
#	define MLTK_CFLOAT       (( BINARY_MASK | SIZEVARIANT_MASK | REAL_MASK | 1))
#	define MLTK_CDOUBLE      (( BINARY_MASK | SIZEVARIANT_MASK | REAL_MASK | 2))
#	define MLTK_CLONGDOUBLE  (( BINARY_MASK | SIZEVARIANT_MASK | REAL_MASK | 3))


#endif



#endif  /* _MLCTK_H */
#	if defined( __STDC__) || defined(__cplusplus) || ! UNIX_MATHLINK || MLTK_CLONGDOUBLE != MLTK_CDOUBLE
		typedef long double extended_ct;
#	else
		typedef double extended_ct;
#		define ML_EXTENDED_IS_DOUBLE
#	endif

#endif /* __extended_ct__ */

typedef unsigned char uchar_nt;
typedef uchar_nt     FAR * ucharp_nt;
typedef ucharp_nt    FAR * ucharpp_nt;

typedef short              short_nt;
typedef short_nt     FAR * shortp_nt;
typedef shortp_nt    FAR * shortpp_nt;

typedef int                int_nt;
typedef int_nt       FAR * intp_nt;
typedef intp_nt      FAR * intpp_nt;

typedef long               long_nt;
typedef long_nt      FAR * longp_nt;
typedef longp_nt     FAR * longpp_nt;

typedef float              float_nt;
typedef float_nt     FAR * floatp_nt;
typedef floatp_nt    FAR * floatpp_nt;

typedef double             double_nt;
typedef double_nt    FAR * doublep_nt;
typedef doublep_nt   FAR * doublepp_nt;

typedef extended_ct        extended_nt;
typedef extended_nt  FAR * extendedp_nt;
typedef extendedp_nt FAR * extendedpp_nt;


#endif /* _MLNTYPES_H */

#if USING_OLD_TYPE_NAMES
typedef charp_ct ml_charp;
typedef charpp_ct ml_charpp;
typedef charppp_ct ml_charppp;
typedef ucharp_ct ml_ucharp;
typedef longp_ct ml_longp;
typedef longpp_ct ml_longpp;
typedef ulongp_ct ml_ulongp;
typedef shortp_nt ml_shortp;
typedef shortpp_nt ml_shortpp;
typedef intp_nt ml_intp;
typedef intpp_nt ml_intpp;
typedef floatp_nt ml_floatp;
typedef floatpp_nt ml_floatpp;
typedef doublep_nt ml_doublep;
typedef doublepp_nt ml_doublepp;
typedef extended_nt ml_extended;
typedef extendedp_nt ml_extendedp;
typedef extendedpp_nt ml_extendedpp;

typedef charp_ct MLBuffer;
typedef kcharp_ct MLKBuffer;
typedef charpp_ct MLBufferArray;

#endif

#endif /* _ML0TYPES_H */

ML_EXTERN_C

#ifndef _MLSTDDEV_H
#define _MLSTDDEV_H


#if WINDOWS_MATHLINK
#endif






#if WINDOWS_MATHLINK
typedef DWORD dev_world;
typedef DWORD dev_cookie;
#else
typedef void FAR * dev_world;
typedef void FAR * dev_cookie;
#endif

typedef dev_world FAR * dev_worldp;
typedef dev_cookie FAR * dev_cookiep;

typedef  MLAllocatorUPP dev_allocator;
#define call_dev_allocator CallMLAllocatorProc
#define new_dev_allocator NewMLAllocatorProc

typedef  MLDeallocatorUPP dev_deallocator;
#define call_dev_deallocator CallMLDeallocatorProc
#define new_dev_deallocator NewMLDeallocatorProc


typedef dev_main_type world_main_type;

#define MLSTDWORLD_INIT        16
#define MLSTDWORLD_DEINIT      17
#define MLSTDWORLD_MAKE        18
#define MLSTDDEV_CONNECT_READY 19
#define MLSTDDEV_CONNECT       20
#define MLSTDDEV_DESTROY       21

#define MLSTDDEV_SET_YIELDER   22
#define MLSTDDEV_GET_YIELDER   23

#define MLSTDDEV_WRITE_MSG     24
#define MLSTDDEV_HAS_MSG       25
#define MLSTDDEV_READ_MSG      26
#define MLSTDDEV_SET_HANDLER   27
#define MLSTDDEV_GET_HANDLER   28



#define T_WORLD_INIT        MLSTDWORLD_INIT
#define T_WORLD_DEINIT      MLSTDWORLD_DEINIT
#define T_WORLD_MAKE        MLSTDWORLD_MAKE
#define T_DEV_CONNECT_READY MLSTDDEV_CONNECT_READY
#define T_DEV_CONNECT       MLSTDDEV_CONNECT
#define T_DEV_DESTROY       MLSTDDEV_DESTROY

#define T_DEV_SET_YIELDER   MLSTDDEV_SET_YIELDER
#define T_DEV_GET_YIELDER   MLSTDDEV_GET_YIELDER

#define T_DEV_WRITE_MSG     MLSTDDEV_WRITE_MSG
#define T_DEV_HAS_MSG       MLSTDDEV_HAS_MSG
#define T_DEV_READ_MSG      MLSTDDEV_READ_MSG
#define T_DEV_SET_HANDLER   MLSTDDEV_SET_HANDLER
#define T_DEV_GET_HANDLER   MLSTDDEV_GET_HANDLER




typedef unsigned long dev_mode;
#define NOMODE           ((dev_mode)0x0000)
#define LOOPBACKBIT      ((dev_mode)0x0001)
#define LISTENBIT        ((dev_mode)0x0002)
#define CONNECTBIT       ((dev_mode)0x0004)
#define LAUNCHBIT        ((dev_mode)0x0008)
#define PARENTCONNECTBIT ((dev_mode)0x0010)
#define ANYMODE          (~(dev_mode)0)

typedef dev_mode FAR * dev_modep;





typedef unsigned long dev_options;

#define _DefaultOptions      ((dev_options)0x00000000)

#define _NetworkVisibleMask  ((dev_options)0x00000003)
#define _BrowseMask          ((dev_options)0x00000010)
#define _NonBlockingMask     ((dev_options)0x00000020)
#define _InteractMask        ((dev_options)0x00000100)
#define _VersionMask         ((dev_options)0x0F000000)

#define _NetworkVisible      ((dev_options)0x00000000)
#define _LocallyVisible      ((dev_options)0x00000001)
#define _InternetVisible     ((dev_options)0x00000002)

#define _Browse              ((dev_options)0x00000000)
#define _DontBrowse          ((dev_options)0x00000010)

#define _NonBlocking         ((dev_options)0x00000000)
#define _Blocking            ((dev_options)0x00000020)

#define _Interact            ((dev_options)0x00000000)
#define _DontInteract        ((dev_options)0x00000100)




/* values returned by selector DEVICE_TYPE */
#define UNREGISTERED_TYPE	0
#define UNIXPIPE_TYPE	1
#define UNIXSOCKET_TYPE 2
#define PPC_TYPE	3
#define MACTCP_TYPE	4
#define LOOPBACK_TYPE	5
#define COMMTB_TYPE	6
#define ADSP_TYPE	7
#define LOCAL_TYPE	8
#define WINLOCAL_TYPE	9

/* selectors */
#define DEVICE_TYPE 0                                       /* long */
#define DEVICE_NAME 1                                       /* char */
#define PIPE_FD                (UNIXPIPE_TYPE * 256 + 0)    /* int */
#define PIPE_CHILD_PID         (UNIXPIPE_TYPE * 256 + 1)    /* int */
#define SOCKET_FD              (UNIXSOCKET_TYPE * 256 + 0)  /* int */
#define SOCKET_PARTNER_ADDR    (UNIXSOCKET_TYPE * 256 + 1)  /* unsigned long */
#define SOCKET_PARTNER_PORT    (UNIXSOCKET_TYPE * 256 + 2)  /* unsigned short */
#define PPC_SESS_REF_NUM       (PPC_TYPE * 256 + 0)         /* PPCSessRefNum */
#define PPC_PARTNER_PSN        (PPC_TYPE * 256 + 1)         /* ProcessSerialNumber */
#define PPC_PARTNER_LOCATION   (PPC_TYPE * 256 + 2)         /* LocationNameRec */
#define PPC_PARTNER_PORT       (PPC_TYPE * 256 + 3)         /* PPCPortRec */
#define MACTCP_STREAM          (MACTCP_TYPE * 256 + 0)      /* StreamPtr */
#define MACTCP_PARTNER_ADDR    (MACTCP_TYPE * 256 + 1)      /* ip_addr */
#define MACTCP_PARTNER_PORT    (MACTCP_TYPE * 256 + 2)      /* tcp_port */
#define MACTCP_IPDRIVER        (MACTCP_TYPE * 256 + 3)      /* short */
#define MACTCP_SETSIMPLESOCKET (MACTCP_TYPE * 256 + 9)      /* buf, buflen ignored */
#define COMMTB_CONNHANDLE      (COMMTB_TYPE * 256 + 0)      /* ConnHandle */
#define ADSP_CCBREFNUM         (ADSP_TYPE * 256 + 0)        /* short */
#define ADSP_IOCREFNUM         (ADSP_TYPE * 256 + 3)        /* short */


/* info selectors */
#define WORLD_THISLOCATION 1        /* char */
#define WORLD_MODES 2               /* dev_mode */
#define WORLD_PROTONAME 3           /* char */
#define WORLD_STREAMCAPACITY 4      /* long */







#define YIELDVERSION 1

typedef long devyield_result;
typedef long devyield_place;
typedef long devyield_count;
typedef unsigned long devyield_sleep;

#define INTERNAL_YIELDING 0
#define MAKE_YIELDING 1
#define CONNECT_YIELDING 2
#define READ_YIELDING 3
#define WRITE_YIELDING 4
#define DESTROY_YIELDING 5
#define READY_YIELDING 6


typedef struct MLYieldParams FAR * MLYieldParameters;


#define MAX_SLEEP (600)
typedef struct MLYieldData{
	union {long l; double d; void FAR * p;} private_data[8];
} FAR * MLYieldDataPointer;

void MLNewYieldData P(( MLYieldDataPointer ydp   /* , dev_allocator, dev_deallocator */));
void MLFreeYieldData P(( MLYieldDataPointer ydp));
MLYieldParameters MLResetYieldData P(( MLYieldDataPointer ydp, devyield_place func_id));
mlapi_result   MLSetYieldParameter P(( MLYieldParameters yp, unsigned long selector, void* data, unsigned long* len));
mlapi_result   MLYieldParameter P(( MLYieldParameters yp, unsigned long selector, void* data, unsigned long* len));
devyield_sleep MLSetSleepYP P(( MLYieldParameters yp, devyield_sleep sleep));
devyield_count MLSetCountYP P(( MLYieldParameters yp, devyield_count count));


enum { MLSleepParameter = 1, MLCountParameter, MLPlaceParameter};





MLYPROC( devyield_result, MLYielderProcPtr, (MLINK mlp, MLYieldParameters yp));
typedef	MLYielderProcPtr MLDeviceYielderProcPtr;

enum {
	uppMLYielderProcInfo = kPascalStackBased
		 | RESULT_SIZE(SIZE_CODE(sizeof(devyield_result)))
		 | STACK_ROUTINE_PARAMETER(1, SIZE_CODE(sizeof(MLINK)))
		 | STACK_ROUTINE_PARAMETER(2, SIZE_CODE(sizeof(MLYieldParameters))),
	uppMLDeviceYielderProcInfo = uppMLYielderProcInfo
};

#if GENERATINGCFM
	typedef UniversalProcPtr MLYielderUPP, MLDeviceYielderUPP;
#	define NewMLYielderProc(userRoutine) \
		NewRoutineDescriptor(MLYielderCast((userRoutine)), uppMLYielderProcInfo, GetCurrentArchitecture())
#elif WIN16_MATHLINK
	typedef FARPROC MLYielderUPP, MLDeviceYielderUPP;
#	define NewMLYielderProc( userRoutine) \
		(MakeProcInstance( MLYielderCast(userRoutine), MLInstance))
#else
	typedef MLYielderProcPtr MLYielderUPP, MLDeviceYielderUPP;
#	define NewMLYielderProc(userRoutine) (userRoutine)
#endif

#define NewMLDeviceYielderProc NewMLYielderProc

typedef  MLYielderUPP MLYieldFunctionType;
typedef unsigned long MLYieldFunctionObject; /* bugcheck should I change this back to void* for 64 bit machines */

typedef  MLYieldFunctionObject dev_yielder;
typedef dev_yielder FAR* dev_yielderp;








typedef unsigned long dev_message;
typedef dev_message FAR * dev_messagep;


MLMPROC( void, MLHandlerProcPtr, (MLINK mlp, dev_message m, dev_message n));
typedef MLHandlerProcPtr MLDeviceHandlerProcPtr;


enum {
	uppMLHandlerProcInfo = kPascalStackBased
		 | STACK_ROUTINE_PARAMETER(1, SIZE_CODE(sizeof(MLINK)))
		 | STACK_ROUTINE_PARAMETER(2, SIZE_CODE(sizeof(dev_message)))
		 | STACK_ROUTINE_PARAMETER(3, SIZE_CODE(sizeof(dev_message))),
	uppMLDeviceHandlerProcInfo = uppMLHandlerProcInfo
};

#if GENERATINGCFM
	typedef UniversalProcPtr MLHandlerUPP, MLDeviceHandlerUPP;
#	define NewMLHandlerProc(userRoutine) \
		NewRoutineDescriptor(MLHandlerCast((userRoutine)), uppMLHandlerProcInfo, GetCurrentArchitecture())
#elif WIN16_MATHLINK
	typedef FARPROC MLHandlerUPP, MLDeviceHandlerUPP;
#	define NewMLHandlerProc( userRoutine) \
		(MakeProcInstance( MLHandlerCast(userRoutine), MLInstance))
#else
	typedef MLHandlerProcPtr MLHandlerUPP, MLDeviceHandlerUPP;
#	define NewMLHandlerProc(userRoutine) (userRoutine)
#endif

#define NewMLDeviceHandlerProc NewMLHandlerProc

typedef  MLHandlerUPP MLMessageHandlerType;
typedef unsigned long MLMessageHandlerObject;

typedef  MLMessageHandlerObject dev_msghandler;
typedef dev_msghandler FAR* dev_msghandlerp;



#endif /* _MLSTDDEV_H */



/* eplicitly not protected by _MLSTDDEV_H in case MLDECL is redefined for multiple inclusion */

/*bugcheck //should the rest of YP stuff be exported? */
MLDECL( devyield_sleep,         MLSleepYP,               ( MLYieldParameters yp));
MLDECL( devyield_count,         MLCountYP,               ( MLYieldParameters yp));
MLDECL( MLYieldFunctionObject,  MLCreateYieldFunction,   ( MLEnvironment ep, MLYieldFunctionType yf, MLPointer reserved)); /* reserved must be 0 */
MLDECL( MLYieldFunctionType,    MLDestroyYieldFunction,  ( MLYieldFunctionObject yfo));
MLDECL( devyield_result,        MLCallYieldFunction,     ( MLYieldFunctionObject yfo, MLINK mlp, MLYieldParameters p));
MLDECL( MLMessageHandlerObject, MLCreateMessageHandler,  ( MLEnvironment ep, MLMessageHandlerType mh, MLPointer reserved)); /* reserved must be 0 */
MLDECL( MLMessageHandlerType,   MLDestroyMessageHandler, ( MLMessageHandlerObject mho));
MLDECL( void,                   MLCallMessageHandler,    ( MLMessageHandlerObject mho, MLINK mlp, dev_message m, dev_message n));


/* just some type-safe casts */
MLDECL( __MLProcPtr__, MLYielderCast, ( MLYielderProcPtr yp));
MLDECL( __MLProcPtr__, MLHandlerCast, ( MLHandlerProcPtr mh));

ML_END_EXTERN_C




#ifndef _MLMAKE_H
#define _MLMAKE_H

/* --binding layer-- */
/*************** Starting MathLink ***************/

#define MLPARAMETERSIZE_R1 256
#define MLPARAMETERSIZE 256
typedef char FAR * MLParametersPointer;
typedef char MLParameters[MLPARAMETERSIZE];

#define MLLoopBackOpen MLLoopbackOpen



ML_EXTERN_C
MLUPROC( void, MLUserProcPtr, (MLINK));
ML_END_EXTERN_C

enum {
	uppMLUserFunctionProcInfo = kPascalStackBased
		 | STACK_ROUTINE_PARAMETER(1, SIZE_CODE(sizeof(MLINK)))
};

#if GENERATINGCFM
	typedef UniversalProcPtr MLUserUPP;
#	define NewMLUserProc(userRoutine) \
		NewRoutineDescriptor(MLUserCast((userRoutine)), uppMLUserFunctionProcInfo, GetCurrentArchitecture())
#else
	typedef MLUserProcPtr MLUserUPP;
#	define NewMLUserProc(userRoutine) (userRoutine)
#endif

typedef MLUserUPP MLUserFunctionType;
typedef MLUserFunctionType FAR * MLUserFunctionTypePointer;





/* The following defines are
 * currently for internal use only.
 */


/* edit here and in mldevice.h and mathlink.r */
#define MLNetworkVisibleMask ((unsigned long)0x00000003)
#define MLBrowseMask         ((unsigned long)0x00000010)
#define MLNonBlockingMask    ((unsigned long)0x00000020)
#define MLInteractMask       ((unsigned long)0x00000100)
#define MLVersionMask        ((unsigned long)0x0000F000)

#define MLDefaultOptions     ((unsigned long)0x00000000)
#define MLNetworkVisible     ((unsigned long)0x00000000)
#define MLLocallyVisible     ((unsigned long)0x00000001)
#define MLInternetVisible    ((unsigned long)0x00000002)

#define MLBrowse             ((unsigned long)0x00000000)
#define MLDontBrowse         ((unsigned long)0x00000010)

#define MLNonBlocking        ((unsigned long)0x00000000)
#define MLBlocking           ((unsigned long)0x00000020)

#define MLInteract           ((unsigned long)0x00000000)
#define MLDontInteract       ((unsigned long)0x00000100)

#endif /* _MLMAKE_H */


/* eplicitly not protected by _MLMAKE_H in case MLDECL is redefined for multiple inclusion */


ML_EXTERN_C
MLDECL( ulong_ct, MLNewParameters,     ( MLParametersPointer p, ulong_ct newrev, ulong_ct oldrev));
MLDECL( void,     MLSetAllocParameter, ( MLParametersPointer p, MLAllocator allocator, MLDeallocator deallocator));
MLDECL( long,     MLErrorParameter,    ( MLParametersPointer p));

MLDECL( MLEnvironment, MLInitialize,   ( MLParametersPointer p)); /* pass in NULL */
MLDECL( void,          MLDeinitialize, ( MLEnvironment env));

/* or, if you use MLOpenArgv, ...*/

MLDECL( MLEnvironment, MLBegin, ( MLParametersPointer p)); /* pass in NULL */
MLDECL( void,          MLEnd,   ( MLEnvironment env));

MLDECL( long_et, MLTestPoint1, ( MLEnvironment ep, ulong_ct selector, voidp_ct p1, voidp_ct p2, longp_ct np));


/*************** Connection interface ***************/
MLDECL( MLINK,         MLCreate0,       ( MLEnvironment ep, dev_type dev, dev_main_type dev_main, longp_ct errp));
MLDECL( MLINK,         MLMake,          ( MLPointer ep, dev_type dev, dev_main_type dev_main, longp_ct errp));
MLDECL( void,          MLDestroy,       ( MLINK mlp, dev_typep devp, dev_main_typep dev_mainp));

MLDECL( charpp_ct,     MLFilterArgv0,   ( MLEnvironment ep, charpp_ct argv, charpp_ct argv_end));
MLDECL( MLINK,         MLOpenArgv,      ( MLEnvironment ep, charpp_ct argv, charpp_ct argv_end, longp_ct errp));
MLDECL( MLINK,         MLOpenString,    ( MLEnvironment ep, kcharp_ct command_line, longp_ct errp));
MLDECL( MLINK,         MLLoopbackOpen,  ( MLEnvironment ep, longp_ct errp));
MLDECL( int_ct,        MLStringToArgv,  ( kcharp_ct commandline, charp_ct buf, charpp_ct argv, int_ct len));
MLDECL( long,          MLScanString,    ( charpp_ct argv, charppp_ct argv_end, charpp_ct commandline, charpp_ct buf));
MLDECL( long,          MLPrintArgv,     ( charp_ct buf, charpp_ct buf_endp, charppp_ct argvp, charpp_ct argv_end));

MLDECL( kcharp_ct,     MLErrorMessage,  ( MLINK mlp));
MLDECL( kcharp_ct,     MLErrorString,   ( MLEnvironment env, long err));

MLDECL( MLINK,         MLOpen,          ( int_ct argc, charpp_ct argv));
MLDECL( MLINK,         MLOpenInEnv,     ( MLEnvironment env, int_ct argc, charpp_ct argv, longp_ct errp));
MLDECL( MLINK,         MLOpenS,         ( kcharp_ct command_line));

MLDECL( MLINK,         MLDuplicateLink,   ( MLINK parentmlp, kcharp_ct name, longp_ct errp ));
MLDECL( mlapi_result,  MLConnect,         ( MLINK mlp));
#define MLActivate MLConnect

#ifndef __feature_setp__
#define __feature_setp__
typedef struct feature_set* feature_setp;
#endif
MLDECL( mlapi_result,  MLEstablish,       ( MLINK mlp, feature_setp features));

MLDECL( mlapi_result,  MLEstablishString, ( MLINK mlp, kcharp_ct features));
MLDECL( void,          MLClose,           ( MLINK mlp));

MLDECL( void,          MLSetUserData,   ( MLINK mlp, MLPointer data, MLUserFunctionType f));
MLDECL( MLPointer,     MLUserData,      ( MLINK mlp, MLUserFunctionTypePointer fp));
MLDECL( void,          MLSetUserBlock,  ( MLINK mlp, MLPointer userblock));
MLDECL( MLPointer,     MLUserBlock,     ( MLINK mlp));

/* just a type-safe cast */
MLDECL( __MLProcPtr__, MLUserCast, ( MLUserProcPtr f));





/* MLName returns a pointer to the link's name.
 * Links are generally named when they are created
 * and are based on information that is potentially
 * useful and is available at that time.
 * Do not attempt to deallocate the name's storage
 * through this pointer.  The storage should be
 * considered in read-only memory.
 */
MLDECL( kcharp_ct, MLName,    ( MLINK mlp));
MLDECL( long,      MLNumber,  ( MLINK mlp));
MLDECL( charp_ct,  MLSetName, ( MLINK mlp, kcharp_ct name));



/* The following functions are
 * currently for internal use only.
 */

MLDECL( MLPointer, MLInit,   ( MLallocator alloc, MLdeallocator dealloc, MLPointer enclosing_environment));
MLDECL( void,      MLDeinit, ( MLPointer env));
MLDECL( MLPointer, MLEnclosingEnvironment, ( MLPointer ep));
MLDECL( MLPointer, MLinkEnvironment, ( MLINK mlp));

/* the following two functions are for internal use only */
MLDECL( MLYieldFunctionObject, MLDefaultYieldFunction,    ( MLEnvironment env));
MLDECL( mlapi_result,          MLSetDefaultYieldFunction, ( MLEnvironment env, MLYieldFunctionObject yf));

ML_END_EXTERN_C


#ifndef _MLERRORS_H
#define _MLERRORS_H


/*************** MathLink errors ***************/
/*
 * When some problem is detected within MathLink, routines
 * will return a simple indication of failure and store
 * an error code internally. (For routines that have nothing
 * else useful to return, success is indicated by returning
 * non-zero and failure by returning 0.)  MLerror() returns
 * the current error code;  MLErrorMessage returns an English
 * language description of the error.
 * The error MLEDEAD is irrecoverable.  For the others, MLClearError()
 * will reset the error code to MLEOK.
 */



#ifndef _MLERRNO_H
#define _MLERRNO_H

/* edit here and in mlerrstr.h */

#define MLEUNKNOWN       -1
#define MLEOK             0
#define MLEDEAD           1
#define MLEGBAD           2
#define MLEGSEQ           3
#define MLEPBTK           4
#define MLEPSEQ           5
#define MLEPBIG           6
#define MLEOVFL           7
#define MLEMEM            8
#define MLEACCEPT         9
#define MLECONNECT       10
#define MLECLOSED        11
#define MLEDEPTH         12  /* internal error */
#define MLENODUPFCN      13  /* stream cannot be duplicated */

#define MLENOACK         15  /* */
#define MLENODATA        16  /* */
#define MLENOTDELIVERED  17  /* */
#define MLENOMSG         18  /* */
#define MLEFAILED        19  /* */

#define MLEPUTENDPACKET  21 /* unexpected call of MLEndPacket */
                            /* currently atoms aren't
                             * counted on the way out so this error is raised only when
                             * MLEndPacket is called in the midst of an atom
                             */
#define MLENEXTPACKET    22
#define MLEUNKNOWNPACKET 23
#define MLEGETENDPACKET  24
#define MLEABORT         25
#define MLEMORE          26 /* internal error */
#define MLENEWLIB        27
#define MLEOLDLIB        28
#define MLEBADPARAM      29


#define MLEINIT          32  /* the MathLink environment was not initialized */
#define MLEARGV          33  /* insufficient arguments to open the link */
#define MLEPROTOCOL      34  /* protocol unavailable */
#define MLEMODE          35  /* mode unavailable */
#define MLELAUNCH        36  /* launch unsupported */
#define MLELAUNCHAGAIN   37  /* cannot launch the program again from the same file */
#define MLELAUNCHSPACE   38  /* insufficient space to launch the program */
#define MLENOPARENT      39  /* found no parent to connect to */
#define MLENAMETAKEN     40  /* the linkname was already in use */
#define MLENOLISTEN      41  /* the linkname was not found to be listening */
#define MLEBADNAME       42  /* the linkname was missing or not in the proper form */
#define MLEBADHOST       43  /* the location was unreachable or not in the proper form */
#define MLERESOURCE      44  /* a required resource was missing */

#define MLELAST MLERESOURCE  /* for internal use only */

#define MLETRACEON      996  /* */
#define MLETRACEOFF     997  /* */
#define MLEDEBUG        998  /* */
#define MLEASSERT       999  /* an internal assertion failed */
#define MLEUSER        1000  /* start of user defined errors */


#endif /* _MLERRNO_H */


#endif /* _MLERRORS_H */

/* eplicitly not protected by _MLERRORS_H in case MLDECL is redefined for multiple inclusion */

MLDECL( mlapi_error,   MLError,        ( MLINK mlp));
MLDECL( mlapi_result,  MLClearError,   ( MLINK mlp));
MLDECL( mlapi_result,  MLSetError,     ( MLINK mlp, mlapi_error err));


#ifndef _MLYLDMSG_H
#define _MLYLDMSG_H



enum {	MLTerminateMessage = 1, MLInterruptMessage, MLAbortMessage,
	MLEndPacketMessage, MLSynchronizeMessage, MLImDyingMessage,
	MLWaitingAcknowledgment, MLMarkTopLevelMessage,
	MLFirstUserMessage = 128, MLLastUserMessage = 255 };

typedef unsigned long devinfo_selector;


#endif /* _MLYLDMSG_H */

/* eplicitly not protected by _MLYLDMSG_H in case MLDECL is redefined for multiple inclusion */

MLDECL( mlapi_result,   MLPutMessage,   ( MLINK mlp, dev_message  msg));
MLDECL( mlapi_result,   MLMessageReady, ( MLINK mlp));
MLDECL( mlapi_result,   MLGetMessage,   ( MLINK mlp, dev_messagep mp, dev_messagep np));

MLDECL( MLMessageHandlerObject, MLMessageHandler,    ( MLINK mlp));
MLDECL( mlapi_result,           MLSetMessageHandler, ( MLINK mlp, MLMessageHandlerObject h));
MLDECL( MLYieldFunctionObject,  MLYieldFunction,     ( MLINK mlp));
MLDECL( mlapi_result,           MLSetYieldFunction,  ( MLINK mlp, MLYieldFunctionObject yf));


MLDECL( mlapi_result, MLDeviceInformation, ( MLINK mlp, devinfo_selector selector, MLPointer buf, longp_st buflen));

/*************** Textual interface ***************/


#ifndef _MLGET_H
#define _MLGET_H


#endif /* _MLGET_H */

/* eplicitly not protected by _MLGET_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C
MLDECL( mlapi_token,    MLGetNext,          ( MLINK mlp));
MLDECL( mlapi_token,    MLGetNextRaw,       ( MLINK mlp));
MLDECL( mlapi_token,    MLGetType,          ( MLINK mlp));
MLDECL( mlapi_token,    MLGetRawType,       ( MLINK mlp));
MLDECL( mlapi_result,   MLGetRawData,       ( MLINK mlp, ucharp_ct data, long_st size, longp_st gotp));
MLDECL( mlapi_result,   MLGetData,          ( MLINK mlp, charp_ct data, long_st size, longp_st gotp));
MLDECL( mlapi_result,   MLGetArgCount,      ( MLINK mlp, longp_st countp));
MLDECL( mlapi_result,   MLGetRawArgCount,   ( MLINK mlp, longp_st countp));
MLDECL( mlapi_result,   MLBytesToGet,       ( MLINK mlp, longp_st leftp));
MLDECL( mlapi_result,   MLRawBytesToGet,    ( MLINK mlp, longp_st leftp));
MLDECL( mlapi_result,   MLExpressionsToGet, ( MLINK mlp, longp_st countp));
MLDECL( mlapi_result,   MLNewPacket,        ( MLINK mlp));
MLDECL( mlapi_result,   MLTakeLast,         ( MLINK mlp, long_st eleft));
MLDECL( mlapi_result,   MLReady,            ( MLINK mlp));
MLDECL( mlapi_result,   MLFill,             ( MLINK mlp));
ML_END_EXTERN_C


#ifndef _MLPUT_H
#define _MLPUT_H


#define MLPutExpression is obsolete, use MLPutComposite

#endif /* _MLPUT_H */

/* eplicitly not protected by _MLPUT_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C
MLDECL( mlapi_result,   MLPutNext,      ( MLINK mlp, mlapi_token tok));
MLDECL( mlapi_result,   MLPutType,      ( MLINK mlp, mlapi__token tok));
MLDECL( mlapi_result,   MLPutRawSize,   ( MLINK mlp, long_st size));
MLDECL( mlapi_result,   MLPutRawData,   ( MLINK mlp, kucharp_ct data, long_st len));
MLDECL( mlapi_result,   MLPutArgCount,  ( MLINK mlp, long_st argc));
MLDECL( mlapi_result,   MLPutComposite, ( MLINK mlp, long_st argc));
MLDECL( mlapi_result,   MLBytesToPut,   ( MLINK mlp, longp_st leftp));
MLDECL( mlapi_result,   MLEndPacket,    ( MLINK mlp));
MLDECL( mlapi_result,   MLFlush,        ( MLINK mlp));
ML_END_EXTERN_C


#ifndef _MLTK_H
#define _MLTK_H

/* begin filter */
#if 0
#define	MLTKSYM     'U'		/* 85 Ox55 01010101 */ /* symbol leaf node */
#define	MLTKSTR     'T'		/* 84 Ox54 01010100 */ /* string leaf node */ /*bugcheck that these choices are reasonable */
#endif
/* end filter */

#define	MLTKOLDINT     'I'		/* 73 Ox49 01001001 */ /* integer leaf node */
#define	MLTKOLDREAL    'R'		/* 82 Ox52 01010010 */ /* real leaf node */

/* begin filter */
/* should I change MLTKFUNC and MLTKARRAY while I'm at it to say '(' or ',' (both with bit 1 clear and differ in bit 2)
   and maybe MLTKPACKED and MLTKDIM as '_' and ')' or switched around a bit to be "readable" and bit sensible
   wait maybe & for MLTKFUNC and '\'' for MLTKARRAY --differ by a bit
   then maybe ',' for MLTKPACKED and hmm for MLTKDIM
*/
/* end filter */

#define	MLTKFUNC    'F'		/* 70 Ox46 01000110 */ /* non-leaf node */

#define	MLTKERROR   (0)		/* bad token */
#define	MLTKERR     (0)		/* bad token */

/* text token bit patterns: 0010x01x --exactly 2 bits worth chosen to make things somewhat readable */
#define MLTK__IS_TEXT( tok) ( (tok & 0x00F6) == 0x0022)

/* begin filter */
/* ' '   00100000 */
/* '!'   00100001 */
/* end filter */
#define	MLTKSTR     '"'  /* 00100010 */
#define	MLTKSYM     '\043'  /* 00100011 */ /* octal here as hash requires a trigraph */

/* begin filter */
/* '$'   00100100 */
/* '%'   00100101 */
/* '&'   00100110 */
/* '\''  00100111 */ /*candidate for MLTKSYM */


/* '('   00101000 */
/* ')'   00101001 */
/* end filter */
#define	MLTKREAL    '*'  /* 00101010 */
#define	MLTKINT     '+'  /* 00101011 */


/* begin filter */
/* ','   00101100 */ /*candidate for MLTKINT*/
/* '-'   00101101 */
/* '.'   00101110 */ /*candidate for MLTKREAL "taken" by MLTKNULL but this could have been changed by disabling an optimazation with V2 */
/* '/'   00101111 */
/* end filter */

/* The following defines are for internal use only */
#define	MLTKPCTEND  ']'     /* at end of top level expression */
#define	MLTKAPCTEND '\n'    /* at end of top level expression */
#define	MLTKEND     '\n'
#define	MLTKAEND    '\r'
#define	MLTKSEND    ','

#define	MLTKCONT    '\\'
#define	MLTKELEN    ' '

#define	MLTKNULL    '.'
#define	MLTKOLDSYM  'Y'     /* 89 0x59 01011001 */
#define	MLTKOLDSTR  'S'     /* 83 0x53 01010011 */


typedef unsigned long decoder_mask;
#define	MLTKPACKED	'P'     /* 80 0x50 01010000 */
#define	MLTKARRAY	'A'     /* 65 0x41 01000001 */
#define	MLTKDIM		'D'     /* 68 0x44 01000100 */

#define MLLENGTH_DECODER        ((decoder_mask) 1<<16)
#define MLTKPACKED_DECODER      ((decoder_mask) 1<<17)
#define MLTKARRAY_DECODER	    ((decoder_mask) 1<<18)
#define MLTKMODERNCHARS_DECODER ((decoder_mask) 1<<19)
#define MLTKALL_DECODERS (MLLENGTH_DECODER | MLTKPACKED_DECODER | MLTKARRAY_DECODER | MLTKMODERNCHARS_DECODER)

#define MLTK_FIRSTUSER '\x30'
#define MLTK_LASTUSER  '\x3F'


/* begin filter */
#if jc
//hack for now
#endif

#if 0 
#undef MLTKALL_DECODERS
#define MLTKALL_DECODERS (MLLENGTH_DECODER | MLTKPACKED_DECODER | MLTKARRAY_DECODER)
#undef MLTKSYM
#define MLTKSYM MLTKOLDSYM
#undef MLTKSTR
#define MLTKSTR MLTKOLDSTR
#endif
/* end filter */

#endif /* _MLTK_H */

/*************** Native C types interface ***************/


#ifndef _MLCGET_H
#define _MLCGET_H


/* begin filter */
/* The functions MLGetString, MLGetSymbol, MLGetString,
 * MLGetFunction, MLGetIntegerList, and
 * MLGetRealList return a pointer to a buffer inside
 * of MathLink.  This buffer should be considered read-
 * only and must be returned to MathLink when you are
 * through using it.  MathLink is only lending you
 * access to its internal data.  You MUST not free
 * this buffer as it may not have been allocated on
 * the free store.  You should not change the contents
 * of the buffer as the data may be used elsewhere
 * within MathLink or elsewhere in your program.
 * For example:
 *	f(){
 *		const char* s;
 *		...
 *		if( MLGetSymbol(stdlink, &s) ){
 *			deal_with_symbol(s);
 *			MLDisownSymbol(stdlink, s);
 *		}
 *		...
 * 	}
 */
/* end filter */

#define MLGetReal MLGetDouble

#endif /* _MLCGET_H */


/* eplicitly not protected by _MLCGET_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C
MLDECL( mlapi_result,   MLGetBinaryNumber, ( MLINK mlp, voidp_ct np, long type));
MLDECL( mlapi_result,   MLGetShortInteger, ( MLINK mlp, shortp_nt hp));
MLDECL( mlapi_result,   MLGetInteger,      ( MLINK mlp, intp_nt ip));
MLDECL( mlapi_result,   MLGetLongInteger,  ( MLINK mlp, longp_nt lp));
MLDECL( mlapi_result,   MLGetFloat,        ( MLINK mlp, floatp_nt fp));
MLDECL( mlapi_result,   MLGetDouble,       ( MLINK mlp, doublep_nt dp));
MLDECL( mlapi_result,   MLGetLongDouble,   ( MLINK mlp, extendedp_nt xp));


MLDECL( mlapi_result,   MLGet16BitCharacters,  ( MLINK mlp, longp_st chars_left, ushortp_ct buf, long_st cardof_buf, longp_st got));
MLDECL( mlapi_result,   MLGet8BitCharacters,   ( MLINK mlp, longp_st chars_left, ucharp_ct  buf, long_st cardof_buf, longp_st got, long missing));
MLDECL( mlapi_result,   MLGet7BitCharacters,   ( MLINK mlp, longp_st chars_left, charp_ct   buf, long_st cardof_buf, longp_st got));

MLDECL( mlapi_result,   MLGetUnicodeString,    ( MLINK mlp, kushortpp_ct sp, longp_st lenp));
MLDECL( mlapi_result,   MLGetByteString,       ( MLINK mlp, kucharpp_ct  sp, longp_st lenp, long missing));
MLDECL( mlapi_result,   MLGetString,           ( MLINK mlp, kcharpp_ct   sp));

MLDECL( mlapi_result,   MLGetUnicodeSymbol,    ( MLINK mlp, kushortpp_ct sp, longp_st lenp));
MLDECL( mlapi_result,   MLGetByteSymbol,       ( MLINK mlp, kucharpp_ct  sp, longp_st lenp, long missing));
MLDECL( mlapi_result,   MLGetSymbol,           ( MLINK mlp, kcharpp_ct   sp));

MLDECL( void,           MLDisownUnicodeString, ( MLINK mlp, kushortp_ct s,   long_st len));
MLDECL( void,           MLDisownByteString,    ( MLINK mlp, kucharp_ct  s,   long_st len));
MLDECL( void,           MLDisownString,        ( MLINK mlp, kcharp_ct   s));

MLDECL( void,           MLDisownUnicodeSymbol, ( MLINK mlp, kushortp_ct s,   long_st len));
MLDECL( void,           MLDisownByteSymbol,    ( MLINK mlp, kucharp_ct  s,   long_st len));
MLDECL( void,           MLDisownSymbol,        ( MLINK mlp, kcharp_ct   s));



MLDECL( mlapi_result,   MLCheckString,   ( MLINK mlp, kcharp_ct name));
MLDECL( mlapi_result,   MLCheckSymbol,   ( MLINK mlp, kcharp_ct name));
MLDECL( mlapi_result,   MLGetFunction,   ( MLINK mlp, kcharpp_ct sp, longp_st countp));
MLDECL( mlapi_result,   MLCheckFunction, ( MLINK mlp, kcharp_ct s, longp_st countp));
MLDECL( mlapi_result,   MLCheckFunctionWithArgCount, ( MLINK mlp, kcharp_ct s, longp_st countp));
ML_END_EXTERN_C


#ifndef _MLCPUT_H
#define _MLCPUT_H


#define MLPutReal MLPutDouble

#endif /* _MLCPUT_H */

/* eplicitly not protected by _MLCPUT_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C
MLDECL( mlapi_result,   MLPutBinaryNumber, ( MLINK mlp, voidp_ct np, long type));
MLDECL( mlapi_result,   MLPutShortInteger, ( MLINK mlp, int_nt h));
MLDECL( mlapi_result,   MLPutInteger,      ( MLINK mlp, int_nt i));
MLDECL( mlapi_result,   MLPutLongInteger,  ( MLINK mlp, long_nt l));
MLDECL( mlapi_result,   MLPutFloat,        ( MLINK mlp, double_nt f));
MLDECL( mlapi_result,   MLPutDouble,       ( MLINK mlp, double_nt d));
MLDECL( mlapi_result,   MLPutLongDouble,   ( MLINK mlp, extended_nt x));

MLDECL( mlapi_result,   MLPut16BitCharacters, ( MLINK mlp, long_st chars_left, kushortp_ct codes, long_st ncodes));
MLDECL( mlapi_result,   MLPut8BitCharacters,  ( MLINK mlp, long_st chars_left, kucharp_ct bytes, long_st nbytes));
MLDECL( mlapi_result,   MLPut7BitCount,       ( MLINK mlp, long_st count, long_st size));
MLDECL( mlapi_result,   MLPut7BitCharacters,  ( MLINK mlp, long_st chars_left, kcharp_ct bytes, long_st nbytes, long_st nchars_now));

MLDECL( mlapi_result,   MLPutUnicodeString, ( MLINK mlp, kushortp_ct s, long_st len));
MLDECL( mlapi_result,   MLPutByteString,    ( MLINK mlp, kucharp_ct  s, long_st len));
MLDECL( mlapi_result,   MLPutString,        ( MLINK mlp, kcharp_ct   s));

MLDECL( mlapi_result,   MLPutUnicodeSymbol, ( MLINK mlp, kushortp_ct s, long_st len));
MLDECL( mlapi_result,   MLPutByteSymbol,    ( MLINK mlp, kucharp_ct  s, long_st len));
MLDECL( mlapi_result,   MLPutSymbol,        ( MLINK mlp, kcharp_ct   s));

MLDECL( mlapi_result,   MLPutFunction,      ( MLINK mlp, kcharp_ct s, long_st argc));


MLDECL( mlapi_result,   MLPutSize, ( MLINK mlp, long_st size));
MLDECL( mlapi_result,   MLPutData, ( MLINK mlp, kcharp_ct buff, long_st len));
ML_END_EXTERN_C



#ifndef _MLSTRING_H
#define _MLSTRING_H


/* begin filter */
/*************** MathLink non-ASCII string interface ***************/

/*
 * To iterate over the character codes in a MathLink string,
 * do the following.  Alternatively, just call MLGetUnicodeString().
 *
 *	f()
 *	{
 *		MLStringPosition pos;
 *		unsigned short code;
 *		char *s;
 *		if( MLGetString( stdlink, &s)) {
 * #if MLVERSION >= 3
 *			char *p = s, *end = s + strlen(s);
 *			while( (code = MLNextCharacter( &p, end)) >= 0)
 *				use_the_character_code( code);
 * #else
 *			MLforString( s, pos) {
 *				code = MLStringChar( pos);
 *				use_the_character_code( code);
 *			}
 * #endif
 *			MLDisownString( stdlink, s);
 *		}
 *	}
 *
 * To construct a MathLink string from a sequence of
 * character codes, do the following.  Or just call MLPutUnicodeString().
 *
 *	g(codes, len)
 *		unsigned short codes[];
 *		int len;
 *	{
 *		int i, size = 0;
 *		char *s, *p;
 * #if MLVERSION >= 3
 *		MLConvertUnicodeString( codes, len, &p, 0);
 *		size = p - (char*)0;
 * #else
 *		for( i = 0; i<len; ++i)
 *			size += MLPutCharToString(codes[i], NULL);
 * #endif
 *
 *		if( p = s = (char*)malloc(size + 1) ) {
 * #if MLVERSION >= 3
 *			MLConvertUnicodeString( codes, len, &p, p + size);
 * #else
 *			for( i = 0; i<len; ++i)
 *				MLPutCharToString(codes[i], &p);
 * #endif
 *			*p = '\0';
 *			MLPutString(stdlink, s);
 *			free(s);
 *		}
 *	}
 */
/* end filter */

#define MAX_BYTES_PER_OLD_CHARACTER 3
#define MAX_BYTES_PER_NEW_CHARACTER 6

#define ML_MAX_BYTES_PER_CHARACTER MAX_BYTES_PER_NEW_CHARACTER

/* for source code compatibility with earlier versions of MathLink */

#if POWERMACINTOSH_MATHLINK
#pragma options align=mac68k
#endif

typedef struct {
	kcharp_ct str;
	kcharp_ct end;
} MLStringPosition;

#if POWERMACINTOSH_MATHLINK
#pragma options align=reset
#endif

typedef MLStringPosition FAR * MLStringPositionPointer;

#define MLStringFirstPos(s,pos) MLStringFirstPosFun( s, &(pos))

#define MLforString( s, pos) \
	for( MLStringFirstPos(s,pos); MLStringCharacter( (pos).str, (pos).end) >= 0; MLNextCharacter(&(pos).str, (pos).end))

#define MLStringChar( pos) MLStringCharacter( (pos).str, (pos).end)

#define MLPutCharToString MLConvertCharacter


/* for internal use only */

#if POWERMACINTOSH_MATHLINK
#pragma options align=mac68k
#endif

typedef struct {
	ucharp_ct cc;
	int  mode;
	int  more;
	ucharp_ct head;
} MLOldStringPosition;

#if POWERMACINTOSH_MATHLINK
#pragma options align=reset
#endif

typedef MLOldStringPosition FAR * MLOldStringPositionPointer;


#define MLOldforString( s, pos) \
  for ( MLOldStringFirstPos( s, pos); (pos).more; MLOldStringNextPos( pos))

#define MLOldStringChar(pos) \
  ( ((pos).mode <= 1) ? (unsigned int)(*(ucharp_ct)((pos).cc)) : MLOldStringCharFun( &pos) )


#define MLOldStringFirstPos(s,pos) MLOldStringFirstPosFun( s, &(pos))

#define MLOldStringNextPos(pos)  ( \
	((pos).mode == 0) \
		? ((*(*(pos).cc ? ++(pos).cc : (pos).cc) ? 0 : ((pos).more = 0)), (pos).cc) \
		: MLOldStringNextPosFun( &pos) )





#endif /* _MLSTRING_H */




/* eplicitly not protected by _MLXDATA_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C
/* assumes *startp aligned on char boundary, if n == -1, returns ~(char_count) */
MLDECL( long, MLCharacterOffset,           ( kcharpp_ct startp, kcharp_ct end, long n));
MLDECL( long, MLStringCharacter,           ( kcharp_ct  start,  kcharp_ct end));
MLDECL( long, MLNextCharacter,             ( kcharpp_ct startp, kcharp_ct end));

MLDECL( long, MLConvertNewLine,            ( charpp_ct sp));
MLDECL( long, MLConvertCharacter,          ( ulong_ct ch, charpp_ct sp));
MLDECL( long, MLConvertByteString,         ( ucharp_ct  codes, long len, charpp_ct strp, charp_ct str_end));
MLDECL( long, MLConvertByteStringNL,       ( ucharp_ct  codes, long len, charpp_ct strp, charp_ct str_end, ulong_ct nl));
MLDECL( long, MLConvertUnicodeString,      ( ushortp_ct codes, long len, charpp_ct strp, charp_ct str_end));
MLDECL( long, MLConvertUnicodeStringNL,    ( ushortp_ct codes, long len, charpp_ct strp, charp_ct str_end, ulong_ct nl));
MLDECL( long, MLConvertDoubleByteString,   ( ucharp_ct  codes, long len, charpp_ct strp, charp_ct str_end));
MLDECL( long, MLConvertDoubleByteStringNL, ( ucharp_ct  codes, long len, charpp_ct strp, charp_ct str_end, ulong_ct nl));







/* for source code compatibility with earlier versions of MathLink */
MLDECL( kcharp_ct,     MLStringFirstPosFun,  ( kcharp_ct s, MLStringPositionPointer p));

/* for internal use only */
MLDECL( mlapi_result, MLOldPutCharToString,      ( uint_ct ch, charpp_ct sp));
MLDECL( ucharp_ct,    MLOldStringNextPosFun,     ( MLOldStringPositionPointer p));
MLDECL( ucharp_ct,    MLOldStringFirstPosFun,    ( charp_ct s, MLOldStringPositionPointer p));
MLDECL( uint_ct,      MLOldStringCharFun,        ( MLOldStringPositionPointer p));
MLDECL( long,         MLOldConvertByteString,    ( ucharp_ct  codes, long len, charpp_ct strp, charp_ct str_end));
MLDECL( long,         MLOldConvertUnicodeString, ( ushortp_ct codes, long len, charpp_ct strp, charp_ct str_end));

ML_END_EXTERN_C


#ifndef _MLCAPUT_H
#define _MLCAPUT_H


#ifndef __array_meterp__
#define __array_meterp__
typedef struct array_meter* array_meterp;
#endif


#define MLPutRealArray MLPutDoubleArray

#endif /* _MLCAPUT_H */


/* eplicitly not protected by _MLCAPUT_H in case MLDECL is redefined for multiple inclusion */

/*bugcheck: bugcheck need FAR here */
ML_EXTERN_C
MLDECL( mlapi_result,   MLPutArray,                 ( MLINK mlp, array_meterp meter));
MLDECL( mlapi_result,   MLPutBinaryNumberArrayData, ( MLINK mlp, array_meterp meter, voidp_ct     datap, long_st count, long type));
MLDECL( mlapi_result,   MLPutByteArrayData,         ( MLINK mlp, array_meterp meter, ucharp_nt    datap, long_st count));
MLDECL( mlapi_result,   MLPutShortIntegerArrayData, ( MLINK mlp, array_meterp meter, shortp_nt    datap, long_st count));
MLDECL( mlapi_result,   MLPutIntegerArrayData,      ( MLINK mlp, array_meterp meter, intp_nt      datap, long_st count));
MLDECL( mlapi_result,   MLPutLongIntegerArrayData,  ( MLINK mlp, array_meterp meter, longp_nt     datap, long_st count));
MLDECL( mlapi_result,   MLPutFloatArrayData,        ( MLINK mlp, array_meterp meter, floatp_nt    datap, long_st count));
MLDECL( mlapi_result,   MLPutDoubleArrayData,       ( MLINK mlp, array_meterp meter, doublep_nt   datap, long_st count));
MLDECL( mlapi_result,   MLPutLongDoubleArrayData,   ( MLINK mlp, array_meterp meter, extendedp_nt datap, long_st count));

MLDECL( mlapi_result,   MLPutBinaryNumberArray, ( MLINK mlp, voidp_ct     data, longp_st dimp, charpp_ct heads, long_st depth, long type));
MLDECL( mlapi_result,   MLPutByteArray,         ( MLINK mlp, ucharp_nt    data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( mlapi_result,   MLPutShortIntegerArray, ( MLINK mlp, shortp_nt    data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( mlapi_result,   MLPutIntegerArray,      ( MLINK mlp, intp_nt      data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( mlapi_result,   MLPutLongIntegerArray,  ( MLINK mlp, longp_nt     data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( mlapi_result,   MLPutDoubleArray,       ( MLINK mlp, doublep_nt   data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( mlapi_result,   MLPutFloatArray,        ( MLINK mlp, floatp_nt    data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( mlapi_result,   MLPutLongDoubleArray,   ( MLINK mlp, extendedp_nt data, longp_st dims, charpp_ct heads, long_st depth));

MLDECL( mlapi_result,   MLPutBinaryNumberList, ( MLINK mlp, voidp_ct   data, long_st count, long type));
MLDECL( mlapi_result,   MLPutIntegerList,      ( MLINK mlp, intp_nt    data, long_st count));
MLDECL( mlapi_result,   MLPutRealList,         ( MLINK mlp, doublep_nt data, long_st count));
ML_END_EXTERN_C


#ifndef _MLCAGET_H
#define _MLCAGET_H


#ifndef __array_meterp__
#define __array_meterp__
typedef struct array_meter* array_meterp;
#endif


#define MLGetRealArray    MLGetDoubleArray
#define MLDisownRealArray MLDisownDoubleArray

#endif /* _MLCAGET_H */



/* eplicitly not protected by _MLCAGET_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C
MLDECL( mlapi_result,  MLGetBinaryNumberList, ( MLINK mlp, voidpp_ct   datap, longp_st countp, long type));
MLDECL( mlapi_result,  MLGetIntegerList,      ( MLINK mlp, intpp_nt    datap, longp_st countp));
MLDECL( mlapi_result,  MLGetRealList,         ( MLINK mlp, doublepp_nt datap, longp_st countp));

MLDECL( void, MLDisownBinaryNumberList, ( MLINK mlp, voidp_ct   data, long_st count, long type));
MLDECL( void, MLDisownIntegerList,      ( MLINK mlp, intp_nt    data, long_st count));
MLDECL( void, MLDisownRealList,         ( MLINK mlp, doublep_nt data, long_st count));

MLDECL( mlapi_token,    MLGetArrayType,             ( MLINK mlp, array_meterp meter));
MLDECL( mlapi_result,   MLGetArrayDimensions,       ( MLINK mlp, array_meterp meter));

MLDECL( mlapi_result,   MLGetBinaryNumberArrayData, ( MLINK mlp, array_meterp meter, voidp_ct     datap, long_st count, long type));
MLDECL( mlapi_result,   MLGetByteArrayData,         ( MLINK mlp, array_meterp meter, ucharp_nt    datap, long_st count));
MLDECL( mlapi_result,   MLGetShortIntegerArrayData, ( MLINK mlp, array_meterp meter, shortp_nt    datap, long_st count));
MLDECL( mlapi_result,   MLGetIntegerArrayData,      ( MLINK mlp, array_meterp meter, intp_nt      datap, long_st count));
MLDECL( mlapi_result,   MLGetLongIntegerArrayData,  ( MLINK mlp, array_meterp meter, longp_nt     datap, long_st count));
MLDECL( mlapi_result,   MLGetFloatArrayData,        ( MLINK mlp, array_meterp meter, floatp_nt    datap, long_st count));
MLDECL( mlapi_result,   MLGetDoubleArrayData,       ( MLINK mlp, array_meterp meter, doublep_nt   datap, long_st count));
MLDECL( mlapi_result,   MLGetLongDoubleArrayData,   ( MLINK mlp, array_meterp meter, extendedp_nt datap, long_st count));

MLDECL( mlapi_result,   MLGetBinaryNumberArray,    ( MLINK mlp, voidpp_ct     datap, longpp_st dimpp, charppp_ct headsp, longp_st depthp, long type));
MLDECL( mlapi_result,   MLGetByteArray,            ( MLINK mlp, ucharpp_nt    datap, longpp_st dimsp, charppp_ct headsp, longp_st depthp));
MLDECL( mlapi_result,   MLGetShortIntegerArray,    ( MLINK mlp, shortpp_nt    datap, longpp_st dimsp, charppp_ct headsp, longp_st depthp));
MLDECL( mlapi_result,   MLGetIntegerArray,         ( MLINK mlp, intpp_nt      datap, longpp_st dimsp, charppp_ct headsp, longp_st depthp));
MLDECL( mlapi_result,   MLGetLongIntegerArray,     ( MLINK mlp, longpp_nt     datap, longpp_st dimsp, charppp_ct headsp, longp_st depthp));
MLDECL( mlapi_result,   MLGetDoubleArray,          ( MLINK mlp, doublepp_nt   datap, longpp_st dimsp, charppp_ct headsp, longp_st depthp));
MLDECL( mlapi_result,   MLGetFloatArray,           ( MLINK mlp, floatpp_nt    datap, longpp_st dimsp, charppp_ct headsp, longp_st depthp));
MLDECL( mlapi_result,   MLGetLongDoubleArray,      ( MLINK mlp, extendedpp_nt datap, longpp_st dimsp, charppp_ct headsp, longp_st depthp));

MLDECL( void,           MLDisownBinaryNumberArray, ( MLINK mlp, voidp_ct     data, longp_st dimp, charpp_ct heads, long_st len, long type));
MLDECL( void,           MLDisownByteArray,         ( MLINK mlp, ucharp_nt    data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( void,           MLDisownShortIntegerArray, ( MLINK mlp, shortp_nt    data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( void,           MLDisownIntegerArray,      ( MLINK mlp, intp_nt      data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( void,           MLDisownLongIntegerArray,  ( MLINK mlp, longp_nt     data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( void,           MLDisownFloatArray,        ( MLINK mlp, floatp_nt    data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( void,           MLDisownDoubleArray,       ( MLINK mlp, doublep_nt   data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( void,           MLDisownLongDoubleArray,   ( MLINK mlp, extendedp_nt data, longp_st dims, charpp_ct heads, long_st depth));
ML_END_EXTERN_C


/*************** seeking, transfering  and synchronization ***************/

#ifndef _MLMARK_H
#define _MLMARK_H


#endif /* _MLMARK_H */

/* eplicitly not protected by _MLMARK_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C
MLDECL( MLINKMark,  MLCreateMark,  ( MLINK mlp));
MLDECL( MLINKMark,  MLSeekToMark,  ( MLINK mlp, MLINKMark mark, long index));
MLDECL( MLINKMark,  MLSeekMark,    ( MLINK mlp, MLINKMark mark, long index));
MLDECL( void,       MLDestroyMark, ( MLINK mlp, MLINKMark mark));
ML_END_EXTERN_C


#ifndef _MLXFER_H
#define _MLXFER_H


#endif /* _MLXFER_H */

/* eplicitly not protected by _MLXFER_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C
MLDECL( mlapi_result, MLTransferExpression, ( MLINK dmlp, MLINK smlp));
MLDECL( mlapi_result, MLTransferToEndOfLoopbackLink, ( MLINK dmlp, MLINK smlp));
ML_END_EXTERN_C


#ifndef _MLSYNC_H
#define _MLSYNC_H


/* export mls__wait and mls__align(mlsp) */

#endif /* _MLSYNC_H */

/* eplicitly not protected by _MLSYNC_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C
/* in response to a reset message */
MLDECL( mlapi_result, MLForwardReset, ( MLINK mlp, ulong_ct marker));
MLDECL( mlapi_result, MLAlign,        ( MLINK lmlp, MLINK rmlp));
ML_END_EXTERN_C

/*************************************************************/


#ifndef _MLPKT_H
#define _MLPKT_H

/*************** Mathematica packet interface ***************/

			/* MLNextPacket returns one of... */


/* edit here and in mlpktstr.h */

#ifndef _MLPKTNO_H
#define _MLPKTNO_H

#define ILLEGALPKT      0

#define CALLPKT         7
#define EVALUATEPKT    13
#define RETURNPKT       3

#define INPUTNAMEPKT    8
#define ENTERTEXTPKT   14
#define ENTEREXPRPKT   15
#define OUTPUTNAMEPKT   9
#define RETURNTEXTPKT   4
#define RETURNEXPRPKT  16

#define DISPLAYPKT     11
#define DISPLAYENDPKT  12

#define MESSAGEPKT      5
#define TEXTPKT         2

#define INPUTPKT        1
#define INPUTSTRPKT    21
#define MENUPKT         6
#define SYNTAXPKT      10

#define SUSPENDPKT     17
#define RESUMEPKT      18

#define BEGINDLGPKT    19
#define ENDDLGPKT      20

#define FIRSTUSERPKT  128
#define LASTUSERPKT   255


#endif /* _MLPKTNO_H */

#endif /* _MLPKT_H */

/* eplicitly not protected by _MLPKT_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C
MLDECL( mlapi_packet,  MLNextPacket, ( MLINK mlp));
ML_END_EXTERN_C


#ifndef _MLALERT_H
#define _MLALERT_H



ML_EXTERN_C
/*************** User interaction--for internal use only ***************/
typedef long mldlg_result;

MLDPROC( mldlg_result, MLAlertProcPtr,             ( MLEnvironment env, kcharp_ct message));
MLDPROC( mldlg_result, MLRequestProcPtr,           ( MLEnvironment env, kcharp_ct prompt, charp_ct response, long sizeof_response));
MLDPROC( mldlg_result, MLConfirmProcPtr,           ( MLEnvironment env, kcharp_ct question, mldlg_result default_answer));
MLDPROC( mldlg_result, MLRequestArgvProcPtr,       ( MLEnvironment env, charpp_ct argv, long cardof_argv, charp_ct buf, long sizeof_buf));
MLDPROC( mldlg_result, MLRequestToInteractProcPtr, ( MLEnvironment env, mldlg_result wait_for_permission));
MLDPROC( mldlg_result, MLDialogProcPtr,            ( MLEnvironment env));

enum {
	uppMLAlertFunctionProcInfo = kPascalStackBased
		 | RESULT_SIZE(SIZE_CODE(sizeof(mldlg_result)))
		 | STACK_ROUTINE_PARAMETER(1, SIZE_CODE(sizeof(MLEnvironment)))
		 | STACK_ROUTINE_PARAMETER(2, SIZE_CODE(sizeof(kcharp_ct))),
	uppMLRequestFunctionProcInfo = kPascalStackBased
		 | RESULT_SIZE(SIZE_CODE(sizeof(mldlg_result)))
		 | STACK_ROUTINE_PARAMETER(1, SIZE_CODE(sizeof(MLEnvironment)))
		 | STACK_ROUTINE_PARAMETER(2, SIZE_CODE(sizeof(kcharp_ct)))
		 | STACK_ROUTINE_PARAMETER(3, SIZE_CODE(sizeof(charp_ct)))
		 | STACK_ROUTINE_PARAMETER(4, SIZE_CODE(sizeof(long))),
	uppMLConfirmFunctionProcInfo = kPascalStackBased
		 | RESULT_SIZE(SIZE_CODE(sizeof(mldlg_result)))
		 | STACK_ROUTINE_PARAMETER(1, SIZE_CODE(sizeof(MLEnvironment)))
		 | STACK_ROUTINE_PARAMETER(2, SIZE_CODE(sizeof(kcharp_ct)))
		 | STACK_ROUTINE_PARAMETER(3, SIZE_CODE(sizeof(mldlg_result))),
	uppMLRequestArgvFunctionProcInfo = kPascalStackBased
		 | RESULT_SIZE(SIZE_CODE(sizeof(mldlg_result)))
		 | STACK_ROUTINE_PARAMETER(1, SIZE_CODE(sizeof(MLEnvironment)))
		 | STACK_ROUTINE_PARAMETER(2, SIZE_CODE(sizeof(charpp_ct)))
		 | STACK_ROUTINE_PARAMETER(3, SIZE_CODE(sizeof(long)))
		 | STACK_ROUTINE_PARAMETER(4, SIZE_CODE(sizeof(charp_ct)))
		 | STACK_ROUTINE_PARAMETER(5, SIZE_CODE(sizeof(long))),
	uppMLRequestToInteractFunctionProcInfo = kPascalStackBased
		 | RESULT_SIZE(SIZE_CODE(sizeof(mldlg_result)))
		 | STACK_ROUTINE_PARAMETER(1, SIZE_CODE(sizeof(MLEnvironment)))
		 | STACK_ROUTINE_PARAMETER(2, SIZE_CODE(sizeof(mldlg_result)))
};



#if GENERATINGCFM

	typedef UniversalProcPtr MLDialogUPP;
	typedef UniversalProcPtr MLAlertUPP;
	typedef UniversalProcPtr MLRequestUPP;
	typedef UniversalProcPtr MLConfirmUPP;
	typedef UniversalProcPtr MLRequestArgvUPP;
	typedef UniversalProcPtr MLRequestToInteractUPP;

#	define NewMLAlertProc(userRoutine) \
		NewRoutineDescriptor((ProcPtr)MLAlertCast((userRoutine)), \
			uppMLAlertFunctionProcInfo, GetCurrentArchitecture())
#	define NewMLRequestProc(userRoutine) \
		NewRoutineDescriptor((ProcPtr)MLRequestCast((userRoutine)), \
			uppMLRequestFunctionProcInfo, GetCurrentArchitecture())
#	define NewMLConfirmProc(userRoutine) \
		NewRoutineDescriptor((ProcPtr)MLConfirmCast((userRoutine)), \
			uppMLConfirmFunctionProcInfo, GetCurrentArchitecture())
#	define NewMLRequestArgvProc(userRoutine) \
		NewRoutineDescriptor((ProcPtr)MLRequestArgvCast((userRoutine)), \
			uppMLRequestArgvFunctionProcInfo, GetCurrentArchitecture())
#	define NewMLRequestToInteractProc(userRoutine) \
		NewRoutineDescriptor((ProcPtr)MLRequestToInteractCast((userRoutine)), \
			uppMLRequestToInteractFunctionProcInfo, GetCurrentArchitecture())

#else

	typedef MLDialogProcPtr MLDialogUPP;
	typedef MLAlertProcPtr MLAlertUPP;
	typedef MLRequestProcPtr MLRequestUPP;
	typedef MLConfirmProcPtr MLConfirmUPP;
	typedef MLRequestArgvProcPtr MLRequestArgvUPP;
	typedef MLRequestToInteractProcPtr MLRequestToInteractUPP;

#	define NewMLAlertProc(userRoutine) MLAlertCast((userRoutine))
#	define NewMLRequestProc(userRoutine) MLRequestCast((userRoutine))
#	define NewMLConfirmProc(userRoutine) MLConfirmCast((userRoutine))
#	define NewMLRequestArgvProc(userRoutine) MLRequestArgvCast((userRoutine))
#	define NewMLRequestToInteractProc(userRoutine) MLRequestToInteractCast((userRoutine))

#endif


typedef MLAlertUPP MLAlertFunctionType;
typedef MLRequestUPP MLRequestFunctionType;
typedef MLConfirmUPP MLConfirmFunctionType;
typedef MLRequestArgvUPP MLRequestArgvFunctionType;
typedef MLRequestToInteractUPP MLRequestToInteractFunctionType;
typedef MLDialogUPP MLDialogFunctionType;



/* 
	MLDDECL( mldlg_result, alert_user, ( MLEnvironment env, kcharp_ct message));
	MLDDEFN( mldlg_result, alert_user, ( MLEnvironment env, kcharp_ct message))
	{
		fprintf( stderr, "%s\n", message);
	}


	...
	MLDialogFunctionType f = NewMLAlertProc(alert_user);
	MLSetDialogFunction( ep, MLAlertFunction, f);
	...
	or
	...
	MLSetDialogFunction( ep, MLAlertFunction, NewMLAlertProc(alert_user));
	...
*/



enum {	MLAlertFunction = 1, MLRequestFunction, MLConfirmFunction,
	MLRequestArgvFunction, MLRequestToInteractFunction };


#define ML_DEFAULT_DIALOG ( (MLDialogFunctionType) 1)
#define ML_IGNORE_DIALOG ( (MLDialogFunctionType) 0)
#define ML_SUPPRESS_DIALOG ML_IGNORE_DIALOG




#if MACINTOSH_MATHLINK

#ifndef _MLMAC_H
#define _MLMAC_H


ML_EXTERN_C

MLDDECL( mldlg_result, MLPermit_application,  ( MLEnvironment env, mldlg_result wait_for_permission));

MLDDECL( mldlg_result, MLAlert_application,   ( MLEnvironment env, kcharp_ct message));
MLDDECL( mldlg_result, MLAlert_tool,          ( MLEnvironment env, kcharp_ct message));
MLDDECL( mldlg_result, MLAlert_siow,          ( MLEnvironment env, kcharp_ct message));
MLDDECL( mldlg_result, MLAlert_console,       ( MLEnvironment env, kcharp_ct message));

MLDDECL( mldlg_result, MLRequest_application, ( MLEnvironment env, kcharp_ct prompt, charp_ct response, long sizeof_response));
MLDDECL( mldlg_result, MLRequest_console,     ( MLEnvironment env, kcharp_ct prompt, charp_ct response, long sizeof_response));
MLDDECL( mldlg_result, MLRequest_tool,        ( MLEnvironment env, kcharp_ct prompt, charp_ct response, long sizeof_response));
MLDDECL( mldlg_result, MLRequest_siow,        ( MLEnvironment env, kcharp_ct prompt, charp_ct response, long sizeof_response));

MLDDECL( mldlg_result, MLConfirm_application, ( MLEnvironment env, kcharp_ct question, mldlg_result default_answer));
MLDDECL( mldlg_result, MLConfirm_tool,        ( MLEnvironment env, kcharp_ct question, mldlg_result default_answer));
MLDDECL( mldlg_result, MLConfirm_siow,        ( MLEnvironment env, kcharp_ct question, mldlg_result default_answer));
MLDDECL( mldlg_result, MLConfirm_console,     ( MLEnvironment env, kcharp_ct question, mldlg_result default_answer));

ML_END_EXTERN_C

#endif /* _MLMAC_H */
#define MLALERT  	MLAlert_application
#define MLREQUEST	MLRequest_application
#define MLCONFIRM	MLConfirm_application
#define MLPERMIT 	MLPermit_application
#define MLREQUESTARGV	default_request_argv
#endif

#if WINDOWS_MATHLINK

#ifndef _MLWIN_H
#define _MLWIN_H



ML_EXTERN_C
MLDDECL( mldlg_result, MLAlert_win,   ( MLEnvironment ep, kcharp_ct alertstr));
MLDDECL( mldlg_result, MLRequest_win, ( MLEnvironment ep, kcharp_ct prompt, charp_ct response, long n));
MLDDECL( mldlg_result, MLConfirm_win, ( MLEnvironment ep, kcharp_ct okcancelquest, mldlg_result default_answer));
MLDDECL( mldlg_result, MLPermit_win,  ( MLEnvironment ep, mldlg_result wait));
ML_END_EXTERN_C

/* edit here and in mlwin.rc -- in both places because of command-line length limitations in dos */
#define DLG_LINKNAME                101
#define DLG_TEXT                    102
#define RIDOK                       1
#define RIDCANCEL                   104

#endif /* _MLWIN_H */
#define MLALERT         MLAlert_win
#define MLREQUEST       MLRequest_win
#define MLCONFIRM       MLConfirm_win
#define MLPERMIT        MLPermit_win
#define MLREQUESTARGV	default_request_argv
#endif

#if UNIX_MATHLINK

#ifndef _MLUNIX_H
#define _MLUNIX_H


ML_EXTERN_C

MLDDECL( mldlg_result, MLAlert_unix,   ( MLEnvironment env, kcharp_ct message));
MLDDECL( mldlg_result, MLRequest_unix, ( MLEnvironment env, kcharp_ct prompt, charp_ct response, long sizeof_response));
MLDDECL( mldlg_result, MLConfirm_unix, ( MLEnvironment env, kcharp_ct question, mldlg_result default_answer));
MLDDECL( mldlg_result, MLPermit_unix,  ( MLEnvironment env, mldlg_result wait_for_permission));

ML_END_EXTERN_C

#endif /* _MLUNIX_H */
#define MLALERT  	MLAlert_unix
#define MLREQUEST	MLRequest_unix
#define MLCONFIRM	MLConfirm_unix
#define MLPERMIT 	MLPermit_unix
#define MLREQUESTARGV	default_request_argv
#endif


MLDDECL( mldlg_result, default_request_argv, ( MLEnvironment ep, charpp_ct argv, long len, charp_ct buff, long size));
ML_END_EXTERN_C

#endif /* _MLALERT_H */


/* eplicitly not protected by _MLXDATA_H in case MLDECL is redefined for multiple inclusion */
ML_EXTERN_C
MLDECL( mldlg_result,  MLAlert,             ( MLEnvironment env, kcharp_ct message));
MLDECL( mldlg_result,  MLRequest,           ( MLEnvironment env, kcharp_ct prompt, charp_ct response, long sizeof_response)); /* initialize response with default*/
MLDECL( mldlg_result,  MLConfirm,           ( MLEnvironment env, kcharp_ct question, mldlg_result default_answer));
MLDECL( mldlg_result,  MLRequestArgv,       ( MLEnvironment env, charpp_ct argv, long cardof_argv, charp_ct buff, long size));
MLDECL( mldlg_result,  MLRequestToInteract, ( MLEnvironment env, mldlg_result wait_for_permission));
MLDECL( mlapi_result,  MLSetDialogFunction, ( MLEnvironment env, long funcnum, MLDialogFunctionType func));

/* just some type-safe casts */
MLDECL( MLDialogProcPtr, MLAlertCast, ( MLAlertProcPtr f));
MLDECL( MLDialogProcPtr, MLRequestCast, ( MLRequestProcPtr f));
MLDECL( MLDialogProcPtr, MLConfirmCast, ( MLConfirmProcPtr f));
MLDECL( MLDialogProcPtr, MLRequestArgvCast, ( MLRequestArgvProcPtr f));
MLDECL( MLDialogProcPtr, MLRequestToInteractCast, ( MLRequestToInteractProcPtr f));
ML_END_EXTERN_C

/*************************************************************/

#ifdef __CFM68K__
#pragma import off
#endif


#ifndef _MLTM_H
#define _MLTM_H


/*************** Template interface ***************/

/* The following are useful only when using template files as
 * their definitions are produced by mprep.
 */

extern MLINK stdlink;
extern MLEnvironment stdenv;
extern MLYieldFunctionObject stdyielder;
extern MLMessageHandlerObject stdhandler;
extern int	MLMain P((int, charpp_ct)); /* pass in argc and argv */
extern int  MLMainString P(( charp_ct commandline));
extern int  MLMainArgv P(( char** argv, char** argv_end)); /* note not FAR pointers */
            
extern int	MLInstall P((MLINK));
extern mlapi_packet	MLAnswer P((MLINK));
extern int	MLDoCallPacket P((MLINK));
extern int	MLEvaluate P(( MLINK, charp_ct));
extern int	MLEvaluateString P(( MLINK, charp_ct));
MLMDECL( void, MLDefaultHandler, ( MLINK, unsigned long, unsigned long));
MLYDECL( devyield_result, MLDefaultYielder, ( MLINK, MLYieldParameters));

#if WINDOWS_MATHLINK
extern HWND MLInitializeIcon P(( HANDLE hinstCurrent, int nCmdShow));
extern HANDLE MLInstance;
extern HWND MLIconWindow;
#endif
extern int	MLAbort, MLDone;
extern long MLSpecialCharacter;

#endif /* _MLTM_H */



#endif /* _MATHLINK_H */
