![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/4d-tips-computed-attribute)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/4d-tips-computed-attribute/total)

# 4d-tips-computed-attribute
examples of get, query, orderBy

## searching by age

to search by age, you need to know the range of dates in which the birth day falls.

the [example given in the documentation](https://developer.4d.com/docs/ORDA/ordaClasses#function-query-attributename) is shown below:

```4d
var $age : Integer
$age:=Num($event.value)  // integer
$d1:=Add to date(Current date; -$age-1; 0; 0)
$d2:=Add to date($d1; 1; 0; 0)
$parameters:=New collection($d1; $d2)
```
* **`Num`** is used to cast text to number. this is done presumably to respect the historic behaviour where 4D allows textual values to be used for searching numeric values.
* since `$age` is typed, decimals are removed. in other words, age `70.5` doesn't convert to `70` years and `6` months.
* `$d1` is the earlier birthday after which the age would qualify
* `$d2` is the later birthday on which the age would qualify
