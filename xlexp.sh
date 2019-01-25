#############
### XLEXP ###
#############
function xlexp(){

if [ "$#" -lt 2 ]

  then

    echo "Directory and language(s) must be supplied"

    echo "usage: xlexp <survey> <languages, separated by ','|all> [--dupes|--new|--omit-blanks]"

    return 1

elif [ "$#" -gt 5 ]

  then

    echo "Too many arguments supplied"

    echo "usage: xlexp <survey> <languages, separated by ','|all> [--dupes|--new|--omit-blanks]"

    return 2

fi


dir=""

langs=""


for arg in $@; do

    if [[ ! $arg =~ ^--?.* && -z $dir ]] ; then

    	dir=$arg

    elif [[ ! $arg =~ ^--?.* && -z $langs ]] ; then

    	langs=$arg

    	break

    fi

done


survey_file_name="$dir/survey.xml"

searched_word="otherLanguages"

line_with_languages=""



if [ "$langs" != "all" ]; then

  languages="$langs"

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



declare -a args;


for ((i=1; i<=$#; i++)); do 

   if [[ "${!i}" =~ ^--?.* ]] ; then

     case "${!i}" in

       -d|--dupes)

         args+=("--dupes")

         ;;

       -n|--new)

         args+=("--new")

         ;;

       -o|--omit-blanks)

         args+=("--omit-blanks")

         ;;

       *)

         echo "Wrong argument supplied: ${!i}"

         echo "Accepted are --dupes|-d; --new|-n; --omit-blanks|-o"

         return 3 

         ;;

     esac

   fi

done


prefix="--"

argsPrint=""


echo 'Do you want to specify file name to be inserted after language_ ?'

read -p 'E.g., date, so the files will be named language_<date>.xls (Y|N): ' answervar

  case $answervar in

    [Yy])

      read -p 'Please specify what to be used in file names [word|digits|_- accepted]: ' name_spec

      if [[ $name_spec =~ ^[A-Za-z0-9_-]*$ ]]; then

        argsPrint="_$name_spec"

      else

        echo "Invalid name"

      fi

      ;;

    *)

      for ((iv=0; iv<${#args[@]}; iv++)); do

        argsPrint+="_${args[$iv]/#$prefix}"

      done

      ;;

  esac



echo "languages: $languages"



IFS=', ' read -r -a array_with_lang <<< "$languages"


 

for LANG in "${array_with_lang[@]}"

do

  if [ ${#args[@]} -eq 0 ]; then

    echo "xlate for ${LANG}"

    xlate -l ${LANG} $dir ${LANG}${argsPrint}.xls

  else

    echo "xlate for ${LANG} with ${args[*]}"

    xlate ${args[*]} -l ${LANG} $dir ${LANG}${argsPrint}.xls

  fi

done

};
