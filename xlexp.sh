function xlexp(){

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]

  then

    echo "Wrong number of arguments supplied"

    echo "usage: xlexp <survey> <xlate languages, separated by ','|all> [--dupes|--new|--omit-blanks]"

    return 1

fi



third_argument=""

survey_file_name="$1/survey.xml"

searched_word="otherLanguages"

line_with_languages=""



if [ "$2" != "all" ]; then

  languages="$2"

else

  while read line;

  do

    if [[ $line = *$searched_word* ]]; then

      line_with_languages=$line

    fi

  done < $survey_file_name



  IFS='"' read -r -a delim_array <<< "$line_with_languages"



  for index in "${!delim_array[@]}"

  do

      if [[ ${delim_array[index]} = *$searched_word* ]]; then

        languages=${delim_array[index + 1]}

        break;

      fi

  done

fi



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

      echo "usage: xlexp <survey> <xlate languages, separated by ','|all> [--dupes|--new|--omit-blanks]"

      return 2

      ;;

  esac

fi

echo "languages: $languages"


IFS=', ' read -r -a array_with_lang <<< "$languages"


for LANG in "${array_with_lang[@]}"

do

  if [ -z "$3" ]; then

    echo "xlate for ${LANG}"

    xlate -l ${LANG} $1 ${LANG}.xls

  else

    echo "xlate for ${LANG} with $third_argument"

    xlate -l ${LANG} $third_argument $1 ${LANG}_${third_argument:2}.xls

  fi

done

};
