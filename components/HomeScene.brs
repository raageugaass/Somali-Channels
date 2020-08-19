
' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

Sub init()
    m.count = 0
    m.Video = m.top.findNode("Video")
    m.RowList = m.top.findNode("RowList")
    m.BottomBarRowList = m.top.findNode("BottomBarRowList")
    m.BottomBar = m.top.findNode("BottomBar")
    m.ShowBar = m.top.findNode("ShowBar")
    m.HideBar = m.top.findNode("HideBar")
    m.Hint = m.top.findNode("Hint")
    m.Timer = m.top.findNode("Timer")
    
    m.RowList.setFocus(true)

    m.Hint.visible = false
    m.Hint.font.size = "20"
    
    
    m.LoadTask = createObject("roSGNode", "RowListContentTask")
    m.LoadTask.observeField("mediaIndex","indexloaded")
    m.LoadTask.observeField("content", "rowListContentChanged")
    m.LoadTask.control = "RUN"

    m.InputTask=createObject("roSgNode","inputTask")
    m.InputTask.observefield("inputData","handleInputEvent")
    m.InputTask.control="RUN"

    m.RowList.observeField("rowItemFocused", "changeContent")

    'm.RowList.setFocus(true)
    m.RowList.rowLabelFont.size = "24"
    m.BottomBarRowList.rowLabelFont.size = "24"
    
    m.Timer.observeField("fire", "hideHint")
    
    m.RowList.observeField("rowItemSelected", "PlayChannel")
    m.BottomBarRowList.observeField("rowItemSelected", "ChannelChange")
End Sub

sub indexloaded(msg as Object)
    if type(msg) = "roSGNodeEvent" and msg.getField() = "mediaIndex"
        m.mediaIndex = msg.getData()
    end if
    handleDeepLink(m.global.deeplink)
    'get run time deeplink updates'
    'm.global.observeField("deeplink", handleRuntimeDeepLink)
end sub

Sub handleDeepLink(deeplink as object)
    if validateDeepLink(deeplink)
        m.global.AdTracker = 0
        videoContent = createObject("RoSGNode", "ContentNode")
        videoContent.url = m.mediaIndex[deeplink.id].url
        videoContent.title = m.mediaIndex[deeplink.id].title
        videoContent.streamformat = m.mediaIndex[deeplink.id].streamformat
        m.Video.content = videoContent
        m.video.visible = "true"
        m.Video.control = "play"
    end if
end Sub

sub handleInputEvent(msg)
    if type(msg) = "roSGNodeEvent" and msg.getField() = "inputData"
        deeplink = msg.getData()
        if deeplink <> invalid
            handleDeepLink(deeplink)
        end if
    end if
end sub


Sub  hideHint()
    m.Hint.visible = false
End Sub

Sub showHint()
    m.Hint.visible = true
    m.Timer.control = "start"
End Sub

Sub optionsMenu()
    if m.global.Options = 0
        m.ShowBar.control = "start"
        m.BottomBarRowList.setFocus(true)
        hideHint()
    else if m.global.Options = 1
        m.HideBar.control = "start"
        m.Video.setFocus(true)
        showHint()
    End if
End Sub

function onKeyEvent(key as String, press as Boolean) as Boolean 
    handled = false
        if press
            if key="up" or key = "down"
                if m.video.visible
                    if m.global.Options = 0 
                        m.global.Options = 1
                        optionsMenu()
                    else
                        m.global.Options = 0
                        optionsMenu()
                    end if
                end if
                handled = true
            end if
            if key = "back"  'If the back button is pressed
                if m.Video.visible
                    returnToUIPage()
                    handled = true
                end if
            end if
        end if
    return handled
end function

Function ChannelChange()
    m.Video.content = m.BottomBarRowList.content.getChild(m.BottomBarRowList.rowItemFocused[0]).getChild(m.BottomBarRowList.rowItemFocused[1])
    m.Video.control = "play"
    showHint()
End Function

Function PlayChannel()
    if m.count = 0
        m.global.AdTracker = 1
        m.count = 1
    end if

    m.Video.content = m.RowList.content.getChild(m.RowList.rowItemFocused[0]).getChild(m.RowList.rowItemFocused[1])
    m.video.visible = "true"
    m.Video.control = "play"
    showHint()
End Function

Sub rowListContentChanged(msg as Object)
    if type(msg) = "roSGNodeEvent" and msg.getField() = "content"
        m.RowList.content = msg.getData()
        m.BottomBarRowList.content = msg.getData()
    end if
end Sub

function validateDeepLink(deeplink as Object) as Boolean
    mediatypes={live:"live"}
    if deeplink <> Invalid
        if deeplink.type <> invalid then
          if mediatypes[deeplink.type]<> invalid
            if m.mediaIndex[deeplink.id] <> invalid
              if m.mediaIndex[deeplink.id].url <> invalid
                return true
              end if
            end if
          end if
        end if
    end if
    return false
  end function


Function returnToUIPage()
   if m.video.visible
        if m.global.Options = 0
            m.global.Options = 2
            m.HideBar.control = "start"
        end if
        m.Video.visible = "false" 'Hide video
        m.Video.control = "stop"  'Stop video from playing
        m.RowList.setFocus(true)
    end if
end Function


Sub changeContent()  'Changes info to be displayed on the overhang
    contentItem = m.RowList.content.getChild(m.RowList.rowItemFocused[0]).getChild(m.RowList.rowItemFocused[1])

    m.top.backgroundUri = contentItem.HDPOSTERURL  'Sets Scene background to the image of the focused item
    
End Sub
