
#############
### XLEXP ###
#############
function xlexp(){

if [ "$#" -lt 2 ]

  then

    echo -e "\e[31mDirectory and language(s) must be supplied\e[39m"

    echo -e "\e[1musage: xlexp <survey> <languages, separated by ','|all> [--dupes|--new|--omit-blanks]\e[22m"

    return 1

elif [ "$#" -gt 5 ]

  then
 
    echo -e "\e[31mToo many arguments supplied\e[39m"

    echo -e "\e[1musage: xlexp <survey> <languages, separated by ','|all> [--dupes|--new|--omit-blanks]\e[22m"

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

searched_word="otherLanguages="

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

       if [[ ! ${!i} =~ ^--dupes|--new|--omit-blanks|-[dno]+$ ]]; then

         echo -e "\e[1mWrong argument supplied\e[22m: \e[31m${!i}\e[39m"

         echo -e "\e[1mAccepted are --dupes|-d; --new|-n; --omit-blanks|-o\e[22m"

         return 4

       fi


       if [[ ${!i} =~ ^-d|--dupes|-[no]*d[no]*$ ]]; then

         args+=("--dupes")

       fi

       if [[ ${!i} =~ ^-n|--new|-[do]*n[do]*$ ]]; then

         args+=("--new")

       fi


       if [[ ${!i} =~ ^-o|--omit-blanks|-[dn]*o[dn]*$ ]]; then

         args+=("--omit-blanks")

       fi

   fi

done


prefix="--"

argsPrint=""


# echo "Specify tex if you want it to be added after \e[3mlanguage_\e[0m in file name or leave empty for defaults:"

# read -p 'E.g., date, so the files will be named language_<date>.xls (Y|N): ' answervar

#   case $answervar in

#     [Yy])

    echo -e "Specify text to be added after \e[1mlanguage_\e[22m in the xlate names."

    read -p  "Or just leave empty and press enter for default names: " name_spec
		
	  if [[ -z $name_spec ]]; then

        for ((iv=0; iv<${#args[@]}; iv++)); do

          if [[ ! ${args[iv]} = "--omit-blanks" ]]; then

            argsPrint+="_${args[$iv]/#$prefix}"

          fi

        done

      elif [[ ! $name_spec =~ ^[A-Za-z0-9_-]*$ ]]; then

        echo -e "\e[31mInvalid characters entered!\e[39m"

		    read -p "Only letters, digits, underscore and hyphen are accepted: " name_spec2

        if [[ $name_spec2 =~ ^[A-Za-z0-9_-]*$ ]]; then

          argsPrint="_$name_spec2"

        fi

      else

      	argsPrint="_$name_spec"

    fi

  #     ;;

  #   *)

  #     for ((iv=0; iv<${#args[@]}; iv++)); do

  #       argsPrint+="_${args[$iv]/#$prefix}"

  #     done

  #     ;;

  # esac



echo -e "\e[1mlanguages\e[22m: $languages"


IFS=', ' read -r -a array_with_lang <<< "$languages"


 

for LANG in "${array_with_lang[@]}"

do

  if [ ${#args[@]} -eq 0 ]; then

    echo -e "xlate for \e[7m${LANG}\e[27m"

    xlate -l ${LANG} $dir ${LANG}${argsPrint}.xls

  else

    echo -e "xlate for \e[7m${LANG}\e[27m with \e[1m${args[*]}\e[22m"

    xlate ${args[*]} -l ${LANG} $dir ${LANG}${argsPrint}.xls

  fi

done

};
