/*************************************************************************

        Copyright 1986 through 2007 by Wolfram Research Inc.
        All rights reserved

*************************************************************************/

#ifndef _MATHLINK_H
#define _MATHLINK_H

#if __BORLANDC__ && ! __BCPLUSPLUS__
#pragma warn -stu
#endif

#ifndef _MLVERS_H
#define _MLVERS_H

#ifndef _MLPLATFM_H
#define _MLPLATFM_H

#if ! WINDOWS_MATHLINK && ! UNIX_MATHLINK
#  define UNIX_MATHLINK 1
#endif

#if defined(__GNUC__)
#	if defined(__GNUC_PATCHLEVEL__)
#		define GCC_MATHLINK_VERSION (__GNUC__ * 10000 \
						+ __GNUC_MINOR__ * 100 \
						+ __GNUC_PATCHLEVEL__)
#	else
#		define GCC_MATHLINK_VERSION (__GNUC__ * 10000 \
						+ __GNUC_MINOR__ * 100)
#	endif
#endif

#if WINDOWS_MATHLINK
#	if defined(WIN64) || defined(__WIN64__) || defined(_WIN64)
#		define WIN64_MATHLINK 1
#		if( _M_IX86 || __i386 || __i386__ || i386)
#			define I86_WIN32_MATHLINK 1
#		endif
#	elif defined(WIN32) || defined(__WIN32__) || defined(__NT__) || defined(_WIN32)
#		define WIN32_MATHLINK 1
#		if( _M_IX86 || __i386 || __i386__ || i386)
#			define I86_WIN32_MATHLINK 1
#		elif _M_ALPHA || __alpha || __alpha__ || alpha
#			define ALPHA_WIN32_MATHLINK 1
#		else
#		endif
#	else
#		define WIN16_MATHLINK 1
#	endif
#elif UNIX_MATHLINK
#	if (__sun || __sun__ || sun) && !defined(SUN_MATHLINK)
#		define SUN_MATHLINK 1
#		if __sparcv9 || __sparcv9__
#			define U64_SOLARIS_MATHLINK 1
#		elif __SVR4 || __svr4__
#			define U32_SOLARIS_MATHLINK 1
#		else
#			define SUNOS_MATHLINK 1
#		endif
#		if __sparc || __sparc__ || sparc
#			define SPARC_SUN_MATHLINK 1
#		elif __i386 || __i386__ || i386
#			define I386_SOLARIS_MATHLINK 1
#		elif __x86_64 || __x86_64__ || x86_64
#			define X86_64_SOLARIS_MATHLINK 1
#		else
			unknown platform
#		endif
#	elif (__MACH || __MACH__ || MACH) && !defined(DARWIN_MATHLINK)
#		define DARWIN_MATHLINK 1
#		if __ppc || __ppc__ || ppc
#			define PPC_DARWIN_MATHLINK 1
#		elif __ppc64 || __ppc64__ || ppc64
#			define PPC64_DARWIN_MATHLINK 1
#		elif __i386 || __i386__ || i386
#			define X86_DARWIN_MATHLINK 1
#		elif __x86_64 || __x86_64__ || x86_64
#			define X86_64_DARWIN_MATHLINK 1
#		else
			not yet implemented
#		endif
#	elif (__linux || __linux__ || linux) && !defined(LINUX_MATHLINK)
#		define LINUX_MATHLINK 1
#		if __i386 || __i386__ || i386
#			define I86_LINUX_MATHLINK 1
#		elif __PPC || __PPC__ || PPC
#			define PPC_LINUX_MATHLINK 1
#		elif __alpha || __alpha__ || alpha
#			define AXP_LINUX_MATHLINK 1
#		elif __ia64 || __ia64__ || ia64
#			define IA64_LINUX_MATHLINK 1
#		elif __x86_64 || __x86_64__ || x86_64
#			define X86_64_LINUX_MATHLINK 1
#		elif __arm || __arm__ || arm
#			define ARM_LINUX_MATHLINK 1
#		else
			not yet implemented
#		endif
#	elif (__osf || __osf__ || osf || OSF1) && !defined(DIGITAL_MATHLINK)
#		define DIGITAL_MATHLINK 1
#		if __alpha || __alpha__ || alpha
#			define ALPHA_DIGITAL_MATHLINK 1
#		else
			unknown platform
#		endif
#	elif (_AIX || _IBMR2 || __xlC__) && !defined(AIX_MATHLINK)
#		define AIX_MATHLINK 1
#		if __64BIT__
#			define A64_AIX_MATHLINK 1
#		endif
#	elif (__sgi || __sgi__ || sgi || mips) && !defined(IRIX_MATHLINK)
#		define IRIX_MATHLINK 1
#		if _MIPS_SZLONG == 32
#			define N32_IRIX_MATHLINK 1
#		elif _MIPS_SZLONG == 64
#			define M64_IRIX_MATHLINK 1
#		else
			not yet implemented
#		endif
#	elif (hpux || __hpux) && !defined(HPUX_MATHLINK)
#		define HPUX_MATHLINK 1
#		if __LP64__
#			define LP64_HPUX_MATHLINK 1
#		endif
#	elif (M_I386 || _SCO_DS || SCO) && !defined(SCO_MATHLINK)
#		define SCO_MATHLINK 1
#	elif (__NetBSD__) && !defined(NETBSD_MATHLINK)
#		define NETBSD_MATHLINK 1
#	elif (__FreeBSD__) && !defined(FREEBSD_MATHLINK)
#		define FREEBSD_MATHLINK 1
#	elif (bsdi || __bsdi__) && !defined(BSDI_MATHLINK)
#		define BSDI_MATHLINK 1
#	else
#	endif
#endif



#ifndef NO_GLOBAL_DATA
#	define NO_GLOBAL_DATA 0
#endif

#if WINDOWS_MATHLINK || __i386 || __i386__ || i386 || _M_IX86 || __x86_64 || __x86_64__ || x86_64 || __ia64 || __ia64__ || ia64 ||  __alpha || __alpha__ || alpha
#	define LITTLEENDIAN_NUMERIC_TYPES 1
#else
#	define BIGENDIAN_NUMERIC_TYPES 1
#endif

#endif /* _MLPLATFM_H */

#ifndef MLVERSION
        /* APPIDSERV */
#       define MLVERSION 4
#endif

#if !OLD_VERSIONING


/*
 * MathLink adopts a simple versioning strategy that can be adapted to many
 * compile-time and run-time environments.  In particular, it is amenable to
 * the various shared library facilities in use.  (Although certain of these
 * facilities provide more sophisticated mechanisms than are required by the
 * following simple strategy.)
 * 
 * MathLink evolves by improving its implementation and by improving its
 * interface.  The values of MLREVISION or MLINTERFACE defined here are 
 * incremented whenever an improvement is made and released.
 * 
 * MLREVISION is the current revision number. It is incremented every time 
 * a change is made to the source and MathLink is rebuilt and distributed
 * on any platform.  (Bug fixes, optimizations, or other improvements
 * transparent to the interface increment only this number.)
 * 
 * MLINTERFACE is a name for a documented interface to MathLink.  This
 * number is incremented whenever a named constant or function is added,
 * removed, or its behavior is changed in a way that could break existing
 * correct* client programs.  It is expected that the interface to MathLink
 * is improved over time so that implemenations of higher numbered 
 * interfaces are more complete or more convenient to use for writing
 * effective client programs.  In particular, a specific interface provides
 * all the useful functionality of an earlier interface.
 * 
 *     *(It is possible that an incorrect MathLink program still works
 *     because it relies on some undocumented detail of a particular
 *     revision.  It may not always be possible to change the interface
 *     number when such a detail changes.  For example, one program may
 *     be relying on a bug in MathLink that a great many other programs
 *     need fixed.  In this case, we would likely choose to potentially
 *     break the incorrect program in order to fix the correct programs
 *     by incrementing the revision number leaving the interface number
 *     unchanged.  It is possible to bind to a particular revision of a
 *     MathLink interface if that is important for some programs.  One
 *     could use a statically linked version of the library, make use of
 *     the search algorithm used by the runtime loader, or dynamically
 *     load the MathLink library manually.)
 * 
 * 
 * If a distributed MathLink implmentation were labeled with its revision 
 * and interface numbers in dotted notation so that, say, ML.1.6 means the
 * sixth revision of interface one, then the following may represent the
 * distribution history of MathLink.
 * 
 *     first distribution
 *         ML.1.5   (Perhaps earlier revisions were never
 *                   distributed for this platform.)
 * 
 *     second distribution
 *         ML.1.6   (Bug fixes or other improvements were
 *                   made that don't affect the interface.)
 * 
 *     third distribution
 *         ML.2.7   (Perhaps some new functions were added.)
 *         
 *         ML.1.7   (And improvements were made that don't
 *                   affect the old interface.)
 * 
 *     fourth distribution
 *         ML.3.8   (Perhaps the return values of an existing
 *                   function changed.)
 *         ML.2.8   (Revision 8 also adds improvements transparent
 *                   to interface 2.)
 *         ML.1.7   (Clients of interface 1 see no improvements
 *                   in this eighth revision.)
 * 
 * Note that the distribution history may not be the same on different
 * platforms.  But revision numbers represent a named body of source code
 * across all platforms.
 * 
 * The mechanism for deploying this strategy differs between platforms
 * because of differing platform-specific facilities and conventions.
 * The interface and revision numbers may form part of the filename of
 * the MathLink library, or they may not.  This information is always
 * available in some conventional form so that it is easy and natural for
 * client programs to bind with and use the best available implementation
 * of a particular MathLink interface.  The details are described in the
 * MathLink Developer's Guide for each platform.
 */

#define MLREVISION 17
#define MLMATHVERSION 6.0.1
#define MLCREATIONID 875980

#define MLAPI1REVISION 1   /* the first revision to support interface 1 */
#define MLAPI2REVISION 6   /* the first revision to support interface 2 */
#define MLAPI3REVISION 16  /* the first revision to support interface 3 */


#ifndef MLINTERFACE
#       define MLINTERFACE 3
#       define MLAPIREVISION MLAPI3REVISION
                /*
                 * Interface 3 adds the following exported functions:
                 *      MLClearAllSymbolReplacements
                 *      MLClearSymbolReplacement
                 *      MLConvertUCS2String
                 *      MLConvertUCS2StringNL
                 *      MLConvertUTF8String
                 *      MLConvertUTF8StringNL
                 *      MLConvertUTF16String
                 *      MLConvertUTF16StringNL
                 *      MLConvertUTF32String
                 *      MLConvertUTF32StringNL
                 *      MLEnvironmentData
                 *      MLGetDomainNameList
                 *      MLGetInteger16
                 *      MLGetInteger16Array
                 *      MLGetInteger16ArrayData
                 *      MLGetInteger16List
                 *      MLGetInteger32
                 *      MLGetInteger32Array
                 *      MLGetInteger32ArrayData
                 *      MLGetInteger32List
                 *      MLGetInteger64
                 *      MLGetInteger64Array
                 *      MLGetInteger64ArrayData
                 *      MLGetInteger64List
                 *      MLGetLinkedEnvIDString
                 *      MLGetMessageHandler
                 *      MLGetNetworkAddressList
                 *      MLGetReal128
                 *      MLGetReal128Array
                 *      MLGetReal128ArrayData
                 *      MLGetReal128List
                 *      MLGetReal32
                 *      MLGetReal32Array
                 *      MLGetReal32ArrayData
                 *      MLGetReal32List
                 *      MLGetReal64
                 *      MLGetReal64Array
                 *      MLGetReal64ArrayData
                 *      MLGetReal64List
                 *      MLGetUCS2Characters
                 *      MLGetUCS2String
                 *      MLGetUCS2Symbol
                 *      MLGetUTF16Characters
                 *      MLGetUTF16String
                 *      MLGetUTF16Symbol
                 *      MLGetUTF32Characters
                 *      MLGetUTF32String
                 *      MLGetUTF32Symbol
                 *      MLGetUTF8Characters
                 *      MLGetUTF8String
                 *      MLGetUTF8Symbol
                 *      MLGetYieldFunction
                 *      MLLinkName
                 *      MLOldConvertUCS2String
                 *      MLOpenArgcArgv
                 *      MLPutInteger16
                 *      MLPutInteger16Array
                 *      MLPutInteger16ArrayData
                 *      MLPutInteger16List
                 *      MLPutInteger32
                 *      MLPutInteger32Array
                 *      MLPutInteger32ArrayData
                 *      MLPutInteger32List
                 *      MLPutInteger64
                 *      MLPutInteger64Array
                 *      MLPutInteger64ArrayData
                 *      MLPutInteger64List
                 *      MLPutMessageWithArg
                 *      MLPutReal128
                 *      MLPutReal128Array
                 *      MLPutReal128ArrayData
                 *      MLPutReal128List
                 *      MLPutReal32
                 *      MLPutReal32Array
                 *      MLPutReal32ArrayData
                 *      MLPutReal32List
                 *      MLPutReal64
                 *      MLPutReal64Array
                 *      MLPutReal64ArrayData
                 *      MLPutReal64List
                 *      MLPutUCS2Characters
                 *      MLPutUCS2String
                 *      MLPutUCS2Symbol
                 *      MLPutUTF16Characters
                 *      MLPutUTF16String
                 *      MLPutUTF16Symbol
                 *      MLPutUTF32Characters
                 *      MLPutUTF32String
                 *      MLPutUTF32Symbol
                 *      MLPutUTF8Characters
                 *      MLPutUTF8String
                 *      MLPutUTF8Symbol
                 *      MLReadyParallel
                 *      MLReleaseBinaryNumberArray
                 *      MLReleaseByteArray
                 *      MLReleaseByteString
                 *      MLReleaseByteSymbol
                 *      MLReleaseDomainNameList
                 *      MLReleaseInteger16Array
                 *      MLReleaseInteger16List
                 *      MLReleaseInteger32Array
                 *      MLReleaseInteger32List
                 *      MLReleaseInteger64Array
                 *      MLReleaseInteger64List
                 *      MLReleaseNetworkAddressList
                 *      MLReleaseReal128Array
                 *      MLReleaseReal128List
                 *      MLReleaseReal32Array
                 *      MLReleaseReal32List
                 *      MLReleaseReal64Array
                 *      MLReleaseReal64List
                 *      MLReleaseString
                 *      MLReleaseSymbol
                 *      MLReleaseUCS2String
                 *      MLReleaseUCS2Symbol
                 *      MLReleaseUTF16String
                 *      MLReleaseUTF16Symbol
                 *      MLReleaseUTF32String
                 *      MLReleaseUTF32Symbol
                 *      MLReleaseUTF8String
                 *      MLReleaseUTF8Symbol
                 *      MLSetEncodingParameter
                 *      MLSetEnvIDString
                 *      MLSetEnvironmentData
                 *      MLSetSignalHandler
                 *      MLSetSignalHandlerFromFunction
                 *      MLSetSymbolReplacement
                 *      MLTestHead
                 *      MLUnsetSignalHandler
                 *      MLVersionNumbers
                 *      
                 *      Interface 3 removes all the special MathLink types such as kcharp_ct, long_st, etc.
                 *      The API functions now all take standard C data types.
                 */

       		/*
                 * Interface 2 adds the following exported functions:
                 *      MLGetBinaryNumberArray0
                 *      MLTransfer0
                 *      MLNextCharacter0
                 * And, for WINDOWS_MATHLINK, some constants in "mlntypes.h"
                 * were changed in a way that causes MLGetRawType to return
                 * different values.
                 *
                 */
#else
#       if MLINTERFACE == 1
#               define MLAPIREVISION MLAPI1REVISION
#       elif MLINTERFACE == 2
#               define MLAPIREVISION MLAPI2REVISION
#	elif MLINTERFACE == 3
#		define MLAPIREVISION MLAPI3REVISION
#       else
/* syntax error */
#       endif
#endif


/* It may be possible for an implementation of one MathLink interface to
 * fully support an earlier interface.  MLNewParameters() may succeed when
 * passed an interface number less than the value of MLAPIREVISION when the
 * library was built.  This would happen, if the newer interface is a proper
 * superset of the older interface, or if the implementation can adjust its
 * behavior at runtime to conform to the older requested interface.
 */

#ifndef MLOLDDEFINITION
#       if WINDOWS_MATHLINK
#               if MLINTERFACE == 1
#                       define MLOLDDEFINITION MLAPI1REVISION
#               elif MLINTERFACE == 2
#                       define MLOLDDEFINITION MLAPI2REVISION
#		elif MLINTERFACE == 3
#			define MLOLDDEFINITION MLAPI2REVISION
#               else
/* syntax error */
#               endif
#       else
#               define MLOLDDEFINITION MLAPI1REVISION
#       endif
#endif




#else
/* syntax error */
#endif

#endif /* _MLVERS_H */

#ifndef ML_EXTERN_C

#if defined(__cplusplus)
#	define ML_C "C"
#	define ML_EXTERN_C extern "C" {
#	define ML_END_EXTERN_C }
#else
#	define ML_C
#	define ML_EXTERN_C
#	define ML_END_EXTERN_C
#endif

#endif



#if WINDOWS_MATHLINK && (MPREP_REVISION || !defined(APIENTRY) || !defined(FAR))

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
#ifndef _MLFAR_H
#define _MLFAR_H

#ifndef FAR

#if WINDOWS_MATHLINK
#	ifndef FAR
/* syntax error */
#	endif
#else
#	define FAR
#endif


#endif

/* //rename this file mlfarhuge.h */

#ifndef MLHUGE
#  if WINDOWS_MATHLINK && !(WIN32_MATHLINK || WIN64_MATHLINK)
#    define MLHUGE huge
#  else
#    define MLHUGE
#  endif
#endif

#endif /* _MLFAR_H */

#ifndef _MLTYPES_H
#define _MLTYPES_H


#ifndef _MLBASICTYPES_H
#define _MLBASICTYPES_H



#ifndef _MLINT64_H
#define _MLINT64_H


#if WIN64_MATHLINK || X86_64_SOLARIS_MATHLINK || IA64_LINUX_MATHLINK || X86_64_LINUX_MATHLINK || A64_AIX_MATHLINK || M64_IRIX_MATHLINK || LP64_HPUX_MATHLINK || PPC64_DARWIN_MATHLINK || X86_64_DARWIN_MATHLINK || DIGITAL_MATHLINK || U64_SOLARIS_MATHLINK
#define ML64BIT_MATHLINK 1
#endif

#endif /* MLINT64_H */


#define ML_SMALLEST_SIGNED_64BIT        -9223372036854775807L - 1
#define ML_LARGEST_SIGNED_64BIT         9223372036854775807L
#define ML_LARGEST_UNSIGNED_64BIT       18446744073709551615UL

#if WIN64_MATHLINK


typedef __int64 mlint64;
typedef unsigned __int64 mluint64;

#elif X86_64_SOLARIS_MATHLINK || IA64_LINUX_MATHLINK || X86_64_LINUX_MATHLINK || A64_AIX_MATHLINK || M64_IRIX_MATHLINK || LP64_HPUX_MATHLINK || PPC64_DARWIN_MATHLINK || X86_64_DARWIN_MATHLINK || DIGITAL_MATHLINK || U64_SOLARIS_MATHLINK


typedef long mlint64;
typedef unsigned long mluint64;

#else /* All other 32 bit platforms */


#ifndef NO_INT64_STRUCT
#define NO_INT64_STRUCT
#if LITTLEENDIAN_NUMERIC_TYPES
typedef struct _wint{
	unsigned long low, hi;
} wint64;
#else
typedef struct _wint{
	unsigned long hi, low;
} wint64;
#endif /* LITTLEENDIAN_NUMERIC_TYPES */

typedef wint64 mlint64;
typedef wint64 mluint64;

#endif /* NO_INT64_STRUCT */

#endif


#endif /* _MLBASICTYPES_H */


#if WINDOWS_MATHLINK
#	ifndef	APIENTRY
#		define APIENTRY far pascal
#	endif
#	ifndef CALLBACK
#		define CALLBACK APIENTRY
#	endif
#	if (WIN32_MATHLINK || WIN64_MATHLINK)
 /* try this #define MLEXPORT __declspec(dllexport) */
#		define MLEXPORT
#	else
#		define MLEXPORT __export
#	endif
#	define MLCB APIENTRY MLEXPORT
#	define MLAPI APIENTRY

#else
#	define MLCB
#	define MLAPI
#	define MLEXPORT
#endif

#define MLAPI_ MLAPI


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
#	define ML_DECL( rtype, name, params) extern ML_C rtype MLAPI_ name P(params)
#endif



#ifndef MLCBPROC
#	define MLCBPROC( rtype, name, params) typedef rtype (MLCB * name) P(params)
#endif
#ifndef MLCBDECL
#	define MLCBDECL( rtype, name, params) extern rtype MLCB name P(params)
#endif
#ifndef MLCBDEFN
#	define MLCBDEFN( rtype, name, params) extern rtype MLCB name params
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
#if MLINTERFACE >= 3
typedef __uint_ct__    FAR * uintp_ct;
typedef uintp_ct       FAR * uintpp_ct;
#endif
typedef __int_ct__           int_ct;
typedef void           FAR * voidp_ct;
typedef voidp_ct       FAR * voidpp_ct;
typedef char           FAR * charp_ct;
typedef charp_ct       FAR * charpp_ct;
typedef charpp_ct      FAR * charppp_ct;
typedef long                 long_ct;
typedef long_ct        FAR * longp_ct;
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
typedef MLCONST unsigned int FAR * kuintp_ct;
typedef MLCONST unsigned int FAR * FAR * kuintpp_ct;
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

typedef long  long_st;
typedef longp_ct longp_st;
typedef longp_st* longpp_st;

typedef long long_et;


#ifndef __mlapi_result__
#define __mlapi_result__ int_ct
#endif
typedef __mlapi_result__ mlapi_result;


#define MLSUCCESS (1) /*bugcheck:  this stuff doesnt belong where it can be seen at MLAPI_ layer */
#define MLFAILURE (0)

ML_EXTERN_C

#if WINDOWS_MATHLINK
typedef int (CALLBACK *__MLProcPtr__)();
#else
typedef long (* __MLProcPtr__)(void);
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

/* #include "mlcfm.h" */


ML_EXTERN_C



typedef void FAR * dev_voidp;
typedef dev_voidp dev_type;
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


typedef struct read_buf {
	unsigned short length;
	unsigned char* ptr;
} read_buf;

typedef read_buf FAR * read_bufp;
typedef read_bufp FAR * read_bufpp;

MLDMPROC( devproc_error, MLDeviceProcPtr, ( dev_type dev, devproc_selector selector, dev_voidp p1, dev_voidp p2));
MLDMDECL( devproc_error, MLDeviceMain, ( dev_type dev, devproc_selector selector, dev_voidp p1, dev_voidp p2));

typedef MLDeviceProcPtr MLDeviceUPP;
#define CallMLDeviceProc(userRoutine, thing, selector, p1, p2) (*(userRoutine))((thing), (selector), (dev_voidp)(p1), (dev_voidp)(p2))
#define NewMLDeviceProc(userRoutine) (userRoutine)

typedef MLDeviceUPP dev_main_type;
typedef dev_main_type FAR * dev_main_typep;

ML_END_EXTERN_C


#endif /* _MLDEVICE_H */


#ifndef _MLAPI_H
#define _MLAPI_H


ML_EXTERN_C

#ifndef _MLALLOC_H
#define _MLALLOC_H

/* #include "mlcfm.h" */

#if MLINTERFACE >= 3
#if WIN64_MATHLINK
MLAPROC( void*, MLAllocatorProcPtr, (unsigned __int64));
#else
MLAPROC( void*, MLAllocatorProcPtr, (unsigned long));
#endif


#else

#if WIN64_MATHLINK
MLAPROC( MLPointer, MLAllocatorProcPtr, (unsigned __int64));
#else
MLAPROC( MLPointer, MLAllocatorProcPtr, (unsigned long));
#endif

#endif /* MLINTERFACE >= 3 */

typedef MLAllocatorProcPtr MLAllocatorUPP;
#define CallMLAllocatorProc(userRoutine, size) (*(userRoutine))((size))
#define NewMLAllocatorProc(userRoutine) (userRoutine)




#if MLINTERFACE >= 3
MLFPROC( void, MLDeallocatorProcPtr, (void*));
#else
MLFPROC( void, MLDeallocatorProcPtr, (MLPointer));
#endif /* MLINTERFACE >= 3 */

typedef MLDeallocatorProcPtr MLDeallocatorUPP;
#define CallMLDeallocatorProc(userRoutine, p) (*(userRoutine))((p))
#define NewMLDeallocatorProc(userRoutine) (userRoutine)



#endif /* _MLALLOC_H */


/* explicitly not protected by _MLALLOC_H in case MLDECL is redefined for multiple inclusion */


