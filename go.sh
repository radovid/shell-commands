############
#### GO ####
############
function go(){
declare -- sn=$1;
declare -a found;
declare -- idx=0;

declare -- BO=$'\e[1m';
declare -- BC=$'\e[22m';
declare -- UO=$'\e[4m';
declare -- UC=$'\e[24m';

#if [[ $sn =~ trans|temp-|.*\.|.*\/.* ]] ;

if [ -d "$sn" ]; then 
   echo "${BO}Going to ${UO}$sn${UC}${BC}";
   cd "$sn";

elif [ -d /home/hermes/v2/"$sn" ]; then
   echo "${BO}Going to ${UO}/home/hermes/v2/$sn${UC}${BC}";
   cd /home/hermes/v2/"$sn";

elif [ -d /home/hermes/v2/gmi/"$sn" ]; then
   echo "${BO}Going to ${UO}/home/hermes/v2/gmi/$sn${UC}${BC}";
   cd /home/hermes/v2/gmi/"$sn";

else

  for dir in "." "/home/hermes/v2/gmi/v3/AMS" "/home/hermes/v2/gmi/v2" "/home/hermes/v2/bor/v1/AG" "/home/hermes/v2/lsr/bmr/v3" "/home/hermes/v2/lsr/bmr/v2" "/home/hermes/v2/gmi/v3/AMS/INTERNAL" "/home/hermes/v2/gmi" "/home/hermes/v2/gmi/v2/maps" "/home/hermes/v2/gmi/v3/AMS/NATO" "/home/hermes/v2/gmi/v2/NATO" ; do
    if [ -d "$dir/$sn" ];
     then
      found+=("$dir/$sn");
    fi
  done;

  if [ -z $found ] ; then
    for line in $(find /home/hermes/v2 ! -readable -prune -o -name $sn -a -type d -print); do
      found+=("$line");
    done;
  fi;

  if [ ${#found[@]} -gt 1 ];
    then
      for item in ${found[@]};  do
        idx=$((idx+1));
        echo "${BO}$idx:${BC} ${UO}$item${UC}";
      done;
      read -p "${BO}Enter the number of the directory to go to:${BC} " dirNum

      echo "${BO}Going to ${UO}${found[$dirNum-1]}${UC}${BC}";
      cd "${found[$dirNum-1]}";

   elif [ ${#found[@]} -eq 1 ];
    then
      echo "${BO}Going to ${UO}${found[0]}${UC}${BC}";
      cd "${found[0]}";
 
    else
      echo -e "\e[38;2;240;143;104mSorry, didn't find where to go!\e[39m"
      return 1
 
   fi;

fi;
};
