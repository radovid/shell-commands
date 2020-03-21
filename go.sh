############
#### GO ####
############
function go(){

declare -- BO=$'\e[1m';
declare -- BC=$'\e[22m';

declare -- name=$1;
declare -a found;
declare -- idx=0;

if [ -d "$name" ]; then 
   echo "${BO}Going to $name${BC}";
   cd "$name";

elif [ -d /home/hermes/v2/"$name" ]; then
   echo "${BO}Going to /home/hermes/v2/$name${BC}";
   cd /home/hermes/v2/"$name";

elif [ -d /home/hermes/v2/gmi/"$name" ]; then
   echo "${BO}Going to /home/hermes/v2/gmi/$name${BC}";
   cd /home/hermes/v2/gmi/"$name";

elif [ -d /home/hermes/v2/selfserve/"$name" ]; then
   echo "${BO}Going to /home/hermes/v2/selfserve/$name${BC}";
   cd /home/hermes/v2/selfserve/"$name";

else

  for dir in "." "/home/hermes/v2/gmi/v3/AMS" "/home/hermes/v2/gmi/v2" "/home/hermes/v2/bor/v1/AG" "/home/hermes/v2/lsr/bmr/AG" "/home/hermes/v2/lsr/bmr/v3" "/home/hermes/v2/lsr/bmr/v2" "/home/hermes/v2/gmi/v3/AMS/INTERNAL" "/home/hermes/v2/gmi" "/home/hermes/v2/gmi/v2/maps" "/home/hermes/v2/gmi/v3/AMS/NATO" "/home/hermes/v2/gmi/v2/NATO" ; do
    if [ -d "$dir/$name" ];
     then
      found+=("$dir/$name");
    fi
  done;

  if [ -z $found ] ; then
    for line in $(find /home/hermes/v2 ! -readable -prune -o -name $name -a -type d -print); do
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

      echo "${BO}Going to ${found[$dirNum-1]}${BC}";
      cd "${found[$dirNum-1]}";

   elif [ ${#found[@]} -eq 1 ];
    then
      echo "${BO}Going to ${found[0]}${BC}";
      cd "${found[0]}";
 
    else
      echo -e "\e[38;2;240;143;104mSorry, didn't find where to go!\e[39m"
      return 1
 
   fi;

fi;

};
