Flutter slider selection with wave effect.

## Demo
<img height="240px" src="https://media.giphy.com/media/TcAhg5Phg5tAxoYP4C/giphy.gif">

<br>
A slection_wave_slider in Flutter is a material design widget utilized for choosing a scope of values. It is an information widget where we can set a range of values by dragging or pushing the ideal position. and also can draggable possition to the bootom. 
Typically, we utilize the slider widget for changing a value. Along these lines, it is needed to store the value in a variable. This widget has a slider class that requires the onChanged() work. This capacity will be called at whatever point we change the slider position.
<br>

## Getting Started

Add dependancy to your pubspec.yaml
```
dependencies:
  ...
  Slider_dependancy: any
```


## Properties
| Properties | Required | Description |
| ------------------------: | :---------------: | ------------- |
| optionToChoose | true | list of string (list size must be less than 10) |
| onSelected | true | call back provide selected value |
| sliderHeight | false | Slider Height |
| toolTipBackgroundColor | false | Tool tip background color |
| toolTipBorderColor | false | Tool tip border color |
| toolTipTextStyle | false |  Tool tip text style  |
| dragButtonColor | false | Draggable object color |
| selected | false | initial selected value |
| dragButton | false | custom drag widget |
| sliderColor | false | Slider color |
| sliderPointColor | false | Color of point present on slider |
| sliderPointBorderColor | false | draggable object border color |

<br>

## Usage 

```
         WaveSliderWithDragPoint(
              dragButton: Container(
                color: Colors.blue,
              ),
              sliderHeight: 80,
              sliderPointColor: Colors.blue,
              sliderPointBorderColor: Colors.orange,
              sliderColor: Colors.red,
              toolTipBackgroundColor: Colors.yellow,
              toolTipBorderColor: Colors.green,
              toolTipTextStyle: TextStyle(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              onSelected: (value) {
                print(value);
              },
              optionToChoose: [
                "Yes",
                "May Be",
                "No",
              ],
            )
```