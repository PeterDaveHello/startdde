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


class ConfirmDialog extends Widget
    timeId = null
    CANCEL = 0
    OK = 1
    choose_num = OK

    img_url_normal = []
    img_url_hover = []
    img_url_click = []
    
    constructor: (opt)->
        super
        if opt is "suspend" or opt is "lock"
            destory_all()
            return
        i = null
        @opt = opt
        for tmp,j in option
            if tmp is opt then i  = j
        if i is null
            echo "no this power option!"
            return
        @i = i
        powerchoose = null
    
    setPos:->
        @element.style.display = "-webkit-box"
        echo "clientWidth:#{@element.clientWidth}"
        echo "clientHeight:#{@element.clientHeight}"
        w = @element.clientWidth
        h = @element.clientHeight
        w = 306 if w == 0
        h = 80 if h == 0
        left = (screen.width  - w) / 2
        bottom = (screen.height) / 2
        @element.style.left = "#{left}px"
        @element.style.bottom = "#{bottom}px"
 
    destory:->
        document.body.removeChild(@element)

    img_url_build:->
        for i of option
            img_url_normal.push("img/#{option[i]}_normal.png")
            img_url_hover.push("img/#{option[i]}_hover.png")
            img_url_click.push("img/#{option[i]}_press.png")


    frame_build:->
        @img_url_build()
        i = @i
        #frame_confirm = create_element("div", "frame_confirm", @element)
        @element.addEventListener("click",->
            frame_click = true
        )
        
        left = create_element("div","left",@element)
        @img_confirm = create_img("img_confirm",img_url_normal[i],left)
        
        right = create_element("div","right",@element)
        @message_confirm = create_element("div","message_confirm",right)

        button_confirm = create_element("div","button_confirm",right)
        
        @button_cancel = create_element("div","button_cancel",button_confirm)
        @button_cancel.textContent = _("Cancel")

        @button_ok = create_element("div","button_ok",button_confirm)
        echo "----------------power_can check-------------"
        if power_can(@opt) then @style_for_direct()
        else @style_for_force()

        @button_cancel.addEventListener("click",->
            echo "button_cancel click"
            destory_all()
        )
        @button_ok.addEventListener("click",->
            echo "button_ok click"
            confirm_ok(option[i])
        )

        @button_cancel.addEventListener("mouseover",=>
            choose_num = CANCEL
            @hover_state(choose_num)
        )
        @button_cancel.addEventListener("mouseout",=>
            @normal_state(CANCEL)
        )
        @button_ok.addEventListener("mouseover",=>
            choose_num = OK
            @hover_state(choose_num)
        )

        @button_ok.addEventListener("mouseout",=>
            @normal_state(OK)
        )
        
        @setPos()
        showAnimation(@element,TIME_SHOW)
    
    style_for_direct:=>
        echo "style_for_direct:power_can true!"
        i = @i
        @img_confirm.src = img_url_normal[i]
        @message_confirm.textContent = message_text[option[i]].args(60)
        @button_ok.textContent = option_text[i]

    style_for_force:=>
        echo "style_for_force:power_can false!"
        i = @i
        @img_confirm.src = img_url_normal[i]
        @message_confirm.textContent = message_text[option[i]].args(60)
        @button_ok.textContent = option_text_force[i]
        @button_ok.style.color = "rgba(255,128,114,1.0)"
    
    interval:(time)->
        i = @i
        that = @
        clearInterval(timeId) if timeId
        timeId = setInterval(->
            time--
            that.message_confirm.textContent = message_text[option[i]].args(time)
            if time == 0
                clearInterval(timeId)
                confirm_ok(option[i])
        ,1000)

    hover_state: (choose_num)->
        switch choose_num
            when OK
                @button_ok.style.color = "rgba(0,193,255,1.0)"
                @button_cancel.style.color = "rgba(255,255,255,0.5)"
            when CANCEL
                @button_cancel.style.color = "rgba(0,193,255,1.0)"
                @button_ok.style.color = "rgba(255,255,255,0.5)"
            else return

    normal_state: (choose_num)->
        switch choose_num
            when OK
                @button_ok.style.color = "rgba(255,255,255,0.5)"
                @button_cancel.style.color = "rgba(255,255,255,0.5)"
            when CANCEL
                @button_cancel.style.color = "rgba(255,255,255,0.5)"
                @button_ok.style.color = "rgba(255,255,255,0.5)"
            else return
    
    keydown:(keyCode)->
        change_choose =->
            echo "change_choose"
            if choose_num == OK then choose_num = CANCEL
            else choose_num = OK
            return choose_num

        choose_enter = =>
            echo "choose_enter :#{choose_num}"
            i = @i
            switch choose_num
                when OK
                    confirm_ok(option[i])
                when CANCEL
                    destory_all()
                else return

        #document.body.removeEventListener("keydown",arguments.callee,false)
        switch keyCode
            when LEFT_ARROW
                change_choose()
                @hover_state(choose_num)
            when RIGHT_ARROW
                change_choose()
                @hover_state(choose_num)
            when ENTER_KEY
                choose_enter()
            when ESC_KEY
                destory_all()