/* just some type-safe casts */
MLDECL( __MLProcPtr__, MLAllocatorCast,   ( MLAllocatorProcPtr f));
MLDECL( __MLProcPtr__, MLDeallocatorCast, ( MLDeallocatorProcPtr f));

ML_END_EXTERN_C

typedef MLAllocatorUPP MLAllocator;
typedef MLAllocator FAR * MLAllocatorp;
#define MLCallAllocator CallMLAllocatorProc
#define MLNewAllocator NewMLAllocatorProc

typedef MLDeallocatorUPP MLDeallocator;
typedef MLDeallocator FAR * MLDeallocatorp;
#define MLCallDeallocator CallMLDeallocatorProc
#define MLNewDeallocator NewMLDeallocatorProc

#define MLallocator MLAllocator
#define MLdeallocator MLDeallocator

#endif /* _MLAPI_H */


#ifndef _MLNTYPES_H
#define _MLNTYPES_H


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
/* 160 -> ((unsigned char)'\240') */
#define	MLTK_8BIT_SIGNED_2sCOMPLEMENT_INTEGER                 160
/* Range[0, 255] */
/* 161 -> ((unsigned char)'\241') */
#define	MLTK_8BIT_UNSIGNED_2sCOMPLEMENT_INTEGER               161
#define MLTK_8BIT_UNSIGNED_INTEGER MLTK_8BIT_UNSIGNED_2sCOMPLEMENT_INTEGER

/* Range[-32768, 32767] */
/* 162 -> ((unsigned char)'\242') */
#define	MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER      162
/* Range[0, 65535] */
/* 163 -> ((unsigned char)'\243') */
#define	MLTK_16BIT_UNSIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER    163
#define	MLTK_16BIT_UNSIGNED_BIGENDIAN_INTEGER MLTK_16BIT_UNSIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
/* Range[-2147483648, 2147483647] */
/* 164 -> ((unsigned char)'\244') */
#define	MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER      164
/* Range[0, 4294967295] */
/* 165 -> ((unsigned char)'\245') */
#define	MLTK_32BIT_UNSIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER    165
#define	MLTK_32BIT_UNSIGNED_BIGENDIAN_INTEGER MLTK_32BIT_UNSIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
/* Range[-9223372036854775808, 9223372036854775807] */
/* 166 -> ((unsigned char)'\246') */
#define	MLTK_64BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER      166
/* Range[0, 18446744073709551615] */
/* 167 -> ((unsigned char)'\247') */
#define	MLTK_64BIT_UNSIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER    167
#define	MLTK_64BIT_UNSIGNED_BIGENDIAN_INTEGER MLTK_64BIT_UNSIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER


/* Range[-32768, 32767] */
/* 226 -> ((unsigned char)'\342') */
#define	MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER   226
/* Range[0, 65535] */
/* 227 -> ((unsigned char)'\343') */
#define	MLTK_16BIT_UNSIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER 227
#define	MLTK_16BIT_UNSIGNED_LITTLEENDIAN_INTEGER MLTK_16BIT_UNSIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
/* Range[-2147483648, 2147483647] */
/* 228 -> ((unsigned char)'\344') */
#define	MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER   228
/* Range[0, 4294967295] */
/* 229 -> ((unsigned char)'\345') */
#define	MLTK_32BIT_UNSIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER 229
#define	MLTK_32BIT_UNSIGNED_LITTLEENDIAN_INTEGER MLTK_32BIT_UNSIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
/* Range[-9223372036854775808, 9223372036854775807] */
/* 230 -> ((unsigned char)'\346') */
#define	MLTK_64BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER   230
/* Range[0, 18446744073709551615] */
/* 231 -> ((unsigned char)'\347') */
#define	MLTK_64BIT_UNSIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER 231
#define	MLTK_64BIT_UNSIGNED_LITTLEENDIAN_INTEGER MLTK_64BIT_UNSIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER

/* Interval[{-3.402823e+38, 3.402823e+38}] */
/* 180 -> ((unsigned char)'\264')    10110100   */
#define	MLTK_BIGENDIAN_IEEE754_SINGLE	                      180
/* Interval[{-1.79769313486232e+308, 1.79769313486232e+308}] */
/* 182 -> ((unsigned char)'\266')    10110110   */
#define	MLTK_BIGENDIAN_IEEE754_DOUBLE	                      182

/* 184 -> ((unsigned char)'\270')    10111000   */
#define MLTK_BIGENDIAN_128BIT_DOUBLE                          184

/* Interval[{-3.402823e+38, 3.402823e+38}] */
/* 244 -> ((unsigned char)'\364')    11110100   */
#define	MLTK_LITTLEENDIAN_IEEE754_SINGLE	                  244
/* Interval[{-1.79769313486232e+308, 1.79769313486232e+308}] */
/* 246 -> ((unsigned char)'\366')    11110110   */
#define	MLTK_LITTLEENDIAN_IEEE754_DOUBLE	                  246

/* 248 -> ((unsigned char)'\370')    11111000   */
#define MLTK_LITTLEENDIAN_128BIT_DOUBLE                       248


/* Note, if the future brings...
 * #define MLTK_128BIT_UNSIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER   ((unsigned char)'\257')
 * with  Range[0, 340282366920938463463374607431768211456 (*approximately 3.40282e+38*)]
 * the dynamic range is still a monotonically increasing function of the token value.
 * An implementation might choose to set the high varient bit to mainain this property
 * and dispatch more efficiently by avoiding overflow checks
 */

#if USE_MLNE__SELECTOR_FUNCTION
int MLNE__SELECTOR(int dtok, int stok);
#else
#define MLNE__SELECTOR( dtok, stok) \
	(((dtok) << 8) | (stok)) /* maybe should mask of high word and cast stok */
#endif
#define MLNE__SIZESELECTOR( tok) MLNE__SELECTOR( 0, tok) 
#define MLNE__INITSELECTOR (0)
#define MLNE__TOSTRINGSELECTOR( tok) MLNE__SELECTOR( MLNE__IS_REAL(tok) ? MLTKREAL : MLTKINT, tok)
#define MLNE__FROMSTRINGSELECTOR( dtok, stok) MLNE__SELECTOR( dtok, stok) 

#define MLNE__STOK( selector) ( (selector) & 0x000000FF)
#define MLNE__DTOK( selector) ( ((selector) & 0x0000FF00)>>8)

#define MLNE__IS_BINARY( tok) ((tok) & BINARY_MASK)
#define MLNE__IS_REAL( tok) ((tok) & REAL_MASK)
#define MLNE__TEXT_TOKEN( tok) (MLNE__IS_REAL( tok) ? MLTKREAL : MLTKINT)




ML_END_EXTERN_C


#endif /* _MLNUMENV_H */

#ifndef MLINTERFACE
/* syntax error */
#endif

/* MLTK_CSHORT_P         193 
   MLTK_CINT_P           194 
   MLTK_CLONG_P          195 
   MLTK_CFLOAT_P         209
   MLTK_CDOUBLE_P        210
   MLTK_CLONGDOUBLE_P    211 */
 
#define MLTK_CSHORT_P       (( BINARY_MASK | SIZEVARIANT_MASK | 1))              
#define MLTK_CINT_P         (( BINARY_MASK | SIZEVARIANT_MASK | 2))              
#define MLTK_CLONG_P        (( BINARY_MASK | SIZEVARIANT_MASK | 3))              
#define MLTK_CFLOAT_P       (( BINARY_MASK | SIZEVARIANT_MASK | REAL_MASK | 1))  
#define MLTK_CDOUBLE_P      (( BINARY_MASK | SIZEVARIANT_MASK | REAL_MASK | 2))  
#define MLTK_CLONGDOUBLE_P  (( BINARY_MASK | SIZEVARIANT_MASK | REAL_MASK | 3))


#define MLTK_CUCHAR  MLTK_8BIT_UNSIGNED_INTEGER
#define MLTK_MLUCHAR MLTK_8BIT_UNSIGNED_INTEGER

#if UNIX_MATHLINK /* hueristic that works for now */
	typedef unsigned int _uint32_nt;
	typedef signed int _sint32_nt;
#else
	typedef unsigned long _uint32_nt;
	typedef signed long _sint32_nt;
#endif

#define MLTK_64BIT_LITTLEENDIAN_STRUCTURE 196
#define MLTK_64BIT_BIGENDIAN_STRUCTURE    197

#if LITTLEENDIAN_NUMERIC_TYPES
#	if ML64BIT_MATHLINK
#		define MLTK_CINT64  MLTK_64BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_MLINT64 MLTK_64BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	else
#		define MLTK_CINT64  MLTK_64BIT_LITTLEENDIAN_STRUCTURE
#		define MLTK_MLINT64 MLTK_64BIT_LITTLEENDIAN_STRUCTURE
#	endif
/*	struct _int64_nt {  _uint32_nt lo; _sint32_nt hi;}; */
#else
#	if ML64BIT_MATHLINK
#		define MLTK_CINT64  MLTK_64BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLINT64 MLTK_64BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#	else
#		define MLTK_CINT64  MLTK_64BIT_BIGENDIAN_STRUCTURE
#		define MLTK_MLINT64 MLTK_64BIT_BIGENDIAN_STRUCTURE
#	endif
/*	struct _int64_nt { _sint32_nt hi; _uint32_nt lo;}; */
#endif


#if WINDOWS_MATHLINK
	/* one private token */
	/* Interval[{-1.189731495357231765e+4932, 1.189731495357231765e+4932}] */
#	define MLTK_INTEL_80BIT_EXTENDED  216 /* ((unsigned char)'\330') */
#	if MLINTERFACE > 1
#		define NEW_WIN32_NUMENV 1
#	endif
#endif





/* #	define MATHLINK_NUMERICS_ENVIRONMENT_ID "Sep 16 1996, 23:14:20" M68KMACINTOSH_MATHLINK */
/* #	define MATHLINK_NUMERICS_ENVIRONMENT_ID "newdog" POWERMACINTOSH_MATHLINK */

#if SUN_MATHLINK


#	if __sparc || __sparc__ || sparc

#		include <sys/types.h>
#               define MATHLINK_NUMERICS_ENVIRONMENT_ID "mastiff"

#		define MLTK_CSHORT       MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CINT         MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER

#		if defined(_ILP32)
#           define MLTK_CLONG         MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		elif defined(_LP64)
#			define MLTK_CLONG         MLTK_64BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		endif

#		define MLTK_CFLOAT       MLTK_BIGENDIAN_IEEE754_SINGLE
#		define MLTK_CDOUBLE      MLTK_BIGENDIAN_IEEE754_DOUBLE
#		ifndef MLTK_CLONGDOUBLE
#			if __SUNPRO_C >= 0x301
				/* one private token */ /* 158 -> ((unsigned char)'\236') */
#				define MLTK_128BIT_EXTENDED  158 
#				define MLTK_128BIT_LONGDOUBLE  MLTK_128BIT_EXTENDED
#				define MLTK_CLONGDOUBLE  MLTK_128BIT_EXTENDED
#			elif defined(__GNUC__) || defined(__GNUG__)
#				define MLTK_CLONGDOUBLE  MLTK_CDOUBLE
#			else
				/* no error directive here as the user may be
				 * using a different compiler.  Some macros
				 * simply won't be available.
				 */
#			endif
#		endif

#		define MLTK_MLSHORT       MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLINT         MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER

#		if defined(_ILP32)
#           define MLTK_MLLONG         MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		elif defined(_LP64)
#			define MLTK_MLLONG         MLTK_64BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		endif

#		define MLTK_MLFLOAT       MLTK_BIGENDIAN_IEEE754_SINGLE
#		define MLTK_MLDOUBLE      MLTK_BIGENDIAN_IEEE754_DOUBLE
#		define MLTK_MLLONGDOUBLE  MLTK_128BIT_EXTENDED

#	elif __i386 || __i386__ || i386

#		if __SUNPRO_C >= 0x301
			/* one private token */
			/* Interval[{-1.189731495357231765e+4932, 1.189731495357231765e+4932}] */
			/* 218 -> ((unsigned char)'\332') */
#			define MLTK_96BIT_HIGHPADDED_INTEL_80BIT_EXTENDED 218 

#			ifdef MATHLINK_NUMERICS_ENVIRONMENT_ID
#				undef MATHLINK_NUMERICS_ENVIRONMENT_ID
#			endif
#			define MATHLINK_NUMERICS_ENVIRONMENT_ID "norwegianelkhound"

#			define MLTK_CSHORT       MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#			define MLTK_CINT         MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#			define MLTK_CLONG        MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#			define MLTK_CFLOAT       MLTK_LITTLEENDIAN_IEEE754_SINGLE
#			define MLTK_CDOUBLE      MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#			define MLTK_CLONGDOUBLE  MLTK_96BIT_HIGHPADDED_INTEL_80BIT_EXTENDED

#			define MLTK_MLSHORT		 MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#			define MLTK_MLINT		 MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#			define MLTK_MLLONG		 MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#			define MLTK_MLFLOAT		 MLTK_LITTLEENDIAN_IEEE754_SINGLE
#			define MLTK_MLDOUBLE	 MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#			define MLTK_MLLONGDOUBLE	MLTK_96BIT_HIGHPADDED_INTEL_80BIT_EXTENDED

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

#	elif __x86_64 || __x86_64__ || x86_64
#		define MATHLINK_NUMERICS_ENVIRONMENT_ID "norwichterrior"

		/* one private token */
		/* Interval[{-1.189731495357231765e+4932, 1.189731495357231765e+4932}] */
		/* 218 -> ((unsigned char)'\332') */
#		define MLTK_96BIT_HIGHPADDED_INTEL_80BIT_EXTENDED 218

#		define MLTK_CSHORT		MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_CINT		MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_CLONG		MLTK_64BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_CFLOAT		MLTK_LITTLEENDIAN_IEEE754_SINGLE
#		define MLTK_CDOUBLE		MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#		ifndef MLTK_CLONGDOUBLE
#			define MLTK_CLONGDOUBLE		MLTK_LITTLEENDIAN_128BIT_DOUBLE
#		endif

#		define MLTK_MLSHORT		MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_MLINT		MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_MLLONG		MLTK_64BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_MLFLOAT		MLTK_LITTLEENDIAN_IEEE754_SINGLE
#		define MLTK_MLDOUBLE		MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#		define MLTK_MLLONGDOUBLE	MLTK_LITTLEENDIAN_128BIT_DOUBLE


#	elif __SVR4 || __svr4__

#		if defined(_ILP32)
#			include <sys/types.h>
#               	define MATHLINK_NUMERICS_ENVIRONMENT_ID "saintbernard"

#               	define MLTK_CSHORT        MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#               	define MLTK_CINT          MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#               	define MLTK_CLONG         MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#               	define MLTK_CFLOAT        MLTK_BIGENDIAN_IEEE754_SINGLE
#               	define MLTK_CDOUBLE       MLTK_BIGENDIAN_IEEE754_DOUBLE
#               	ifndef MLTK_CLONGDOUBLE
				/* 158 -> ((unsigned char)'\236') */
#                       	define MLTK_128BIT_EXTENDED  158 
#				if __SUNPRO_C >= 0x301
					/* one private token */
#					define MLTK_128BIT_LONGDOUBLE  MLTK_128BIT_EXTENDED
#					define MLTK_CLONGDOUBLE  MLTK_128BIT_EXTENDED
#				elif defined(__GNUC__) || defined(__GNUG__)
#					define MLTK_CLONGDOUBLE  MLTK_128BIT_EXTENDED
#				else
					/* no error directive here as the user may be
					 * using a different compiler.  Some macros
					 * simply won't be available.
					 */
#				endif
#			endif

#			define MLTK_MLSHORT       MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#			define MLTK_MLINT         MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#			define MLTK_MLLONG        MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#			define MLTK_MLFLOAT       MLTK_BIGENDIAN_IEEE754_SINGLE
#			define MLTK_MLDOUBLE      MLTK_BIGENDIAN_IEEE754_DOUBLE
#			define MLTK_MLLONGDOUBLE  MLTK_128BIT_EXTENDED

#		elif defined(_LP64)
#			include <sys/types.h>
#               	define MATHLINK_NUMERICS_ENVIRONMENT_ID "bernesemountaindog"

#               	define MLTK_CSHORT        MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#               	define MLTK_CINT          MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#               	define MLTK_CLONG         MLTK_64BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#               	define MLTK_CFLOAT        MLTK_BIGENDIAN_IEEE754_SINGLE
#               	define MLTK_CDOUBLE       MLTK_BIGENDIAN_IEEE754_DOUBLE
#               	ifndef MLTK_CLONGDOUBLE
				/* 158 -> ((unsigned char)'\236') */
#                       	define MLTK_128BIT_EXTENDED  158 
#				if __SUNPRO_C >= 0x301
					/* one private token */
#					define MLTK_128BIT_LONGDOUBLE  MLTK_128BIT_EXTENDED
#					define MLTK_CLONGDOUBLE  MLTK_128BIT_EXTENDED
#				elif defined(__GNUC__) || defined(__GNUG__)
#					define MLTK_CLONGDOUBLE  MLTK_128BIT_EXTENDED
#				else
					/* no error directive here as the user may be
					 * using a different compiler.  Some macros
					 * simply won't be available.
					 */
#				endif
#			endif

#			define MLTK_MLSHORT       MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#			define MLTK_MLINT         MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#			define MLTK_MLLONG        MLTK_64BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#			define MLTK_MLFLOAT       MLTK_BIGENDIAN_IEEE754_SINGLE
#			define MLTK_MLDOUBLE      MLTK_BIGENDIAN_IEEE754_DOUBLE
#			define MLTK_MLLONGDOUBLE  MLTK_128BIT_EXTENDED
#		else
			/* no error directive here as the user may be
			 * using a different compiler.  Some macros
			 * simply won't be available.
			 */
#		endif


#	else
/* syntax error */
#	endif


#elif WIN16_MATHLINK || ((WIN32_MATHLINK || WIN64_MATHLINK) && NEW_WIN32_NUMENV)
#	if MLINTERFACE < 3
#		if WIN16_MATHLINK
#			define MATHLINK_NUMERICS_ENVIRONMENT_ID "poodle"
#		elif WIN32_MATHLINK
#				define MATHLINK_NUMERICS_ENVIRONMENT_ID "setter"
#		elif WIN64_MATHLINK
#			define MATHLINK_NUMERICS_ENVIRONMENT_ID "bichon_frise"
#		endif

#		define MLTK_CSHORT       MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_CLONG        MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_CFLOAT       MLTK_LITTLEENDIAN_IEEE754_SINGLE
#		define MLTK_CDOUBLE      MLTK_LITTLEENDIAN_IEEE754_DOUBLE

#		if WIN16_MATHLINK
#			define MLTK_CINT         MLTK_CSHORT
#		elif (WIN32_MATHLINK || WIN64_MATHLINK)
#			define MLTK_CINT         MLTK_CLONG
#		endif

#		if __WATCOMC__ || __SC__
#			define MLTK_CLONGDOUBLE  MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#		elif __BORLANDC__ || __BCPLUSPLUS__ || __TURBOC__ || __TCPLUSPLUS__
#			define MLTK_CLONGDOUBLE  MLTK_INTEL_80BIT_EXTENDED
#		elif _MSC_VER
#			if WIN16_MATHLINK
#				define MLTK_CLONGDOUBLE  MLTK_INTEL_80BIT_EXTENDED
#			elif (WIN32_MATHLINK || WIN64_MATHLINK)
#				define MLTK_CLONGDOUBLE  MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#			endif
#		endif

#		define MLTK_MLSHORT         MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		if WIN16_MATHLINK
#			define MLTK_MLINT       MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		elif (WIN32_MATHLINK || WIN64_MATHLINK)
#			define MLTK_MLINT       MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		endif
#		define MLTK_MLLONG          MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_MLFLOAT         MLTK_LITTLEENDIAN_IEEE754_SINGLE
#		define MLTK_MLDOUBLE        MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#		if WIN64_MATHLINK
#			define MLTK_MLLONGDOUBLE   MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#		else
#			define MLTK_MLLONGDOUBLE    MLTK_INTEL_80BIT_EXTENDED
#		endif /* WIN64_MATHLINK */

#	else  /* MLINTERFACE >= 3 */

#		if WIN32_MATHLINK
#			define MATHLINK_NUMERICS_ENVIRONMENT_ID "french_bulldog"
#		elif WIN64_MATHLINK
#			define MATHLINK_NUMERICS_ENVIRONMENT_ID "bichon_frise"
#		endif

#		define MLTK_CSHORT       MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_CINT         MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_CLONG        MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_CFLOAT       MLTK_LITTLEENDIAN_IEEE754_SINGLE
#		define MLTK_CDOUBLE      MLTK_LITTLEENDIAN_IEEE754_DOUBLE

#		if __WATCOMC__ || __SC__
#			define MLTK_CLONGDOUBLE  MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#		elif __BORLANDC__ || __BCPLUSPLUS__ || __TURBOC__ || __TCPLUSPLUS__
#			define MLTK_CLONGDOUBLE  MLTK_INTEL_80BIT_EXTENDED
#		elif _MSC_VER
#			define MLTK_CLONGDOUBLE  MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#		endif

#		define MLTK_MLSHORT         MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_MLINT           MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_MLLONG          MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_MLFLOAT         MLTK_LITTLEENDIAN_IEEE754_SINGLE
#		define MLTK_MLDOUBLE        MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#		define MLTK_MLLONGDOUBLE    MLTK_LITTLEENDIAN_IEEE754_DOUBLE

#	endif /* MLINTERFACE < 3 */

#elif ALPHA_WIN32_MATHLINK
#	define MATHLINK_NUMERICS_ENVIRONMENT_ID "helen"

#	define MLTK_CSHORT       MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_CINT         MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_CLONG        MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_CFLOAT       MLTK_LITTLEENDIAN_IEEE754_SINGLE
#	define MLTK_CDOUBLE      MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#	define MLTK_CLONGDOUBLE  MLTK_LITTLEENDIAN_IEEE754_DOUBLE

#	define MLTK_MLSHORT       MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_MLINT         MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_MLLONG        MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_MLFLOAT       MLTK_LITTLEENDIAN_IEEE754_SINGLE
#	define MLTK_MLDOUBLE      MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#	define MLTK_MLLONGDOUBLE  MLTK_LITTLEENDIAN_IEEE754_DOUBLE

#elif DARWIN_MATHLINK
#	if PPC_DARWIN_MATHLINK
		/* We must use a different numerics env if we are built with gcc 3.3 or earlier. */
#		if GCC_MATHLINK_VERSION <= 30300
#			define MATHLINK_NUMERICS_ENVIRONMENT_ID "beagle"

#			define MLTK_CSHORT			MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#			define MLTK_CINT			MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#			define MLTK_CLONG			MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#			define MLTK_CFLOAT			MLTK_BIGENDIAN_IEEE754_SINGLE
#			define MLTK_CDOUBLE			MLTK_BIGENDIAN_IEEE754_DOUBLE
#			define MLTK_CLONGDOUBLE			MLTK_BIGENDIAN_IEEE754_DOUBLE

#			define MLTK_MLSHORT			MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#			define MLTK_MLINT			MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#			define MLTK_MLLONG			MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#			define MLTK_MLFLOAT			MLTK_BIGENDIAN_IEEE754_SINGLE
#			define MLTK_MLDOUBLE			MLTK_BIGENDIAN_IEEE754_DOUBLE
#			define MLTK_MLLONGDOUBLE		MLTK_BIGENDIAN_IEEE754_DOUBLE
#		else
#			define MATHLINK_NUMERICS_ENVIRONMENT_ID "bullterrier"
#			define MLTK_CSHORT			MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#			define MLTK_CINT			MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#			define MLTK_CLONG			MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#			define MLTK_CFLOAT			MLTK_BIGENDIAN_IEEE754_SINGLE
#			define MLTK_CDOUBLE			MLTK_BIGENDIAN_IEEE754_DOUBLE
#			define MLTK_CLONGDOUBLE			MLTK_BIGENDIAN_128BIT_DOUBLE

#			define MLTK_MLSHORT			MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#			define MLTK_MLINT			MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#			define MLTK_MLLONG			MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#			define MLTK_MLFLOAT			MLTK_BIGENDIAN_IEEE754_SINGLE
#			define MLTK_MLDOUBLE			MLTK_BIGENDIAN_IEEE754_DOUBLE
#			define MLTK_MLLONGDOUBLE		MLTK_BIGENDIAN_128BIT_DOUBLE

#		endif /* GCC_MATHLINK_VERSION > 30300 */

#	elif PPC64_DARWIN_MATHLINK
#		define MATHLINK_NUMERICS_ENVIRONMENT_ID "borderterrier"

