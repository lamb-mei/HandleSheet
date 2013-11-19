# Starling HandleSheet

Use one finger touching to moving 、 rotating and scaling on Starling

Baseed on Starling 實現單手簡單操作物件位移 、旋轉和縮放

![screenshot](https://raw.github.com/lamb-mei/HandleSheet/master/docs/images/screenshot.png)


Demo (http://proj.lamb-mei.com/handlesheet/)

## Feature

What feature in HandleSheet:

  - one finger touch control button to rotating and scaling
  - two finger touching to rotating and scaling
  - finger touch moving
  - coustom control button display
  - scale limit
  - auto bring to front
  - outline border thickness
  - outline border color
  - init by config




## Ues Libs (Depends) 

  - Starling (https://github.com/PrimaryFeather/Starling-Framework)
  - Starling-Extension-Graphics (https://github.com/StarlingGraphics/Starling-Extension-Graphics)



## Usage

Base

    var _contents:DisplayObject = new Image(_texture)
    var hs:HandleSheet = new HandleSheet(_contents)


Set Control Button By Texture 

    var hs:HandleSheet = new HandleSheet(_contents)
    hs.setCtrlButtonInitByTexture(upTexture, downTexture)


Set Control Button By Factory 

    function imgFactory():Image{
        var img:Image = new Image(_texture)
        return img
    }
    var hs:HandleSheet = new HandleSheet(_contents)
    hs.setCtrlButtonInitByFactory(imgFactory)
    
    
Scale limit 

    var hs:HandleSheet = new HandleSheet(_contents)
    hs.minSize = 0.5
    hs.maxSize = 2


Coustom outline border

    var hs:HandleSheet = new HandleSheet(_contents)
    hs.thickness = 5
    hs.lineColor = 0xF7BD19
    

Init by Config

    var _conf:HandleSheetConfig = new HandleSheetConfig()
    _conf.setCtrlButtonInitByTexture(_upTexture, _downTexture)
    _conf.dispatchEventBubbles = true
    _conf.minSize = 0.5
    _conf.lineColor = 0xFF0000
    //set config
    var hs:HandleSheet = new HandleSheet(_contents , _conf)


