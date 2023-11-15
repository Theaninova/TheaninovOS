import Gio from "gi://Gio"
import Gdk from "gi://Gdk?version=3.0"
import GdkPixbuf from "gi://GdkPixbuf"
import DbusmenuGtk3 from "gi://DbusmenuGtk3"
import Service from "../service.js"
export declare class TrayItem extends Service {
  private _proxy
  private _busName
  private _iconTheme?
  menu?: DbusmenuGtk3.Menu
  constructor(busName: string, objectPath: string)
  activate(event: Gdk.Event): void
  secondaryActivate(event: Gdk.Event): void
  scroll(event: Gdk.EventScroll): void
  openMenu(event: Gdk.Event): void
  get category(): string
  get id(): string
  get title(): string
  get status(): string
  get window_id(): number
  get is_menu(): boolean
  get tooltip_markup(): string
  get icon(): string | GdkPixbuf.Pixbuf
  private _itemProxyAcquired
  _notify(): void
  private _refreshAllProperties
  private _getPixbuf
}
export declare class SystemTray extends Service {
  private _dbus
  private _items
  get IsStatusNotifierHostRegistered(): boolean
  get ProtocolVersion(): number
  get RegisteredStatusNotifierItems(): string[]
  get items(): TrayItem[]
  getItem(name: string): TrayItem | undefined
  constructor()
  private _register
  RegisterStatusNotifierItemAsync(serviceName: string[], invocation: Gio.DBusMethodInvocation): void
}
export declare const systemTray: SystemTray
export default systemTray