#		define MLTK_CSHORT			MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CINT			MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CLONG			MLTK_64BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CFLOAT			MLTK_BIGENDIAN_IEEE754_SINGLE
#		define MLTK_CDOUBLE			MLTK_BIGENDIAN_IEEE754_DOUBLE
#		define MLTK_CLONGDOUBLE			MLTK_BIGENDIAN_128BIT_DOUBLE

#		define MLTK_MLSHORT			MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLINT			MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLLONG			MLTK_64BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLFLOAT			MLTK_BIGENDIAN_IEEE754_SINGLE
#		define MLTK_MLDOUBLE			MLTK_BIGENDIAN_IEEE754_DOUBLE
#		define MLTK_MLLONGDOUBLE		MLTK_BIGENDIAN_128BIT_DOUBLE

#	elif X86_DARWIN_MATHLINK
#		define MATHLINK_NUMERICS_ENVIRONMENT_ID "basenji"

		/* one private token */
		/* Interval[{-1.189731495357231765e+4932, 1.189731495357231765e+4932}] */
		/* 218 -> ((unsigned char)'\332') */
#		define MLTK_96BIT_HIGHPADDED_INTEL_80BIT_EXTENDED 218

#		define MLTK_CSHORT      MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_CINT        MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_CLONG       MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_CFLOAT      MLTK_LITTLEENDIAN_IEEE754_SINGLE
#		define MLTK_CDOUBLE     MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#		define MLTK_CLONGDOUBLE	MLTK_LITTLEENDIAN_128BIT_DOUBLE

#		define MLTK_MLSHORT       MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_MLINT         MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_MLLONG        MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_MLFLOAT       MLTK_LITTLEENDIAN_IEEE754_SINGLE
#		define MLTK_MLDOUBLE      MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#		define MLTK_MLLONGDOUBLE  MLTK_LITTLEENDIAN_128BIT_DOUBLE

#	elif X86_64_DARWIN_MATHLINK
#		define MATHLINK_NUMERICS_ENVIRONMENT_ID "greatdane"

#		define MLTK_CSHORT	MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_CINT	MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_CLONG	MLTK_64BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_CFLOAT	MLTK_LITTLEENDIAN_IEEE754_SINGLE
#		define MLTK_CDOUBLE	MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#		define MLTK_CLONGDOUBLE MLTK_LITTLEENDIAN_128BIT_DOUBLE

#		define MLTK_MLSHORT       MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_MLINT         MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_MLLONG        MLTK_64BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#		define MLTK_MLFLOAT       MLTK_LITTLEENDIAN_IEEE754_SINGLE
#		define MLTK_MLDOUBLE      MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#		define MLTK_MLLONGDOUBLE  MLTK_LITTLEENDIAN_128BIT_DOUBLE
#	endif

#elif I86_LINUX_MATHLINK
#	define MATHLINK_NUMERICS_ENVIRONMENT_ID "reddog"

	/* one private token */
	/* Interval[{-1.189731495357231765e+4932, 1.189731495357231765e+4932}] */
	/* 218 -> ((unsigned char)'\332') */
#	define MLTK_96BIT_HIGHPADDED_INTEL_80BIT_EXTENDED 218

#	define MLTK_CSHORT      MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_CINT        MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_CLONG       MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_CFLOAT      MLTK_LITTLEENDIAN_IEEE754_SINGLE
#	define MLTK_CDOUBLE     MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#	ifndef MLTK_CLONGDOUBLE
#		define MLTK_CLONGDOUBLE  MLTK_96BIT_HIGHPADDED_INTEL_80BIT_EXTENDED
#	endif

#	define MLTK_MLSHORT       MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_MLINT         MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_MLLONG        MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_MLFLOAT       MLTK_LITTLEENDIAN_IEEE754_SINGLE
#	define MLTK_MLDOUBLE      MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#	define MLTK_MLLONGDOUBLE  MLTK_96BIT_HIGHPADDED_INTEL_80BIT_EXTENDED

#elif IA64_LINUX_MATHLINK
#	define MATHLINK_NUMERICS_ENVIRONMENT_ID "australiancattledog"

	/* one private token */
	/* Interval[{-1.189731495357231765e+4932, 1.189731495357231765e+4932}] */
	/* 218 -> ((unsigned char)'\332') */
#	define MLTK_96BIT_HIGHPADDED_INTEL_80BIT_EXTENDED 218

#	define MLTK_CSHORT      MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_CINT        MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_CLONG       MLTK_64BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_CFLOAT      MLTK_LITTLEENDIAN_IEEE754_SINGLE
#	define MLTK_CDOUBLE     MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#	ifndef MLTK_CLONGDOUBLE
#		define MLTK_CLONGDOUBLE  MLTK_LITTLEENDIAN_128BIT_DOUBLE
#	endif

#	define MLTK_MLSHORT       MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_MLINT         MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_MLLONG        MLTK_64BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_MLFLOAT       MLTK_LITTLEENDIAN_IEEE754_SINGLE
#	define MLTK_MLDOUBLE      MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#	define MLTK_MLLONGDOUBLE  MLTK_LITTLEENDIAN_128BIT_DOUBLE

#elif X86_64_LINUX_MATHLINK
#	define MATHLINK_NUMERICS_ENVIRONMENT_ID "boxer"

	/* one private token */
	/* Interval[{-1.189731495357231765e+4932, 1.189731495357231765e+4932}] */
	/* 218 -> ((unsigned char)'\332') */
#	define MLTK_96BIT_HIGHPADDED_INTEL_80BIT_EXTENDED 218

#	define MLTK_CSHORT		MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_CINT		MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_CLONG		MLTK_64BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_CFLOAT		MLTK_LITTLEENDIAN_IEEE754_SINGLE
#	define MLTK_CDOUBLE		MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#	ifndef MLTK_CLONGDOUBLE
#		define MLTK_CLONGDOUBLE		MLTK_LITTLEENDIAN_128BIT_DOUBLE
#	endif

#	define MLTK_MLSHORT		MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_MLINT		MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_MLLONG		MLTK_64BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_MLFLOAT		MLTK_LITTLEENDIAN_IEEE754_SINGLE
#	define MLTK_MLDOUBLE		MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#	define MLTK_MLLONGDOUBLE	MLTK_LITTLEENDIAN_128BIT_DOUBLE

#elif AXP_LINUX_MATHLINK
#       define MATHLINK_NUMERICS_ENVIRONMENT_ID "akitainu"

#       define MLTK_CSHORT         MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#       define MLTK_CINT           MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#       define MLTK_CLONG          MLTK_64BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#       define MLTK_CFLOAT         MLTK_LITTLEENDIAN_IEEE754_SINGLE
#       define MLTK_CDOUBLE        MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#       define MLTK_CLONGDOUBLE    MLTK_LITTLEENDIAN_IEEE754_DOUBLE

#       define MLTK_MLSHORT        MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#       define MLTK_MLINT          MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#       define MLTK_MLLONG         MLTK_64BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#       define MLTK_MLFLOAT        MLTK_LITTLEENDIAN_IEEE754_SINGLE
#       define MLTK_MLDOUBLE       MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#       define MLTK_MLLONGDOUBLE   MLTK_LITTLEENDIAN_IEEE754_DOUBLE

#elif ARM_LINUX_MATHLINK
#	define MATHLINK_NUMERICS_ENVIRONMENT_ID "chihuahua"

	/* one private token */
	/* Interval[{-1.189731495357231765e+4932, 1.189731495357231765e+4932}] */
	/* 218 -> ((unsigned char)'\332') */
#	define MLTK_96BIT_HIGHPADDED_INTEL_80BIT_EXTENDED 218

#	define MLTK_CSHORT     MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_CINT       MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_CLONG      MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_CFLOAT     MLTK_LITTLEENDIAN_IEEE754_SINGLE
#	define MLTK_CDOUBLE    MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#	ifndef MLTK_CLONGDOUBLE
#		define MLTK_CLONGDOUBLE  MLTK_96BIT_HIGHPADDED_INTEL_80BIT_EXTENDED
#	endif

#	define MLTK_MLSHORT       MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_MLINT         MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_MLLONG        MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_MLFLOAT       MLTK_LITTLEENDIAN_IEEE754_SINGLE
#	define MLTK_MLDOUBLE      MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#	define MLTK_MLLONGDOUBLE  MLTK_96BIT_HIGHPADDED_INTEL_80BIT_EXTENDED

#elif PPC_LINUX_MATHLINK
#       define MATHLINK_NUMERICS_ENVIRONMENT_ID "rottweiler"

#       define MLTK_CSHORT         MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#       define MLTK_CINT           MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#       define MLTK_CLONG          MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#       define MLTK_CFLOAT         MLTK_BIGENDIAN_IEEE754_SINGLE
#       define MLTK_CDOUBLE        MLTK_BIGENDIAN_IEEE754_DOUBLE
#       define MLTK_CLONGDOUBLE    MLTK_BIGENDIAN_IEEE754_DOUBLE

#       define MLTK_MLSHORT        MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#       define MLTK_MLINT          MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#       define MLTK_MLLONG         MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#       define MLTK_MLFLOAT        MLTK_BIGENDIAN_IEEE754_SINGLE
#       define MLTK_MLDOUBLE       MLTK_BIGENDIAN_IEEE754_DOUBLE
#       define MLTK_MLLONGDOUBLE   MLTK_BIGENDIAN_IEEE754_DOUBLE

#elif AIX_MATHLINK
#	if defined(__64BIT__)
#		if defined(MATHLINK_NUMERICS_ENVIRONMENT_ID)
#			undef MATHLINK_NUMERICS_ENVIRONMENT_ID
#		endif

#		ifdef __LONGDOUBLE128
#			define MATHLINK_NUMERICS_ENVIRONMENT_ID "pharaohhound"
#		else
#			define MATHLINK_NUMERICS_ENVIRONMENT_ID "trout"
#		endif

#		define MLTK_CSHORT     MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CINT       MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CLONG      MLTK_64BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CFLOAT     MLTK_BIGENDIAN_IEEE754_SINGLE
#		define MLTK_CDOUBLE    MLTK_BIGENDIAN_IEEE754_DOUBLE
#		ifndef MLTK_CLONGDOUBLE
#			ifdef __LONGDOUBLE128
#				define MLTK_CLONGDOUBLE  MLTK_BIGENDIAN_128BIT_DOUBLE
#			else
#				define MLTK_CLONGDOUBLE MLTK_BIGENDIAN_IEEE754_DOUBLE
#			endif
#		endif

#		define MLTK_MLSHORT       MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLINT         MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLLONG	      MLTK_64BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLFLOAT       MLTK_BIGENDIAN_IEEE754_SINGLE
#		define MLTK_MLDOUBLE      MLTK_BIGENDIAN_IEEE754_DOUBLE
#		ifndef MLTK_MLLONGDOUBLE
#			ifdef __LONGDOUBLE128
#				define MLTK_MLLONGDOUBLE MLTK_BIGENDIAN_128BIT_DOUBLE
#			else
#				define MLTK_MLLONGDOUBLE MLTK_BIGENDIAN_IEEE754_DOUBLE
#			endif
#		endif
#	else
#		if defined(MATHLINK_NUMERICS_ENVIRONMENT_ID)
#			undef MATHLINK_NUMERICS_ENVIRONMENT_ID
#		endif

#		ifdef __LONGDOUBLE128
#			define MATHLINK_NUMERICS_ENVIRONMENT_ID "pug"
#		else
#			define MATHLINK_NUMERICS_ENVIRONMENT_ID "pointer"
#		endif

#		define MLTK_CSHORT     MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CINT       MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CLONG      MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CFLOAT     MLTK_BIGENDIAN_IEEE754_SINGLE
#		define MLTK_CDOUBLE    MLTK_BIGENDIAN_IEEE754_DOUBLE
#		ifndef MLTK_CLONGDOUBLE
#			ifdef __LONGDOUBLE128
#				define MLTK_CLONGDOUBLE  MLTK_BIGENDIAN_128BIT_DOUBLE
#			else
#				define MLTK_CLONGDOUBLE MLTK_BIGENDIAN_IEEE754_DOUBLE
#			endif
#		endif

#		define MLTK_MLSHORT       MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLINT         MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLLONG        MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLFLOAT       MLTK_BIGENDIAN_IEEE754_SINGLE
#		define MLTK_MLDOUBLE      MLTK_BIGENDIAN_IEEE754_DOUBLE
#		ifndef MLTK_MLLONGDOUBLE
#			ifdef __LONGDOUBLE128
#				define MLTK_MLLONGDOUBLE MLTK_BIGENDIAN_128BIT_DOUBLE
#			else
#				define MLTK_MLLONGDOUBLE MLTK_BIGENDIAN_IEEE754_DOUBLE
#			endif
#		endif

#	endif /* __64BIT__ */
#elif HPUX_MATHLINK
#	if defined(__LP64__)
#		define MATHLINK_NUMERICS_ENVIRONMENT_ID "samoyed"

		/* private tokens, for data type long long */
		/* 134 -> ((unsigned char)'\206') */
#		define MLTK_64BIT_LONGLONG    134
		/* 158 -> ((unsigned char)'\236') */ 
#		define MLTK_128BIT_LONGDOUBLE 158

#		define MLTK_CSHORT         MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CINT           MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CLONG          MLTK_64BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER

#		define MLTK_CFLOAT         MLTK_BIGENDIAN_IEEE754_SINGLE
#		define MLTK_CDOUBLE        MLTK_BIGENDIAN_IEEE754_DOUBLE
#		define MLTK_CLONGDOUBLE    MLTK_128BIT_LONGDOUBLE

#		define MLTK_MLSHORT        MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLINT          MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLLONG         MLTK_64BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER

#		define MLTK_MLFLOAT        MLTK_BIGENDIAN_IEEE754_SINGLE
#		define MLTK_MLDOUBLE       MLTK_BIGENDIAN_IEEE754_DOUBLE
#		define MLTK_MLLONGDOUBLE   MLTK_128BIT_LONGDOUBLE
#	else
#		define MATHLINK_NUMERICS_ENVIRONMENT_ID "siberianhusky"

		/* private tokens, for data type long long */
		/* 134 -> ((unsigned char)'\206') */
#		define MLTK_64BIT_LONGLONG    134
		/* 158 -> ((unsigned char)'\236') */ 
#		define MLTK_128BIT_LONGDOUBLE 158

#		define MLTK_CSHORT         MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CINT           MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CLONG          MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER

#		define MLTK_CFLOAT         MLTK_BIGENDIAN_IEEE754_SINGLE
#		define MLTK_CDOUBLE        MLTK_BIGENDIAN_IEEE754_DOUBLE
#		define MLTK_CLONGDOUBLE    MLTK_128BIT_LONGDOUBLE

#		define MLTK_MLSHORT        MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLINT          MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLLONG         MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER

#		define MLTK_MLFLOAT        MLTK_BIGENDIAN_IEEE754_SINGLE
#		define MLTK_MLDOUBLE       MLTK_BIGENDIAN_IEEE754_DOUBLE
#		define MLTK_MLLONGDOUBLE   MLTK_128BIT_LONGDOUBLE

#	endif /* __LP64__ */
#elif DIGITAL_MATHLINK
#	define MATHLINK_NUMERICS_ENVIRONMENT_ID "shibainu"

	/* private tokens, .. */
	/* 158 -> ((unsigned char)'\236) */
#	define MLTK_128BIT_LONGDOUBLE          158

	/* 197 -> ((unsigned char)'\305) */
#	define MLTK_32BIT_WCHAR_T              197

	/* 198 -> ((unsigned char)'\306) */
#	define MLTK_64BIT_SIGNED_BARBARINT64   198

	/* 199 -> ((unsigned char)'\307) */
#	define MLTK_64BIT_UNSIGNED_BARBARINT64 199

#	define MLTK_CSHORT         MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_CINT           MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_CLONG          MLTK_64BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_CFLOAT         MLTK_LITTLEENDIAN_IEEE754_SINGLE
#	define MLTK_CDOUBLE        MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#	define MLTK_CLONGDOUBLE    MLTK_128BIT_LONGDOUBLE

#	define MLTK_MLSHORT        MLTK_16BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_MLINT          MLTK_32BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_MLLONG         MLTK_64BIT_SIGNED_2sCOMPLEMENT_LITTLEENDIAN_INTEGER
#	define MLTK_MLFLOAT        MLTK_LITTLEENDIAN_IEEE754_SINGLE
#	define MLTK_MLDOUBLE       MLTK_LITTLEENDIAN_IEEE754_DOUBLE
#	define MLTK_MLLONGDOUBLE   MLTK_128BIT_LONGDOUBLE

#elif IRIX_MATHLINK

	/* private tokens for long long and 128 long double */
	/* 134 -> ((unsigned char)'\206') */
#	define MLTK_64BIT_LONGLONG    134

	/* 158 -> ((unsigned char)'\236') */
#	define MLTK_128BIT_LONGDOUBLE 158

#	if N32_IRIX_MATHLINK
#		define MATHLINK_NUMERICS_ENVIRONMENT_ID "newfoundland"

#		define MLTK_CSHORT	   MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CINT	   MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CLONG	   MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CFLOAT	   MLTK_BIGENDIAN_IEEE754_SINGLE
#		define MLTK_CDOUBLE	   MLTK_BIGENDIAN_IEEE754_DOUBLE
#		define MLTK_CLONGDOUBLE	   MLTK_128BIT_LONGDOUBLE

#		define MLTK_MLSHORT	   MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLINT	   MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLLONG	   MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLFLOAT	   MLTK_BIGENDIAN_IEEE754_SINGLE
#		define MLTK_MLDOUBLE	   MLTK_BIGENDIAN_IEEE754_DOUBLE
#		define MLTK_MLLONGDOUBLE   MLTK_128BIT_LONGDOUBLE

#	elif M64_IRIX_MATHLINK
#		define MATHLINK_NUMERICS_ENVIRONMENT_ID "affenpinscher"

#		define MLTK_CSHORT	   MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CINT	   MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CLONG	   MLTK_64BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_CFLOAT	   MLTK_BIGENDIAN_IEEE754_SINGLE
#		define MLTK_CDOUBLE	   MLTK_BIGENDIAN_IEEE754_DOUBLE
#		define MLTK_CLONGDOUBLE	   MLTK_128BIT_LONGDOUBLE

#		define MLTK_MLSHORT	   MLTK_16BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLINT	   MLTK_32BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLLONG	   MLTK_64BIT_SIGNED_2sCOMPLEMENT_BIGENDIAN_INTEGER
#		define MLTK_MLFLOAT	   MLTK_BIGENDIAN_IEEE754_SINGLE
#		define MLTK_MLDOUBLE	   MLTK_BIGENDIAN_IEEE754_DOUBLE
#		define MLTK_MLLONGDOUBLE   MLTK_128BIT_LONGDOUBLE

#	endif

#else

#	if WIN32_MATHLINK || WIN64_MATHLINK
#		define MATHLINK_NUMERICS_ENVIRONMENT_ID "Sep 13 1996, 13:46:34"
#	endif

#	define MLTK_CSHORT       MLTK_CSHORT_P
#	define MLTK_CINT         MLTK_CINT_P
#	define MLTK_CLONG        MLTK_CLONG_P
#	define MLTK_CFLOAT       MLTK_CFLOAT_P
#	define MLTK_CDOUBLE      MLTK_CDOUBLE_P
#	define MLTK_CLONGDOUBLE  MLTK_CLONGDOUBLE_P

#	define MLTK_MLSHORT       MLTK_CSHORT_P
#	define MLTK_MLINT         MLTK_CINT_P
#	define MLTK_MLLONG        MLTK_CLONG_P
#	define MLTK_MLFLOAT       MLTK_CFLOAT_P
#	define MLTK_MLDOUBLE      MLTK_CDOUBLE_P
#	define MLTK_MLLONGDOUBLE  MLTK_CLONGDOUBLE_P

#endif

/* Objects of these numeric types exist in MathLink only in the numerics
 * environment and, unfortunately, in the "stack frames" of the functions that
 * put atomic numbers like MLPutInteger.  These C types are used by client
 * programs solely for type-checked access to the BinaryNumber functions.
 */
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

typedef mlint64            int64_nt;
typedef int64_nt         * int64p_nt;
typedef int64p_nt        * int64pp_nt;

typedef float              float_nt;
typedef float_nt     FAR * floatp_nt;
typedef floatp_nt    FAR * floatpp_nt;

typedef double             double_nt;
typedef double_nt    FAR * doublep_nt;
typedef doublep_nt   FAR * doublepp_nt;

#ifndef CC_SUPPORTS_LONG_DOUBLE
#	if defined( __STDC__) || defined(__cplusplus) || ! UNIX_MATHLINK
#		define CC_SUPPORTS_LONG_DOUBLE 1
#	else
#		define CC_SUPPORTS_LONG_DOUBLE MLPROTOTYPES
#	endif
#endif

struct _i87extended_nt { unsigned short w[5];};

#if CC_SUPPORTS_LONG_DOUBLE
#	ifndef __extended_nt__
#		if WINDOWS_MATHLINK && (MLTK_CLONGDOUBLE != MLTK_MLLONGDOUBLE) /* subtle predicate that works for old and new windows numenvs */
#			define __extended_nt__ struct _i87extended_nt
#			define EXTENDED_NT_TO_I87_EXTENDED(a,b) a = b
#			define I87_EXTENDED_TO_EXTENDED_NT(a,b) a = b
#		else
#			define __extended_nt__ long double
#			define EXTENDED_NT_TO_I87_EXTENDED(a,b) \
				{ \
					int i; \
					unsigned short *c = (unsigned short *)&b; \
					for(i = 0; i < 5; i++) a.w[i] = 0; \
					for(i = 1; i < 5; i++) a.w[i] = *(c + i); \
				}
#			define I87_EXTENDED_TO_EXTENDED_NT(a,b) \
				{ \
					int i; \
					unsigned short *c = (unsigned short *)&a; \
					a = 0; \
					for(i = 1; i < 5; i++) *(c + i) = b.w[i]; \
				}
#		endif
#	endif

	typedef __extended_nt__    mlextended_double;

	typedef __extended_nt__    extended_nt;
	typedef extended_nt  FAR * extendedp_nt;
	typedef extendedp_nt FAR * extendedpp_nt;
#endif /* CC_SUPPORTS_LONG_DOUBLE */

#endif /* _MLNTYPES_H */

#ifndef _ML0TYPES_H
#define _ML0TYPES_H


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
#if CC_SUPPORTS_LONG_DOUBLE
typedef extended_nt ml_extended;
typedef extendedp_nt ml_extendedp;
typedef extendedpp_nt ml_extendedpp;
#endif
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


typedef void FAR * dev_world;
typedef MLINK dev_cookie;

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
#if UNIX_MATHLINK
#define MLSTDDEV_GET_SIGNAL_HANDLERS        29
#define MLSTDDEV_RELEASE_SIGNAL_HANDLERS    30
#endif


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
/* edit here and in mathlink.r */
#define NOMODE           ((dev_mode)0x0000)
#define LOOPBACKBIT      ((dev_mode)0x0001)
#define LISTENBIT        ((dev_mode)0x0002)
#define CONNECTBIT       ((dev_mode)0x0004)
#define LAUNCHBIT        ((dev_mode)0x0008)
#define PARENTCONNECTBIT ((dev_mode)0x0010)
#define READBIT          ((dev_mode)0x0020)
#define WRITEBIT         ((dev_mode)0x0040)
#define SERVERBIT        ((dev_mode)0x0080)
#define ANYMODE          (~(dev_mode)0)

typedef dev_mode FAR * dev_modep;





typedef unsigned long dev_options;

#define _DefaultOptions      ((dev_options)0x00000000)

#define _NetworkVisibleMask  ((dev_options)0x00000003)
#define _BrowseMask          ((dev_options)0x00000010)
#define _NonBlockingMask     ((dev_options)0x00000020)
#define _InteractMask        ((dev_options)0x00000100)
#define _YieldMask           ((dev_options)0x00000200)
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

#define _ForceYield          ((dev_options)0x00000200)


#if MLINTERFACE >= 3
/* DEVICE selector and WORLD selector masks */
#define INFO_MASK (1UL << 31)
#define INFO_TYPE_MASK ((1UL << 31) - 1UL)
#define INFO_SWITCH_MASK (1UL << 30)
#define MLDEVICE_MASK INFO_MASK
#define WORLD_MASK (INFO_MASK | (1UL << 30))
#endif

/* values returned by selector MLDEVICE_TYPE */
#define UNREGISTERED_TYPE  0
#define UNIXPIPE_TYPE      1
#define UNIXSOCKET_TYPE    2
#define PPC_TYPE           3
#define MACTCP_TYPE        4
#define LOOPBACK_TYPE      5
#define COMMTB_TYPE        6
#define ADSP_TYPE          7
#define LOCAL_TYPE         8
#define WINLOCAL_TYPE      9
#define WINFMAP_TYPE       10
#define WINSHM_TYPE        11
#define SOCKET2_TYPE       12
#define GENERIC_TYPE	   13  /* Internal use only, not valid for MLDeviceInformation */
#define UNIXSHM_TYPE       14

