#Copyright (c) 2011 ~ 2014 Deepin, Inc.
#              2011 ~ 2014 bluth
#
#encoding: utf-8
#Author:      bluth <yuanchenglu@linuxdeepin.com>
#Maintainer:  bluth <yuanchenglu@linuxdeepin.com>
#
#This program is free software; you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation; either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program; if not, see <http://www.gnu.org/licenses/>.

APP_NAME = "Shutdown"
DEFAULT_BG = "/usr/share/backgrounds/default_background.jpg"

confirmdialog = null
powerchoose = null

frame_click = false
option = ["shutdown","restart","lock","suspend","logout"]
option_text = [_("Shut down"),_("Restart"),_("Lock"),_("Suspend"),_("Log out")]
option_text_force = [_("Force Shut down"),_("Force Restart"),_("Lock"),_("Suspend"),_("Force Log out")]
message_text = {}
message_text["shutdown"] = _("The system will shut down in %1 seconds.")
message_text["restart"] = _("The system will restart in %1 seconds.")
message_text["lock"] = _("The system will be locked in %1 seconds.")
message_text["suspend"] = _("The system will be suspended in %1 seconds.")
message_text["logout"] = _("You will be automatically logged out in %1 seconds.")
message_text["systemUpdate"] = _("Your system is updating.please donnot poweroff...")
message_text["default"] = _("Are you sure to do it?")

timeId = null

destory_all = ->
    clearInterval(timeId) if timeId
    DCore.Shutdown.quit()

confirm_ok = (power)->
    echo "--------------confirm_ok(#{power})-------------"
    switch power
        when "lock" then destory_all()
        when "suspend" then destory_all()
    power_force(power)
    clearInterval(timeId) if timeId

document.body.style.height = window.innerHeight
document.body.style.width = window.innerWidth

TIME_SHOW = 500
showAnimation =(el,t)->
    _b = document.body
    _b.style.display = "none"
    jQuery(_b).fadeIn(t)

isSystemUpdating = false

