//===--------------------------- Refcount.h ------------------------------===//
//
//                              SPIR Tools
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===---------------------------------------------------------------------===//
/*
 * Contributed by: Intel Corporation
 */

#ifndef __REF_COUNT_H__
#define __REF_COUNT_H__

#include <assert.h>

namespace SPIR {

template <typename T> class RefCount {
public:
  RefCount() : MRefCount(0), MPtr(0) {}

  RefCount(T *Ptr) : MPtr(Ptr) { MRefCount = new int(1); }

  RefCount(const RefCount<T> &Other) { cpy(Other); }

  ~RefCount() {
    if (MRefCount)
      dispose();
  }

  RefCount &operator=(const RefCount<T> &Other) {
    if (this == &Other)
      return *this;
    if (MRefCount)
      dispose();
    cpy(Other);
    return *this;
  }

  void init(T *Ptr) {
    assert(!MPtr && "overrunning non NULL pointer");
    assert(!MRefCount && "overrunning non NULL pointer");
    MRefCount = new int(1);
    MPtr = Ptr;
  }

  bool isNull() const { return (!MPtr); }

  // Pointer access
  const T &operator*() const {
    sanity();
    return *MPtr;
  }

  T &operator*() {
    sanity();
    return *MPtr;
  }

  operator T *() { return MPtr; }

  operator const T *() const { return MPtr; }

  T *operator->() { return MPtr; }

  const T *operator->() const { return MPtr; }

private:
  void sanity() const {
    assert(MPtr && "NULL pointer");
    assert(MRefCount && "NULL ref counter");
    assert(*MRefCount && "zero ref counter");
  }

  void cpy(const RefCount<T> &Other) {
    MRefCount = Other.MRefCount;
    MPtr = Other.MPtr;
    if (MRefCount)
      ++*MRefCount;
  }

  void dispose() {
    sanity();
    if (0 == --*MRefCount) {
      delete MRefCount;
      delete MPtr;
      MPtr = 0;
      MRefCount = 0;
    }
  }

  int *MRefCount;
  T *MPtr;
}; // End RefCount

} // namespace SPIR

#endif //__REF_COUNT_H__