#if MLINTERFACE < 3
/* selectors */
#define MLDEVICE_TYPE 0                                       /* long */
#define MLDEVICE_NAME 1                                       /* char */
#define MLDEVICE_NAME_SIZE 2									/* long */
#define MLDEVICE_WORLD_ID 5                                   /* char */
#define SHM_FD                 (UNIXSHM_TYPE * 256 + 0)    /* int */
#define PIPE_FD                (UNIXPIPE_TYPE * 256 + 0)    /* int */
#define PIPE_CHILD_PID         (UNIXPIPE_TYPE * 256 + 1)    /* int */
#define SOCKET_FD              (UNIXSOCKET_TYPE * 256 + 0)  /* int */
#define SOCKET_PARTNER_ADDR    (UNIXSOCKET_TYPE * 256 + 1)  /* unsigned long */
#define SOCKET_PARTNER_PORT    (UNIXSOCKET_TYPE * 256 + 2)  /* unsigned short */
#define LOOPBACK_FD            (LOOPBACK_TYPE * 256 + 2)    /* int */
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

#define	WINDOWS_SET_NOTIFY_WINDOW     2330 /* HWND */
#define	WINDOWS_REMOVE_NOTIFY_WINDOW  2331 /* HWND */

/* info selectors */
#define WORLD_THISLOCATION 1        /* char */
#define WORLD_MODES 2               /* dev_mode */
#define WORLD_PROTONAME 3           /* char */
#define WORLD_STREAMCAPACITY 4      /* long */ /*this belongs in mlolddev.h*/
#define WORLD_ID MLDEVICE_WORLD_ID    /* char */
#else
/* selectors */
#define MLDEVICE_TYPE MLDEVICE_MASK + 0                                       /* long */
#define MLDEVICE_NAME MLDEVICE_MASK + 1                                       /* char */
#define MLDEVICE_NAME_SIZE MLDEVICE_MASK + 2                                  /* long */
#define MLDEVICE_WORLD_ID MLDEVICE_MASK + 5                                   /* char */
#define SHM_FD                 MLDEVICE_MASK + (UNIXSHM_TYPE * 256 + 0)     /* int */
#define PIPE_FD                MLDEVICE_MASK + (UNIXPIPE_TYPE * 256 + 0)    /* int */
#define PIPE_CHILD_PID         MLDEVICE_MASK + (UNIXPIPE_TYPE * 256 + 1)    /* int */
#define SOCKET_FD              MLDEVICE_MASK + (UNIXSOCKET_TYPE * 256 + 0)  /* int */
#define SOCKET_PARTNER_ADDR    MLDEVICE_MASK + (UNIXSOCKET_TYPE * 256 + 1)  /* unsigned long */
#define SOCKET_PARTNER_PORT    MLDEVICE_MASK + (UNIXSOCKET_TYPE * 256 + 2)  /* unsigned short */
#define LOOPBACK_FD            MLDEVICE_MASK + (LOOPBACK_TYPE * 256 + 0)    /* int */
#define PPC_SESS_REF_NUM       MLDEVICE_MASK + (PPC_TYPE * 256 + 0)         /* PPCSessRefNum */
#define PPC_PARTNER_PSN        MLDEVICE_MASK + (PPC_TYPE * 256 + 1)         /* ProcessSerialNumber */
#define PPC_PARTNER_LOCATION   MLDEVICE_MASK + (PPC_TYPE * 256 + 2)         /* LocationNameRec */
#define PPC_PARTNER_PORT       MLDEVICE_MASK + (PPC_TYPE * 256 + 3)         /* PPCPortRec */
#define MACTCP_STREAM          MLDEVICE_MASK + (MACTCP_TYPE * 256 + 0)      /* StreamPtr */
#define MACTCP_PARTNER_ADDR    MLDEVICE_MASK + (MACTCP_TYPE * 256 + 1)      /* ip_addr */
#define MACTCP_PARTNER_PORT    MLDEVICE_MASK + (MACTCP_TYPE * 256 + 2)      /* tcp_port */
#define MACTCP_IPDRIVER        MLDEVICE_MASK + (MACTCP_TYPE * 256 + 3)      /* short */
#define MACTCP_SETSIMPLESOCKET MLDEVICE_MASK + (MACTCP_TYPE * 256 + 9)      /* buf, buflen ignored */
#define COMMTB_CONNHANDLE      MLDEVICE_MASK + (COMMTB_TYPE * 256 + 0)      /* ConnHandle */
#define ADSP_CCBREFNUM         MLDEVICE_MASK + (ADSP_TYPE * 256 + 0)        /* short */
#define ADSP_IOCREFNUM         MLDEVICE_MASK + (ADSP_TYPE * 256 + 3)        /* short */

#define	WINDOWS_SET_NOTIFY_WINDOW     MLDEVICE_MASK + 2330 /* HWND */
#define	WINDOWS_REMOVE_NOTIFY_WINDOW  MLDEVICE_MASK + 2331 /* HWND */
#define WINDOWS_READY_CONDITION       MLDEVICE_MASK + 2332 /* HANDLE */

/* info selectors */
#define WORLD_THISLOCATION (1 + WORLD_MASK)        /* char */
#define WORLD_MODES (2 + WORLD_MASK)               /* dev_mode */
#define WORLD_PROTONAME (3 + WORLD_MASK)           /* char */
#define WORLD_STREAMCAPACITY (4 + WORLD_MASK)      /* long */ /*this belongs in mlolddev.h*/
#define WORLD_ID (5 + WORLD_MASK)    /* char */
#endif /* MLINTERFACE < 3 */


#ifndef MATHLINK_DEVICE_WORLD_ID
#define MATHLINK_DEVICE_WORLD_ID (__DATE__ ", " __TIME__)
#endif




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
#if MLINTERFACE >= 3
int   MLSetYieldParameter P(( MLYieldParameters yp, unsigned long selector, void* data, unsigned long* len));
int   MLYieldParameter P(( MLYieldParameters yp, unsigned long selector, void* data, unsigned long* len));
#else
mlapi_result   MLSetYieldParameter P(( MLYieldParameters yp, unsigned long selector, void* data, unsigned long* len));
mlapi_result   MLYieldParameter P(( MLYieldParameters yp, unsigned long selector, void* data, unsigned long* len));
#endif /* MLINTERFACE >= 3 */
devyield_sleep MLSetSleepYP P(( MLYieldParameters yp, devyield_sleep sleep));
devyield_count MLSetCountYP P(( MLYieldParameters yp, devyield_count count));


enum { MLSleepParameter = 1, MLCountParameter, MLPlaceParameter};





#if MLINTERFACE >= 3
MLYPROC( int, MLYielderProcPtr, (MLINK mlp, MLYieldParameters yp));
#else
MLYPROC( devyield_result, MLYielderProcPtr, (MLINK mlp, MLYieldParameters yp));
#endif /* MLINTERFACE >= 3 */
typedef	MLYielderProcPtr MLDeviceYielderProcPtr;

typedef MLYielderProcPtr MLYielderUPP, MLDeviceYielderUPP;
#define NewMLYielderProc(userRoutine) (userRoutine)

#define NewMLDeviceYielderProc NewMLYielderProc

typedef  MLYielderUPP MLYieldFunctionType;

#if MLINTERFACE >= 3
typedef MLYielderUPP MLYieldFunctionObject;
#else
typedef void* MLYieldFunctionObject; /* Made change to void* for 64 bit machines */
#endif

typedef  MLYieldFunctionObject dev_yielder;
typedef dev_yielder FAR* dev_yielderp;


typedef unsigned long dev_message;
typedef dev_message FAR * dev_messagep;


#if MLINTERFACE >= 3
MLMPROC( void, MLHandlerProcPtr, (MLINK mlp, int m, int n));
#else
MLMPROC( void, MLHandlerProcPtr, (MLINK mlp, dev_message m, dev_message n));
#endif /* MLINTERFACE >= 3 */
typedef MLHandlerProcPtr MLDeviceHandlerProcPtr;


typedef MLHandlerProcPtr MLHandlerUPP, MLDeviceHandlerUPP;
#define NewMLHandlerProc(userRoutine) (userRoutine)

#define NewMLDeviceHandlerProc NewMLHandlerProc

typedef  MLHandlerUPP MLMessageHandlerType;

#if 0
#if MLINTERFACE >= 3
typedef MLHandlerUPP MLMessageHandler;
#endif /* MLINTERFACE >= 3 */
#if WIN64_MATHLINK
typedef unsigned __int64 MLMessageHandlerObject;
#else
typedef unsigned long MLMessageHandlerObject;
#endif

#endif /* if 0 */


#if MLINTERFACE >= 3
typedef MLHandlerUPP MLMessageHandlerObject;
#else
#if WIN64_MATHLINK
typedef unsigned __int64 MLMessageHandlerObject;
#else
typedef unsigned long MLMessageHandlerObject;
#endif
#endif /* MLINTERFACE >= 3 */


typedef  MLMessageHandlerObject dev_msghandler;
typedef dev_msghandler FAR* dev_msghandlerp;



#endif /* _MLSTDDEV_H */

#ifndef MLINTERFACE
/* syntax error */
#endif


/* explicitly not protected by _MLSTDDEV_H in case MLDECL is redefined for multiple inclusion */

/*bugcheck //should the rest of YP stuff be exported? */
MLDECL( devyield_sleep,         MLSleepYP,               ( MLYieldParameters yp));
MLDECL( devyield_count,         MLCountYP,               ( MLYieldParameters yp));

#if MLINTERFACE >= 3
MLDECL( MLYieldFunctionObject,  MLCreateYieldFunction,   ( MLEnvironment ep, MLYieldFunctionType yf, void* reserved)); /* reserved must be 0 */
#else
MLDECL( MLYieldFunctionObject,  MLCreateYieldFunction,   ( MLEnvironment ep, MLYieldFunctionType yf, MLPointer reserved)); /* reserved must be 0 */
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE > 1
#if MLINTERFACE >= 3
MLDECL( MLYieldFunctionObject,  MLCreateYieldFunction0,   ( MLEnvironment ep, MLYieldFunctionType yf, void* reserved)); /* reserved must be 0 */
#else
MLDECL( MLYieldFunctionObject,  MLCreateYieldFunction0,   ( MLEnvironment ep, MLYieldFunctionType yf, MLPointer reserved)); /* reserved must be 0 */
#endif /* MLINTERFACE >= 3 */
#endif

MLDECL( MLYieldFunctionType,    MLDestroyYieldFunction,  ( MLYieldFunctionObject yfo));

#if MLINTERFACE >= 3
MLDECL( int,        MLCallYieldFunction,     ( MLYieldFunctionObject yfo, MLINK mlp, MLYieldParameters p));
#else
MLDECL( devyield_result,        MLCallYieldFunction,     ( MLYieldFunctionObject yfo, MLINK mlp, MLYieldParameters p));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
MLDECL( MLMessageHandlerObject, MLCreateMessageHandler,  ( MLEnvironment ep, MLMessageHandlerType mh, void* reserved)); /* reserved must be 0 */
#else
MLDECL( MLMessageHandlerObject, MLCreateMessageHandler,  ( MLEnvironment ep, MLMessageHandlerType mh, MLPointer reserved)); /* reserved must be 0 */
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE > 1
#if MLINTERFACE >= 3
MLDECL( MLMessageHandlerObject, MLCreateMessageHandler0,  ( MLEnvironment ep, MLMessageHandlerType mh, void* reserved)); /* reserved must be 0 */
#else
MLDECL( MLMessageHandlerObject, MLCreateMessageHandler0,  ( MLEnvironment ep, MLMessageHandlerType mh, MLPointer reserved)); /* reserved must be 0 */
#endif /* MLINTERFACE >= 3 */
#endif

MLDECL( MLMessageHandlerType,   MLDestroyMessageHandler, ( MLMessageHandlerObject mho));

#if MLINTERFACE >= 3
MLDECL( void,                   MLCallMessageHandler,    ( MLMessageHandlerObject mho, MLINK mlp, int m, int n));
#else
MLDECL( void,                   MLCallMessageHandler,    ( MLMessageHandlerObject mho, MLINK mlp, dev_message m, dev_message n));
#endif /* MLINTERFACE >= 3 */


/* just some type-safe casts */
MLDECL( __MLProcPtr__, MLYielderCast, ( MLYielderProcPtr yp));
MLDECL( __MLProcPtr__, MLHandlerCast, ( MLHandlerProcPtr mh));

ML_END_EXTERN_C




#ifndef MLSIGNAL_H
#define MLSIGNAL_H

#if MLINTERFACE >= 3
MLYPROC( void, MLSigHandlerProcPtr, (int signal));
#else
MLYPROC( void, MLSigHandlerProcPtr, (int_ct signal));
#endif /* MLINTERFACE >= 3 */

typedef MLSigHandlerProcPtr MLSignalHandlerType;
typedef void * MLSignalHandlerObject;

#endif /* MLSIGNAL_H */




#ifndef _MLMAKE_H
#define _MLMAKE_H

/* --binding layer-- */
/*************** Starting MathLink ***************/

#define MLPARAMETERSIZE_R1 256
#if MLINTERFACE >= 3
#define MLPARAMETERSIZE 356
#else
#define MLPARAMETERSIZE 256
#endif

typedef char FAR * MLParametersPointer;
typedef char MLParameters[MLPARAMETERSIZE];

#define MLLoopBackOpen MLLoopbackOpen



ML_EXTERN_C
MLUPROC( void, MLUserProcPtr, (MLINK));
ML_END_EXTERN_C

typedef MLUserProcPtr MLUserUPP;
#define NewMLUserProc(userRoutine) (userRoutine)

typedef MLUserUPP MLUserFunctionType;
typedef MLUserFunctionType FAR * MLUserFunctionTypePointer;

#if MLINTERFACE >= 3
typedef MLUserUPP MLUserFunction;
#endif /* MLINTERFACE >= 3 */


/* The following defines are
 * currently for internal use only.
 */


/* edit here and in mldevice.h and mathlink.r */
#define MLNetworkVisibleMask ((unsigned long)0x00000003)
#define MLBrowseMask         ((unsigned long)0x00000010)
#define MLNonBlockingMask    ((unsigned long)0x00000020)
#define MLInteractMask       ((unsigned long)0x00000100)
#define MLYieldMask          ((unsigned long)0x00000200)
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

#define MLForceYield         ((unsigned long)0x00000200)


/* Encoding types for use with MLSetEncodingParameter */
#if MLINTERFACE >= 3
#define MLASCII_ENC		1
#define MLBYTES_ENC		2
#define MLUCS2_ENC		3
#define MLOLD_ENC		4
#define MLUTF8_ENC		5
#define MLUTF16_ENC		6
#define MLUTF32_ENC		8
#endif


#endif /* _MLMAKE_H */


/* explicitly not protected by _MLMAKE_H in case MLDECL is redefined for multiple inclusion */


ML_EXTERN_C
#if MLINTERFACE >= 3
MLDECL( unsigned long, MLNewParameters,     ( char* p, unsigned long rev, unsigned long apirev));
MLDECL( void,          MLSetAllocParameter, ( char* p, MLAllocator allocator, MLDeallocator deallocator));
#else
MLDECL( ulong_ct, MLNewParameters,     ( MLParametersPointer p, ulong_ct rev, ulong_ct apirev));
MLDECL( void,     MLSetAllocParameter, ( MLParametersPointer p, MLAllocator allocator, MLDeallocator deallocator));
#endif /* MLINTERFACE >= 3 */


#ifndef MLINTERFACE
/* syntax error */
#endif
#if MLINTERFACE > 1
#if MLINTERFACE >= 3
MLDECL( int,      MLAllocParameter,       (char* p, MLAllocator* allocator, MLDeallocator* deallocator));
MLDECL( long,     MLSetResourceParameter, (char* p, const char *path));
MLDECL( long,     MLSetDeviceParameter,   (char* p, const char *devspec));
MLDECL( long,     MLErrorParameter,       (char* p));
MLDECL( long,     MLSetEncodingParameter, (char *p, unsigned int etype));
#else
MLDECL( long,     MLAllocParameter,       (MLParametersPointer p, MLAllocatorp allocatorp, MLDeallocatorp deallocatorp));
MLDECL( long,     MLSetResourceParameter, (MLParametersPointer p, kcharp_ct path));
MLDECL( long,     MLSetDeviceParameter,   (MLParametersPointer p, kcharp_ct devspec));
MLDECL( long,     MLErrorParameter,       (MLParametersPointer p));
#endif /* MLINTERFACE >= 3 */
#endif /* MLINTERFACE > 1 */

#if MLINTERFACE >= 3
MLDECL( long,          MLSetEnvironmentData,           ( MLEnvironment env, void *cookie));
MLDECL( void *,        MLEnvironmentData,              ( MLEnvironment env));
MLDECL( int,           MLSetSignalHandler,             ( MLEnvironment env, int signum, void *so));
MLDECL( int,           MLSetSignalHandlerFromFunction, ( MLEnvironment env, int signum, MLSignalHandlerType sigfunc));
MLDECL( int,           MLUnsetSignalHandler,           ( MLEnvironment env, int signum, MLSignalHandlerType sigfunc));
MLDECL( long,          MLSetSymbolReplacement,         ( MLINK mlp, const char *priv, int prlen, const char *pub, int pblen));
MLDECL( int,           MLClearSymbolReplacement,       ( MLINK mlp, long index));
MLDECL( void,          MLClearAllSymbolReplacements,   ( MLINK mlp));
#endif

#if MLINTERFACE >= 3
MLDECL( long,          MLSetSignalHandler0, ( MLEnvironment env, int signum, MLSignalHandlerObject so));
MLDECL( long,          MLUnsetSignalHandler0, ( MLEnvironment env, int signum, MLSignalHandlerObject so));
#else
MLDECL( long,          MLSetSignalHandler0, ( MLEnvironment env, int_ct signum, MLSignalHandlerObject so));
MLDECL( long,          MLUnsetSignalHandler0, ( MLEnvironment env, int_ct signum, MLSignalHandlerObject so));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
MLDECL( MLEnvironment, MLInitialize,   ( char* p)); /* pass in NULL */
#else
MLDECL( MLEnvironment, MLInitialize,   ( MLParametersPointer p)); /* pass in NULL */
#endif /* MLINTERFACE >= 3 */

MLDECL( void,          MLDeinitialize, ( MLEnvironment env));

/*************** MathLink Revsion Number/Interface Number ************/
#if MLINTERFACE >= 3
MLDECL( void,          MLVersionNumber0, ( MLEnvironment env, long *inumb, long *rnumb));
#else
MLDECL( void,          MLVersionNumber0, ( MLEnvironment env, longp_ct inumb, longp_ct rnumb));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
MLDECL( void,          MLVersionNumbers, ( MLEnvironment env, int *inumb, int *rnumb, int *bnumb));
#endif
/********************************************************************/

/* or, if you use MLOpenArgcArgv, ...*/

#if MLINTERFACE >= 3
MLDECL( MLEnvironment, MLBegin, ( char* p)); /* pass in NULL */
#else
MLDECL( MLEnvironment, MLBegin, ( MLParametersPointer p)); /* pass in NULL */
#endif /* MLINTERFACE >= 3 */

MLDECL( void,          MLEnd,   ( MLEnvironment env));

/*************** Environment Identification Interface ***************/

#if MLINTERFACE >= 3
MLDECL( int, MLSetEnvIDString, ( MLEnvironment ep, const char *environment_id)); /* APPIDSERV */
MLDECL( int, MLGetLinkedEnvIDString, (MLINK mlp, const char **environment_id)); /* APPIDSERV */
MLDECL( void, MLReleaseEnvIDString, (MLINK mlp, const char *environment_id));
#endif

#if MLINTERFACE >= 3
MLDECL( long, MLSetEnvIDString0, ( MLEnvironment ep, const char *environment_id)); /* APPIDSERV */
MLDECL( long, MLGetLinkedEnvIDString0, ( MLINK mlp, const char *environment_id)); /* APPIDSERV */
#else
MLDECL( long, MLSetEnvIDString0, ( MLEnvironment ep, kcharp_ct environment_id)); /* APPIDSERV */
MLDECL( long, MLGetLinkedEnvIDString0, ( MLINK mlp, kcharp_ct environment_id)); /* APPIDSERV */
#endif /* MLINTERFACE >= 3 */

/*********************************************************************/


/**************** Network Interface List API *************************/
#if MLINTERFACE >= 3
MLDECL( char **,    MLGetNetworkAddressList, ( MLEnvironment ep, unsigned long *size ));
MLDECL( void,   MLReleaseNetworkAddressList, ( MLEnvironment ep, char **addresses, unsigned long size));

/* MLDisownNetworkAddressList is for internal use only. */
MLDECL( void,   MLDisownNetworkAddressList, ( MLEnvironment ep, char **addresses, unsigned long size));

MLDECL( char **,        MLGetDomainNameList, ( MLEnvironment ep, unsigned long *size ));
MLDECL( void,       MLReleaseDomainNameList, ( MLEnvironment ep, char **dnsnames, unsigned long size));

/* MLDisownDomainNameList is for internal use only */
MLDECL( void,       MLDisownDomainNameList, ( MLEnvironment ep, char **dnsnames, unsigned long size));

#endif /* MLINTERFACE >= 3 */
/*********************************************************************/

#if MLNTESTPOINTS < 1
#undef MLNTESTPOINTS
#define MLNTESTPOINTS 1
#endif
#if MLINTERFACE >= 3
MLDECL( long, MLTestPoint1, ( MLEnvironment ep, unsigned long selector, void *p1, void *p2, long *np));
#else
MLDECL( long_et, MLTestPoint1, ( MLEnvironment ep, ulong_ct selector, voidp_ct p1, voidp_ct p2, longp_ct np));
#endif /* MLINTERFACE >= 3 */

#ifndef MLINTERFACE
/* syntax error */
#endif
#if MLINTERFACE > 1

#if MLNTESTPOINTS < 2
#undef MLNTESTPOINTS
#define MLNTESTPOINTS 2
#endif
MLDECL( void,    MLTestPoint2,     ( MLINK mlp));

#if MLNTESTPOINTS < 3
#undef MLNTESTPOINTS
#define MLNTESTPOINTS 3
#endif
#if MLINTERFACE >= 3
MLDECL( unsigned long,    MLTestPoint3,     ( MLINK mlp));
#else
MLDECL( ulong_ct,    MLTestPoint3,     ( MLINK mlp));
#endif /* MLINTERFACE >= 3 */

#if MLNTESTPOINTS < 4
#undef MLNTESTPOINTS
#define MLNTESTPOINTS 4
#endif
#if MLINTERFACE >= 3
MLDECL( unsigned long,    MLTestPoint4,     ( MLINK mlp));
#else
MLDECL( ulong_ct,    MLTestPoint4,     ( MLINK mlp));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
MLDECL( long, MLNumberControl0, ( MLEnvironment ep, unsigned long selector, void *p1, void *p2, long *np));
#else
MLDECL( long_et, MLNumberControl0, ( MLEnvironment ep, ulong_ct selector, voidp_ct p1, voidp_ct p2, longp_ct np));
#endif /* MLINTERFACE >= 3 */

#else
#if MLINTERFACE >= 3
extern long MLNumberControl0( MLEnvironment ep, unsigned long selector, void *p1, void *p2, long *np);
#else
extern long_et MLNumberControl0( MLEnvironment ep, ulong_ct selector, voidp_ct p1, voidp_ct p2, longp_ct np);
#endif /* MLINTERFACE >= 3 */
#endif


/*************** Connection interface ***************/
#if MLINTERFACE >= 3
MLDECL( MLINK,         MLCreate0,       ( MLEnvironment ep, dev_type dev, dev_main_type dev_main, int *errp));
MLDECL( MLINK,         MLMake,          ( void* ep, dev_type dev, dev_main_type dev_main, int *errp));
#else
MLDECL( MLINK,         MLCreate0,       ( MLEnvironment ep, dev_type dev, dev_main_type dev_main, longp_ct errp));
MLDECL( MLINK,         MLMake,          ( MLPointer ep, dev_type dev, dev_main_type dev_main, longp_ct errp));
#endif /* MLINTERFACE >= 3 */

MLDECL( void,          MLDestroy,       ( MLINK mlp, dev_typep devp, dev_main_typep dev_mainp));
MLDECL( int,           MLValid0,        ( MLINK mlp));

