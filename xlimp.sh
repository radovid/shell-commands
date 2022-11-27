#############
### XLIMP ###
#############
function xlimp(){

if [ "$#" -lt 2 ]

  then

    echo -e "\e[31mDirectory and file names(s) must be supplied\e[39m"

    echo -e "\e[1musage: xlimp <survey> <xlate names, separated by ','> [--dupes|--unsafe]\e[22m"
    return 1

elif [ "$#" -gt 5 ]

  then

    echo -e "\e[31mToo many arguments supplied\e[39m"

    echo -e "\e[1musage: xlimp <survey> <xlate names, separated by ','> [--dupes|--unsafe]\e[22m"

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

       if [[ ! ${!i} =~ ^--dupes|--new|--omit-blanks|-[dnou]+$ ]]; then

         echo -e "\e[1mWrong argument supplied\e[22m: \e[31m${!i}\e[39m"

         echo -e "\e[1mAccepted are --dupes|-d; --unsafe|-u; --new|-n; --omit-blanks|-o\e[22m"

         return 4

       fi
       

       if [[ ${!i} =~ ^-d|--dupes|-[nou]*d[nou]*$ ]]; then

         args+=("--dupes")

       fi

       if [[ ${!i} =~ ^-n|--new|-[dou]*n[dou]*$ ]]; then

         args+=("--new")

       fi


       if [[ ${!i} =~ ^-o|--omit-blanks|-[dnu]*o[dnu]*$ ]]; then

         args+=("--omit-blanks")

       fi

       if [[ ${!i} =~ ^-u|--unsafe|-[dno]*u[dno]*$ ]]; then

         args+=("--unsafe")

       fi

   fi

done




declare -a languages_array=("afrikaans" "albanian" "arabic" "arabic_egypt" "arabic_lebanon" "arabic_morocco" "arabic_qatar" "arabic_saudiarabia" "arabic_uae" "assamese" "azerbaijani" "bengali" "bulgarian" "burmese" "canadian" "chinese" "croatian" "czech" "danish" "danish.utf8" "dutch" "dutch_belgium" "english.utf8" "estonian" "finnish" "french" "french_belgium" "french_lu" "french_ch" "georgian" "german" "german_austria" "german_lu" "german_ch" "greek" "gujarati" "hebrew" "hindi" "hungarian" "icelandic" "indonesian" "italian" "italian.utf8" "italian_ch" "japanese" "kannada" "kazakh" "khmer" "korean" "latvian" "lithuanian" "macedonian" "malay" "malay_sg" "malayalam" "maltese" "marathi" "mongolian" "norwegian" "oriya" "persian" "polish" "portuguese" "portuguese_br" "punjabi" "romanian" "russian" "samoan" "serbian" "simplifiedchinese" "simplifiedchinese_my" "simplifiedchinese_sg" "slovak" "slovene" "slovenian" "spanish" "spanish.utf8" "spanish_argentina" "spanish_brazil" "spanish_chile" "spanish_colombia" "spanish_ecuador" "spanish_eu" "spanish_peru" "spanish_venezuela" "spanish_latin" "spanish_mexico " "spanish_south" "swahili" "swedish" "tagalog" "tamil" "telugu" "thai" "tongan" "traditionalchinese" "traditionalchinese_tw" "turkish" "uk" "aus" "english_ca" "english_china" "english_g1" "english_g2" "english_g3" "english_g4" "english_hk" "english_id" "english_india" "english_ireland" "english_my" "english_nigeria" "english_sg" "english_tw" "english_za" "ukrainian" "urdu" "urdu_india" "vietnamese" "welsh")



IFS=', ' read -r -a supplied_langs <<< "$langs"



for element in "${supplied_langs[@]}"

do

  element=${element%.xlsx}
  element=${element%.XLSX}
  element=${element%.xls}
  element=${element%.XLS}

  found_language=${element}

  for each_language in "${languages_array[@]}"

  do

    if [[ "${element}" = *"${each_language}"* ]]; then

      found_language=${each_language}

      found_language="${found_language}_"

    fi

  done

 
  declare -a foundfiles=();

  clear_dir="$dir/"


  for line in $(find $dir -maxdepth 2 -regextype posix-extended -regex ".*?/${element}.(xlsx?|XLSX?)"); do

    foundfiles+=("${line/#$clear_dir}")

  done


  idf=0

  file_name=""

  skip_xlate=false

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

  else

     echo -e "\e[31mxlate file with this name wasn't found\e[39m"

     echo -e "\e[1musage: xlimp <survey> <xlate (file) names, separated by ','> [--dupes|--unsafe]\e[22m"

     skip_xlate=true

  fi;

  if [ "$skip_xlate" == false ]; then

    if [ ${#args[@]} -eq 0 ]; then

        echo -e "file name = \e[7m${file_name}\e[27m, language = \e[1m${found_language%_*}\e[22m"

    else

        echo -e "file name = \e[7m${file_name}\e[27m, language = \e[1m${found_language%_*}\e[22m, \e[1m${args[*]}\e[22m"

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

  fi

done

};
