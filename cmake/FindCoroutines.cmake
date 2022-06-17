# Copyright (c) 2019-present, Facebook, Inc.
#
# This source code is licensed under the Apache License found in the
# LICENSE.txt file in the root directory of this source tree.

#[=======================================================================[.rst:

FindCoroutines
##############

This module supports the C++ standard support for coroutines. Use
the :imp-target:`std::coroutines` imported target to

Options
*******

The ``COMPONENTS`` argument to this module supports the following values:

.. find-component:: Experimental
    :name: coro.Experimental

    Allows the module to find the "experimental" Coroutines TS
    version of the coroutines library. This is the library that should be
    used with the ``std::experimental`` namespace.

.. find-component:: Final
    :name: coro.Final

    Finds the final C++20 standard version of coroutines.

If no components are provided, behaves as if the
:find-component:`coro.Final` component was specified.

If both :find-component:`coro.Experimental` and :find-component:`coro.Final` are
provided, first looks for ``Final``, and falls back to ``Experimental`` in case
of failure. If ``Final`` is found, :imp-target:`std::coroutines` and all
:ref:`variables <coro.variables>` will refer to the ``Final`` version.


Imported Targets
****************

.. imp-target:: std::coroutines

    The ``std::coroutines`` imported target is defined when any requested
    version of the C++ coroutines library has been found, whether it is
    *Experimental* or *Final*.

    If no version of the coroutines library is available, this target will not
    be defined.

    .. note::
        This target has ``cxx_std_17`` as an ``INTERFACE``
        :ref:`compile language standard feature <req-lang-standards>`. Linking
        to this target will automatically enable C++17 if no later standard
        version is already required on the linking target.


.. _coro.variables:

Variables
*********

.. variable:: CXX_COROUTINES_HAVE_COROUTINES

    Set to ``TRUE`` when coroutines are supported in both the language and the
    library.

.. variable:: CXX_COROUTINES_HEADER

    Set to either ``coroutine`` or ``experimental/coroutine`` depending on
    whether :find-component:`coro.Final` or :find-component:`coro.Experimental` was
    found.

.. variable:: CXX_COROUTINES_NAMESPACE

    Set to either ``std`` or ``std::experimental``
    depending on whether :find-component:`coro.Final` or
    :find-component:`coro.Experimental` was found.


Examples
********

Using `find_package(Coroutines)` with no component arguments:

.. code-block:: cmake

    find_package(Coroutines REQUIRED)

    add_executable(my-program main.cpp)
    target_link_libraries(my-program PRIVATE std::coroutines)


#]=======================================================================]


if(TARGET std::coroutines)
    # This module has already been processed. Don't do it again.
    return()
endif()

include(CheckCXXCompilerFlag)
include(CMakePushCheckState)
include(CheckIncludeFileCXX)
include(CheckCXXSourceCompiles)

cmake_push_check_state()

set(_have_coro TRUE)
set(_coro_header coroutine)
set(_coro_namespace std)

set(CXX_COROUTINES_HAVE_COROUTINES ${_have_coro} CACHE BOOL "TRUE if we have the C++ coroutines feature")
set(CXX_COROUTINES_HEADER ${_coro_header} CACHE STRING "The header that should be included to obtain the coroutines APIs")
set(CXX_COROUTINES_NAMESPACE ${_coro_namespace} CACHE STRING "The C++ namespace that contains the coroutines APIs")

add_library(std::coroutines INTERFACE IMPORTED)
set(_found TRUE)

cmake_pop_check_state()

set(Coroutines_FOUND ${_found} CACHE BOOL "TRUE if we can compile and link a program using std::coroutines" FORCE)

if(Coroutines_FIND_REQUIRED AND NOT Coroutines_FOUND)
    message(FATAL_ERROR "Cannot compile simple program using std::coroutines. Is C++17 or later activated?")
endif()