#if MLINTERFACE >= 3
MLDECL( long,          MLFeatureString, ( MLINK mlp, char *buf, long buffsize));
MLDECL( char **,       MLFilterArgv0,   ( MLEnvironment ep, char **argv, char **argv_end));
MLDECL( MLINK,         MLOpenArgv,      ( MLEnvironment ep, char **argv, char **argv_end, int *errp));
MLDECL( MLINK,         MLOpenArgcArgv,  ( MLEnvironment ep, int argc, char **argv, int *errp));
MLDECL( MLINK,         MLOpenString,    ( MLEnvironment ep, const char *command_line, int *errp));
MLDECL( MLINK,         MLLoopbackOpen,  ( MLEnvironment ep, int *errp));
MLDECL( MLINK,         MLLoopbackOpen0, ( MLEnvironment ep, const char *features, int *errp));
MLDECL( int,           MLStringToArgv,  ( const char *commandline, char *buf, char **argv, int len));
MLDECL( long,          MLScanString,    ( char **argv, char ***argv_end, char **commandline, char **buf));
MLDECL( long,          MLPrintArgv,     ( char *buf, char **buf_endp, char ***argvp, char **argv_end));
#else
MLDECL( long,          MLFeatureString, ( MLINK mlp, charp_ct buf, long buffsize));
MLDECL( charpp_ct,     MLFilterArgv0,   ( MLEnvironment ep, charpp_ct argv, charpp_ct argv_end));
MLDECL( MLINK,         MLOpenArgv,      ( MLEnvironment ep, charpp_ct argv, charpp_ct argv_end, longp_ct errp));
MLDECL( MLINK,         MLOpenString,    ( MLEnvironment ep, kcharp_ct command_line, longp_ct errp));
MLDECL( MLINK,         MLLoopbackOpen,  ( MLEnvironment ep, longp_ct errp));
MLDECL( MLINK,         MLLoopbackOpen0, ( MLEnvironment ep, kcharp_ct features, longp_ct errp));
MLDECL( int_ct,        MLStringToArgv,  ( kcharp_ct commandline, charp_ct buf, charpp_ct argv, int_ct len));
MLDECL( long,          MLScanString,    ( charpp_ct argv, charppp_ct argv_end, charpp_ct commandline, charpp_ct buf));
MLDECL( long,          MLPrintArgv,     ( charp_ct buf, charpp_ct buf_endp, charppp_ct argvp, charpp_ct argv_end));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
MLDECL( const char *,     MLErrorMessage,  ( MLINK mlp));
MLDECL( const char *,     MLErrorString,   ( MLEnvironment env, long err));
#else
MLDECL( kcharp_ct,     MLErrorMessage,  ( MLINK mlp));
MLDECL( kcharp_ct,     MLErrorString,   ( MLEnvironment env, long err));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
MLDECL( MLINK,         MLOpen,          ( int argc, char **argv));
MLDECL( MLINK,         MLOpenInEnv,     ( MLEnvironment env, int argc, char **argv, int *errp));
MLDECL( MLINK,         MLOpenS,         ( const char *command_line));
#else
MLDECL( MLINK,         MLOpen,          ( int_ct argc, charpp_ct argv));
MLDECL( MLINK,         MLOpenInEnv,     ( MLEnvironment env, int_ct argc, charpp_ct argv, longp_ct errp));
MLDECL( MLINK,         MLOpenS,         ( kcharp_ct command_line));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
MLDECL( MLINK,         MLDuplicateLink,   ( MLINK parentmlp, const char *name, int *errp ));
#else
MLDECL( MLINK,         MLDuplicateLink,   ( MLINK parentmlp, kcharp_ct name, longp_ct errp ));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
MLDECL( int,  MLConnect,         ( MLINK mlp));
MLDECL( int,  MLActivate,        ( MLINK mlp));
#else
MLDECL( mlapi_result,  MLConnect,         ( MLINK mlp));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE < 3
#define MLActivate MLConnect
#endif

#ifndef __feature_setp__
#define __feature_setp__
typedef struct feature_set* feature_setp;
#endif
#if MLINTERFACE >= 3
MLDECL( int,  MLEstablish,       ( MLINK mlp, feature_setp features));
#else
MLDECL( mlapi_result,  MLEstablish,       ( MLINK mlp, feature_setp features));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
MLDECL( int,  MLEstablishString, ( MLINK mlp, const char *features));
#else
MLDECL( mlapi_result,  MLEstablishString, ( MLINK mlp, kcharp_ct features));
#endif /* MLINTERFACE >= 3 */

MLDECL( void,          MLClose,           ( MLINK mlp));

#if MLINTERFACE >= 3
MLDECL( void,          MLSetUserData,   ( MLINK mlp, void* data, MLUserFunction f));
MLDECL( void*,         MLUserData,      ( MLINK mlp, MLUserFunctionType *fp));
MLDECL( void,          MLSetUserBlock,  ( MLINK mlp, void* userblock));
MLDECL( void*,         MLUserBlock,     ( MLINK mlp));
#else
MLDECL( void,          MLSetUserData,   ( MLINK mlp, MLPointer data, MLUserFunctionType f));
MLDECL( MLPointer,     MLUserData,      ( MLINK mlp, MLUserFunctionTypePointer fp));
MLDECL( void,          MLSetUserBlock,  ( MLINK mlp, MLPointer userblock));
MLDECL( MLPointer,     MLUserBlock,     ( MLINK mlp));
#endif /* MLINTERFACE >= 3 */

/* just a type-safe cast */
MLDECL( __MLProcPtr__, MLUserCast, ( MLUserProcPtr f));





/* MLLinkName returns a pointer to the link's name.
 * Links are generally named when they are created
 * and are based on information that is potentially
 * useful and is available at that time.
 * Do not attempt to deallocate the name's storage
 * through this pointer.  The storage should be
 * considered in read-only memory.
 */
#if MLINTERFACE >= 3
MLDECL( const char *, MLName,    ( MLINK mlp));
MLDECL( const char *, MLLinkName,    ( MLINK mlp));
#else
MLDECL( kcharp_ct, MLName,    ( MLINK mlp));
MLDECL( kcharp_ct, MLLinkName,    ( MLINK mlp));
#endif /* MLINTERFACE >= 3 */

MLDECL( long,      MLNumber,  ( MLINK mlp));
#if MLINTERFACE > 1
MLDECL( long,  MLToLinkID,  ( MLINK mlp));
MLDECL( MLINK, MLFromLinkID, ( MLEnvironment ep, long n));
#else
extern MLINK MLFromLinkID( MLEnvironment ep, long n);
#endif

#if MLINTERFACE >= 3
MLDECL( char *,  MLSetName, ( MLINK mlp, const char *name));
#else
MLDECL( charp_ct,  MLSetName, ( MLINK mlp, kcharp_ct name));
#endif /* MLINTERFACE >= 3 */



/* The following functions are
 * currently for internal use only.
 */

#if MLINTERFACE >= 3
MLDECL( void*, MLInit,   ( MLallocator alloc, MLdeallocator dealloc, void* enclosing_environment));
MLDECL( void,  MLDeinit, ( void* env));
MLDECL( void*, MLEnclosingEnvironment, ( void* ep));
MLDECL( void*, MLinkEnvironment, ( MLINK mlp));
#else
MLDECL( MLPointer, MLInit,   ( MLallocator alloc, MLdeallocator dealloc, MLPointer enclosing_environment));
MLDECL( void,      MLDeinit, ( MLPointer env));
MLDECL( MLPointer, MLEnclosingEnvironment, ( MLPointer ep));
MLDECL( MLPointer, MLinkEnvironment, ( MLINK mlp));
#endif /* MLINTERFACE >= 3 */


/* the following two functions are for internal use only */
MLDECL( MLYieldFunctionObject, MLDefaultYieldFunction,    ( MLEnvironment env));

#if MLINTERFACE >= 3
MLDECL( int,          MLSetDefaultYieldFunction, ( MLEnvironment env, MLYieldFunctionObject yf));
#else
MLDECL( mlapi_result,          MLSetDefaultYieldFunction, ( MLEnvironment env, MLYieldFunctionObject yf));
#endif /* MLINTERFACE >= 3 */

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

#define MLEUNKNOWN          -1
#define MLEOK                0
#define MLEDEAD              1
#define MLEGBAD              2
#define MLEGSEQ              3
#define MLEPBTK              4
#define MLEPSEQ              5
#define MLEPBIG              6
#define MLEOVFL              7
#define MLEMEM               8
#define MLEACCEPT            9
#define MLECONNECT          10
#define MLECLOSED           11
#define MLEDEPTH            12  /* internal error */
#define MLENODUPFCN         13  /* stream cannot be duplicated */

#define MLENOACK            15  /* */
#define MLENODATA           16  /* */
#define MLENOTDELIVERED     17  /* */
#define MLENOMSG            18  /* */
#define MLEFAILED           19  /* */

#define MLEGETENDEXPR       20
#define MLEPUTENDPACKET     21 /* unexpected call of MLEndPacket */
                               /* currently atoms aren't
                                * counted on the way out so this error is raised only when
                                * MLEndPacket is called in the midst of an atom
                                */
#define MLENEXTPACKET       22
#define MLEUNKNOWNPACKET    23
#define MLEGETENDPACKET     24
#define MLEABORT            25
#define MLEMORE             26 /* internal error */
#define MLENEWLIB           27
#define MLEOLDLIB           28
#define MLEBADPARAM         29
#define MLENOTIMPLEMENTED   30


#define MLEINIT             32
#define MLEARGV             33
#define MLEPROTOCOL         34
#define MLEMODE             35
#define MLELAUNCH           36
#define MLELAUNCHAGAIN      37
#define MLELAUNCHSPACE      38
#define MLENOPARENT         39
#define MLENAMETAKEN        40
#define MLENOLISTEN         41
#define MLEBADNAME          42
#define MLEBADHOST          43
#define MLERESOURCE         44  /* a required resource was missing */
#define MLELAUNCHFAILED     45
#define MLELAUNCHNAME       46
#if MLINTERFACE >= 3
#define MLEPDATABAD         47
#define MLEPSCONVERT        48
#define MLEGSCONVERT        49
#define MLENOTEXE           50
#define MLESYNCOBJECTMAKE   51
#define MLELAST MLESYNCOBJECTMAKE
#else
#define MLELAST MLELAUNCHNAME /* for internal use only */
#endif

#define MLETRACEON         996  /* */
#define MLETRACEOFF        997  /* */
#define MLEDEBUG           998  /* */
#define MLEASSERT          999  /* an internal assertion failed */
#define MLEUSER           1000  /* start of user defined errors */


#endif /* _MLERRNO_H */


#endif /* _MLERRORS_H */

/* explicitly not protected by _MLERRORS_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C
#if MLINTERFACE >= 3
MLDECL( int,  MLError,        ( MLINK mlp));
MLDECL( int,  MLClearError,   ( MLINK mlp));
MLDECL( int,  MLSetError,     ( MLINK mlp, int err));
#else
MLDECL( mlapi_error,   MLError,        ( MLINK mlp));
MLDECL( mlapi_result,  MLClearError,   ( MLINK mlp));
MLDECL( mlapi_result,  MLSetError,     ( MLINK mlp, mlapi_error err));
#endif /* MLINTERFACE >= 3 */
ML_END_EXTERN_C


#ifndef _MLYLDMSG_H
#define _MLYLDMSG_H



enum {	MLTerminateMessage = 1, MLInterruptMessage, MLAbortMessage,
	MLEndPacketMessage, MLSynchronizeMessage, MLImDyingMessage,
	MLWaitingAcknowledgment, MLMarkTopLevelMessage, MLLinkClosingMessage,
	MLAuthenticateFailure, MLFirstUserMessage = 128, MLLastUserMessage = 255 };

typedef unsigned long devinfo_selector;


#endif /* _MLYLDMSG_H */

/* explicitly not protected by _MLYLDMSG_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C

#ifndef MLINTERFACE
/* syntax error */
#endif

#if MLINTERFACE >= 3
MLDECL( int,   MLPutMessage,   ( MLINK mlp, int  msg));
MLDECL( int,   MLGetMessage,   ( MLINK mlp, int *mp, int *np));
MLDECL( int,   MLMessageReady, ( MLINK mlp));
#else
MLDECL( mlapi_result,   MLGetMessage,   ( MLINK mlp, dev_messagep mp, dev_messagep np));
MLDECL( mlapi_result,   MLPutMessage,   ( MLINK mlp, dev_message  msg));
MLDECL( mlapi_result,   MLMessageReady, ( MLINK mlp));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
MLDECL( int,   MLPutMessageWithArg, ( MLINK mlp, int msg, int arg));
#endif


#if MLINTERFACE >= 3
MLDECL( MLMessageHandlerObject, MLGetMessageHandler,    ( MLINK mlp));
#endif /* MLINTERFACE >= 3 */
MLDECL( MLMessageHandlerObject, MLMessageHandler,    ( MLINK mlp));

#if MLINTERFACE >= 3
MLDECL( MLYieldFunctionObject,  MLGetYieldFunction,     ( MLINK mlp));
#endif /* MLINTERFACE >= 3 */
MLDECL( MLYieldFunctionObject,  MLYieldFunction,     ( MLINK mlp));

#if MLINTERFACE >= 3
MLDECL( int,  MLSetMessageHandler, ( MLINK mlp, MLMessageHandlerObject h));
MLDECL( int,  MLSetYieldFunction,  ( MLINK mlp, MLYieldFunctionObject yf));
#else
MLDECL( mlapi_result,  MLSetMessageHandler, ( MLINK mlp, MLMessageHandlerObject h));
MLDECL( mlapi_result,  MLSetYieldFunction,  ( MLINK mlp, MLYieldFunctionObject yf));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE > 1
#if MLINTERFACE >= 3
MLDECL( int,  MLSetYieldFunction0,  ( MLINK mlp, MLYieldFunctionObject yf, MLINK cookie));
MLDECL( int,  MLSetMessageHandler0, ( MLINK mlp, MLMessageHandlerObject func, MLINK cookie));
#else
MLDECL( mlapi_result,  MLSetYieldFunction0,  ( MLINK mlp, MLYieldFunctionObject yf, MLINK cookie));
MLDECL( mlapi_result,  MLSetMessageHandler0, ( MLINK mlp, MLMessageHandlerObject func, MLINK cookie));
#endif /* MLINTERFACE >= 3 */
#endif /* MLINTERFACE > 1 */

#if MLINTERFACE >= 3
MLDECL( int, MLDeviceInformation, ( MLINK mlp, devinfo_selector selector, void* buf, long *buflen));
#else
MLDECL( mlapi_result, MLDeviceInformation, ( MLINK mlp, devinfo_selector selector, MLPointer buf, longp_st buflen));
#endif /* MLINTERFACE >= 3 */
ML_END_EXTERN_C

/*************** Textual interface ***************/


#ifndef _MLGET_H
#define _MLGET_H


#endif /* _MLGET_H */

/* explicitly not protected by _MLGET_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C

#if MLINTERFACE >= 3
MLDECL( int,   MLGetNext,          ( MLINK mlp));
MLDECL( int,   MLGetNextRaw,       ( MLINK mlp));
MLDECL( int,   MLGetType,          ( MLINK mlp));
MLDECL( int,   MLGetRawType,       ( MLINK mlp));
MLDECL( int,   MLGetRawData,       ( MLINK mlp, unsigned char *data, int size, int *gotp));
MLDECL( int,   MLGetData,          ( MLINK mlp, char *data, int size, int *gotp));
MLDECL( int,   MLGetArgCount,      ( MLINK mlp, int *countp));
MLDECL( int,   MLGetRawArgCount,   ( MLINK mlp, int *countp));
MLDECL( int,   MLBytesToGet,       ( MLINK mlp, int *leftp));
MLDECL( int,   MLRawBytesToGet,    ( MLINK mlp, int *leftp));
MLDECL( int,   MLExpressionsToGet, ( MLINK mlp, int *countp));
#else
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
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
MLDECL( int,   MLNewPacket,        ( MLINK mlp));
#else
MLDECL( mlapi_result,   MLNewPacket,        ( MLINK mlp));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
MLDECL( int,   MLTakeLast,         ( MLINK mlp, int eleft));
#else
MLDECL( mlapi_result,   MLTakeLast,         ( MLINK mlp, long_st eleft));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
MLDECL( int,   MLFill,             ( MLINK mlp));
#else
MLDECL( mlapi_result,   MLFill,             ( MLINK mlp));
#endif /* MLINTERFACE >= 3 */
ML_END_EXTERN_C


#ifndef _MLPUT_H
#define _MLPUT_H


#define MLPutExpression is obsolete, use MLPutComposite

#endif /* _MLPUT_H */

/* explicitly not protected by _MLPUT_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C

#if MLINTERFACE >= 3
MLDECL( int,   MLPutNext,      ( MLINK mlp, int tok));
MLDECL( int,   MLPutType,      ( MLINK mlp, int tok));
MLDECL( int,   MLPutRawSize,   ( MLINK mlp, int size));
MLDECL( int,   MLPutRawData,   ( MLINK mlp, const unsigned char *data, int len));
MLDECL( int,   MLPutArgCount,  ( MLINK mlp, int argc));
MLDECL( int,   MLPutComposite, ( MLINK mlp, int argc));
MLDECL( int,   MLBytesToPut,   ( MLINK mlp, int *leftp));
MLDECL( int,   MLEndPacket,    ( MLINK mlp));
MLDECL( int,   MLFlush,        ( MLINK mlp));
#else
MLDECL( mlapi_result,   MLPutNext,      ( MLINK mlp, mlapi_token tok));
MLDECL( mlapi_result,   MLPutType,      ( MLINK mlp, mlapi__token tok));
MLDECL( mlapi_result,   MLPutRawSize,   ( MLINK mlp, long_st size));
MLDECL( mlapi_result,   MLPutRawData,   ( MLINK mlp, kucharp_ct data, long_st len));
MLDECL( mlapi_result,   MLPutArgCount,  ( MLINK mlp, long_st argc));
MLDECL( mlapi_result,   MLPutComposite, ( MLINK mlp, long_st argc));
MLDECL( mlapi_result,   MLBytesToPut,   ( MLINK mlp, longp_st leftp));
MLDECL( mlapi_result,   MLEndPacket,    ( MLINK mlp));
MLDECL( mlapi_result,   MLFlush,        ( MLINK mlp));
#endif /* MLINTERFACE >= 3 */

ML_END_EXTERN_C


#ifndef _MLTK_H
#define _MLTK_H


#define	MLTKOLDINT     'I'		/* 73 Ox49 01001001 */ /* integer leaf node */
#define	MLTKOLDREAL    'R'		/* 82 Ox52 01010010 */ /* real leaf node */


#define	MLTKFUNC    'F'		/* 70 Ox46 01000110 */ /* non-leaf node */

#define	MLTKERROR   (0)		/* bad token */
#define	MLTKERR     (0)		/* bad token */

/* text token bit patterns: 0010x01x --exactly 2 bits worth chosen to make things somewhat readable */
#define MLTK__IS_TEXT( tok) ( (tok & 0x00F6) == 0x0022)

#define	MLTKSTR     '"'  /* 00100010 */
#define	MLTKSYM     '\043'  /* # 00100011 */ /* octal here as hash requires a trigraph */

#define	MLTKREAL    '*'  /* 00101010 */
#define	MLTKINT     '+'  /* 00101011 */



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
#if 0
#define MLTKNULLSEQUENCE_DECODER ((decoder_mask) 1<<20)
#else
#define MLTKNULLSEQUENCE_DECODER ((decoder_mask) 0)
#endif
#define MLTKALL_DECODERS (MLLENGTH_DECODER | MLTKPACKED_DECODER | MLTKARRAY_DECODER | MLTKMODERNCHARS_DECODER | MLTKNULLSEQUENCE_DECODER)

#define MLTK_FIRSTUSER '\x30' /* user token */
#define MLTK_LASTUSER  '\x3F'



#endif /* _MLTK_H */

/*************** mlint64 interface ***************/


#ifndef _MLINTEGER64_H
#define _MLINTEGER64_H


#if MLINTERFACE >= 3

ML_EXTERN_C

MLDECL(mlint64,              MLInteger64_FromInteger16,    (short a));
MLDECL(mlint64,              MLInteger64_FromInteger32,    (int a));
MLDECL(short,                  MLInteger64_ToInteger16,    (mlint64 a));
MLDECL(int,                    MLInteger64_ToInteger32,    (mlint64 a));

MLDECL(int,                          MLInteger64_Equal,    (mlint64 a, mlint64 b));
MLDECL(int,                       MLInteger64_NotEqual,    (mlint64 a, mlint64 b));
MLDECL(int,                      MLInteger64_LessEqual,    (mlint64 a, mlint64 b));
MLDECL(int,                           MLInteger64_Less,    (mlint64 a, mlint64 b));
MLDECL(int,                   MLInteger64_GreaterEqual,    (mlint64 a, mlint64 b));
MLDECL(int,                        MLInteger64_Greater,    (mlint64 a, mlint64 b));

MLDECL(int,    MLInteger64_GreaterThanLargestInteger32,  (mlint64 a));

MLDECL(mlint64,                     MLInteger64_BitAnd,    (mlint64 a, mlint64 b));
MLDECL(mlint64,                      MLInteger64_BitOr,    (mlint64 a, mlint64 b));
MLDECL(mlint64,                     MLInteger64_BitXor,    (mlint64 a, mlint64 b));
MLDECL(mlint64,                     MLInteger64_BitNot,    (mlint64 a));
MLDECL(mlint64,                        MLInteger64_Neg,    (mlint64 a));

MLDECL(mlint64,                       MLInteger64_Plus,    (mlint64 a, mlint64 b));
MLDECL(mlint64,                  MLInteger64_Increment,    (mlint64 a, mlint64 b));
MLDECL(mlint64,                MLInteger64_Increment32,    (mlint64 a, int b));
MLDECL(mlint64,                   MLInteger64_Subtract,    (mlint64 a, mlint64 b));
MLDECL(mlint64,                  MLInteger64_Decrement,    (mlint64 a, mlint64 b));
MLDECL(mlint64,                MLInteger64_Decrement32,    (mlint64 a, int b));
MLDECL(mlint64,                      MLInteger64_Times,    (mlint64 a, mlint64 b));
MLDECL(mlint64,                     MLInteger64_Divide,    (mlint64 a, mlint64 b));
MLDECL(mlint64,                        MLInteger64_Mod,    (mlint64 a, mlint64 b));

ML_END_EXTERN_C

#endif /* MLINTERFACE >= 3 */

#endif /* _MLINTEGER64_H */

/*************** Native C types interface ***************/


#ifndef _MLCGET_H
#define _MLCGET_H



#if MLINTERFACE < 3
#define MLGetReal MLGetDouble
#endif

#endif /* _MLCGET_H */


/* explicitly not protected by _MLCGET_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C

#if MLINTERFACE >= 3
MLDECL( int,   MLGetBinaryNumber,  ( MLINK mlp, void *np, long type));

/*
As of MLINTERFACE 3 the following functions have been deprecated.  Use the suggested functions in their
place:

MLGetShortInteger   - MLGetInteger16
MLGetInteger        - MLGetInteger32
MLGetLongInteger    - MLGetInteger64 for 64-bit integers or MLGetInteger32 for 32-bit integers
*/
MLDECL( int,   MLGetShortInteger,  ( MLINK mlp, short *hp));
MLDECL( int,   MLGetInteger,       ( MLINK mlp, int *ip));
MLDECL( int,   MLGetLongInteger,   ( MLINK mlp, long *lp));


MLDECL( int,   MLGetInteger16,  ( MLINK mlp, short *hp));
MLDECL( int,   MLGetInteger32,  ( MLINK mlp, int *ip));
MLDECL( int,   MLGetInteger64,  ( MLINK mlp, mlint64 *wp));
#else
MLDECL( mlapi_result,   MLGetBinaryNumber,  ( MLINK mlp, voidp_ct np, long type));
MLDECL( mlapi_result,   MLGetShortInteger,  ( MLINK mlp, shortp_nt hp));
MLDECL( mlapi_result,   MLGetInteger,       ( MLINK mlp, intp_nt ip));
MLDECL( mlapi_result,   MLGetLongInteger,   ( MLINK mlp, longp_nt lp));
#endif /* MLINTERFACE >= 3 */


#if MLINTERFACE >= 3
/*
As of MLINTERFACE 3 the following functions have been deprecated.  Use the suggested functions in their
place:

MLGetFloat      - MLGetReal32
MLGetDouble     - MLGetReal64
MLGetReal       - MLGetReal64
MLGetLongDouble - MLGetReal128
*/
MLDECL( int,   MLGetFloat,         ( MLINK mlp, float *fp));
MLDECL( int,   MLGetDouble,        ( MLINK mlp, double *dp));
MLDECL( int,   MLGetReal,          ( MLINK mlp, double *dp));
#if CC_SUPPORTS_LONG_DOUBLE
MLDECL( int,   MLGetLongDouble,    ( MLINK mlp, mlextended_double *xp));
#endif


