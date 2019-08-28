## go-command

The `go` command aims to get directly to a survey directory only by the directory name – SN or Mac #, for example. 
The full path (/home/hermes/v2/…) doesn’t need to be specified. 
Saves some window switching and copying time.

Optimized for AMS FS! 
Works for all, but it takes some time for the non-default AMS directories, as it manually searches every dir in hermes/v2.

If the name is found in more than one of the default directories (e.g., in bor/v1/AG and lsr/bmr/v3) a prompt is shown to choose to which path to go.

When a path is specified or if going to a temp-dir, `go` works as `cd`. So all cases below are valid:

    go 91227086
  
    go /home/hermes/v2/gmi/v2/508119
  
    go temp-changes

    go lsr/bmr/v3/91230564
  
    go ..


### Installation

Just copy the *go.sh* file content at the end of your **.bashrc** file. It’s in your home directory (/home/USER). 
*Ctrl+Alt+H* will display hidden files, in case **.bashrc** is not visible. 
On next login `go` will be usable.

---

# xlimp & xlexp

> Георги Лалов

## xlate-commands

Много ме е дразнило, когато трябва да качвам или да свалям няколко xlate-и на веднъж и всеки път да пиша една и съща команда, като единствената разлика е езика и името на файла.
Затова ми дойде идеята за една обща команда, с която да може да се качват/свалят няколко xlate-а наведнъж.

Всъщност са две команди, една за качване и една за сваляне на xlate-и.

## Употреба
### Команда за сваляне:

    xlexp <survey> <xlate languages, separated by ','|all> [--dupes|--new|--omit-blanks]

Тоест ако сме в директорията на стъдито и примерно искаме да свалим френски, немски и италиански, пишем следната команда:

    xlexp . french,german,italian

Това ще ни създаде три файла – french.xls, german.xls, italian.xls

Ако искаме с `–-new`, пишем

    xlexp . french,german,italian –-new

Това пък ще ни създаде следните три файла – french_new.xls, german_new.xls, italian_new.xls

Веднага след рънване командата пита дали не искаме да зададем име на файла и при Y, можем да дадем текста, който да се добави след езика. Допускат се букви, цифри, - и \_. Например ако ръннем `xlexp . french,german,italian -n`, и после потвърдим че искаме да зададем име и напишем 101, ще се създадат 3 файла казващи се french_101.xls, german_101.xls, italian_101.xls

Ако искаме да свалим всички езици, които имаме в стъдито просто пишем:

    xlexp . all

Това какво прави – прочита какво сме въвели в otherLanguages=”…” в стъдито и ги сваля абсолютно всичките.

### Команда за качване:

    xlimp <survey> <xlate names, separated by ','> [--dupes|--new|--omit-blanks]

Тук трябва да изброим само имената на файловете (без .xls), като скрипта сам определя за кой език е съответния xlate, като предварително ни пита дали това е правилният език. За целта името на езика трябва да се съдържа в името на xlate-а.

Например ако имаме следните два файла за качване – french_dupes.xls и german_dupes.xls, командата е следната:

    xlimp . french_dupes,german_dupes

Ако искаме да са с dupes например:

    xlimp . french_dupes,german_dupes --dupes

## Инсталация

Копирате си съдържанието на *xlimp.sh* и/или *xlexp.sh* файловете в **.bashrc** файла.
Той се намира home директорията ви (/home/USER). Ако е скрит, използвайте *Ctrl+Alt+H* за да го покажете.
На следващия логин командите ще работят.
