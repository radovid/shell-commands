#############
### XLIMP ###
#############
function xlimp(){

if [ "$#" -lt 2 ]

  then

    echo "Directory and language(s) must be supplied"

    echo "usage: xlimp <survey> <xlate names, separated by ','> [--dupes|--unsafe]"
    return 1

elif [ "$#" -gt 5 ]

  then

    echo "Too many arguments supplied"

    echo "usage: xlimp <survey> <xlate names, separated by ','> [--dupes|--unsafe]"

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

      -u|--unsafe)

        args+=("--unsafe")

        ;;

      *)

        echo "Wrong argument supplied: ${!i}"

        echo "Accepted are --dupes|-d; --unsafe|-u; --new|-n; --omit-blanks|-o"

        ;;

    esac

  fi

done


declare -a languages_array=("arabic_egypt" "arabic_lebanon" "arabic_morocco" "arabic_qatar" "arabic_saudiarabia" "arabic_uae" "french_belgium" "french_lu" "french_ch" "german_austria" "german_lu" "german_ch" "dutch_belgium" "malay_sg" "portuguese_br" "simplifiedchinese_my" "simplifiedchinese_sg" "spanish_brazil" "spanish_chile" "spanish_colombia" "spanish_ecuador" "spanish_eu" "spanish_peru" "spanish_venezuela" "spanish_latin" "spanish_mexico" "spanish_south" "traditionalchinese_tw" "english_ca" "english_china" "english_g1" "english_g2" "english_g3" "english_g4" "english_hk" "english_id" "english_india" "english_ireland" "english_my" "english_nigeria" "english_sg" "english_tw" "english_za" "danish.utf8" "english.utf8" "italian.utf8" "spanish.utf8" "albanian" "arabic" "azerbaijani" "bulgarian" "canadian" "croatian" "czech" "danish" "dutch" "english" "estonian" "finnish" "french" "georgian" "german" "greek" "hebrew" "hindi" "hungarian" "icelandic" "indonesian" "italian" "japanese" "khmer" "korean" "latvian" "lithuanian" "macedonian" "malay" "mongolian" "persian" "polish" "portuguese" "romanian" "russian" "serbian" "simplifiedchinese" "slovak" "slovene" "spanish" "spanish_argentina" "swahili" "swedish" "tagalog" "thai" "traditionalchinese" "turkish" "uk" "aus" "ukrainian" "urdu" "vietnamese")



IFS=', ' read -r -a supplied_langs <<< "$langs"



for element in "${supplied_langs[@]}"

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


  declare -a foundfiles;

  clear_dir="$dir/"


  for line in $(find $dir -maxdepth 2 -regextype posix-extended -regex ".*?/${element}.(xlsx?|XLSX?)"); do

    foundfiles+=("${line/#$clear_dir}")

  done


  idf=0

  file_name=""


  if [ ${#foundfiles[@]} -gt 1 ];

   then

    for file in ${foundfiles[@]};  do

      idf=$((idf+1));

      echo $idf': ' "${file}";

    done

     read -p "Enter the number of the file to be used: " fileNum

     file_name="${foundfiles[$fileNum-1]}";

  elif [ ${#foundfiles[@]} -eq 1 ];

   then

     file_name="${foundfiles[0]}";

  fi;


  if [ ${#args[@]} -eq 0 ]; then

      echo "file name = ${file_name}, language = ${found_language%_*}"

  else

      echo "file name = ${file_name}, language = ${found_language%_*}, ${args[*]}"

  fi



  read -p 'Do you want to execute this xlate? (Y|N): ' answervar

  case $answervar in

  [Yy])

    if [ ${#args[@]} -eq 0 ]; then

      xlate -l ${found_language%_*} $dir ${file_name} $dir

    else

      xlate ${args[*]} -l ${found_language%_*} $dir ${file_name} $dir

    fi

    ;;

  *) continue ;;

  esac

done

};