MLDECL( int,   MLGetReal32,         ( MLINK mlp, float *fp));
MLDECL( int,   MLGetReal64,        ( MLINK mlp, double *dp));
MLDECL( int,   MLGetReal128,          ( MLINK mlp, mlextended_double *dp));
#else
MLDECL( mlapi_result,   MLGetFloat,         ( MLINK mlp, floatp_nt fp));
MLDECL( mlapi_result,   MLGetDouble,        ( MLINK mlp, doublep_nt dp));
#if CC_SUPPORTS_LONG_DOUBLE
MLDECL( mlapi_result,   MLGetLongDouble,    ( MLINK mlp, extendedp_nt xp));
#endif
#endif /* MLINTERFACE >= 3 */


#if MLINTERFACE >= 3
/*
As of MLINTERFACE 3 MLGet16BitCharacters has been deprecated.  Use the suggested function in its
place:

MLGet16BitCharacters   - MLGetUCS2Characters
*/
MLDECL( int,   MLGet16BitCharacters,  ( MLINK mlp, long *chars_left, unsigned short *buf, long cardof_buf, long *got));
MLDECL( int,   MLGet8BitCharacters,   ( MLINK mlp, long *chars_left, unsigned char *buf, long cardof_buf, long *got, long missing));
MLDECL( int,   MLGet7BitCharacters,   ( MLINK mlp, long *chars_left, char *buf, long cardof_buf, long *got));

MLDECL( int,   MLGetUCS2Characters,   ( MLINK mlp, int *chars_left, unsigned short *buf, int cardof_buf, int *got));
MLDECL( int,   MLGetUTF8Characters,   ( MLINK mlp, int *chars_left, unsigned char *buf, int cardof_buf, int *got));
MLDECL( int,   MLGetUTF16Characters,  ( MLINK mlp, int *chars_left, unsigned short *buf, int cardof_buf, int *got));
MLDECL( int,   MLGetUTF32Characters,  ( MLINK mlp, int *chars_left, unsigned int *buf, int cardof_buf, int *got));

/*
As of MLINTERFACE 3 MLGetUnicodeString has been deprecated.  Use the suggested function in its
place:

MLGetUnicodeString - MLGetUCS2String
*/
MLDECL( int,   MLGetUnicodeString,    ( MLINK mlp, const unsigned short **sp, long *lenp));
MLDECL( int,   MLGetByteString,       ( MLINK mlp, const unsigned char **sp, int *lenp, long missing));
MLDECL( int,   MLGetString,           ( MLINK mlp, const char **sp));

MLDECL( int,   MLGetUCS2String,       ( MLINK mlp, const unsigned short **sp, int *lenp));
MLDECL( int,   MLGetUTF8String,       ( MLINK mlp, const unsigned char **sp, int *bytes, int *chars));
MLDECL( int,   MLGetUTF16String,      ( MLINK mlp, const unsigned short **sp, int *ncodes, int *chars));
MLDECL( int,   MLGetUTF32String,      ( MLINK mlp, const unsigned int **sp, int *len));
#else
MLDECL( mlapi_result,   MLGet16BitCharacters,  ( MLINK mlp, longp_st chars_left, ushortp_ct buf, long_st cardof_buf, longp_st got));
MLDECL( mlapi_result,   MLGet8BitCharacters,   ( MLINK mlp, longp_st chars_left, ucharp_ct  buf, long_st cardof_buf, longp_st got, long missing));
MLDECL( mlapi_result,   MLGet7BitCharacters,   ( MLINK mlp, longp_st chars_left, charp_ct   buf, long_st cardof_buf, longp_st got));

MLDECL( mlapi_result,   MLGetUnicodeString,    ( MLINK mlp, kushortpp_ct sp, longp_st lenp));
MLDECL( mlapi_result,   MLGetByteString,       ( MLINK mlp, kucharpp_ct  sp, longp_st lenp, long missing));
MLDECL( mlapi_result,   MLGetString,           ( MLINK mlp, kcharpp_ct   sp));
#endif /* MLINTERFACE >= 3 */


#ifndef MLINTERFACE
/* syntax error */
#endif

#if MLINTERFACE >= 3
/*
As of MLINTERFACE 3 MLGetUnicodeString0 has been deprecated.  Use the suggested function in its
place:

MLGetUnicodeString0 - MLGetUCS2String0
*/
MLDECL( int,   MLGetUnicodeString0,   ( MLINK mlp, const unsigned short **sp, long *lenp));
MLDECL( int,   MLGetByteString0,      ( MLINK mlp, const unsigned char **sp, long *lenp, long missing));
MLDECL( int,   MLGetString0,          ( MLINK mlp, const char **sp));

MLDECL( int,   MLGetUCS2String0,      ( MLINK mlp, const unsigned short **sp, int *lenp));
MLDECL( int,   MLGetUTF8String0,      ( MLINK mlp, const unsigned char **sp, int *bytes, int *chars));
MLDECL( int,   MLGetUTF16String0,     ( MLINK mlp, const unsigned short **sp, int *ncodes, int *chars));
MLDECL( int,   MLGetUTF32String0,     ( MLINK mlp, const unsigned int **sp, int *lenp));
#else
#if MLINTERFACE > 1
MLDECL( mlapi_result,   MLGetUnicodeString0,   ( MLINK mlp, kushortpp_ct sp, longp_st lenp));
MLDECL( mlapi_result,   MLGetByteString0,      ( MLINK mlp, kucharpp_ct  sp, longp_st lenp, long missing));
MLDECL( mlapi_result,   MLGetString0,          ( MLINK mlp, kcharpp_ct   sp));
#endif

#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
/*
As of MLINTERFACE 3 MLGetUnicodeSymbol has been deprecated.  Use the suggested function in its
place:

MLGetUnicodeSymbol - MLGetUCS2Symbol
*/
MLDECL( int,   MLGetUnicodeSymbol,    ( MLINK mlp, const unsigned short **sp, long *lenp));
MLDECL( int,   MLGetByteSymbol,       ( MLINK mlp, const unsigned char ** sp, int *lenp, long missing));
MLDECL( int,   MLGetSymbol,           ( MLINK mlp, const char **          sp));

MLDECL( int,   MLGetUCS2Symbol,       ( MLINK mlp, const unsigned short **sp, int *lenp));
MLDECL( int,   MLGetUTF8Symbol,       ( MLINK mlp, const unsigned char **sp, int *bytes, int *chars));
MLDECL( int,   MLGetUTF16Symbol,      ( MLINK mlp, const unsigned short **sp, int *ncodes, int *chars));
MLDECL( int,   MLGetUTF32Symbol,      ( MLINK mlp, const unsigned int **sp, int *lenp));

/*
As of MLINTERFACE 3 the following functions have been deprecated.  Use the suggested functions in their
place:

MLDisownUnicodeString - MLReleaseUCS2String 
MLDisownByteString    - MLReleaseByteString
MLDisownString        - MLReleaseString
MLDisownUnicodeSymbol - MLReleaseUCS2Symbol
MLDisownByteSymbol    - MLReleaseByteSymbol
MLDisownSymbol        - MLReleaseSymbol
*/

MLDECL( void,           MLDisownUnicodeString, ( MLINK mlp, const unsigned short *s,   long len));
MLDECL( void,           MLDisownByteString,    ( MLINK mlp, const unsigned char * s,   long len));
MLDECL( void,           MLDisownString,        ( MLINK mlp, const char *s));
MLDECL( void,           MLDisownUnicodeSymbol, ( MLINK mlp, const unsigned short *s,   long len));
MLDECL( void,           MLDisownByteSymbol,    ( MLINK mlp, const unsigned char * s,   long len));
MLDECL( void,           MLDisownSymbol,        ( MLINK mlp, const char *s));

MLDECL( void,           MLReleaseUCS2String,   ( MLINK mlp, const unsigned short *s,   int len));
MLDECL( void,           MLReleaseUTF8String,   ( MLINK mlp, const unsigned char *s, int len));
MLDECL( void,           MLReleaseUTF16String,  ( MLINK mlp, const unsigned short *s, int len));
MLDECL( void,           MLReleaseUTF32String,  ( MLINK mlp, const unsigned int *s, int len));
MLDECL( void,           MLReleaseByteString,   ( MLINK mlp, const unsigned char * s,   int len));
MLDECL( void,           MLReleaseString,       ( MLINK mlp, const char *s));

MLDECL( void,           MLReleaseUCS2Symbol,   ( MLINK mlp, const unsigned short *s,   int len));
MLDECL( void,           MLReleaseUTF8Symbol,   ( MLINK mlp, const unsigned char *s, int len));
MLDECL( void,           MLReleaseUTF16Symbol,  ( MLINK mlp, const unsigned short *s, int len));
MLDECL( void,           MLReleaseUTF32Symbol,  ( MLINK mlp, const unsigned int *s, int len));
MLDECL( void,           MLReleaseByteSymbol,   ( MLINK mlp, const unsigned char * s,   int len));
MLDECL( void,           MLReleaseSymbol,       ( MLINK mlp, const char *s));



MLDECL( int,   MLCheckString,   ( MLINK mlp, const char *name));
MLDECL( int,   MLCheckSymbol,   ( MLINK mlp, const char *name));
MLDECL( int,   MLGetFunction,   ( MLINK mlp, const char **sp, int *countp));

/*
As of MLINTERFACE 3 the following functions have been deprecated.  Use the suggested functions in their
place:

MLCheckFunction             - MLTestHead
MLCheckFunctionWithArgCount - MLTestHead
*/
MLDECL( int,   MLCheckFunction, ( MLINK mlp, const char *s, long *countp));
MLDECL( int,   MLCheckFunctionWithArgCount, ( MLINK mlp, const char *s, long *countp));

MLDECL( int,   MLTestHead,      ( MLINK mlp, const char *s, int *countp));

#else
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

#endif /* MLINTERFACE >= 3 */

ML_END_EXTERN_C


#ifndef _MLCPUT_H
#define _MLCPUT_H


#if MLINTERFACE < 3
#define MLPutReal MLPutDouble
#endif

#endif /* _MLCPUT_H */

/* explicitly not protected by _MLCPUT_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C

#if MLINTERFACE >= 3
MLDECL( int,   MLPutBinaryNumber,  ( MLINK mlp, void *np, long type));

/* 
As of MLINTERFACE 3 the following functions have been deprecated.  Use the following new functions as their replacement:

MLPutShortInteger  - MLPutInteger16
MLPutInteger       - MLPutInteger32
MLPutLongInteger   - MLPutInteger64 for 64-bit integers or MLPutInteger32 for 32-bit integers.
*/
MLDECL( int,   MLPutShortInteger,  ( MLINK mlp, int h));
MLDECL( int,   MLPutInteger,       ( MLINK mlp, int i));
MLDECL( int,   MLPutLongInteger,   ( MLINK mlp, long l));

MLDECL( int,   MLPutInteger16,     ( MLINK mlp, int h));
MLDECL( int,   MLPutInteger32,     ( MLINK mlp, int i));
MLDECL( int,   MLPutInteger64,     ( MLINK mlp, mlint64 w));
#else
MLDECL( mlapi_result,   MLPutBinaryNumber,  ( MLINK mlp, voidp_ct np, long type));
MLDECL( mlapi_result,   MLPutShortInteger,  ( MLINK mlp, int_nt h));
MLDECL( mlapi_result,   MLPutInteger,       ( MLINK mlp, int_nt i));
MLDECL( mlapi_result,   MLPutLongInteger,   ( MLINK mlp, long_nt l));
#endif /* MLINTERFACE >= 3 */



#if MLINTERFACE >= 3
/* 
As of MLINTERFACE 3 the following functions have been deprecated.  Use the following new functions as their replacement:

MLPutFloat      - MLPutReal32
MLPutDouble     - MLPutReal64
MLPutReal       - MLPutReal64
MLPutLongDouble - MLPutReal128
*/
MLDECL( int,   MLPutFloat,         ( MLINK mlp, double f));
MLDECL( int,   MLPutDouble,        ( MLINK mlp, double d));
MLDECL( int,   MLPutReal,          ( MLINK mlp, double d));
#if CC_SUPPORTS_LONG_DOUBLE
MLDECL( int,   MLPutLongDouble,    ( MLINK mlp, mlextended_double x));
#endif

MLDECL( int,   MLPutReal32,         ( MLINK mlp, double f));
MLDECL( int,   MLPutReal64,         ( MLINK mlp, double d));
MLDECL( int,   MLPutReal128,        ( MLINK mlp, mlextended_double x));
#else
MLDECL( mlapi_result,   MLPutFloat,         ( MLINK mlp, double_nt f));
MLDECL( mlapi_result,   MLPutDouble,        ( MLINK mlp, double_nt d));
#if CC_SUPPORTS_LONG_DOUBLE
MLDECL( mlapi_result,   MLPutLongDouble,   ( MLINK mlp, extended_nt x));
#endif
#endif /* MLINTERFACE >= 3 */


#if MLINTERFACE >= 3
/*
As of MLINTERFACE 3 MLPut16BitCharacters has been deprecated.  Use the suggested function in its
place:

MLPut16BitCharacters   - MLPutUCS2Characters
*/
MLDECL( int,   MLPut16BitCharacters, ( MLINK mlp, long chars_left, const unsigned short *codes, long ncodes));
MLDECL( int,   MLPut8BitCharacters,  ( MLINK mlp, long chars_left, const unsigned char *bytes, long nbytes));
MLDECL( int,   MLPut7BitCount,       ( MLINK mlp, long count, long size));
MLDECL( int,   MLPut7BitCharacters,  ( MLINK mlp, long chars_left, const char *bytes, long nbytes, long nchars_now));

MLDECL( int,   MLPutUCS2Characters,  ( MLINK mlp, int chars_left, const unsigned short *codes, int ncodes));
MLDECL( int,   MLPutUTF8Characters,  ( MLINK mlp, int chars_left, const unsigned char *codes, int ncodes));
MLDECL( int,   MLPutUTF16Characters, ( MLINK mlp, int chars_left, const unsigned short *codes, int ncodes));
MLDECL( int,   MLPutUTF32Characters, ( MLINK mlp, int chars_left, const unsigned int *codes, int ncodes));

/*
As of MLINTERFACE 3 MLPutUnicodeString has been deprecated.  Use the suggested function in its
place:

MLPutUnicodeString - MLPutUCS2String
*/
MLDECL( int,   MLPutUnicodeString, ( MLINK mlp, const unsigned short *s, long len));
MLDECL( int,   MLPutByteString,    ( MLINK mlp, const unsigned char *s, long len));
MLDECL( int,   MLPutString,        ( MLINK mlp, const char *s));

MLDECL( int,   MLPutUCS2String,    ( MLINK mlp, const unsigned short *s, int len));
MLDECL( int,   MLPutUTF8String,    ( MLINK mlp, const unsigned char *s, int len));
MLDECL( int,   MLPutUTF16String,   ( MLINK mlp, const unsigned short *s, int len));
MLDECL( int,   MLPutUTF32String,   ( MLINK mlp, const unsigned int *s, int len));
#else
MLDECL( mlapi_result,   MLPut16BitCharacters, ( MLINK mlp, long_st chars_left, kushortp_ct codes, long_st ncodes));
MLDECL( mlapi_result,   MLPut8BitCharacters,  ( MLINK mlp, long_st chars_left, kucharp_ct bytes, long_st nbytes));
MLDECL( mlapi_result,   MLPut7BitCount,       ( MLINK mlp, long_st count, long_st size));
MLDECL( mlapi_result,   MLPut7BitCharacters,  ( MLINK mlp, long_st chars_left, kcharp_ct bytes, long_st nbytes, long_st nchars_now));

MLDECL( mlapi_result,   MLPutUnicodeString, ( MLINK mlp, kushortp_ct s, long_st len));
MLDECL( mlapi_result,   MLPutByteString,    ( MLINK mlp, kucharp_ct  s, long_st len));
MLDECL( mlapi_result,   MLPutString,        ( MLINK mlp, kcharp_ct   s));
#endif /* MLINTERFACE >= 3 */

#ifndef MLINTERFACE
/* syntax error */
#endif

#if MLINTERFACE >= 3
/*
As of MLINTERFACE 3 MLPutRealUnicodeString0 has been deprecated.  Use the suggested function in its
place:

MLPutRealUnicodeString0 - MLPutRealUCS2String0
*/
MLDECL( int,   MLPutRealUnicodeString0, ( MLINK mlp, unsigned short *s));
MLDECL( int,   MLPutRealByteString0,    ( MLINK mlp, unsigned char *s));

MLDECL( int,   MLPutRealUCS2String0,    ( MLINK mlp, unsigned short *s));
MLDECL( int,   MLPutRealUTF8String0,    ( MLINK mlp, unsigned char *s, int nbytes));
MLDECL( int,   MLPutRealUTF16String0,   ( MLINK mlp, unsigned short *s, int ncodes));
MLDECL( int,   MLPutRealUTF32String0,   ( MLINK mlp, unsigned int *s, int nchars));
#else
#if MLINTERFACE > 1
MLDECL( mlapi_result,   MLPutRealUnicodeString0, ( MLINK mlp, ushortp_ct s));
MLDECL( mlapi_result,   MLPutRealByteString0,    ( MLINK mlp, ucharp_ct  s));
#endif
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
/*
As of MLINTERFACE 3 MLPutUnicodeSymbol has been deprecated.  Use the suggested function in its
place:

MLPutUnicodeSymbol - MLPutUCS2Symbol
*/
MLDECL( int,   MLPutUnicodeSymbol, ( MLINK mlp, const unsigned short *s, long len));
MLDECL( int,   MLPutByteSymbol,    ( MLINK mlp, const unsigned char *s, long len));
MLDECL( int,   MLPutSymbol,        ( MLINK mlp, const char *s));

MLDECL( int,   MLPutUCS2Symbol,    ( MLINK mlp, const unsigned short *s, int len));
MLDECL( int,   MLPutUTF8Symbol,    ( MLINK mlp, const unsigned char *s, int len));
MLDECL( int,   MLPutUTF16Symbol,   ( MLINK mlp, const unsigned short *s, int len));
MLDECL( int,   MLPutUTF32Symbol,   ( MLINK mlp, const unsigned int *s, int len));


MLDECL( int,   MLPutFunction,      ( MLINK mlp, const char *s, int argc));
MLDECL( int,   MLPutSize,          ( MLINK mlp, int size));
MLDECL( int,   MLPutData,          ( MLINK mlp, const char *buff, int len));
#else
MLDECL( mlapi_result,   MLPutUnicodeSymbol, ( MLINK mlp, kushortp_ct s, long_st len));
MLDECL( mlapi_result,   MLPutByteSymbol,    ( MLINK mlp, kucharp_ct  s, long_st len));
MLDECL( mlapi_result,   MLPutSymbol,        ( MLINK mlp, kcharp_ct   s));
MLDECL( mlapi_result,   MLPutFunction,      ( MLINK mlp, kcharp_ct s, long_st argc));
MLDECL( mlapi_result,   MLPutSize, ( MLINK mlp, long_st size));
MLDECL( mlapi_result,   MLPutData, ( MLINK mlp, kcharp_ct buff, long_st len));
#endif /* MLINTERFACE >= 3 */


ML_END_EXTERN_C



#ifndef _MLSTRING_H
#define _MLSTRING_H



#define MAX_BYTES_PER_OLD_CHARACTER 3
#if MLINTERFACE < 3
#define MAX_BYTES_PER_NEW_CHARACTER 6
#else
#define MAX_BYTES_PER_NEW_CHARACTER 10
#endif

#define ML_MAX_BYTES_PER_CHARACTER MAX_BYTES_PER_NEW_CHARACTER

/* for source code compatibility with earlier versions of MathLink */

typedef struct {
#if MLINTERFACE >= 3
	const char *str;
	const char *end;
#else
	kcharp_ct str;
	kcharp_ct end;
#endif /* MLINTERFACE >= 3 */
} MLStringPosition;

typedef MLStringPosition FAR * MLStringPositionPointer;

#define MLStringFirstPos(s,pos) MLStringFirstPosFun( s, &(pos))

#define MLforString( s, pos) \
	for( MLStringFirstPos(s,pos); MLStringCharacter( (pos).str, (pos).end) >= 0; MLNextCharacter(&(pos).str, (pos).end))

#define MLStringChar( pos) MLStringCharacter( (pos).str, (pos).end)

#define MLPutCharToString MLConvertCharacter


/* for internal use only */

typedef struct {
#if MLINTERFACE >= 3
	unsigned char *cc;
	int  mode;
	int  more;
	unsigned char *head;
#else
	ucharp_ct cc;
	int_ct  mode;
	int_ct  more;
	ucharp_ct head;
#endif /* MLINTERFACE >= 3 */
} MLOldStringPosition;

typedef MLOldStringPosition FAR * MLOldStringPositionPointer;


#define MLOldforString( s, pos) \
  for ( MLOldStringFirstPos( s, pos); (pos).more; MLOldStringNextPos( pos))

#define MLOldStringChar(pos) \
  ( ((pos).mode <= 1) ? (uint_ct)(*(ucharp_ct)((pos).cc)) : MLOldStringCharFun( &pos) )


#define MLOldStringFirstPos(s,pos) MLOldStringFirstPosFun( s, &(pos))

#define MLOldStringNextPos(pos)  ( \
	((pos).mode == 0) \
		? ((*(*(pos).cc ? ++(pos).cc : (pos).cc) ? 0 : ((pos).more = 0)), (pos).cc) \
		: MLOldStringNextPosFun( &pos) )

#endif /* _MLSTRING_H */




/* explicitly not protected by _MLXDATA_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C
/* assumes *startp aligned on char boundary, if n == -1, returns ~(char_count) */

#if MLINTERFACE >= 3
MLDECL( long, MLCharacterOffset,           ( const char **startp, const char *end, long n));
MLDECL( long, MLStringCharacter,           ( const char * start,  const char *end));
MLDECL( long, MLNextCharacter,             ( const char **startp, const char *end));
#else
MLDECL( long, MLCharacterOffset,           ( kcharpp_ct startp, kcharp_ct end, long n));
MLDECL( long, MLStringCharacter,           ( kcharp_ct  start,  kcharp_ct end));
MLDECL( long, MLNextCharacter,             ( kcharpp_ct startp, kcharp_ct end));
#endif /* MLINTERFACE >= 3 */


#ifndef MLINTERFACE
/* syntax error */
#endif
#if MLINTERFACE > 1
#if MLINTERFACE >= 3
MLDECL( long, MLNextCharacter0,            ( const char *str, long *indexp, long len));
#else
MLDECL( long, MLNextCharacter0,            ( kcharp_ct str, longp_ct indexp, long len));
#endif /* MLINTERFACE >= 3 */
#endif

#if MLINTERFACE >= 3
MLDECL( long, MLConvertNewLine,            ( char **sp));
MLDECL( long, MLConvertCharacter,          ( unsigned long ch, char **sp));
MLDECL( long, MLConvertByteString,         ( unsigned char *codes, long len, char **strp, char *str_end));
MLDECL( long, MLConvertByteStringNL,       ( unsigned char *codes, long len, char **strp, char *str_end, unsigned long nl));
MLDECL( long, MLConvertUnicodeString,      ( unsigned short *codes, long len, char **strp, char *str_end));
MLDECL( long, MLConvertUnicodeStringNL,    ( unsigned short *codes, long len, char **strp, char *str_end, unsigned long nl));
MLDECL( long, MLConvertDoubleByteString,   ( unsigned char *codes, long len, char **strp, char *str_end));
MLDECL( long, MLConvertDoubleByteStringNL, ( unsigned char *codes, long len, char **strp, char *str_end, unsigned long nl));

MLDECL( long, MLConvertUCS2String,         ( unsigned short *codes, long len, char **strp, char *str_end));
MLDECL( long, MLConvertUCS2StringNL,       ( unsigned short *codes, long len, char **strp, char *str_end, unsigned long nl));
MLDECL( long, MLConvertUTF8String,         ( unsigned char *codes, long len, char **strp, char *str_end));
MLDECL( long, MLConvertUTF8StringNL,       ( unsigned char *codes, long len, char **strp, char *str_end, unsigned long nl));
MLDECL( long, MLConvertUTF16String,        ( unsigned short *codes, long len, char **strp, char *str_end));
MLDECL( long, MLConvertUTF16StringNL,      ( unsigned short *codes, long len, char **strp, char *str_end, unsigned long nl));
MLDECL( long, MLConvertUTF32String,        ( unsigned int *codes, long len, char **strp, char *str_end));
MLDECL( long, MLConvertUTF32StringNL,      ( unsigned int *codes, long len, char **strp, char *str_end, unsigned long nl));



