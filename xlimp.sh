function xlimp(){

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]

  then

    echo "Wrong number of arguments supplied"

    echo "usage: xlimp <survey> <xlate names, separated by ','> [--dupes|--new|--omit-blanks]"

    return 1

fi

 

third_argument=""

 

if [ -z "$3" ]; then

  third_argument=""

else

  case "$3" in

    -d|--dupes)

      third_argument="--dupes"

      ;;

    -n|--new)

      third_argument="--new"

      ;;

    -o|--omit-blanks)

      third_argument="--omit-blanks"

      ;;

    *)

      echo "Wrong arguments supplied"

      echo "usage: xlimp <survey> <xlate names, separated by ','> [--dupes|--new|--omit-blanks]"

      return 2

      ;;

  esac

fi

 

declare
 -a languages_array=("arabic_egypt" "arabic_lebanon" "arabic_morocco" 
"arabic_qatar" "arabic_saudiarabia" "arabic_uae" "french_belgium" 
"french_lu" "french_ch" "german_austria" "german_lu" "german_ch" 
"dutch_belgium" "malay_sg" "portuguese_br" "simplifiedchinese_my" 
"simplifiedchinese_sg" "spanish_brazil" "spanish_chile" 
"spanish_colombia" "spanish_ecuador" "spanish_eu" "spanish_peru" 
"spanish_venezuela" "spanish_latin" "spanish_mexico" "spanish_south" 
"traditionalchinese_tw" "english_ca" "english_china" "english_g1" 
"english_g2" "english_g3" "english_g4" "english_hk" "english_id" 
"english_india" "english_ireland" "english_my" "english_nigeria" 
"english_sg" "english_tw" "english_za" "danish.utf8" "english.utf8" 
"italian.utf8" "spanish.utf8" "albanian" "arabic" "azerbaijani" 
"bulgarian" "canadian" "croatian" "czech" "danish" "dutch" "english" 
"estonian" "finnish" "french" "georgian" "german" "greek" "hebrew" 
"hindi" "hungarian" "icelandic" "indonesian" "italian" "japanese" 
"khmer" "korean" "latvian" "lithuanian" "macedonian" "malay" "mongolian"
 "persian" "polish" "portuguese" "romanian" "russian" "serbian" 
"simplifiedchinese" "slovak" "slovene" "spanish" "spanish_argentina" 
"swahili" "swedish" "tagalog" "thai" "traditionalchinese" "turkish" "uk"
 "aus" "ukrainian" "urdu" "vietnamese")

IFS=', ' read -r -a array <<< "$2"
for element in "${array[@]}"
do
  found_language=${element}
  for each_language in "${languages_array[@]}"
  do
    if [[ "${element}" = *"${each_language}"* ]]; then
      found_language=${each_language}
      found_language="${found_language}_"
      break;
    fi
  done

  if [ -z "$3" ]; then
      echo "file name = ${element}.xls, language = ${found_language%_*}"
  else
      echo "file name = ${element}.xls, language = ${found_language%_*}, $third_argument"
  fi
 
  read -p 'Do you want to execute this xlate? (Y|N): ' answervar
  case $answervar in
  [Yy])
    if [ -z "$3" ]; then
      xlate -l ${found_language%_*} $1 ${element}.xls $1
    else
      xlate -l ${found_language%_*} $third_argument $1 ${element}.xls $1
    fi
    ;;
  *) continue ;;
  esac
done

};
