// -*- c++ -*-
// Generated by gtkmmproc -- DO NOT MODIFY!
#ifndef _GIOMM_SOCKETCONNECTABLE_H
#define _GIOMM_SOCKETCONNECTABLE_H


#include <glibmm.h>

// -*- Mode: C++; indent-tabs-mode: nil; c-basic-offset: 2 -*-

/* Copyright (C) 2007 The giomm Development Team
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free
 * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include <glibmm/interface.h>
#include <giomm/socketaddressenumerator.h>


#ifndef DOXYGEN_SHOULD_SKIP_THIS
typedef struct _GSocketConnectableIface GSocketConnectableIface;
#endif /* DOXYGEN_SHOULD_SKIP_THIS */

#ifndef DOXYGEN_SHOULD_SKIP_THIS
typedef struct _GSocketConnectable GSocketConnectable;
typedef struct _GSocketConnectableClass GSocketConnectableClass;
#endif /* DOXYGEN_SHOULD_SKIP_THIS */


namespace Gio
{ class SocketConnectable_Class; } // namespace Gio
namespace Gio
{

/** Interface for potential socket endpoints
 *
 * @newin{2,24}
 * @ingroup NetworkIO
 */

class SocketConnectable : public Glib::Interface
{
  
#ifndef DOXYGEN_SHOULD_SKIP_THIS

public:
  typedef SocketConnectable CppObjectType;
  typedef SocketConnectable_Class CppClassType;
  typedef GSocketConnectable BaseObjectType;
  typedef GSocketConnectableIface BaseClassType;

private:
  friend class SocketConnectable_Class;
  static CppClassType socketconnectable_class_;

  // noncopyable
  SocketConnectable(const SocketConnectable&);
  SocketConnectable& operator=(const SocketConnectable&);

protected:
  SocketConnectable(); // you must derive from this class

  /** Called by constructors of derived classes. Provide the result of 
   * the Class init() function to ensure that it is properly 
   * initialized.
   * 
   * @param interface_class The Class object for the derived type.
   */
  explicit SocketConnectable(const Glib::Interface_Class& interface_class);

public:
  // This is public so that C++ wrapper instances can be
  // created for C instances of unwrapped types.
  // For instance, if an unexpected C type implements the C interface. 
  explicit SocketConnectable(GSocketConnectable* castitem);

protected:
#endif /* DOXYGEN_SHOULD_SKIP_THIS */

public:
  virtual ~SocketConnectable();

  static void add_interface(GType gtype_implementer);

#ifndef DOXYGEN_SHOULD_SKIP_THIS
  static GType get_type()      G_GNUC_CONST;
  static GType get_base_type() G_GNUC_CONST;
#endif

  ///Provides access to the underlying C GObject.
  GSocketConnectable*       gobj()       { return reinterpret_cast<GSocketConnectable*>(gobject_); }

  ///Provides access to the underlying C GObject.  
  const GSocketConnectable* gobj() const { return reinterpret_cast<GSocketConnectable*>(gobject_); }

private:


public:
      // TODO
      
  /** Creates a SocketAddressEnumerator for @a connectable.
   * 
   * @newin{2,22}
   * @return A new SocketAddressEnumerator.
   */
  Glib::RefPtr<SocketAddressEnumerator> enumerate();


public:

public:
  //C++ methods used to invoke GTK+ virtual functions:
#ifdef GLIBMM_VFUNCS_ENABLED
#endif //GLIBMM_VFUNCS_ENABLED

protected:
  //GTK+ Virtual Functions (override these to change behaviour):
#ifdef GLIBMM_VFUNCS_ENABLED
#endif //GLIBMM_VFUNCS_ENABLED

  //Default Signal Handlers::
#ifdef GLIBMM_DEFAULT_SIGNAL_HANDLERS_ENABLED
#endif //GLIBMM_DEFAULT_SIGNAL_HANDLERS_ENABLED


};

} // namespace Gio


namespace Glib
{
  /** A Glib::wrap() method for this object.
   * 
   * @param object The C instance.
   * @param take_copy False if the result should take ownership of the C instance. True if it should take a new copy or ref.
   * @result A C++ instance that wraps this C instance.
   *
   * @relates Gio::SocketConnectable
   */
  Glib::RefPtr<Gio::SocketConnectable> wrap(GSocketConnectable* object, bool take_copy = false);

} // namespace Glib


#endif /* _GIOMM_SOCKETCONNECTABLE_H */