#else
MLDECL( long, MLConvertNewLine,            ( charpp_ct sp));
MLDECL( long, MLConvertCharacter,          ( ulong_ct ch, charpp_ct sp));
MLDECL( long, MLConvertByteString,         ( ucharp_ct  codes, long len, charpp_ct strp, charp_ct str_end));
MLDECL( long, MLConvertByteStringNL,       ( ucharp_ct  codes, long len, charpp_ct strp, charp_ct str_end, ulong_ct nl));
MLDECL( long, MLConvertUnicodeString,      ( ushortp_ct codes, long len, charpp_ct strp, charp_ct str_end));
MLDECL( long, MLConvertUnicodeStringNL,    ( ushortp_ct codes, long len, charpp_ct strp, charp_ct str_end, ulong_ct nl));
MLDECL( long, MLConvertDoubleByteString,   ( ucharp_ct  codes, long len, charpp_ct strp, charp_ct str_end));
MLDECL( long, MLConvertDoubleByteStringNL, ( ucharp_ct  codes, long len, charpp_ct strp, charp_ct str_end, ulong_ct nl));
#endif /* MLINTERFACE >= 3 */







/* for source code compatibility with earlier versions of MathLink */
#if MLINTERFACE >= 3
MLDECL( const char *,     MLStringFirstPosFun,  ( const char *s, MLStringPositionPointer p));
#else
MLDECL( kcharp_ct,        MLStringFirstPosFun,  ( kcharp_ct s, MLStringPositionPointer p));
#endif /* MLINTERFACE >= 3 */

/* for internal use only */
#if MLINTERFACE >= 3
MLDECL( int,                MLOldPutCharToString,      ( unsigned int ch, char **sp));
MLDECL( unsigned char *,    MLOldStringNextPosFun,     ( MLOldStringPositionPointer p));
MLDECL( unsigned char *,    MLOldStringFirstPosFun,    ( char *s, MLOldStringPositionPointer p));
MLDECL( unsigned int,       MLOldStringCharFun,        ( MLOldStringPositionPointer p));
MLDECL( long,               MLOldConvertByteString,    ( unsigned char *codes, long len, char **strp, char *str_end));
MLDECL( long,               MLOldConvertUnicodeString, ( unsigned short *codes, long len, char **strp, char *str_end));

MLDECL( long,               MLOldConvertUCS2String,    ( unsigned short *codes, long len, char **strp, char *str_end));
#else
MLDECL( mlapi_result,       MLOldPutCharToString,      ( uint_ct ch, charpp_ct sp));
MLDECL( ucharp_ct,          MLOldStringNextPosFun,     ( MLOldStringPositionPointer p));
MLDECL( ucharp_ct,          MLOldStringFirstPosFun,    ( charp_ct s, MLOldStringPositionPointer p));
MLDECL( uint_ct,            MLOldStringCharFun,        ( MLOldStringPositionPointer p));
MLDECL( long,               MLOldConvertByteString,    ( ucharp_ct  codes, long len, charpp_ct strp, charp_ct str_end));
MLDECL( long,               MLOldConvertUnicodeString, ( ushortp_ct codes, long len, charpp_ct strp, charp_ct str_end));
#endif /* MLINTERFACE >= 3 */

ML_END_EXTERN_C


#ifndef _MLCAPUT_H
#define _MLCAPUT_H

#ifndef MLINTERFACE
/* syntax error */
#endif

#ifndef __array_meterp__
#define __array_meterp__
typedef struct array_meter FAR * array_meterp;
typedef array_meterp FAR * array_meterpp;
#endif


#if MLINTERFACE < 3
#define MLPutRealArray MLPutDoubleArray
#endif

#endif /* _MLCAPUT_H */


/* explicitly not protected by _MLCAPUT_H in case MLDECL is redefined for multiple inclusion */

/*bugcheck: bugcheck need FAR here */
ML_EXTERN_C
#if MLINTERFACE >= 3
MLDECL( int,   MLPutArray,                  ( MLINK mlp, array_meterp meterp));
#else
MLDECL( mlapi_result,   MLPutArray,                  ( MLINK mlp, array_meterp meterp));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
MLDECL( int,   MLPutBinaryNumberArrayData,  ( MLINK mlp, array_meterp meterp, void *         datap, long count, long type));
MLDECL( int,   MLPutByteArrayData,          ( MLINK mlp, array_meterp meterp, unsigned char *datap, long count));

/* 
As of MLINTERFACE 3 the following functions have been deprecated.  Use the following new functions as their replacement:

MLPutShortIntegerArrayData  - MLPutInteger16ArrayData
MLPutIntegerArrayData       - MLPutInteger32ArrayData
MLPutLongIntegerArrayData   - MLPutInteger64ArrayData for 64-bit integers or MLPutInteger32ArrayData for 32-bit integers
*/
MLDECL( int,   MLPutShortIntegerArrayData,  ( MLINK mlp, array_meterp meterp, short *        datap, long count));
MLDECL( int,   MLPutIntegerArrayData,       ( MLINK mlp, array_meterp meterp, int *          datap, long count));
MLDECL( int,   MLPutLongIntegerArrayData,   ( MLINK mlp, array_meterp meterp, long *         datap, long count));

MLDECL( int,   MLPutInteger16ArrayData,     ( MLINK mlp, array_meterp meterp, short *        datap, int count));
MLDECL( int,   MLPutInteger32ArrayData,     ( MLINK mlp, array_meterp meterp, int *          datap, int count));
MLDECL( int,   MLPutInteger64ArrayData,     ( MLINK mlp, array_meterp meterp, mlint64 *      datap, int count));
#else
MLDECL( mlapi_result,   MLPutBinaryNumberArrayData,  ( MLINK mlp, array_meterp meterp, voidp_ct     datap, long_st count, long type));
MLDECL( mlapi_result,   MLPutByteArrayData,          ( MLINK mlp, array_meterp meterp, ucharp_nt    datap, long_st count));
MLDECL( mlapi_result,   MLPutShortIntegerArrayData,  ( MLINK mlp, array_meterp meterp, shortp_nt    datap, long_st count));
MLDECL( mlapi_result,   MLPutIntegerArrayData,       ( MLINK mlp, array_meterp meterp, intp_nt      datap, long_st count));
MLDECL( mlapi_result,   MLPutLongIntegerArrayData,   ( MLINK mlp, array_meterp meterp, longp_nt     datap, long_st count));
#endif /* MLINTERFACE >= 3 */


#if MLINTERFACE >= 3
/* 
As of MLINTERFACE 3 the following functions have been deprecated.  Use the following new functions as their replacement:

MLPutFloatArrayData      - MLPutReal32ArrayData
MLPutDoubleArrayData     - MLPutReal64ArrayData
MLPutLongDoubleArrayData - MLPutReal128ArrayData
*/
MLDECL( int,   MLPutFloatArrayData,         ( MLINK mlp, array_meterp meterp, float * datap, long count));
MLDECL( int,   MLPutDoubleArrayData,        ( MLINK mlp, array_meterp meterp, double *datap, long count));
#if CC_SUPPORTS_LONG_DOUBLE
MLDECL( int,   MLPutLongDoubleArrayData,    ( MLINK mlp, array_meterp meterp, mlextended_double *datap, long count));
#endif

MLDECL( int,   MLPutReal32ArrayData,        ( MLINK mlp, array_meterp meterp, float * datap, int count));
MLDECL( int,   MLPutReal64ArrayData,        ( MLINK mlp, array_meterp meterp, double *datap, int count));
MLDECL( int,   MLPutReal128ArrayData,       ( MLINK mlp, array_meterp meterp, mlextended_double *datap, int count));
#else
MLDECL( mlapi_result,   MLPutFloatArrayData,         ( MLINK mlp, array_meterp meterp, floatp_nt    datap, long_st count));
MLDECL( mlapi_result,   MLPutDoubleArrayData,        ( MLINK mlp, array_meterp meterp, doublep_nt   datap, long_st count));
#if CC_SUPPORTS_LONG_DOUBLE
MLDECL( mlapi_result,   MLPutLongDoubleArrayData,   ( MLINK mlp, array_meterp meterp, extendedp_nt datap, long_st count));
#endif
#endif /* MLINTERFACE >= 3 */


#if MLINTERFACE >= 3
MLDECL( int,   MLPutBinaryNumberArray,  ( MLINK mlp, void *         data, long *dimp, char **heads, long depth, long type));
MLDECL( int,   MLPutByteArray,          ( MLINK mlp, unsigned char *data, long *dims, char **heads, long depth));

/* 
As of MLINTERFACE 3 the following functions have been deprecated.  Use the following new functions as their replacement:

MLPutShortIntegerArray  - MLPutInteger16Array
MLPutIntegerArray       - MLPutInteger32Array
MLPutLongIntegerArray   - MLPutInteger64Array for 64-bit integers or MLPutInteger32Array for 32-bit integers
*/
MLDECL( int,   MLPutShortIntegerArray,  ( MLINK mlp, short *        data, long *dims, char **heads, long depth));
MLDECL( int,   MLPutIntegerArray,       ( MLINK mlp, int *          data, long *dims, char **heads, long depth));
MLDECL( int,   MLPutLongIntegerArray,   ( MLINK mlp, long *         data, long *dims, char **heads, long depth));

