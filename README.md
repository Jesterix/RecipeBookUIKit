# RecipeBookUIKit

This project was created for those who like to cook. 
It's not easy to find good instrument to store your recipes, update them, and use them in different conditions.

This app manages storing recipes, including structuring ingredients. You can write down new recipe, fill ingredients table, and choose measurement for each of them. You can even create your own measurements (especially if you get used to your old cup, which holds exactly 256g :)

You can convert measurements from one to another (finally to know differences between imperial tablespoon and metric cup).

Besides that you can easily recalculate your recipe's ingredient quantity of mashed potatoes from 2 persons breakfast to dinner for 12.5 persons (including Charly the terrier).

## Technologies
* Swift 5
* UIKit
* Realm 5.3.2
* SnapKit 5.0.1

## MeasureLibrary

For purposes of managing measurement converting MeasureLibrary was created. Its a wrapper of Foundation.Measurement struct. It handles creating and converting Measurements from string symbols, entered by user. Also it provides protocol for handling and storing custom measurements.

## Setup

To launch this project clone repository and open it with Xcode. SwiftPM is used for dependencies so there would be no need for any another managers.

## Project status

Project is being developed now. There are plans for adding some functionality:
* sharing of recipes
* different layouts for recipe screen for better usability
* image inserting for recipe textView
* tutorial for the first launch
* toolbar for keyboards with additional functions (like closing keyboard)
* default basic ingredients (like water, flour and some others) and ability to convert them from Mass to Volume with density value.