MLDECL( int,   MLPutInteger16Array,     ( MLINK mlp, short *        data, int *dims, char **heads, int depth));
MLDECL( int,   MLPutInteger32Array,     ( MLINK mlp, int *          data, int *dims, char **heads, int depth));
MLDECL( int,   MLPutInteger64Array,     ( MLINK mlp, mlint64 *      data, int *dims, char **heads, int depth));
#else
MLDECL( mlapi_result,   MLPutBinaryNumberArray,  ( MLINK mlp, voidp_ct     data, longp_st dimp, charpp_ct heads, long_st depth, long type));
MLDECL( mlapi_result,   MLPutByteArray,          ( MLINK mlp, ucharp_nt    data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( mlapi_result,   MLPutShortIntegerArray,  ( MLINK mlp, shortp_nt    data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( mlapi_result,   MLPutIntegerArray,       ( MLINK mlp, intp_nt      data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( mlapi_result,   MLPutLongIntegerArray,   ( MLINK mlp, longp_nt     data, longp_st dims, charpp_ct heads, long_st depth));
#endif /* MLINTERFACE >= 3 */



#if MLINTERFACE >= 3
/* 
As of MLINTERFACE 3 the following functions have been deprecated.  Use the following new functions as their replacement:

MLPutFloatArray      - MLPutReal32Array
MLPutDoubleArray     - MLPutReal64Array
MLPutRealArray       - MLPutReal64Array
MLPUtLongDoubleArray - MLPutReal128Array
*/
MLDECL( int,   MLPutFloatArray,         ( MLINK mlp, float * data, long *dims, char **heads, long depth));
MLDECL( int,   MLPutDoubleArray,        ( MLINK mlp, double *data, long *dims, char **heads, long depth));
MLDECL( int,   MLPutRealArray,          ( MLINK mlp, double *data, long *dims, char **heads, long depth));
#if CC_SUPPORTS_LONG_DOUBLE
MLDECL( int,   MLPutLongDoubleArray,    ( MLINK mlp, mlextended_double *data, long *dims, char **heads, long depth));
#endif

MLDECL( int,   MLPutReal32Array,        ( MLINK mlp, float * data, int *dims, char **heads, int depth));
MLDECL( int,   MLPutReal64Array,        ( MLINK mlp, double *data, int *dims, char **heads, int depth));
MLDECL( int,   MLPutReal128Array,       ( MLINK mlp, mlextended_double *data, int *dims, char **heads, int depth));
#else
MLDECL( mlapi_result,   MLPutFloatArray,         ( MLINK mlp, floatp_nt    data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( mlapi_result,   MLPutDoubleArray,        ( MLINK mlp, doublep_nt   data, longp_st dims, charpp_ct heads, long_st depth));
#if CC_SUPPORTS_LONG_DOUBLE
MLDECL( mlapi_result,   MLPutLongDoubleArray,   ( MLINK mlp, extendedp_nt data, longp_st dims, charpp_ct heads, long_st depth));
#endif
#endif /* MLINTERFACE >= 3 */


#if MLINTERFACE >= 3
MLDECL( int,   MLPutBinaryNumberList, ( MLINK mlp, void *  data, long count, long type));

/* 
As of MLINTERFACE 3 the following functions have been deprecated.  Use the following new functions as their replacement:

MLPutIntegerList  - MLPutInteger32List
MLPutRealList     - MLPutReal64List
*/
MLDECL( int,   MLPutIntegerList,      ( MLINK mlp, int *   data, long count));
MLDECL( int,   MLPutRealList,         ( MLINK mlp, double *data, long count));

MLDECL( int,   MLPutInteger16List,    ( MLINK mlp, short *   data, int count));
MLDECL( int,   MLPutInteger32List,    ( MLINK mlp, int *     data, int count));
MLDECL( int,   MLPutInteger64List,    ( MLINK mlp, mlint64 * data, int count));

MLDECL( int,   MLPutReal32List,       ( MLINK mlp, float * data, int count));
MLDECL( int,   MLPutReal64List,       ( MLINK mlp, double *data, int count));
MLDECL( int,   MLPutReal128List,      ( MLINK mlp, mlextended_double *data, int count));
#else
MLDECL( mlapi_result,   MLPutBinaryNumberList, ( MLINK mlp, voidp_ct   data, long_st count, long type));
MLDECL( mlapi_result,   MLPutIntegerList,      ( MLINK mlp, intp_nt    data, long_st count));
MLDECL( mlapi_result,   MLPutRealList,         ( MLINK mlp, doublep_nt data, long_st count));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
MLDECL( int, MLPutArrayType0,             ( MLINK mlp, MLINK heads, long depth, array_meterpp meterpp));
MLDECL( int, MLReleasePutArrayState0,     ( MLINK mlp, MLINK heads, array_meterp meterp));
#else
MLDECL( mlapi_result, MLPutArrayType0,             ( MLINK mlp, MLINK heads, long depth, array_meterpp meterpp));
MLDECL( mlapi_result, MLReleasePutArrayState0,     ( MLINK mlp, MLINK heads, array_meterp meterp));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
MLDECL( int, MLPutBinaryNumberArrayData0, ( MLINK mlp, MLINK heads, array_meterp meterp, void *datap, long count, long type));
MLDECL( int, MLPutArrayLeaves0,           ( MLINK mlp, MLINK heads, array_meterp meterp, MLINK leaves, long count));
#else
#if MLINTERFACE > 1
MLDECL( mlapi_result, MLPutBinaryNumberArrayData0, ( MLINK mlp, MLINK heads, array_meterp meterp, voidp_ct datap, long_st count, long type));
MLDECL( mlapi_result, MLPutArrayLeaves0,           ( MLINK mlp, MLINK heads, array_meterp meterp, MLINK leaves, long_st count));
#endif /* mMLINTERFACE >= 1 */
#endif /* MLINTERFACE >= 3 */


ML_END_EXTERN_C


#ifndef _MLCAGET_H
#define _MLCAGET_H

#ifndef MLINTERFACE
/* syntax error */
#endif

#ifndef __array_meterp__
#define __array_meterp__
typedef struct array_meter FAR * array_meterp;
typedef array_meterp FAR * array_meterpp;
#endif


#if MLINTERFACE < 3
#define MLGetRealArray    MLGetDoubleArray
#define MLDisownRealArray MLDisownDoubleArray
#endif

#endif /* _MLCAGET_H */



/* explicitly not protected by _MLCAGET_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C

#if MLINTERFACE >= 3
MLDECL( int,   MLGetArrayDimensions,       ( MLINK mlp, array_meterp meterp));
MLDECL( int,   MLGetArrayType,             ( MLINK mlp, array_meterp meterp));
#else
MLDECL( mlapi_result,   MLGetArrayDimensions,       ( MLINK mlp, array_meterp meterp));
MLDECL( mlapi_token,    MLGetArrayType,             ( MLINK mlp, array_meterp meterp));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
MLDECL( int,  MLGetBinaryNumberList, ( MLINK mlp, void **datap, long *countp, long type));

/*
As of MLINTERFACE 3 the following functions have been deprecated.  Use the suggested functions in their
place:

MLGetIntegerList  - MLGetInteger32List
MLGetRealList     - MLGetReal64List
*/
MLDECL( int,  MLGetIntegerList,      ( MLINK mlp, int **datap, long *countp));
MLDECL( int,  MLGetRealList,         ( MLINK mlp, double **datap, long *countp));

MLDECL( int,  MLGetInteger16List,      ( MLINK mlp, short **   datap, int *countp));
MLDECL( int,  MLGetInteger32List,      ( MLINK mlp, int **     datap, int *countp));
MLDECL( int,  MLGetInteger64List,      ( MLINK mlp, mlint64 ** datap, int *countp));

MLDECL( int,  MLGetReal32List,         ( MLINK mlp, float **                 datap, int *countp));
MLDECL( int,  MLGetReal64List,         ( MLINK mlp, double **                datap, int *countp));
MLDECL( int,  MLGetReal128List,         ( MLINK mlp, mlextended_double **    datap, int *countp));

/*
As of MLINTERFACE 3 the following functions have been deprecated.  Use the suggested functions in their
place:

MLDisownBinaryNumberList  - MLReleaseBinaryNumberList
MLDisownIntegerList       - MLReleaseInteger32List
MLDisownRealList          - MLReleaseReal64List
*/
MLDECL( void, MLDisownBinaryNumberList, ( MLINK mlp, void *data, long count, long type));
MLDECL( void, MLDisownIntegerList,      ( MLINK mlp, int *data, long count));
MLDECL( void, MLDisownRealList,         ( MLINK mlp, double *data, long count));

MLDECL( void, MLReleaseBinaryNumberList,   ( MLINK mlp, void *data, int count, long type));
MLDECL( void, MLReleaseInteger16List,      ( MLINK mlp, short *data, int count));
MLDECL( void, MLReleaseInteger32List,      ( MLINK mlp, int *data, int count));
MLDECL( void, MLReleaseInteger64List,      ( MLINK mlp, mlint64 *data, int count));

MLDECL( void, MLReleaseReal32List,         ( MLINK mlp, float *data, int count));
MLDECL( void, MLReleaseReal64List,         ( MLINK mlp, double *data, int count));
MLDECL( void, MLReleaseReal128List,        ( MLINK mlp, mlextended_double *data, int count));

MLDECL( int,   MLGetBinaryNumberArrayData,  ( MLINK mlp, array_meterp meterp, void *datap, long count, long type));
MLDECL( int,   MLGetByteArrayData,          ( MLINK mlp, array_meterp meterp, unsigned char * datap, long count));

/*
As of MLINTERFACE 3 the following functions have been deprecated.  Use the suggested functions in their
place:

MLGetShortIntegerArrayData  - MLGetInteger16ArrayData
MLGetIntegerArrayData       - MLGetInteger32ArrayData
MLGetLongIntegerArrayData   - MLGetInteger64ArrayData for 64-bit integers or MLGetInteger32ArrayData for 32-bit integers.
*/
MLDECL( int,   MLGetShortIntegerArrayData,  ( MLINK mlp, array_meterp meterp, short *         datap, long count));
MLDECL( int,   MLGetIntegerArrayData,       ( MLINK mlp, array_meterp meterp, int *           datap, long count));
MLDECL( int,   MLGetLongIntegerArrayData,   ( MLINK mlp, array_meterp meterp, long *          datap, long count));

MLDECL( int,   MLGetInteger16ArrayData,     ( MLINK mlp, array_meterp meterp, short *         datap, int count));
MLDECL( int,   MLGetInteger32ArrayData,     ( MLINK mlp, array_meterp meterp, int *           datap, int count));
MLDECL( int,   MLGetInteger64ArrayData,     ( MLINK mlp, array_meterp meterp, mlint64 *       datap, int count));
#else
MLDECL( mlapi_result,  MLGetBinaryNumberList, ( MLINK mlp, voidpp_ct   datap, longp_st countp, long type));
MLDECL( mlapi_result,  MLGetIntegerList,      ( MLINK mlp, intpp_nt    datap, longp_st countp));
MLDECL( mlapi_result,  MLGetRealList,         ( MLINK mlp, doublepp_nt datap, longp_st countp));

MLDECL( void, MLDisownBinaryNumberList, ( MLINK mlp, voidp_ct   data, long_st count, long type));
MLDECL( void, MLDisownIntegerList,      ( MLINK mlp, intp_nt    data, long_st count));
MLDECL( void, MLDisownRealList,         ( MLINK mlp, doublep_nt data, long_st count));

MLDECL( mlapi_result,   MLGetBinaryNumberArrayData,  ( MLINK mlp, array_meterp meterp, voidp_ct     datap, long_st count, long type));
MLDECL( mlapi_result,   MLGetByteArrayData,          ( MLINK mlp, array_meterp meterp, ucharp_nt    datap, long_st count));
MLDECL( mlapi_result,   MLGetShortIntegerArrayData,  ( MLINK mlp, array_meterp meterp, shortp_nt    datap, long_st count));
MLDECL( mlapi_result,   MLGetIntegerArrayData,       ( MLINK mlp, array_meterp meterp, intp_nt      datap, long_st count));
MLDECL( mlapi_result,   MLGetLongIntegerArrayData,   ( MLINK mlp, array_meterp meterp, longp_nt     datap, long_st count));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
/*
As of MLINTERFACE 3 the following functions have been deprecated.  Use the suggested functions in their
place:

MLGetFloatArrayData        - MLGetReal32ArrayData
MLGetDoubleArrayData       - MLGetReal64ArrayData
MLGetLongDoubleArrayData   - MLGetReal128ArrayData
*/
MLDECL( int,   MLGetFloatArrayData,         ( MLINK mlp, array_meterp meterp, float *datap, long count));
MLDECL( int,   MLGetDoubleArrayData,        ( MLINK mlp, array_meterp meterp, double *datap, long count));
#if CC_SUPPORTS_LONG_DOUBLE
MLDECL( int,   MLGetLongDoubleArrayData,   ( MLINK mlp, array_meterp meterp, mlextended_double *datap, long count));
#endif

MLDECL( int,   MLGetReal32ArrayData,         ( MLINK mlp, array_meterp meterp, float *datap, int count));
MLDECL( int,   MLGetReal64ArrayData,        ( MLINK mlp, array_meterp meterp, double *datap, int count));
MLDECL( int,   MLGetReal128ArrayData,   ( MLINK mlp, array_meterp meterp, mlextended_double *datap, int count));
#else
MLDECL( mlapi_result,   MLGetFloatArrayData,         ( MLINK mlp, array_meterp meterp, floatp_nt    datap, long_st count));
MLDECL( mlapi_result,   MLGetDoubleArrayData,        ( MLINK mlp, array_meterp meterp, doublep_nt   datap, long_st count));

#if CC_SUPPORTS_LONG_DOUBLE
MLDECL( mlapi_result,   MLGetLongDoubleArrayData,   ( MLINK mlp, array_meterp meterp, extendedp_nt datap, long_st count));
#endif

#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
MLDECL( int,   MLGetArrayType0,             ( MLINK mlp, MLINK heads, array_meterpp meterpp, long *depthp, mlapi__token *leaf_tokp));
MLDECL( int,   MLGetBinaryNumberArrayData0, ( MLINK mlp, MLINK heads, array_meterp  meterp, void *datap, long *countp, long type));
MLDECL( void,  MLReleaseGetArrayState0,     ( MLINK mlp, MLINK heads, array_meterp  meterp));

MLDECL( int,   MLGetBinaryNumberArray0,   ( MLINK mlp, void **datap, long **dimpp, char ***headsp, long *depthp, long type, mlapi__token *leaf_tokp));
#else
#if MLINTERFACE > 1
MLDECL( mlapi_result,   MLGetArrayType0,             ( MLINK mlp, MLINK heads, array_meterpp meterpp, longp_st depthp, mlapi__tokenp leaf_tokp));
MLDECL( mlapi_result,   MLGetBinaryNumberArrayData0, ( MLINK mlp, MLINK heads, array_meterp  meterp, voidp_ct datap, longp_st countp, long type));
MLDECL( void,           MLReleaseGetArrayState0,     ( MLINK mlp, MLINK heads, array_meterp  meterp));

MLDECL( mlapi_result,   MLGetBinaryNumberArray0,   ( MLINK mlp, voidpp_ct     datap, longpp_st dimpp, charppp_ct headsp, longp_st depthp, long type, mlapi__tokenp leaf_tokp));
#endif /* MLINTERFACE > 1 */
#endif /* MLINTERFACE >= 3 */


#if MLINTERFACE >= 3
MLDECL( int,   MLGetBinaryNumberArray,    ( MLINK mlp, void **          datap, long **dimpp, char ***headsp, long *depthp, long type));
MLDECL( int,   MLGetByteArray,            ( MLINK mlp, unsigned char ** datap, long **dimsp, char ***headsp, long *depthp));

/*
As of MLINTERFACE 3 the following functions have been deprecated.  Use the suggested functions in their
place:

MLGetShortIntegerArray   - MLGetInteger16Array
MLGetIntegerArray        - MLGetInteger32Array
MLGetLongIntegerArray    - MLGetInteger64Array for 64-bit integers or MLGetInteger32Array from 32-bit integers.
*/
MLDECL( int,   MLGetShortIntegerArray,    ( MLINK mlp, short **         datap, long **dimsp, char ***headsp, long *depthp));
MLDECL( int,   MLGetIntegerArray,         ( MLINK mlp, int **           datap, long **dimsp, char ***headsp, long *depthp));
MLDECL( int,   MLGetLongIntegerArray,     ( MLINK mlp, long **          datap, long **dimsp, char ***headsp, long *depthp));

MLDECL( int,   MLGetInteger16Array,       ( MLINK mlp, short **         datap, int **dimsp, char ***headsp, int *depthp));
MLDECL( int,   MLGetInteger32Array,       ( MLINK mlp, int **           datap, int **dimsp, char ***headsp, int *depthp));
MLDECL( int,   MLGetInteger64Array,       ( MLINK mlp, mlint64 **       datap, int **dimsp, char ***headsp, int *depthp));
#else
MLDECL( mlapi_result,   MLGetBinaryNumberArray,    ( MLINK mlp, voidpp_ct     datap, longpp_st dimpp, charppp_ct headsp, longp_st depthp, long type));
MLDECL( mlapi_result,   MLGetByteArray,            ( MLINK mlp, ucharpp_nt    datap, longpp_st dimsp, charppp_ct headsp, longp_st depthp));
MLDECL( mlapi_result,   MLGetShortIntegerArray,    ( MLINK mlp, shortpp_nt    datap, longpp_st dimsp, charppp_ct headsp, longp_st depthp));
MLDECL( mlapi_result,   MLGetIntegerArray,         ( MLINK mlp, intpp_nt      datap, longpp_st dimsp, charppp_ct headsp, longp_st depthp));
MLDECL( mlapi_result,   MLGetLongIntegerArray,     ( MLINK mlp, longpp_nt     datap, longpp_st dimsp, charppp_ct headsp, longp_st depthp));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
/*
As of MLINTERFACE 3 the following functions have been deprecated.  Use the suggested functions in their
place:

MLGetFloatArray      - MLGetReal32Array
MLGetDoubleArray     - MLGetReal64Array
MLGetRealArray       - MLGetReal64Array
MLGetLongDoubleArray - MLGetReal128Array
*/
MLDECL( int,   MLGetFloatArray,           ( MLINK mlp, float ** datap, long **dimsp, char ***headsp, long *depthp));
MLDECL( int,   MLGetDoubleArray,          ( MLINK mlp, double **datap, long **dimsp, char ***headsp, long *depthp));
MLDECL( int,   MLGetRealArray,            ( MLINK mlp, double **datap, long **dimsp, char ***headsp, long *depthp));
#if CC_SUPPORTS_LONG_DOUBLE
MLDECL( int,   MLGetLongDoubleArray,      ( MLINK mlp, mlextended_double **datap, long **dimsp, char ***headsp, long *depthp));
#endif

MLDECL( int,   MLGetReal32Array,          ( MLINK mlp, float ** datap, int **dimsp, char ***headsp, int *depthp));
MLDECL( int,   MLGetReal64Array,          ( MLINK mlp, double **datap, int **dimsp, char ***headsp, int *depthp));
MLDECL( int,   MLGetReal128Array,         ( MLINK mlp, mlextended_double **datap, int **dimsp, char ***headsp, int *depthp));
#else
MLDECL( mlapi_result,   MLGetDoubleArray,          ( MLINK mlp, doublepp_nt   datap, longpp_st dimsp, charppp_ct headsp, longp_st depthp));
MLDECL( mlapi_result,   MLGetFloatArray,           ( MLINK mlp, floatpp_nt    datap, longpp_st dimsp, charppp_ct headsp, longp_st depthp));
#if CC_SUPPORTS_LONG_DOUBLE
MLDECL( mlapi_result,   MLGetLongDoubleArray,      ( MLINK mlp, extendedpp_nt datap, longpp_st dimsp, charppp_ct headsp, longp_st depthp));
#endif
#endif /* MLINTERFACE >= 3*/


#if MLINTERFACE >= 3
/* 
As of MLINTERFACE 3 the following functions have been deprecated.  Use the following new functions as their replacement:

MLDisownBinaryNumberArray - MLReleaseBinaryNumberArray
MLDisownByteArray         - MLReleaseByteArray
MLDisownShortIntegerArray - MLReleaseInteger16Array
MLDisownIntegerArray      - MLReleaseInteger32Array
MLDisownLongIntegerArray  - Use MLReleaseInteger32Array for 32-bit integers or MLReleaseInteger64Array for 64-bit integers.
*/
MLDECL( void,           MLDisownBinaryNumberArray,  ( MLINK mlp, void *         data, long *dimp, char **heads, long len, long type));
MLDECL( void,           MLDisownByteArray,          ( MLINK mlp, unsigned char *data, long *dims, char **heads, long depth));
MLDECL( void,           MLDisownShortIntegerArray,  ( MLINK mlp, short *        data, long *dims, char **heads, long depth));
MLDECL( void,           MLDisownIntegerArray,       ( MLINK mlp, int *          data, long *dims, char **heads, long depth));
MLDECL( void,           MLDisownLongIntegerArray,   ( MLINK mlp, long *         data, long *dims, char **heads, long depth));


MLDECL( void,           MLReleaseBinaryNumberArray,  ( MLINK mlp, void *         data, int *dimp, char **heads, int len, long type));
MLDECL( void,           MLReleaseByteArray,          ( MLINK mlp, unsigned char *data, int *dims, char **heads, int depth));
MLDECL( void,           MLReleaseInteger16Array,     ( MLINK mlp, short *        data, int *dims, char **heads, int depth));
MLDECL( void,           MLReleaseInteger32Array,     ( MLINK mlp, int *          data, int *dims, char **heads, int depth));
MLDECL( void,           MLReleaseInteger64Array,     ( MLINK mlp, mlint64 *      data, int *dims, char **heads, int depth));
#else
MLDECL( void,           MLDisownBinaryNumberArray,  ( MLINK mlp, voidp_ct     data, longp_st dimp, charpp_ct heads, long_st len, long type));
MLDECL( void,           MLDisownByteArray,          ( MLINK mlp, ucharp_nt    data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( void,           MLDisownShortIntegerArray,  ( MLINK mlp, shortp_nt    data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( void,           MLDisownIntegerArray,       ( MLINK mlp, intp_nt      data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( void,           MLDisownLongIntegerArray,   ( MLINK mlp, longp_nt     data, longp_st dims, charpp_ct heads, long_st depth));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
#endif

#if MLINTERFACE >= 3
/* 
As of MLINTERFACE 3 the following functions have been deprecated.  Use the following new functions as their replacement:

MLDisownFloatArray  - MLReleaseReal32Array
MLDisownDoubleArray - MLReleaseReal64Array
MLDisownRealArray   - MLReleaseReal64Array
*/
MLDECL( void,           MLDisownFloatArray,         ( MLINK mlp, float * data, long *dims, char **heads, long depth));
MLDECL( void,           MLDisownDoubleArray,        ( MLINK mlp, double *data, long *dims, char **heads, long depth));
MLDECL( void,           MLDisownRealArray,          ( MLINK mlp, double *data, long *dims, char **heads, long depth));

MLDECL( void,           MLReleaseReal32Array,         ( MLINK mlp, float * data, int *dims, char **heads, int depth));
MLDECL( void,           MLReleaseReal64Array,          ( MLINK mlp, double *data, int *dims, char **heads, int depth));
#else
MLDECL( void,           MLDisownFloatArray,         ( MLINK mlp, floatp_nt    data, longp_st dims, charpp_ct heads, long_st depth));
MLDECL( void,           MLDisownDoubleArray,        ( MLINK mlp, doublep_nt   data, longp_st dims, charpp_ct heads, long_st depth));
#endif /* MLINTERFACE >= 3 */


#if CC_SUPPORTS_LONG_DOUBLE
#if MLINTERFACE >= 3
/* 
As of MLINTERFACE 3 the following functions have been deprecated.  Use the following new functions as their replacement:

MLDisownLongDoubleArray - MLReleaseReal128Array
*/
MLDECL( void,           MLDisownLongDoubleArray,   ( MLINK mlp, mlextended_double *data, long *dims, char **heads, long depth));

MLDECL( void,           MLReleaseReal128Array,     ( MLINK mlp, mlextended_double *data, int *dims, char **heads, int depth));
#else
MLDECL( void,           MLDisownLongDoubleArray,   ( MLINK mlp, extendedp_nt data, longp_st dims, charpp_ct heads, long_st depth));
#endif /* MLINTERFACE >= 3 */
#endif /* CC_SUPPORTS_LONG_DOUBLE */


ML_END_EXTERN_C


/*************** seeking, transfering  and synchronization ***************/

#ifndef _MLMARK_H
#define _MLMARK_H


#endif /* _MLMARK_H */

/* explicitly not protected by _MLMARK_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C
MLDECL( MLINKMark,  MLCreateMark,  ( MLINK mlp));
#if MLINTERFACE >= 3
MLDECL( MLINKMark,  MLSeekToMark,  ( MLINK mlp, MLINKMark mark, int index));
MLDECL( MLINKMark,  MLSeekMark,    ( MLINK mlp, MLINKMark mark, int index));
#else
MLDECL( MLINKMark,  MLSeekToMark,  ( MLINK mlp, MLINKMark mark, long index));
MLDECL( MLINKMark,  MLSeekMark,    ( MLINK mlp, MLINKMark mark, long index));
#endif /* MLINTERFACE >= 3 */
MLDECL( void,       MLDestroyMark, ( MLINK mlp, MLINKMark mark));
ML_END_EXTERN_C


#ifndef _MLXFER_H
#define _MLXFER_H


#endif /* _MLXFER_H */

/* explicitly not protected by _MLXFER_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C

#ifndef MLINTERFACE
/* syntax error */
#endif

#if MLINTERFACE >= 3
MLDECL( int, MLTransferExpression, ( MLINK dmlp, MLINK smlp));
MLDECL( int, MLTransferToEndOfLoopbackLink, ( MLINK dmlp, MLINK smlp));
#else
MLDECL( mlapi_result, MLTransferExpression, ( MLINK dmlp, MLINK smlp));
MLDECL( mlapi_result, MLTransferToEndOfLoopbackLink, ( MLINK dmlp, MLINK smlp));
#endif /* MLINTERFACE >= 3 */


#if MLINTERFACE > 1
#if MLINTERFACE >= 3
MLDECL( int, MLTransfer0, ( MLINK dmlp, MLINK smlp, unsigned long sequence_no));
#else
MLDECL( mlapi_result, MLTransfer0, ( MLINK dmlp, MLINK smlp, ulong_ct sequence_no));
#endif /* MLINTERFACE >= 3 */
#else
static mlapi_result MLTransfer0 (MLINK dmlp, MLINK smlp, ulong_ct sequence_no);
#endif
ML_END_EXTERN_C


#ifndef _MLSYNC_H
#define _MLSYNC_H


/* export mls__wait and mls__align(mlsp) */

#endif /* _MLSYNC_H */

/* explicitly not protected by _MLSYNC_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C
/* in response to a reset message */
#if MLINTERFACE >= 3
MLDECL( int, MLForwardReset, ( MLINK mlp, unsigned long marker));
#else
MLDECL( mlapi_result, MLForwardReset, ( MLINK mlp, ulong_ct marker));
#endif /* MLINTERFACE >= 3 */


#if MLINTERFACE >= 3
MLDECL( int, MLAlign,        ( MLINK lmlp, MLINK rmlp));
#else
MLDECL( mlapi_result, MLAlign,        ( MLINK lmlp, MLINK rmlp));
#endif /* MLINTERFACE >= 3 */
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

/* explicitly not protected by _MLPKT_H in case MLDECL is redefined for multiple inclusion */

ML_EXTERN_C
#if MLINTERFACE >= 3
MLDECL( int,  MLNextPacket, ( MLINK mlp));
#else
MLDECL( mlapi_packet,  MLNextPacket, ( MLINK mlp));
#endif /* MLINTERFACE >= 3 */
ML_END_EXTERN_C


#ifndef _MLALERT_H
#define _MLALERT_H


ML_EXTERN_C
/*************** User interaction--for internal use only ***************/

#if WIN64_MATHLINK
typedef __int64 mldlg_result;
#else
typedef long mldlg_result;
#endif

#if MLINTERFACE >= 3
MLDPROC( mldlg_result, MLAlertProcPtr,             ( MLEnvironment env, const char *message));
MLDPROC( mldlg_result, MLRequestProcPtr,           ( MLEnvironment env, const char *prompt, char *response, long sizeof_response));
MLDPROC( mldlg_result, MLConfirmProcPtr,           ( MLEnvironment env, const char *question, mldlg_result default_answer));
MLDPROC( mldlg_result, MLRequestArgvProcPtr,       ( MLEnvironment env, char **argv, long cardof_argv, char *buf, long sizeof_buf));
#else
MLDPROC( mldlg_result, MLAlertProcPtr,             ( MLEnvironment env, kcharp_ct message));
MLDPROC( mldlg_result, MLRequestProcPtr,           ( MLEnvironment env, kcharp_ct prompt, charp_ct response, long sizeof_response));
MLDPROC( mldlg_result, MLConfirmProcPtr,           ( MLEnvironment env, kcharp_ct question, mldlg_result default_answer));
MLDPROC( mldlg_result, MLRequestArgvProcPtr,       ( MLEnvironment env, charpp_ct argv, long cardof_argv, charp_ct buf, long sizeof_buf));
#endif /* MLINTERFACE >= 3 */
MLDPROC( mldlg_result, MLRequestToInteractProcPtr, ( MLEnvironment env, mldlg_result wait_for_permission));
MLDPROC( mldlg_result, MLDialogProcPtr,            ( MLEnvironment env));


typedef MLDialogProcPtr MLDialogUPP;
typedef MLAlertProcPtr MLAlertUPP;
typedef MLRequestProcPtr MLRequestUPP;
typedef MLConfirmProcPtr MLConfirmUPP;
typedef MLRequestArgvProcPtr MLRequestArgvUPP;
typedef MLRequestToInteractProcPtr MLRequestToInteractUPP;
#define NewMLAlertProc(userRoutine) MLAlertCast((userRoutine))
#define NewMLRequestProc(userRoutine) MLRequestCast((userRoutine))
#define NewMLConfirmProc(userRoutine) MLConfirmCast((userRoutine))
#define NewMLRequestArgvProc(userRoutine) MLRequestArgvCast((userRoutine))
#define NewMLRequestToInteractProc(userRoutine) MLRequestToInteractCast((userRoutine))

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



#if WINDOWS_MATHLINK

#ifndef _MLWIN_H
#define _MLWIN_H



ML_EXTERN_C
#if MLINTERFACE >= 3
MLDDECL( mldlg_result, MLAlert_win,   ( MLEnvironment ep, const char *alertstr));
MLDDECL( mldlg_result, MLRequest_win, ( MLEnvironment ep, const char *prompt, char *response, long n));
MLDDECL( mldlg_result, MLConfirm_win, ( MLEnvironment ep, const char *okcancelquest, mldlg_result default_answer));
#else
MLDDECL( mldlg_result, MLAlert_win,   ( MLEnvironment ep, kcharp_ct alertstr));
MLDDECL( mldlg_result, MLRequest_win, ( MLEnvironment ep, kcharp_ct prompt, charp_ct response, long n));
MLDDECL( mldlg_result, MLConfirm_win, ( MLEnvironment ep, kcharp_ct okcancelquest, mldlg_result default_answer));
#endif /* MLINTERFACE >= 3 */
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
#if DARWIN_MATHLINK  && defined (__CONDITIONALMACROS__)

#ifndef _MLDARWIN_H
#define _MLDARWIN_H


ML_EXTERN_C

#if MLINTERFACE >= 3
MLDDECL( mldlg_result, MLAlert_darwin,   ( MLEnvironment env, const char *message));
MLDDECL( mldlg_result, MLRequest_darwin, ( MLEnvironment env, const char *prompt, char *response, long sizeof_response));
MLDDECL( mldlg_result, MLConfirm_darwin, ( MLEnvironment env, const char *question, mldlg_result default_answer));
#else
MLDDECL( mldlg_result, MLAlert_darwin,   ( MLEnvironment env, kcharp_ct message));
MLDDECL( mldlg_result, MLRequest_darwin, ( MLEnvironment env, kcharp_ct prompt, charp_ct response, long sizeof_response));
MLDDECL( mldlg_result, MLConfirm_darwin, ( MLEnvironment env, kcharp_ct question, mldlg_result default_answer));
#endif /* MLINTERFACE >= 3 */
MLDDECL( mldlg_result, MLPermit_darwin,  ( MLEnvironment env, mldlg_result wait_for_permission));
MLDDECL( mldlg_result, MLDontPermit_darwin, ( MLEnvironment ep, mldlg_result wait_for_permission));

ML_END_EXTERN_C

#endif /* _MLDARWIN_H */
#define MLALERT  	MLAlert_darwin
#define MLREQUEST	MLRequest_darwin
#define MLCONFIRM	MLConfirm_darwin
#define MLPERMIT 	MLPermit_darwin
#define MLREQUESTARGV	default_request_argv
#else /* !(DARWIN_MATHLINK && defined (__CONDITIONALMACROS__)) */

#ifndef _MLUNIX_H
#define _MLUNIX_H


ML_EXTERN_C

#if MLINTERFACE >= 3
MLDDECL( mldlg_result, MLAlert_unix,   ( MLEnvironment env, const char *message));
MLDDECL( mldlg_result, MLRequest_unix, ( MLEnvironment env, const char *prompt, char *response, long sizeof_response));
MLDDECL( mldlg_result, MLConfirm_unix, ( MLEnvironment env, const char *question, mldlg_result default_answer));
#else
MLDDECL( mldlg_result, MLAlert_unix,   ( MLEnvironment env, kcharp_ct message));
MLDDECL( mldlg_result, MLRequest_unix, ( MLEnvironment env, kcharp_ct prompt, charp_ct response, long sizeof_response));
MLDDECL( mldlg_result, MLConfirm_unix, ( MLEnvironment env, kcharp_ct question, mldlg_result default_answer));
#endif /* MLINTERFACE >= 3 */
MLDDECL( mldlg_result, MLPermit_unix,  ( MLEnvironment env, mldlg_result wait_for_permission));

ML_END_EXTERN_C

#endif /* _MLUNIX_H */
#define MLALERT  	MLAlert_unix
#define MLREQUEST	MLRequest_unix
#define MLCONFIRM	MLConfirm_unix
#define MLPERMIT 	MLPermit_unix
#define MLREQUESTARGV	default_request_argv
#endif /* DARWIN_MATHLINK && defined (__CONDITIONALMACROS__) */
#endif


#if MLINTERFACE >= 3
MLDDECL( mldlg_result, default_request_argv, ( MLEnvironment ep, char **argv, long len, char *buff, long size));
#else
MLDDECL( mldlg_result, default_request_argv, ( MLEnvironment ep, charpp_ct argv, long len, charp_ct buff, long size));
#endif /* MLINTERFACE >= 3 */
ML_END_EXTERN_C

#endif /* _MLALERT_H */


/* explicitly not protected by _MLXDATA_H in case MLDECL is redefined for multiple inclusion */
ML_EXTERN_C

#if MLINTERFACE >= 3
MLDECL( mldlg_result,  MLAlert,             ( MLEnvironment env, const char *message));
MLDECL( mldlg_result,  MLRequest,           ( MLEnvironment env, const char *prompt, char *response, long sizeof_response)); /* initialize response with default*/
MLDECL( mldlg_result,  MLConfirm,           ( MLEnvironment env, const char *question, mldlg_result default_answer));
MLDECL( mldlg_result,  MLRequestArgv,       ( MLEnvironment env, char **argv, long cardof_argv, char *buff, long size));
#else
MLDECL( mldlg_result,  MLAlert,             ( MLEnvironment env, kcharp_ct message));
MLDECL( mldlg_result,  MLRequest,           ( MLEnvironment env, kcharp_ct prompt, charp_ct response, long sizeof_response)); /* initialize response with default*/
MLDECL( mldlg_result,  MLConfirm,           ( MLEnvironment env, kcharp_ct question, mldlg_result default_answer));
MLDECL( mldlg_result,  MLRequestArgv,       ( MLEnvironment env, charpp_ct argv, long cardof_argv, charp_ct buff, long size));
#endif /* MLINTERFACE >= 3 */

MLDECL( mldlg_result,  MLRequestToInteract, ( MLEnvironment env, mldlg_result wait_for_permission));
#if MLINTERFACE >= 3
MLDECL( int,  MLSetDialogFunction, ( MLEnvironment env, long funcnum, MLDialogFunctionType func));
#else
MLDECL( mlapi_result,  MLSetDialogFunction, ( MLEnvironment env, long funcnum, MLDialogFunctionType func));
#endif /* MLINTERFACE >= 3 */

/* just some type-safe casts */
MLDECL( MLDialogProcPtr, MLAlertCast, ( MLAlertProcPtr f));
MLDECL( MLDialogProcPtr, MLRequestCast, ( MLRequestProcPtr f));
MLDECL( MLDialogProcPtr, MLConfirmCast, ( MLConfirmProcPtr f));
MLDECL( MLDialogProcPtr, MLRequestArgvCast, ( MLRequestArgvProcPtr f));
MLDECL( MLDialogProcPtr, MLRequestToInteractCast, ( MLRequestToInteractProcPtr f));
ML_END_EXTERN_C

/*************************************************************/


#ifndef _MLREADY_H
#define _MLREADY_H

#ifndef _MLTIME_H
#define _MLTIME_H

typedef struct _mltimeval{
	unsigned long tv_sec;
	unsigned long tv_usec;
} mltimeval;


#endif /* _MLTIME_H */

ML_EXTERN_C
#if MLINTERFACE >= 3
MLDECL( int,   MLReady,            ( MLINK mlp));
#else
MLDECL( mlapi_result,   MLReady,            ( MLINK mlp));
#endif /* MLINTERFACE >= 3 */
ML_END_EXTERN_C

#if MLINTERFACE >= 3


#define MLINFINITEWAIT {-1, -1}

#define MLREADYPARALLELERROR -1
#define MLREADYPARALLELTIMEDOUT -2

typedef void *MLREADYPARALLELENV;

ML_EXTERN_C
MLDECL(int,              MLReadyParallel, (MLENV, MLINK *, int, mltimeval));
ML_END_EXTERN_C

#endif /* MLINTERFACE >= 3 */

#endif /* _MLREADY_H */

/********************************************************/


#ifndef _MLTM_H
#define _MLTM_H


/*************** Template interface ***************/

/* The following are useful only when using template files as
 * their definitions are produced by mprep.
 */

ML_EXTERN_C
extern MLINK stdlink;
extern MLEnvironment stdenv;

extern MLYieldFunctionObject stdyielder;
extern MLMessageHandlerObject stdhandler;

#if MLINTERFACE >= 3
extern int MLMain P((int, char **)); /* pass in argc and argv */
extern int MLMainString P(( char *commandline));
#else
extern int MLMain P((int, charpp_ct)); /* pass in argc and argv */
extern int MLMainString P(( charp_ct commandline));
#endif /* MLINTERFACE >= 3 */

extern int MLMainArgv P(( char** argv, char** argv_end)); /* note not FAR pointers */
            
extern int MLInstall P((MLINK));
extern mlapi_packet MLAnswer P((MLINK));
extern int MLDoCallPacket P((MLINK));
#if MLINTERFACE >= 3
extern int MLEvaluate P(( MLINK, char *));
extern int MLEvaluateString P(( MLINK, char *));
#else
extern int MLEvaluate P(( MLINK, charp_ct));
extern int MLEvaluateString P(( MLINK, charp_ct));
#endif /* MLINTERFACE >= 3 */
ML_END_EXTERN_C

#if MLINTERFACE >= 3
MLMDECL( void, MLDefaultHandler, ( MLINK, int, int));
#else
MLMDECL( void, MLDefaultHandler, ( MLINK, unsigned long, unsigned long));
#endif /* MLINTERFACE >= 3 */

#if MLINTERFACE >= 3
MLYDECL( int, MLDefaultYielder, ( MLINK, MLYieldParameters));
#else
MLYDECL( devyield_result, MLDefaultYielder, ( MLINK, MLYieldParameters));
#endif /* MLINTERFACE >= 3 */

ML_EXTERN_C
#if WINDOWS_MATHLINK
extern HWND MLInitializeIcon P(( HINSTANCE hinstCurrent, int nCmdShow));
extern HANDLE MLInstance;
extern HWND MLIconWindow;
#endif
extern int MLAbort, MLDone;
extern long MLSpecialCharacter;
ML_END_EXTERN_C

#endif /* _MLTM_H */



#endif /* _MATHLINK_H */
